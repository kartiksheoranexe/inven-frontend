class Alert {
  int id;
  String itemName;
  String itemType;
  double size;
  String unitOfMeasurement;
  int quantity;
  int alertquantity;
  Map<String, dynamic> additionalInfo;
  String category;
  String distributorName;

  Alert({
    required this.id,
    required this.itemName,
    required this.itemType,
    required this.size,
    required this.unitOfMeasurement,
    required this.quantity,
    required this.alertquantity,
    required this.additionalInfo,
    required this.category,
    required this.distributorName,
  });

  factory Alert.fromJson(Map<String, dynamic> json) {
    return Alert(
      id: json['id'],
      itemName: json['item_name'],
      itemType: json['item_type'],
      size: json['size'],
      unitOfMeasurement: json['unit_of_measurement'],
      quantity: json['quantity'],
      alertquantity: json['alert_quantity'],
      additionalInfo: json['additional_info'] ?? {},
      category: json['supplier']['category'],
      distributorName: json['supplier']['distributor_name'],
    );
  }
}
