import 'package:flutter/material.dart';
import 'package:inven/models/salesperformancemodel.dart';
import '../../customcard.dart';
import '../../mydiologbox.dart';

class SalesDetailWidget extends StatefulWidget {
  final List<SalesData> salesData;

  SalesDetailWidget({required this.salesData});

  @override
  _SalesDetailWidgetState createState() => _SalesDetailWidgetState();
}

class _SalesDetailWidgetState extends State<SalesDetailWidget> {
  int _currentPageIndex = 0;
  int _rowsPerPage = 8;

  List<SalesData> _displayedSalesData() {
    int startIndex = _currentPageIndex * _rowsPerPage;
    int endIndex = startIndex + _rowsPerPage;
    endIndex = endIndex > widget.salesData.length ? widget.salesData.length : endIndex;
    return widget.salesData.sublist(startIndex, endIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: SingleChildScrollView(
            child: CustomCard(
              child: Column(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columnSpacing: 10.0,
                      columns: const [
                        DataColumn(label: Text('Item Name')),
                        DataColumn(label: Text('Units Sold')),
                        DataColumn(label: Text('Revenue')),
                        DataColumn(label: Text('Details')),
                      ],
                      rows: _displayedSalesData()
                          .map((data) => DataRow(cells: [
                        DataCell(Text(data.itemName)),
                        DataCell(Text(data.unitsSold.toString())),
                        DataCell(Text('₹${data.revenue.toStringAsFixed(2)}')),
                        DataCell(
                          InkWell(
                            child: Text(
                              'Details',
                              style: TextStyle(color: Colors.blue),
                            ),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext ctx) {
                                  return MyAlertDialog(
                                    title: 'Details',
                                    content:
                                    'Distributor: ${data.distributor}\nCategory: ${data.category}\nRevenue: ₹${data.revenue.toStringAsFixed(2)}\nCOGS: ₹${data.cogs.toStringAsFixed(2)}\nProfit/Loss: ₹${data.profitLoss.toStringAsFixed(2)}',
                                    buttonText: 'Close',
                                    onButtonPressed: () {
                                      Navigator.pop(ctx);
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ]))
                          .toList(),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: _currentPageIndex > 0
                            ? () {
                          setState(() {
                            _currentPageIndex--;
                          });
                        }
                            : null,
                        icon: Icon(Icons.arrow_back),
                      ),
                      Text(' ${_currentPageIndex + 1}'),
                      IconButton(
                        onPressed:
                        (_currentPageIndex + 1) * _rowsPerPage < widget.salesData.length
                            ? () {
                          setState(() {
                            _currentPageIndex++;
                          });
                        }
                            : null,
                        icon: Icon(Icons.arrow_forward),
                      ),
                    ],
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
