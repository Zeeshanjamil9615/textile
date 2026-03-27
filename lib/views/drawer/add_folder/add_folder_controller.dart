import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:textile/api_service/api_service.dart';
import 'package:textile/api_service/local_storage_service.dart';
import 'package:textile/widgets/custom_snackbar.dart';

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

  Future<bool> addFolder({
    required String firstName,
    required String lastName,
    required String folderName,
    required String description,
  }) async {
    final user = await LocalStorageService.getUserData();
    if (user == null || user.id.trim().isEmpty) {
      CustomSnackbar.error('Please log in to continue.');
      return false;
    }

    try {
      isLoading.value = true;
      final apiService = ApiService();
      final response = await apiService.createFolder(
        csId: user.id.trim(),
        companyName: user.company.trim(),
        csFname: firstName,
        csLname: lastName,
        folderName: folderName,
        folderDesc: description,
      );

      if (response.status == 200) {
        CustomSnackbar.success(response.message);
        await fetchFolders();
        return true;
      }

      CustomSnackbar.error(response.message);
      return false;
    } catch (_) {
      CustomSnackbar.error('Failed to create folder.');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteFolder(int index) async {
    if (index < 0 || index >= folders.length) return;

    final folder = folders[index];
    if (folder.folderId.trim().isEmpty) {
      CustomSnackbar.error('Invalid folder id.');
      return;
    }

    try {
      isLoading.value = true;
      final apiService = ApiService();
      final response = await apiService.deleteFolder(id: folder.folderId.trim());

      if (response.status == 200) {
        CustomSnackbar.success(response.message);
        await fetchFolders();
      } else {
        CustomSnackbar.error(response.message);
      }
    } catch (_) {
      CustomSnackbar.error('Failed to delete folder.');
    } finally {
      isLoading.value = false;
    }
  }
  void openDrawer() {
    scaffoldKey.currentState?.openDrawer();
  }
}




