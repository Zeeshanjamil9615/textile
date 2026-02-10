class SellerDetails {
  final String id;
  final String importer;
  final String latlong;
  final String country;
  final String city;
  final String address;
  final String email;
  final String contactNumber;
  final String website;
  final String recordFound;

  SellerDetails({
    required this.id,
    required this.importer,
    required this.latlong,
    required this.country,
    required this.city,
    required this.address,
    required this.email,
    required this.contactNumber,
    required this.website,
    required this.recordFound,
  });

  factory SellerDetails.fromJson(Map<String, dynamic> json) {
    return SellerDetails(
      id: json['id']?.toString() ?? '',
      importer: json['importer']?.toString() ?? '',
      latlong: json['latlong']?.toString() ?? '',
      country: json['country']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      contactNumber: json['contact_number']?.toString() ?? '',
      website: json['website']?.toString() ?? '',
      recordFound: json['record_found']?.toString() ?? '',
    );
  }
}

