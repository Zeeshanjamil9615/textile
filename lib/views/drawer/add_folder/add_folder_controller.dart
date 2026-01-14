import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FolderItem {
  final int sr;
  final String folderName;
  final String description;
  final String imageUrl;

  FolderItem({
    required this.sr,
    required this.folderName,
    required this.description,
    required this.imageUrl,
  });
}

class AddFolderController extends GetxController {
  final folders = <FolderItem>[].obs;
  final scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  void onInit() {
    super.onInit();
    _loadDummyData();
  }

  void _loadDummyData() {
    folders.assignAll([
      FolderItem(
        sr: 1,
        folderName: 'Testing2',
        description: 'testing',
        imageUrl: '',
      ),
      FolderItem(
        sr: 2,
        folderName: 'UK buyers',
        description: 'testing to add uk buyers',
        imageUrl: '',
      ),
      FolderItem(
        sr: 3,
        folderName: 'Test',
        description: 'testing',
        imageUrl: '',
      ),
    ]);
  }

  void addFolder({
    required String folderName,
    required String description,
  }) {
    final nextSr = folders.length + 1;
    folders.add(
      FolderItem(
        sr: nextSr,
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




