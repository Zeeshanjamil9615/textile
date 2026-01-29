/// Single buyer/importer item from folderDetails API.
class FolderDetailItem {
  final String id;
  final String folderId;
  final String folderName;
  final String userId;
  final String userName;
  final String userCompany;
  final String name;
  final String email;
  final String address;
  final String city;
  final String country;
  final String cell;
  final String latlong;
  final String? contactPerson;
  final String? landline;
  final String? capacity;
  final String? productCode;
  final String? secondEmail;
  final String? description;
  final String? buyerType;

  FolderDetailItem({
    required this.id,
    required this.folderId,
    required this.folderName,
    required this.userId,
    required this.userName,
    required this.userCompany,
    required this.name,
    required this.email,
    required this.address,
    required this.city,
    required this.country,
    required this.cell,
    required this.latlong,
    this.contactPerson,
    this.landline,
    this.capacity,
    this.productCode,
    this.secondEmail,
    this.description,
    this.buyerType,
  });

  factory FolderDetailItem.fromJson(Map<String, dynamic> json) {
    return FolderDetailItem(
      id: json['id']?.toString() ?? '',
      folderId: json['folder_id']?.toString() ?? '',
      folderName: json['folder_name']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      userName: json['user_name']?.toString() ?? '',
      userCompany: json['user_company']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      country: json['country']?.toString() ?? '',
      cell: json['cell']?.toString() ?? '',
      latlong: json['latlong']?.toString() ?? '',
      contactPerson: json['contact_person']?.toString(),
      landline: json['landline']?.toString(),
      capacity: json['capacity']?.toString(),
      productCode: json['product_code']?.toString(),
      secondEmail: json['second_email']?.toString(),
      description: json['description']?.toString(),
      buyerType: json['buyer_type']?.toString(),
    );
  }
}
