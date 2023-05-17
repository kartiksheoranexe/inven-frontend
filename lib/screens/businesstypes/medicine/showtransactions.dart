import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:inven/screens/customcard.dart';
import 'package:inven/screens/button.dart';
import 'package:inven/code/itemsoldbydateapi.dart';
import 'package:inven/models/transactionmodel.dart';
import 'package:inven/screens/widgetbackground.dart';

class ShowTransactionWidget extends StatefulWidget {
  final List<String> businessNames;

  ShowTransactionWidget({
    required this.businessNames,
  });

  @override
  _ShowTransactionWidgetState createState() => _ShowTransactionWidgetState();
}

class _ShowTransactionWidgetState extends State<ShowTransactionWidget> {
  String? selectedBusinessName;
  DateTime _selectedDate = DateTime.now();
  List<Transaction> _transactions = [];
  int _currentPageIndex = 0;


  DateTime getCurrentIstDate() {
    DateTime currentUtcDate = DateTime.now().toUtc();
    Duration istTimeDifference = Duration(hours: 5, minutes: 30);
    DateTime currentIstDate = currentUtcDate.add(istTimeDifference);
    return currentIstDate;
  }

  TextEditingController _dateController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: getCurrentIstDate().add(Duration(days: 1)),

    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(_selectedDate);
      });
    }

  }

  List<Transaction> _displayedTransactions() {
    int startIndex = _currentPageIndex * 8;
    int endIndex = startIndex + 8;
    endIndex = endIndex > _transactions.length ? _transactions.length : endIndex;
    return _transactions.sublist(startIndex, endIndex);
  }


  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    selectedBusinessName = widget.businessNames.first;
    _dateController.text = DateFormat('yyyy-MM-dd').format(_selectedDate);
  }


  void _fetchTransactionData(String date, String? selectedBusinessName) async {
    if (selectedBusinessName == null) {
      print('Error: selectedBusinessName is null');
      return;
    }
    try {
      final List<Transaction> transactions = await getTransactionDetails(date, selectedBusinessName!);
      setState(() {
        _transactions = transactions;
      });
    } catch (e) {
      print('Error fetching transaction details: $e');
    }
  }

  void _showTransactionDetails(BuildContext context, Transaction transaction) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Transaction Details'),
          content: CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Item: ${transaction.itemDetails.itemName}'),
                Text('Unit: ${transaction.unit}'),
                Text('Amount: ${transaction.amount}'),
                Text('Time: ${transaction.time}'),
                Text('Transaction Id: ${transaction.transactionId}'),
                Text('Status: ${transaction.status}'),
              ],
            ),
          ),
          actions: [
            MyButton(
              onPressed: () => Navigator.of(context).pop(),
              text: 'Close',
            ),
          ],
        );
      },
    );

  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
          SingleChildScrollView(
            child: CustomCard(
            child: Column(
            children: [
                GestureDetector(
                onTap: () => _selectDate(context),
      child: AbsorbPointer(
      child: TextFormField(
        controller: _dateController,
        decoration: InputDecoration(
          labelText: 'Select a date',
        ),
      ),
      ),
      ),
      DropdownButtonFormField<String>(
      decoration: InputDecoration(
      labelText: 'Business Name',
      ),
      value: selectedBusinessName,
      items: widget.businessNames.map<DropdownMenuItem<String>>((String value) {
      return DropdownMenuItem<String>(
      value: value,
      child: Text(value),
      );
      }).toList(),
      onChanged: (String? newValue) {
      if (newValue != null) {
      setState(() {
      selectedBusinessName = newValue;
      // _fetchTransactionData(DateFormat('yyyy-MM-dd').format(_selectedDate));
      });
      }
      },
      ),
              SizedBox(height: 20),
              MyButton(
                text: 'PROCEED',
                onPressed: () {
                  _fetchTransactionData(DateFormat('yyyy-MM-dd').format(_selectedDate), selectedBusinessName);
                },
              ),
              // SizedBox(height: 20),
            ],
            ),
            ),
          ),
                SizedBox(height: 20),
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: CustomCard(
                    child: Column(
                      children: [
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columnSpacing: 15,
                            columns: [
                              DataColumn(label: Text('Item')),
                              DataColumn(label: Text('Unit')),
                              DataColumn(label: Text('Amount')),
                              DataColumn(label: Text('See Full Details')),
                            ],
                            rows: _displayedTransactions()
                                .map(
                                  (transaction) => DataRow(
                                cells: [
                                  DataCell(Text('${transaction.itemDetails.itemName}')),
                                  DataCell(Text('${transaction.unit}')),
                                  DataCell(Text('${transaction.amount}')),
                                  DataCell(
                                    InkWell(
                                      onTap: () => _showTransactionDetails(context, transaction),
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
                            )
                                .toList(),
                          ),
                        ),
                        Row( // Wrap navigation controls in a Row widget
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
                              onPressed: (_currentPageIndex + 1) * 8 < _transactions.length
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

              ],

          ),
      ),
    );
  }
}

