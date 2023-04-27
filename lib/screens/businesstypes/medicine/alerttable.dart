import 'package:flutter/material.dart';
import 'package:inven/models/alertmodel.dart';
import 'package:inven/screens/businesstypes/medicine/seefulldetails.dart';

class AlertCustomTable extends StatelessWidget {
  final List<Alert> data;

  AlertCustomTable({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
      child: Table(
        border: TableBorder.all(
          color: Colors.grey.shade400,
          width: 1,
        ),
        columnWidths: const {
          0: FixedColumnWidth(100),
          1: FixedColumnWidth(85),
          2: FixedColumnWidth(85),
          3: FixedColumnWidth(100),
        },
        children: [
          TableRow(
            decoration: BoxDecoration(
              color: Colors.grey.shade500,
            ),
            children: [
              TableCell(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Item',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              TableCell(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Distributor',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              TableCell(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Quantity',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              TableCell(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'See Full Details',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          ...data.map((row) => TableRow(
            children: [
              TableCell(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    row.itemName,
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                ),
              ),
              TableCell(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                   row.distributorName,
                    textAlign: TextAlign.center,
                    softWrap: true,),
                ),
              ),
              TableCell(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    row.quantity.toString(),
                    textAlign: TextAlign.center,
                    softWrap: true,),
                ),
              ),
              TableCell(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DataDisplayWidget(
                            category: row.category,
                            distributorName: row.distributorName,
                            itemName: row.itemName,
                            itemType: row.itemType,
                            size: row.size,
                            unitOfMeasurement: row.unitOfMeasurement,
                            currentQuantity: row.quantity,
                            alertQuantity: row.alertquantity,
                              additionalinfo: row.additionalInfo,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      'See Full Details',
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          )).toList(),
        ],
      ),
    ),
    );
  }
}
