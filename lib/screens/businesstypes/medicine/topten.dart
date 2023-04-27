import 'package:flutter/material.dart';
import '../../customcard.dart';


class TopTenWidget extends StatelessWidget {
  final List<dynamic> topItems;

  TopTenWidget({required this.topItems});

  void _showItemDetails(BuildContext context, Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: CustomCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Size: ${item['size']} ${item['unit_of_measurement']}'),
                Text('Distributor: ${item['distributor']}'),
                Text('Category: ${item['category']}'),
                Text('COGS: ₹${item['cogs']}'),
                Text('Profit/Loss: ₹${item['profit_loss']}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 10,
      child: CustomCard(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columnSpacing: 2,
            columns: [
              DataColumn(label: Text('Rank')),
              DataColumn(label: Text('Item')),
              DataColumn(label: Text('Units Sold')),
              DataColumn(label: Text('Revenue')),
              DataColumn(label: Text('Details')),
            ],
            rows: topItems
                .asMap()
                .map(
                  (index, item) => MapEntry(
                index,
                DataRow(
                  cells: [
                    DataCell(Text('${index + 1}')),
                    DataCell(Text('${item['item_name']}')),
                    DataCell(Text('${item['units_sold']}')),
                    DataCell(Text('₹${item['revenue']}')),
                    DataCell(
                      InkWell(
                        onTap: () => _showItemDetails(context, item),
                        child: Text(
                          'Click Here',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
                .values
                .toList(),
          ),
        ),
      ),
    );
  }
}
