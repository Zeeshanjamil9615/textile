import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile/api_service/api_service.dart';
import 'package:textile/api_service/local_storage_service.dart';
import 'package:textile/widgets/colors.dart';
import 'package:textile/widgets/filter_empty_state.dart';
import 'package:textile/views/web/google_search_webview.dart';

class ImporterItem {
  final int sr;
  final String id;
  final String importerName;
  final String email;
  final String address;
  final String city;
  final String country;
  final String cell;
  final String latlong;
  final String? landline;
  final String? contactPerson;
  final String? secondEmail;
  final String? narration;

  ImporterItem({
    required this.sr,
    required this.id,
    required this.importerName,
    required this.email,
    required this.address,
    required this.city,
    required this.country,
    required this.cell,
    required this.latlong,
    this.landline,
    this.contactPerson,
    this.secondEmail,
    this.narration,
  });
}

class OpenFolderController extends GetxController {
  final String folderId;
  final String folderName;
  OpenFolderController({
    required this.folderId,
    required this.folderName,
  });

  final importers = <ImporterItem>[].obs;
  // (removed) filtered/pagination state for table UI
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final countries = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchCountries();
    fetchFolderDetails();
  }

  Future<void> fetchCountries() async {
    try {
      final apiService = ApiService();
      final response = await apiService.getCountriesList();
      if (response.status == 200 && response.data != null) {
        final list = response.data!.where((c) => c != 'All').toList();
        countries.value = list;
      } else {
        countries.value = ['Select Country'];
      }
    } catch (_) {
      countries.value = ['Select Country'];
    } finally {
      if (!countries.contains('Select Country')) {
        countries.insert(0, 'Select Country');
      } else {
        countries.removeWhere((c) => c == 'Select Country');
        countries.insert(0, 'Select Country');
      }
    }
  }

  Future<void> fetchFolderDetails() async {
    final user = await LocalStorageService.getUserData();
    if (user == null || user.id.isEmpty) {
      errorMessage.value = 'Please log in to view folder details.';
      importers.clear();
      return;
    }
    if (folderId.isEmpty) {
      errorMessage.value = 'Invalid folder.';
      importers.clear();
      return;
    }
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final apiService = ApiService();
      final response = await apiService.getFolderDetails(user.id, folderId);
      if (response.status == 200 && response.data != null) {
        importers.assignAll(
          response.data!.asMap().entries.map((e) {
            final f = e.value;
            return ImporterItem(
              sr: e.key + 1,
              id: f.id,
              importerName: f.name,
              email: f.email,
              address: f.address,
              city: f.city,
              country: f.country,
              cell: f.cell,
              latlong: f.latlong,
              landline: f.landline,
              contactPerson: f.contactPerson,
              secondEmail: f.secondEmail,
              narration: (f.description?.trim().isNotEmpty ?? false)
                  ? f.description!.trim()
                  : (f.productCode?.trim().isNotEmpty ?? false)
                      ? f.productCode!.trim()
                      : null,
            );
          }),
        );
      } else {
        errorMessage.value = response.message;
        importers.clear();
      }
    } catch (_) {
      errorMessage.value = 'Failed to load folder details.';
      importers.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> addOrUpdateBuyerFromForm({
    String? id,
    required String importerName,
    required String country,
    required String city,
    required String address,
    required String email,
    required String cell,
    required String latitude,
    required String longitude,
  }) async {
    final user = await LocalStorageService.getUserData();
    if (user == null || user.id.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please log in to continue.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    try {
      isLoading.value = true;
      final apiService = ApiService();
      final response = await apiService.addOrUpdateBuyer(
        id: id,
        csId: user.id.trim(),
        csName: user.fullName.trim().isEmpty ? user.email.trim() : user.fullName.trim(),
        companyName: user.company.trim(),
        folderId: folderId,
        importerName: importerName,
        country: country,
        city: city,
        address: address,
        email: email,
        cell: cell,
        latitude: latitude,
        longitude: longitude,
      );

      if (response.status == 200) {
        Get.snackbar(
          'Success',
          response.message,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        await fetchFolderDetails();
        return true;
      }

      Get.snackbar(
        'Error',
        response.message,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void addImporter(ImporterItem item) {
    importers.add(
      ImporterItem(
        sr: importers.length + 1,
        id: item.id,
        importerName: item.importerName,
        email: item.email,
        address: item.address,
        city: item.city,
        country: item.country,
        cell: item.cell,
        latlong: item.latlong,
        landline: item.landline,
        contactPerson: item.contactPerson,
        secondEmail: item.secondEmail,
        narration: item.narration,
      ),
    );
  }

  void updateImporter(int index, ImporterItem updated) {
    if (index < 0 || index >= importers.length) return;
    final existing = importers[index];
    importers[index] = ImporterItem(
      sr: existing.sr,
      id: existing.id,
      importerName: updated.importerName,
      email: updated.email,
      address: updated.address,
      city: updated.city,
      country: updated.country,
      cell: updated.cell,
      latlong: updated.latlong,
      landline: updated.landline,
      contactPerson: updated.contactPerson,
      secondEmail: updated.secondEmail,
      narration: updated.narration,
    );
  }

  Future<void> deleteImporter(int index) async {
    if (index < 0 || index >= importers.length) return;
    final importer = importers[index];
    if (importer.id.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Invalid importer id.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;
      final apiService = ApiService();
      final response =
          await apiService.deleteImporter(id: importer.id.trim());

      if (response.status == 200) {
        Get.snackbar(
          'Success',
          response.message,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        await fetchFolderDetails();
      } else {
        Get.snackbar(
          'Error',
          response.message,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to delete importer.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}

class OpenFolderScreen extends StatelessWidget {
  final String folderName;
  final String folderId;

  const OpenFolderScreen({
    Key? key,
    required this.folderName,
    required this.folderId,
  }) : super(key: key);

  static String _buildGoogleSearchUrl({
    required String importerName,
    required String country,
  }) {
    final parts = <String>[
      importerName.trim(),
      country.trim(),
    ].where((e) => e.isNotEmpty).toList();

    final query = parts.isEmpty ? importerName.trim() : parts.join(' ');
    final encoded = Uri.encodeQueryComponent(query.isEmpty ? ' ' : query);
    return 'https://www.google.com/search?q=$encoded';
  }

  static void _openGoogleSearchInApp(
    BuildContext context, {
    required String importerName,
    required String country,
  }) {
    final url = _buildGoogleSearchUrl(
      importerName: importerName,
      country: country,
    );
    final title =
        importerName.trim().isEmpty ? 'Google Search' : importerName.trim();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => GoogleSearchWebViewPage(url: url, title: title),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OpenFolderController>(
      init: OpenFolderController(
        folderId: folderId,
        folderName: folderName,
      ),
      builder: (controller) {
        return Scaffold(
          backgroundColor: const Color(0xFFF4F6F9),
          appBar: AppBar(
            title: Text(folderName),
            backgroundColor: const Color(0xFF2D7373),
            elevation: 0,
            actions: const [
              Center(
                child: Padding(
                  padding: EdgeInsets.only(right: 16),
                  child: Text(
                    'My Folders',
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                const SizedBox(height: 12),
                Obx(() {
                  if (controller.errorMessage.value.isNotEmpty) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        controller.errorMessage.value,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF003366),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 2,
                          ),
                          onPressed: () {
                            _openAddImporterSheet(context, controller);
                          },
                          icon: const Icon(Icons.person_add_alt_1_rounded,color: AppColors.textWhite ,),
                          label: const Text('Add Importer',style: TextStyle(color: AppColors.textWhite),),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            side: const BorderSide(color: Color(0xFFCC3333)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            // Dummy "Send Mail to all" action
                          },
                          icon: const Icon(Icons.email_outlined,
                              color: Color(0xFFCC3333)),
                          label: const Text(
                            'Send Mail to all',
                            style: TextStyle(color: Color(0xFFCC3333)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          decoration: const BoxDecoration(
                            color: Color(0xFF2D7373),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Expanded(
                                child: Text(
                                  'Importers',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.5,
                                  ),
                                ),
                              ),
                              Obx(
                                () => Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    '${controller.importers.length}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Obx(
                          () {
                            if (controller.isLoading.value) {
                              return const Padding(
                                padding: EdgeInsets.all(24),
                                child: Center(child: CircularProgressIndicator()),
                              );
                            }
                            if (controller.importers.isEmpty) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 28),
                                child: FilterEmptyState(
                                  hasLoadedData: true,
                                  messageNoResults:
                                      'No importers in this folder yet. Tap “Add Importer” to add one.',
                                ),
                              );
                            }
                            return ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: controller.importers.length,
                              separatorBuilder: (_, __) =>
                                  const Divider(height: 1),
                              itemBuilder: (context, index) {
                                final item = controller.importers[index];
                                final city = item.city.trim();
                                final country = item.country.trim();
                                final cityCountry =
                                    city.isEmpty && country.isEmpty
                                        ? '—'
                                        : city.isEmpty
                                            ? country
                                            : country.isEmpty
                                                ? city
                                                : '$city / $country';
                                final narrationText =
                                    (item.narration?.trim().isNotEmpty ?? false)
                                        ? item.narration!.trim()
                                        : (item.address.trim().isNotEmpty
                                            ? item.address.trim()
                                            : '—');
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 10),
                                  child: Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${item.sr}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                      const SizedBox(width: 8),
                                          
                                          Expanded(
                                            flex: 3,
                                            child: Text(
                                              item.importerName,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [Expanded(
                                            flex: 3,
                                            child: Text(
                                              cityCountry,
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Text(
                                              narrationText,
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(fontSize: 12),
                                            ),
                                          ),],),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color(0xFF2D7373),
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 16, vertical: 8),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                            ),
                                            onPressed: () {
                                              _openGoogleSearchInApp(
                                                context,
                                                importerName: item.importerName,
                                                country: item.country,
                                              );
                                            },
                                            child: const Text(
                                              'Search Site',
                                              style: TextStyle(
                                                color: AppColors.textWhite,
                                              ),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              IconButton(
                                                onPressed: () async {
                                                  await controller
                                                      .deleteImporter(index);
                                                },
                                                icon: const Icon(
                                                  Icons.delete_outline,
                                                  color: Colors.redAccent,
                                                  size: 20,
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  _openEditBuyerSheet(
                                                    context,
                                                    controller,
                                                    index,
                                                    item,
                                                  );
                                                },
                                                icon: const Icon(
                                                  Icons.edit_outlined,
                                                  color: Colors.blueAccent,
                                                  size: 20,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                        },
                      ),

                    ],
                  ),
                ),
            ),

            ],
            ),
          ),
        );
      },
    );
  }


  void _openAddImporterSheet(
    BuildContext context,
    OpenFolderController controller,
  ) {
    final formKey = GlobalKey<FormState>();
    final importerNameController = TextEditingController();
    final latitudeController = TextEditingController();
    final longitudeController = TextEditingController();
    final cityController = TextEditingController();
    final addressController = TextEditingController();
    final emailController = TextEditingController();
    final contactController = TextEditingController();
    final landlineController = TextEditingController();
    final contactPersonController = TextEditingController();
    final secondEmailController = TextEditingController();
    final narrationController = TextEditingController();
    String selectedCountry = 'Select Country';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 16,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                ),
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Expanded(
                              child: Text(
                                'Add into Existing Folder or Create New Folder',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                              splashRadius: 18,
                              onPressed: () => Get.back(),
                              icon: const Icon(Icons.close),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Obx(
                          () => DropdownButtonFormField<String>(
                            value: controller.countries.contains(selectedCountry)
                                ? selectedCountry
                                : 'Select Country',
                            decoration: const InputDecoration(
                              labelText: 'Country',
                              border: OutlineInputBorder(),
                            ),
                            items: controller.countries
                                .map(
                                  (c) => DropdownMenuItem<String>(
                                    value: c,
                                    child: Text(c),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedCountry = value ?? 'Select Country';
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: importerNameController,
                          decoration: const InputDecoration(
                            labelText: 'Buyer Name',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) => value == null || value.isEmpty
                              ? 'Required'
                              : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: emailController,
                          decoration: const InputDecoration(
                            labelText: 'Buyer Email (Optional)',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: addressController,
                          decoration: const InputDecoration(
                            labelText: 'Address (Optional)',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 2,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: latitudeController,
                                decoration: const InputDecoration(
                                  labelText: 'Latitude (Optional)',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextFormField(
                                controller: longitudeController,
                                decoration: const InputDecoration(
                                  labelText: 'Longitude (Optional)',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: cityController,
                                decoration: const InputDecoration(
                                  labelText: 'City (Optional)',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: contactController,
                                decoration: const InputDecoration(
                                  labelText: 'Cell (Optional)',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextFormField(
                                controller: landlineController,
                                decoration: const InputDecoration(
                                  labelText: 'Landline (Optional)',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: contactPersonController,
                                decoration: const InputDecoration(
                                  labelText: 'Contact Person (Optional)',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextFormField(
                                controller: secondEmailController,
                                decoration: const InputDecoration(
                                  labelText: 'Second Email (Optional)',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: narrationController,
                          decoration: const InputDecoration(
                            labelText: 'Narration (Optional)',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 2,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () => Get.back(),
                              child: const Text('Close'),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF003366),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 10,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                if (formKey.currentState?.validate() ??
                                    false) {
                                  final city = cityController.text.trim();
                                  final lat = latitudeController.text.trim();
                                  final lng = longitudeController.text.trim();

                                  controller
                                      .addOrUpdateBuyerFromForm(
                                        importerName: importerNameController.text
                                            .trim(),
                                        country: selectedCountry ==
                                                'Select Country'
                                            ? ''
                                            : selectedCountry,
                                        city: city,
                                        address: addressController.text.trim(),
                                        email: emailController.text.trim(),
                                        cell: contactController.text.trim(),
                                        latitude: lat,
                                        longitude: lng,
                                      )
                                      .then((ok) {
                                    if (ok) Get.back();
                                  });
                                }
                              },
                              child: const Text(
                                'Add Importer',
                                style: TextStyle(color: AppColors.textWhite),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _openEditBuyerSheet(
    BuildContext context,
    OpenFolderController controller,
    int index,
    ImporterItem item,
  ) {
    final formKey = GlobalKey<FormState>();

    final buyerNameController = TextEditingController(text: item.importerName);
    final buyerEmailController = TextEditingController(text: item.email);
    final addressController = TextEditingController(text: item.address);
    final cityController = TextEditingController(text: item.city);
    final cellController = TextEditingController(text: item.cell);
    final landlineController = TextEditingController(text: item.landline ?? '');
    final contactPersonController =
        TextEditingController(text: item.contactPerson ?? '');
    final secondEmailController =
        TextEditingController(text: item.secondEmail ?? '');
    final narrationController =
        TextEditingController(text: item.narration ?? '');

    final countryController = TextEditingController(text: item.country);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 16,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                ),
                child: Form(
                  key: formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Expanded(
                              child: Text(
                                'Edit My Buyer Details',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                              splashRadius: 18,
                              onPressed: () => Get.back(),
                              icon: const Icon(Icons.close),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: buyerNameController,
                          decoration: const InputDecoration(
                            labelText: 'Buyer Name',
                            border: OutlineInputBorder(),
                          ),
                          validator: (v) =>
                              v == null || v.trim().isEmpty ? 'Required' : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: buyerEmailController,
                          decoration: const InputDecoration(
                            labelText: 'Buyer Email (Optional)',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: addressController,
                          decoration: const InputDecoration(
                            labelText: 'Address (Optional)',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 2,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: cityController,
                          decoration: const InputDecoration(
                            labelText: 'City (Optional)',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: countryController,
                          decoration: const InputDecoration(
                            labelText: 'Country (Optional)',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: cellController,
                                decoration: const InputDecoration(
                                  labelText: 'Cell (Optional)',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextFormField(
                                controller: landlineController,
                                decoration: const InputDecoration(
                                  labelText: 'Landline (Optional)',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: contactPersonController,
                                decoration: const InputDecoration(
                                  labelText: 'Contact Person (Optional)',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextFormField(
                                controller: secondEmailController,
                                decoration: const InputDecoration(
                                  labelText: 'Second Email (Optional)',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: narrationController,
                          decoration: const InputDecoration(
                            labelText: 'Narration (Optional)',
                            border: OutlineInputBorder(),
                          ),
                          maxLines: 2,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () => Get.back(),
                              child: const Text('Close'),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFCC3333),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 10,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                if (formKey.currentState?.validate() ?? false) {
                                  // Try to parse lat/long from stored value: "lat,long"
                                  final latlong = item.latlong.trim();
                                  final parts = latlong.split(',');
                                  final lat = parts.isNotEmpty ? parts[0].trim() : '';
                                  final lng = parts.length > 1 ? parts[1].trim() : '';

                                  controller
                                      .addOrUpdateBuyerFromForm(
                                        id: item.id,
                                        importerName: buyerNameController.text
                                            .trim(),
                                        country: countryController.text.trim(),
                                        city: cityController.text.trim(),
                                        address: addressController.text.trim(),
                                        email: buyerEmailController.text.trim(),
                                        cell: cellController.text.trim(),
                                        latitude: lat,
                                        longitude: lng,
                                      )
                                      .then((ok) {
                                    if (ok) Get.back();
                                  });
                                }
                              },
                              child: const Text(
                                'Update My Buyer',
                                style: TextStyle(color: AppColors.textWhite),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // (removed) _pill helper for card/table UI
}

// (removed) _MetaChip: no longer used after table redesign


