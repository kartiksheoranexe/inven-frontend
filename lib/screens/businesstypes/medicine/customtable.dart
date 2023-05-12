import 'package:flutter/material.dart';
import 'package:inven/models/inventorymodel.dart';
import 'package:inven/screens/button.dart';
import 'package:inven/screens/mydiologbox.dart';

class CustomTable extends StatelessWidget {
  final List<Item> items;

  CustomTable({required this.items});

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
            0: FixedColumnWidth(120),
            1: FixedColumnWidth(70),
            2: FixedColumnWidth(70),
            3: FixedColumnWidth(100),
            // 4: FixedColumnWidth(100),
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
                      'Size',
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
            ...items.map((item) => TableRow(
              children: [
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(item.itemName),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('${item.size} ${item.unitOfMeasurement}'),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('${item.quantity}'),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text('Item Details'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Item ID: ${item.id}'),
                                SizedBox(height: 8),
                                Text('Item Type: ${item.itemType}'),
                                SizedBox(height: 8),
                                Text('Price: ${item.price}'),
                                SizedBox(height: 8),
                                Text('COGS: ${item.cogs}'),
                                SizedBox(height: 8),
                                Text('Days to stock out: ${item.daystostockout}'),
                                SizedBox(height: 8),
                                Text('Category: ${item.category}'),
                                SizedBox(height: 8),
                                Text('Distributor: ${item.distributorName}'),
                                SizedBox(height: 8),
                                if (item.additionalInfo.isNotEmpty)
                                  Text('Additional Info: ${item.additionalInfo.toString()}'),
                              ],
                            ),
                            actions: [
                              MyButton(
                                text: 'Close',
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                            'See Full Details',
                            // overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                          ),
                          ),
                          ),
                        ],
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
