import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile/views/drawer/add_folder/add_folder_controller.dart';
import 'package:textile/views/drawer/add_folder/open_folder.dart';
import 'package:textile/views/drawer/drawer.dart';
import 'package:textile/widgets/colors.dart';
import 'package:textile/widgets/custom_app_bar.dart';

class AddFolderScreen extends StatelessWidget {
  const AddFolderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AddFolderController>(
      init: AddFolderController(),
      builder: (controller) {
        return Scaffold(
          key: controller.scaffoldKey,
          backgroundColor: const Color(0xFFF4F6F9),
          appBar: CustomAppBar(onMenuPressed: controller.openDrawer),
          drawer: const CustomDrawer(),
          body: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2D7373),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                  ),
                  onPressed: () {
                    Get.to(() => const _AddNewFolderForm());
                  },
                  icon: const Icon(Icons.create_new_folder_rounded,color: AppColors.textWhite,),
                  label: const Text(
                    'Add New Folder',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,color: AppColors.textWhite),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'My Folders',
                      style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Tap folder to see importers',
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Obx(() {
                if (controller.errorMessage.value.isNotEmpty)
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      controller.errorMessage.value,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                    ),
                  );
                return const SizedBox.shrink();
              }),
              Expanded(
                child: Obx(
                  () {
                    if (controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return RefreshIndicator(
                      onRefresh: controller.fetchFolders,
                      child: ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        itemCount: controller.folders.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                      final item = controller.folders[index];
                      return Material(
                        color: Colors.white,
                        elevation: 2,
                        borderRadius: BorderRadius.circular(12),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            Get.to(
                              () => OpenFolderScreen(
                                folderName: item.folderName,
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 18,
                                  backgroundColor:
                                      const Color(0xFF2D7373).withOpacity(0.1),
                                  child: Text(
                                    '${item.sr}',
                                    style: const TextStyle(
                                      color: Color(0xFF2D7373),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.folderName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        item.description,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    OutlinedButton.icon(
                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 6),
                                        side: const BorderSide(
                                          color: Color(0xFF2D7373),
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      ),
                                      onPressed: () {
                                        Get.to(
                                          () => OpenFolderScreen(
                                            folderName: item.folderName,
                                          ),
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.folder_open,
                                        size: 18,
                                        color: Color(0xFF2D7373),
                                      ),
                                      label: const Text(
                                        'Open',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF2D7373),
                                        ),
                                      ),
                                    ),
                                    TextButton.icon(
                                      onPressed: () {
                                        controller.deleteFolder(index);
                                      },
                                      icon: const Icon(
                                        Icons.delete_outline,
                                        color: Colors.redAccent,
                                        size: 18,
                                      ),
                                      label: const Text(
                                        'Delete',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.redAccent,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
        )]),
        );
      },
    );
  }
}

class _AddNewFolderForm extends StatefulWidget {
  const _AddNewFolderForm({Key? key}) : super(key: key);

  @override
  State<_AddNewFolderForm> createState() => _AddNewFolderFormState();
}

class _AddNewFolderFormState extends State<_AddNewFolderForm> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController(text: 'Hassan');
  final _lastNameController = TextEditingController(text: 'Qasim');
  final _folderNameController = TextEditingController();
  final _folderDescriptionController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _folderNameController.dispose();
    _folderDescriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddFolderController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6F9),
      appBar: AppBar(
        title: const Text('Add New Folder'),
        backgroundColor: const Color(0xFF2D7373),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: const BoxDecoration(
                        color: Color(0xFF2D7373),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Enter Details',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Personal details',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _firstNameController,
                            decoration: const InputDecoration(
                              labelText: 'First Name*',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) => value == null ||
                                    value.isEmpty
                                ? 'Required'
                                : null,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _lastNameController,
                            decoration: const InputDecoration(
                              labelText: 'Last Name*',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) => value == null ||
                                    value.isEmpty
                                ? 'Required'
                                : null,
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Folder Details',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextFormField(
                            controller: _folderNameController,
                            decoration: const InputDecoration(
                              labelText: 'Folder name*',
                              hintText: 'Folder Name',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) => value == null ||
                                    value.isEmpty
                                ? 'Required'
                                : null,
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _folderDescriptionController,
                            maxLines: 3,
                            decoration: const InputDecoration(
                              labelText: 'Folder Description',
                              hintText: 'Optional',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Upload Image',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              // Dummy picker - no real image handling for now
                            },
                            icon: const Icon(Icons.image_outlined),
                            label: const Text('Choose file'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2D7373),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                  ),
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      controller.addFolder(
                        folderName: _folderNameController.text.trim(),
                        description:
                            _folderDescriptionController.text.trim().isEmpty
                                ? 'No description'
                                : _folderDescriptionController.text.trim(),
                      );
                      Get.back();
                    }
                  },
                  child: const Text(
                    'Create Folder',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,color: AppColors.textWhite),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


