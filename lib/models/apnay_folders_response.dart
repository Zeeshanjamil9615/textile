/// Single folder item from apnayFolders API.
class ApnayFolderItem {
  final String folderId;
  final String csFolder;
  final String csFolderDetails;
  final String userId;
  final String csFname;
  final String csLname;
  final String csCompany;
  final String csStatus;
  final String? image;

  ApnayFolderItem({
    required this.folderId,
    required this.csFolder,
    required this.csFolderDetails,
    required this.userId,
    required this.csFname,
    required this.csLname,
    required this.csCompany,
    required this.csStatus,
    this.image,
  });

  factory ApnayFolderItem.fromJson(Map<String, dynamic> json) {
    return ApnayFolderItem(
      folderId: json['folder_id']?.toString() ?? '',
      csFolder: json['cs_folder']?.toString() ?? '',
      csFolderDetails: json['cs_folder_details']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      csFname: json['cs_fname']?.toString() ?? '',
      csLname: json['cs_lname']?.toString() ?? '',
      csCompany: json['cs_company']?.toString() ?? '',
      csStatus: json['cs_status']?.toString() ?? '',
      image: json['image']?.toString(),
    );
  }
}

/// Wrapper for apnayFolders API data (data.folders + data.type).
class ApnayFoldersData {
  final List<ApnayFolderItem> folders;
  final String type;

  ApnayFoldersData({
    required this.folders,
    required this.type,
  });

  factory ApnayFoldersData.fromJson(Map<String, dynamic> json) {
    final list = json['folders'];
    final List<ApnayFolderItem> foldersList = [];
    if (list is List) {
      for (final e in list) {
        if (e is Map<String, dynamic>) {
          foldersList.add(ApnayFolderItem.fromJson(e));
        }
      }
    }
    return ApnayFoldersData(
      folders: foldersList,
      type: json['type']?.toString() ?? '',
    );
  }
}
