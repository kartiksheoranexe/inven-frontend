class Business {
  final String businessName;
  final String businessType;
  final String businessAddress;
  final String businessCity;
  final String businessState;
  final String businessCountry;
  final String businessPhone;

  Business({
    required this.businessName,
    required this.businessType,
    required this.businessAddress,
    required this.businessCity,
    required this.businessState,
    required this.businessCountry,
    required this.businessPhone,
  });

  factory Business.fromJson(Map<String, dynamic> json) {
    return Business(
      businessName: json['business_name'],
      businessType: json['business_type'],
      businessAddress: json['business_address'],
      businessCity: json['business_city'],
      businessState: json['business_state'],
      businessCountry: json['business_country'],
      businessPhone: json['business_phone'],
    );
  }
}
