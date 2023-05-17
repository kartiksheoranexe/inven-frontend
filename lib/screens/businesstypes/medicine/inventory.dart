import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:file_picker/file_picker.dart';
import 'package:inven/screens/widgetbackground.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:inven/screens/button.dart';
import 'package:inven/screens/header.dart';
import 'package:inven/screens/footer.dart';
import 'package:inven/screens/customcard.dart';
import 'package:inven/screens/businesstypes/medicine/customtable.dart';
import 'package:inven/code/inventoryapi.dart';
import 'package:inven/code/exceluploadapi.dart';
import 'package:inven/models/inventorymodel.dart';

import '../../mydiologbox.dart';

class InventoryWidget extends StatefulWidget {
  final String businessName;

  const InventoryWidget({required this.businessName, Key? key})
      : super(key: key);

  @override
  _InventoryWidgetState createState() => _InventoryWidgetState();
}

class _InventoryWidgetState extends State<InventoryWidget> {
  int _currentIndex = 0;
  List<Item> medicines = [];
  String? _selectedMedicine;
  int _currentPageIndex = 0;

  String? _selectedDistributor;

  List<String> _categoryOptions = [];
  String? _selectedCategory;

  TextEditingController _distributorController = TextEditingController();

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  List<Item> _displayedMedicines() {
    int startIndex = _currentPageIndex * 8;
    int endIndex = startIndex + 8;
    endIndex = endIndex > medicines.length ? medicines.length : endIndex;
    return medicines.sublist(startIndex, endIndex);
  }

  void _onCategoryChanged(String value) {
    setState(() {
      _selectedCategory = value;
    });
  }

  Future<List<Item>> _searchDistributorName(String query) async {
    List<Item> searchResults = await InventoryApi.searchItems(
      businessName: widget.businessName,
      category: '',
      distributorName: query,
      itemName: '',
    );

    Set<String> uniqueNames = searchResults.map((item) => item.distributorName).toSet();
    List<Item> distinctDistributors = uniqueNames.map((name) {
      return searchResults.firstWhere((item) => item.distributorName == name);
    }).toList();

    return distinctDistributors;
  }


  Future<void> _fetchCategoryOptions() async {
    List<Item> medicines = await InventoryApi.searchItems(
      businessName: widget.businessName,
      itemName: '',
      distributorName: _selectedDistributor!,
      category: '',
    );
    setState(() {
      _categoryOptions = medicines.map((medicine) => medicine.category).toSet().toList();
    });
  }

  void _onSearchPressed() async {
    List<Item> medicineList = await InventoryApi.searchItems(
        businessName: widget.businessName,
        category: _selectedCategory!,
        distributorName: _selectedDistributor!,
        itemName: ''
    );
    setState(() {
      medicines = medicineList;
    });
  }


  @override
  void dispose() {
    _distributorController.dispose();
    super.dispose();
  }

  void _pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );
    print(result);
    if (result == null) return;

    // we get the file from result object
    final platformFile = result.files.first;
    final file = io.File(platformFile.path!); // Create a new File object using the path of the picked file
    final response = await importItemExcel(file);

    // Handle the response
    showDialog(
      context: context,
      builder: (context) {
        String content;
        if (response['status'] == 'success') {
          content = '${response['message']}\n';
          content += 'Added Rows: ${response['added_rows']}\n';
          content += 'Updated Rows: ${response['updated_rows']}';
        } else {
          content = response['message'];
        }

        return MyAlertDialog(
          title: response['status'] == 'success' ? 'Import Successful' : 'Import Failed',
          content: content,
          buttonText: 'OK',
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: Header(title: widget.businessName),
      body: Center(
        child: Container(
          width: 400,
          child: CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            Autocomplete<Item>(
            optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue == '') {
          return const Iterable<Item>.empty();
          }
          return _searchDistributorName(textEditingValue.text);
          },
            displayStringForOption: (Item option) => option.distributorName,
            onSelected: (Item selection) async {
              setState(() {
                _selectedDistributor = selection.distributorName;
                _distributorController.text = selection.distributorName;
              });
              await _fetchCategoryOptions();
            },
            fieldViewBuilder: (BuildContext context,
                TextEditingController fieldTextEditingController,
                FocusNode fieldFocusNode,
                VoidCallback onFieldSubmitted) {
              _distributorController.addListener(() {
                fieldTextEditingController.text = _distributorController.text;
              });
              return TextFormField(
                controller: _distributorController,
                focusNode: fieldFocusNode,
                decoration: InputDecoration(hintText: 'Distributor'),
                onChanged: (value) {
                  setState(() {
                    _selectedDistributor = value;
                  });
                },
              );
            },
          ),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  hint: Text('Category'),
                  onChanged: (String? value) {
                    _onCategoryChanged(value!);
                  },
                  items: _categoryOptions.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyButton(
                      onPressed: _onSearchPressed,
                      text: 'PROCEED',
                    ),
                    IconButton(
                      onPressed:_pickFiles,
                      icon: Icon(Icons.upload_file),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                CustomTable(
                  items: _displayedMedicines(),
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
                      onPressed: (_currentPageIndex + 1) * 8 < medicines.length
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
      bottomNavigationBar: Footer(
        currentIndex: _currentIndex,
        onTabTapped: _onTabTapped,
        businessName: widget.businessName,
      ),
    );
  }
}
