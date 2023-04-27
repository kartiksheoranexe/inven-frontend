class Transaction {
  final String transactionId;
  final String time;
  final int unit;
  final String amount;
  final String status;
  final ItemDetails itemDetails;

  Transaction({required this.transactionId, required this.time, required this.unit, required this.amount, required this.status, required this.itemDetails});

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      transactionId: json['transaction_id'] ?? '',
      time: json['time'] ?? '',
      unit: json['unit'] ?? 0,
      amount: json['amount'] ?? '',
      status: json['status'] ?? '',
      itemDetails: ItemDetails.fromJson(json['item_details'] ?? {}),
    );
  }
}

class ItemDetails {
  final int id;
  final String itemName;
  final String itemType;
  final double size;
  final String unitOfMeasurement;
  final int quantity;
  final int alertQuantity;
  final String price;
  final Map<String, dynamic> additionalInfo;
  final String importedDate;
  final String createdAt;
  final int supplier;

  ItemDetails({
    required this.id,
    required this.itemName,
    required this.itemType,
    required this.size,
    required this.unitOfMeasurement,
    required this.quantity,
    required this.alertQuantity,
    required this.price,
    required this.additionalInfo,
    required this.importedDate,
    required this.createdAt,
    required this.supplier,
  });

  factory ItemDetails.fromJson(Map<String, dynamic> json) {
    return ItemDetails(
      id: json['id'] ?? 0,
      itemName: json['item_name'] ?? '',
      itemType: json['item_type'] ?? '',
      size: (json['size'] ?? 0).toDouble(),
      unitOfMeasurement: json['unit_of_measurement'] ?? '',
      quantity: json['quantity'] ?? 0,
      alertQuantity: json['alert_quantity'] ?? 0,
      price: json['price'] ?? '',
      additionalInfo: json['additional_info'] ?? {},
      importedDate: json['imported_date'] ?? '',
      createdAt: json['created_at'] ?? '',
      supplier: json['supplier'] ?? 0,
    );
  }
}
