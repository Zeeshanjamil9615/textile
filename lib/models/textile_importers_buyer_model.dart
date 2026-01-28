class TextileImportersBuyerModel {
  final String id;
  final String mltcd;
  final String sb;
  final String date;
  final String pct;
  final String description;
  final String code;
  final String country;
  final String ntn;
  final String exporter;
  final String importer;
  final String city;
  final String latlong;
  final String address;
  final String email;
  final String contactNumber;
  final String qty;
  final String unit;
  final String unitPrice;
  final String currCode;
  final String valueFc;
  final String valuePkr;

  TextileImportersBuyerModel({
    required this.id,
    required this.mltcd,
    required this.sb,
    required this.date,
    required this.pct,
    required this.description,
    required this.code,
    required this.country,
    required this.ntn,
    required this.exporter,
    required this.importer,
    required this.city,
    required this.latlong,
    required this.address,
    required this.email,
    required this.contactNumber,
    required this.qty,
    required this.unit,
    required this.unitPrice,
    required this.currCode,
    required this.valueFc,
    required this.valuePkr,
  });

  factory TextileImportersBuyerModel.fromJson(Map<String, dynamic> json) {
    return TextileImportersBuyerModel(
      id: json['id']?.toString() ?? '',
      mltcd: json['mltcd']?.toString() ?? '',
      sb: json['sb']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      pct: json['pct']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      code: json['code']?.toString() ?? '',
      country: json['country']?.toString() ?? '',
      ntn: json['ntn']?.toString() ?? '',
      exporter: json['exporter']?.toString() ?? '',
      importer: json['importer']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      latlong: json['latlong']?.toString() ?? '',
      address: json['address']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      contactNumber: json['contact_number']?.toString() ?? '',
      qty: json['qty']?.toString() ?? '',
      unit: json['unit']?.toString() ?? '',
      unitPrice: json['unit price']?.toString() ?? '',
      currCode: json['curr_code']?.toString() ?? '',
      valueFc: json['value (fc)']?.toString() ?? '',
      valuePkr: json['value_pkr']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mltcd': mltcd,
      'sb': sb,
      'date': date,
      'pct': pct,
      'description': description,
      'code': code,
      'country': country,
      'ntn': ntn,
      'exporter': exporter,
      'importer': importer,
      'city': city,
      'latlong': latlong,
      'address': address,
      'email': email,
      'contact_number': contactNumber,
      'qty': qty,
      'unit': unit,
      'unit price': unitPrice,
      'curr_code': currCode,
      'value (fc)': valueFc,
      'value_pkr': valuePkr,
    };
  }
}
