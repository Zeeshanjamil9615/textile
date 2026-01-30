import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile/views/drawer/add_folder/add_folder.dart';
import 'package:textile/views/drawer/add_folder/add_folder_controller.dart';
import 'package:textile/views/drawer/add_folder/open_folder.dart';
import 'package:textile/widgets/colors.dart';

void showFolderSelectionBottomSheet(BuildContext context) {
  // Ensure AddFolderController is initialized
  if (!Get.isRegistered<AddFolderController>()) {
    Get.put(AddFolderController());
  }
  final folderController = Get.find<AddFolderController>();
  
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Text(
                    'Add into Existing Folder or Create New Folder',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white24, height: 1),
          // Folder List
          Expanded(
            child: Obx(() => ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: folderController.folders.length,
              itemBuilder: (context, index) {
                final folder = folderController.folders[index];
                return ListTile(
                  leading: const Icon(
                    Icons.folder,
                    color: Colors.white,
                    size: 24,
                  ),
                  title: Text(
                    folder.folderName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Get.to(() => OpenFolderScreen(folderName: folder.folderName, folderId: '',));
                  },
                );
              },
            )),
          ),
          const Divider(color: Colors.white24, height: 1),
          // Create New Folder option
          ListTile(
            leading: const Icon(
              Icons.create_new_folder,
              color: Colors.white,
              size: 24,
            ),
            title: const Text(
              'Create New Folder',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              Get.to(() => const AddFolderScreen());
            },
          ),
          // Close button
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: AppColors.primaryDark,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Close',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

