import 'package:flutter/material.dart';
import 'package:inven/screens/customcard.dart';
import 'package:inven/code/listallsuppliers.dart';

class CategoryListWidget extends StatefulWidget {
  final List<String> businessNames;

  CategoryListWidget({
    required this.businessNames,
  });

  @override
  _CategoryListWidgetState createState() => _CategoryListWidgetState();
}

class _CategoryListWidgetState extends State<CategoryListWidget> {
  String? selectedBusinessName;
  Map<String, String> categoryMap = {};

  @override
  void initState() {
    super.initState();
    selectedBusinessName = widget.businessNames.first;
    _fetchSupplierData(selectedBusinessName!);
  }

  void _fetchSupplierData(String businessName) async {
    var response = await getAllSuppliers(businessName);
    if (response['statusCode'] == 200) {
      setState(() {
        categoryMap = response['suppliers'];
      });
    } else {
      // Handle error
      print('Error fetching suppliers');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomCard(
              child: DropdownButtonFormField<String>(
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
                      _fetchSupplierData(selectedBusinessName!);
                    });
                  }
                },
              ),
            ),
            SizedBox(height: 20),
            CustomCard(
              child: SingleChildScrollView(
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('No.')),
                    DataColumn(label: Text('Category')),
                    DataColumn(label: Text('Distributor')),
                  ],
                  rows: categoryMap.entries
                      .toList() // Convert iterable to list
                      .asMap()
                      .map(
                        (index, entry) => MapEntry(
                      index,
                      DataRow(
                        cells: [
                          DataCell(Text('${index + 1}')),
                          DataCell(Text('${entry.key}')),
                          DataCell(Text('${entry.value}')),
                        ],
                      ),
                    ),
                  )
                      .values
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}