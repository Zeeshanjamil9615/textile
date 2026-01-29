import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile/api_service/api_service.dart';
import 'package:textile/api_service/local_storage_service.dart';

class FolderItem {
  final int sr;
  final String folderId;
  final String folderName;
  final String description;
  final String imageUrl;

  FolderItem({
    required this.sr,
    required this.folderId,
    required this.folderName,
    required this.description,
    required this.imageUrl,
  });
}

class AddFolderController extends GetxController {
  final folders = <FolderItem>[].obs;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchFolders();
  }

  Future<void> fetchFolders() async {
    final user = await LocalStorageService.getUserData();
    if (user == null || user.id.isEmpty) {
      errorMessage.value = 'Please log in to view folders.';
      folders.clear();
      return;
    }
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final apiService = ApiService();
      final response = await apiService.getApnayFolders(user.id);
      if (response.status == 200 && response.data != null) {
        final list = response.data!.folders;
        folders.assignAll(
          list.asMap().entries.map((e) {
            final f = e.value;
            return FolderItem(
              sr: e.key + 1,
              folderId: f.folderId,
              folderName: f.csFolder,
              description: f.csFolderDetails.isEmpty ? 'No description' : f.csFolderDetails,
              imageUrl: f.image ?? '',
            );
          }),
        );
      } else {
        errorMessage.value = response.message;
        folders.clear();
      }
    } catch (e) {
      errorMessage.value = 'Failed to load folders.';
      folders.clear();
    } finally {
      isLoading.value = false;
    }
  }

  void addFolder({
    required String folderName,
    required String description,
  }) {
    final nextSr = folders.length + 1;
    folders.add(
      FolderItem(
        sr: nextSr,
        folderId: '',
        folderName: folderName,
        description: description,
        imageUrl: '',
      ),
    );
  }

  void deleteFolder(int index) {
    if (index >= 0 && index < folders.length) {
      folders.removeAt(index);
    }
  }
  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }
}




