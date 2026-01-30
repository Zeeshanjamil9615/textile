import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile/api_service/api_service.dart';
import 'package:textile/api_service/local_storage_service.dart';
import 'package:textile/widgets/colors.dart';

class ImporterItem {
  final int sr;
  final String id;
  final String importerName;
  final String cityCountry;
  final String narration;

  ImporterItem({
    required this.sr,
    required this.id,
    required this.importerName,
    required this.cityCountry,
    required this.narration,
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
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchFolderDetails();
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
            final city = f.city.trim();
            final country = f.country.trim();
            final cityCountry = city.isEmpty && country.isEmpty
                ? '—'
                : city.isEmpty
                    ? country
                    : country.isEmpty
                        ? city
                        : '$city / $country';
            return ImporterItem(
              sr: e.key + 1,
              id: f.id,
              importerName: f.name,
              cityCountry: cityCountry,
              narration: f.description?.trim().isEmpty ?? true
                  ? (f.productCode?.trim().isEmpty ?? true
                      ? '—'
                      : f.productCode!)
                  : f.description!,
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

  void addImporter(ImporterItem item) {
    importers.add(
      ImporterItem(
        sr: importers.length + 1,
        id: item.id,
        importerName: item.importerName,
        cityCountry: item.cityCountry,
        narration: item.narration,
      ),
    );
  }

  void deleteImporter(int index) {
    if (index >= 0 && index < importers.length) {
      importers.removeAt(index);
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
                            children: const [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  'Sr#',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  'Importer Name\nCell',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  'City\nCountry',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  'Narration',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
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
                            return ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: controller.importers.length,
                            separatorBuilder: (_, __) =>
                                const Divider(height: 1),
                            itemBuilder: (context, index) {
                              final item = controller.importers[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 10),
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            '${item.sr}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Text(
                                            item.importerName,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Text(
                                            item.cityCountry,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Text(
                                            item.narration,
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(fontSize: 12),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
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
                                            // Dummy "Search Site" action
                                          },
                                          child: const Text('Search Site',style: TextStyle(color: AppColors.textWhite),),
                                        ),
                                        Row(
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                controller
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
                                                // Dummy "Edit" action
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
    String country = 'Select Country';
    final importerNameController = TextEditingController();
    final latitudeController = TextEditingController();
    final longitudeController = TextEditingController();
    final cityController = TextEditingController();
    final addressController = TextEditingController();
    final emailController = TextEditingController();
    final contactController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
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
                  DropdownButtonFormField<String>(
                    value: country,
                    decoration: const InputDecoration(
                      labelText: 'Country',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'Select Country',
                        child: Text('Select Country'),
                      ),
                      DropdownMenuItem(
                        value: 'UK',
                        child: Text('United Kingdom'),
                      ),
                      DropdownMenuItem(
                        value: 'France',
                        child: Text('France'),
                      ),
                      DropdownMenuItem(
                        value: 'Germany',
                        child: Text('Germany'),
                      ),
                    ],
                    onChanged: (value) {
                      country = value ?? 'Select Country';
                    },
                  ),
                    const SizedBox(height: 12),
                  TextFormField(
                    controller: importerNameController,
                    decoration: const InputDecoration(
                      labelText: 'Importer Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Required' : null,
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
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          controller: addressController,
                          decoration: const InputDecoration(
                            labelText: 'Address (Optional)',
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
                          controller: emailController,
                          decoration: const InputDecoration(
                            labelText: 'Email (Optional)',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          controller: contactController,
                          decoration: const InputDecoration(
                            labelText: 'Contact Number (Optional)',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
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
                                horizontal: 18, vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            if (formKey.currentState?.validate() ?? false) {
                              controller.addImporter(
                                ImporterItem(
                                  sr: 0,
                                  id: '',
                                  importerName:
                                      importerNameController.text.trim(),
                                  cityCountry:
                                      '${cityController.text.trim().isEmpty ? 'City' : cityController.text.trim()} / $country',
                                  narration:
                                      addressController.text.trim().isEmpty
                                          ? 'New importer'
                                          : addressController.text.trim(),
                                ),
                              );
                              Get.back();
                            }
                          },
                          child: const Text('Add Importer',style: TextStyle(color: AppColors.textWhite),),
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
  }
}


