import 'package:flutter/material.dart';
import 'package:inven/screens/customcard.dart';

class DataDisplayWidget extends StatelessWidget {
  final String? category;
  final String? distributorName;
  final String? itemName;
  final String? itemType;
  final double? size;
  final String? unitOfMeasurement;
  final int? currentQuantity;
  final int? alertQuantity;
  final Map<String, dynamic>? additionalinfo;

  DataDisplayWidget({
    this.category,
    this.distributorName,
    this.itemName,
    this.itemType,
    this.size,
    this.unitOfMeasurement,
    this.currentQuantity,
    this.alertQuantity,
    this.additionalinfo,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: Header(),
      body: Center(
        child: Container(
          width: 400,
          child: CustomCard(
            child: Center( // Wrap the Column in a Center widget
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height:50),
                  Text(
                    "Category: $category",
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Distributor Name: $distributorName",
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Item: $itemName",
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Type: $itemType",
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Size: $size",
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Unit of Measure: $unitOfMeasurement",
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Current Quantity: $currentQuantity",
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Alert Quantity: $alertQuantity",
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    "Additional Info: $additionalinfo",
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
