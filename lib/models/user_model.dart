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
  /// List of permission codes (e.g. 1AB, 14GSK, 15GD) parsed from super_margin / super_margin_detail
  final List<String> permissionCodes;

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
    required this.permissionCodes,
  });

  // Parse from API response
  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Parse permission codes from multiple possible sources:
    // - API login response: "super_margin_detail" (list of {code, name})
    // - API login response: "super_margin" (comma-separated codes)
    // - Locally stored JSON: "permission_codes" (list of strings)

    // From stored list (local storage)
    List<String> codesFromStored = [];
    if (json['permission_codes'] is List) {
      codesFromStored = (json['permission_codes'] as List)
          .map((e) => e.toString())
          .where((e) => e.isNotEmpty)
          .toList();
    }

    // From "super_margin_detail" (API login)
    List<String> codesFromDetail = [];
    if (json['super_margin_detail'] is List) {
      codesFromDetail = (json['super_margin_detail'] as List)
          .whereType<Map<String, dynamic>>()
          .map((e) => e['code']?.toString() ?? '')
          .where((code) => code.isNotEmpty)
          .toList();
    }

    // From "super_margin" comma-separated string (API login / legacy)
    final superMarginRaw = json['super_margin']?.toString() ?? '';
    final List<String> codesFromString = superMarginRaw
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    // Merge and de-duplicate all sources
    final mergedCodes = <String>{};
    mergedCodes.addAll(codesFromStored);
    mergedCodes.addAll(codesFromDetail);
    mergedCodes.addAll(codesFromString);

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
      permissionCodes: mergedCodes.toList(),
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
      'permission_codes': permissionCodes,
    };
  }

  // Get full name
  String get fullName => '$firstName $lastName';

  // Helper to check if user has a specific permission code
  bool hasPermission(String code) {
    return permissionCodes.contains(code);
  }
}
