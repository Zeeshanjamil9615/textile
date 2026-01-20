class UserModel {
  final String id;
  final String gender;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String company;
  final String country;
  final String state;
  final String city;
  final String address;
  final String postcode;
  final String status;
  final String superId;
  final String superMargin;
  final String agent;
  final String ipAddress;
  final String commission;
  final String agentCurrency;
  final String expiry;

  UserModel({
    required this.id,
    required this.gender,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.company,
    required this.country,
    required this.state,
    required this.city,
    required this.address,
    required this.postcode,
    required this.status,
    required this.superId,
    required this.superMargin,
    required this.agent,
    required this.ipAddress,
    required this.commission,
    required this.agentCurrency,
    required this.expiry,
  });

  // Parse from API response
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['cs_id']?.toString() ?? '',
      gender: json['cs_gender']?.toString() ?? '',
      firstName: json['cs_fname']?.toString() ?? '',
      lastName: json['cs_lname']?.toString() ?? '',
      email: json['cs_email']?.toString() ?? '',
      phone: json['cs_phone']?.toString() ?? '',
      company: json['cs_company']?.toString() ?? '',
      country: json['cs_country']?.toString() ?? '',
      state: json['cs_state']?.toString() ?? '',
      city: json['cs_city']?.toString() ?? '',
      address: json['cs_address']?.toString() ?? '',
      postcode: json['cs_postcode']?.toString() ?? '',
      status: json['cs_status']?.toString() ?? '',
      superId: json['super_id']?.toString() ?? '',
      superMargin: json['super_margin']?.toString() ?? '',
      agent: json['cs_agent']?.toString() ?? '',
      ipAddress: json['cs_ipaddress']?.toString() ?? '',
      commission: json['commission']?.toString() ?? '',
      agentCurrency: json['agent_currency']?.toString() ?? '',
      expiry: json['cs_expiry']?.toString() ?? '',
    );
  }

  // Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'cs_id': id,
      'cs_gender': gender,
      'cs_fname': firstName,
      'cs_lname': lastName,
      'cs_email': email,
      'cs_phone': phone,
      'cs_company': company,
      'cs_country': country,
      'cs_state': state,
      'cs_city': city,
      'cs_address': address,
      'cs_postcode': postcode,
      'cs_status': status,
      'super_id': superId,
      'super_margin': superMargin,
      'cs_agent': agent,
      'cs_ipaddress': ipAddress,
      'commission': commission,
      'agent_currency': agentCurrency,
      'cs_expiry': expiry,
    };
  }

  // Get full name
  String get fullName => '$firstName $lastName';
}
