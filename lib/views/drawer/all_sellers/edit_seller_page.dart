import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile/api_service/api_service.dart';
import 'package:textile/models/seller_details_model.dart';
import 'package:textile/models/cities_list_response.dart';
import 'package:textile/widgets/colors.dart';

class EditSellerPage extends StatefulWidget {
  final String exporterName;

  const EditSellerPage({Key? key, required this.exporterName}) : super(key: key);

  @override
  State<EditSellerPage> createState() => _EditSellerPageState();
}

class _EditSellerPageState extends State<EditSellerPage> {
  final _formKey = GlobalKey<FormState>();
  final _api = ApiService();

  bool _loading = true;
  bool _saving = false;
  SellerDetails? _details;
  List<CityNameItem> _cities = [];

  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _emailController = TextEditingController();
  final _contactController = TextEditingController();
  final _mapController = TextEditingController();
  final _websiteController = TextEditingController();
  String _selectedCity = '';
  String _selectedCountry = '';
  String _statusBar = '0';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    try {
      final detailsResp = await _api.getSellerDetails(
        seller: widget.exporterName,
        exporting: '7xaz4',
      );
      final citiesResp = await _api.getCitiesList();

      if (detailsResp.status == 200 && detailsResp.data != null) {
        _details = detailsResp.data;
        _nameController.text = _details!.importer;
        _addressController.text = _details!.address;
        _emailController.text = _details!.email;
        _contactController.text = _details!.contactNumber;
        _websiteController.text = _details!.website;
        _mapController.text = _details!.latlong;
        _selectedCity = _details!.city;
        _selectedCountry = _details!.country;
        _statusBar = _details!.recordFound;
      }

      if (citiesResp.status == 200 && citiesResp.data != null) {
        _cities = citiesResp.data!;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load seller details',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate() || _details == null) return;
    setState(() => _saving = true);
    try {
      final resp = await _api.saveSellerInfo(
        rowId: _details!.id,
        importerName: _nameController.text.trim(),
        address: _addressController.text.trim(),
        email: _emailController.text.trim(),
        city: _selectedCity,
        country: _selectedCountry,
        contact: _contactController.text.trim(),
        map: _mapController.text.trim(),
        website: _websiteController.text.trim(),
        statusBar: _statusBar,
      );
      if (resp.status == 200) {
        Get.snackbar(
          'Success',
          resp.message,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.back(result: true);
      } else {
        Get.snackbar(
          'Error',
          resp.message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _contactController.dispose();
    _mapController.dispose();
    _websiteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.exporterName),
        backgroundColor: AppColors.primaryDark,
      ),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primaryDark),
            )
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextField('Seller Name', _nameController),
                      _buildTextField('Address', _addressController, maxLines: 2),
                      _buildTextField('Email', _emailController),
                      _buildCityDropdown(),
                      const SizedBox(height: 12),
                      _buildCountryField(),
                      _buildTextField('Contact Number', _contactController),
                      _buildTextField('Map', _mapController),
                      _buildTextField('Website', _websiteController),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _saving ? null : _save,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryDark,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: _saving
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor:
                                        AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : const Text(
                                  'Update Importer',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          isDense: true,
        ),
        validator: (v) {
          if (label == 'Seller Name' && (v == null || v.trim().isEmpty)) {
            return 'Required';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildCityDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField<String>(
        value: _selectedCity.isEmpty ? null : _selectedCity,
        items: _cities
            .map((c) => DropdownMenuItem<String>(
                  value: c.city,
                  child: Text(c.city),
                ))
            .toList(),
        onChanged: (v) {
          if (v != null) {
            setState(() => _selectedCity = v);
          }
        },
        decoration: InputDecoration(
          labelText: 'City',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          isDense: true,
        ),
      ),
    );
  }

  Widget _buildCountryField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        initialValue: _selectedCountry,
        readOnly: true,
        decoration: InputDecoration(
          labelText: 'Country',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          isDense: true,
        ),
      ),
    );
  }
}

