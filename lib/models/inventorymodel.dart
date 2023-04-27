class Item {
  int id;
  String itemName;
  String itemType;
  double size;
  String unitOfMeasurement;
  int quantity;
  double price;
  double cogs;
  int daystostockout;
  Map<String, dynamic> additionalInfo;
  String category;
  String distributorName;

  Item({
    required this.id,
    required this.itemName,
    required this.itemType,
    required this.size,
    required this.unitOfMeasurement,
    required this.quantity,
    required this.price,
    required this.cogs,
    required this.daystostockout,
    required this.additionalInfo,
    required this.category,
    required this.distributorName,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      itemName: json['item_name'],
      itemType: json['item_type'],
      size: json['size'],
      unitOfMeasurement: json['unit_of_measurement'],
      quantity: json['quantity'],
      price: double.parse(json['price'].toString()),
      cogs: double.parse(json['cogs'].toString()),
      daystostockout: json['daystostockout'],
      additionalInfo: json['additional_info'],
      category: json['supplier']['category'],
      distributorName: json['supplier']['distributor_name'],
    );
  }
}
