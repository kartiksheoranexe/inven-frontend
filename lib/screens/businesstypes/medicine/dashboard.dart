import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:inven/screens/button.dart';
import 'package:inven/screens/customcard.dart';
import 'package:inven/screens/footer.dart';
import 'package:inven/screens/header.dart';
import 'package:inven/screens/mydiologbox.dart';
import 'package:inven/code/inventoryapi.dart';
import 'package:inven/code/updateqtyapi.dart';
import 'package:inven/code/barcodeapi.dart';
import 'package:inven/models/inventorymodel.dart';

import '../../../code/cartapi.dart';
import 'barcode.dart';
import 'checkout.dart';

class DashboardWidget extends StatefulWidget {
  final String businessName;

  DashboardWidget({required this.businessName});

  @override
  _DashboardWidgetState createState() => _DashboardWidgetState();
}

class _DashboardWidgetState extends State<DashboardWidget> {
  final _formKey = GlobalKey<FormState>();
  int _currentIndex = 0;
  String? _selectedMedicine;
  double? _selectedSize;
  String? _selectedUnit;
  String? _selectedDistributor;
  String? _selectedCategory;
  String? _selectedButton;
  List<Map<String, dynamic>> _additionalInfo = [];
  List<Item> medicines = [];
  List<String> _medicineUnits = [];
  List<double> _medicineSizes = [];
  List<String> _distributors = [];
  List<String> _categories = [];
  String? _selectedAdditionalInfo = null;

  final TextEditingController _medicineNameController = TextEditingController();
  final TextEditingController _fieldTextEditingController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();


  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Map<String, dynamic> parseAdditionalInfo(String input) {
    Map<String, dynamic> resultMap = {};
    List<String> pairs = input.split(',').map((e) => e.trim()).toList();

    for (String pair in pairs) {
      List<String> keyValue = pair.split(':').map((e) => e.trim()).toList();
      if (keyValue.length == 2) {
        resultMap[keyValue[0]] = keyValue[1];
      }
    }

    return resultMap;
  }


  Future<List<Item>> _searchMedicineName(String query) async {
    List<Item> searchResults =  await InventoryApi.searchItems(
      businessName: widget.businessName,
      category: '',
      distributorName: '',
      itemName: query,
    );

    Set<String> uniqueNames = searchResults.map((item) => item.itemName).toSet();
    List<Item> distinctMedicines = uniqueNames.map((name) {
      return searchResults.firstWhere((item) => item.itemName == name);
    }).toList();

    return distinctMedicines.take(4).toList();
  }


  Future<void> _getMedSizesAndUnits(String medicineName) async {
    List<Item> searchResults = await InventoryApi.searchItems(
      businessName: widget.businessName,
      category: '',
      distributorName: '',
      itemName: medicineName,
    );

    Set<double> uniqueSizes = searchResults.map((item) => item.size).toSet();
    Set<String> uniqueUnits = searchResults.map((item) => item.unitOfMeasurement).toSet();

    setState(() {
      _medicineSizes = uniqueSizes.toList();
      _medicineUnits = uniqueUnits.toList();
      if (_medicineUnits.isNotEmpty) {
        _selectedUnit = _medicineUnits.first;
      }
    });
  }

  Future<List<String>> _getDistributors(String medicineName, double size, String unit) async {
    List<Item> searchResults = await InventoryApi.searchItems(
      businessName: widget.businessName,
      category: '',
      distributorName: '',
      itemName: medicineName,
    );

    List<String> distributors = searchResults
        .where((item) => item.size == size && item.unitOfMeasurement == unit)
        .map((item) => item.distributorName)
        .toSet()
        .toList();

    return distributors;
  }

  void _updateDistributors() async {
    if (_selectedMedicine != null && _selectedSize != null && _selectedUnit != null) {
      List<String> distributors = await _getDistributors(_selectedMedicine!, _selectedSize!, _selectedUnit!);
      setState(() {
        _distributors = distributors;
      });
    }
  }

  Future<List<String>> _getCategories(String medicineName, double size, String unit, String distributor) async {
    List<Item> searchResults = await InventoryApi.searchItems(
      businessName: widget.businessName,
      category: '',
      distributorName: distributor,
      itemName: medicineName,
    );

    List<String> categories = searchResults
        .where((item) => item.size == size && item.unitOfMeasurement == unit)
        .map((item) => item.category)
        .toSet()
        .toList();

    return categories;
  }


  Future<void> _updateCategories() async {
    if (_selectedMedicine != null && _selectedSize != null && _selectedUnit != null && _selectedDistributor != null) {
      List<String> categories = await _getCategories(_selectedMedicine!, _selectedSize!, _selectedUnit!, _selectedDistributor!);
      setState(() {
        _categories = categories;
      });
    }
  }

  Future<List<Map<String, dynamic>>> _getAdditionalInfo(String medicineName, double size, String unit, String distributor, String category) async {
    List<Item> searchResults = await InventoryApi.searchItems(
      businessName: widget.businessName,
      category: category,
      distributorName: distributor,
      itemName: medicineName,
    );

    List<Map<String, dynamic>> additionalInfo = searchResults
        .where((item) => item.size == size && item.unitOfMeasurement == unit && item.category == category && item.distributorName == distributor)
        .map((item) => item.additionalInfo)
        .toSet()
        .toList();

    return additionalInfo;
  }

  Future<void> _updateAdditionalInfo() async {
    if (_selectedMedicine != null && _selectedSize != null && _selectedUnit != null && _selectedDistributor != null && _selectedCategory != null) {
      List<Map<String, dynamic>> additionalInfo = await _getAdditionalInfo(_selectedMedicine!, _selectedSize!, _selectedUnit!, _selectedDistributor!, _selectedCategory!);
      setState(() {
        _additionalInfo = additionalInfo;
      });
    }
  }
  final GlobalKey<FormFieldState> _additionalInfoDropdownKey = GlobalKey<FormFieldState>();

  Widget _buildAdditionalInfoDropdown() {
    if (_selectedMedicine == null ||
        _selectedSize == null ||
        _selectedUnit == null ||
        _selectedDistributor == null ||
        _selectedCategory == null) {
      return Text("");
    }

    return FutureBuilder(
      future: _getAdditionalInfo(
        _selectedMedicine!,
        _selectedSize!,
        _selectedUnit!,
        _selectedDistributor!,
        _selectedCategory!,
      ),
      builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            List<Map<String, dynamic>> additionalInfoList = snapshot.data!;
            List<String> additionalInfoStrings = additionalInfoList
                .map((info) => info.entries.map((e) => '${e.key}: ${e.value}').join(', '))
                .toList();
            if (_selectedAdditionalInfo == null ||
                !additionalInfoStrings.contains(_selectedAdditionalInfo)) {
              _selectedAdditionalInfo = additionalInfoStrings[0];
            }

            return DropdownButtonFormField<String>(
              key: _additionalInfoDropdownKey,
              hint: Text("Select Additional Info"),
              value: _selectedAdditionalInfo,
              onChanged: (String? value) {
                if (value != null) {
                  setState(() {
                    _selectedAdditionalInfo = value;
                    _additionalInfoDropdownKey.currentState?.didChange(value);
                  });
                }
              },
              items: additionalInfoStrings.map((String additionalInfoString) {
                return DropdownMenuItem<String>(
                  value: additionalInfoString,
                  child: Text(additionalInfoString),
                );
              }).toList(),
              selectedItemBuilder: (BuildContext context) {
                return additionalInfoStrings.map((String additionalInfoString) {
                  return Text(additionalInfoString);
                }).toList();
              },
            );
          } else {
            return Text("No Additional Info Available");
          }
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }



  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget buildButton(String label, Color color, VoidCallback onPressed) {
    bool isSelected = _selectedButton == label;
    return InkWell(
      onTap: () {
        onPressed();
        setState(() {
          _selectedButton = isSelected ? null : label;
        });
      },
      child: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: color.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ]
              : [],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(fontSize: 30, color: Colors.white),
          ),
        ),
      ),
    );
  }


  @override
  void dispose() {
    _medicineNameController.dispose();
    _fieldTextEditingController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
        future: _getToken(),
    builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
    return Center(child: CircularProgressIndicator());
    } else {
    if (snapshot.hasData && snapshot.data != null) {
    return Scaffold(
    appBar: Header(title: widget.businessName),
    body: SingleChildScrollView(
    padding: EdgeInsets.all(16.0),
    child: CustomCard(
    child: Padding(
    padding: EdgeInsets.all(8.0),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      TypeAheadFormField<Item>(
        textFieldConfiguration: TextFieldConfiguration(
          controller: _fieldTextEditingController,
          decoration: InputDecoration(hintText: 'Item Name'),
        ),
        suggestionsCallback: (pattern) async {
          return await _searchMedicineName(pattern);
        },
        itemBuilder: (context, Item suggestion) {
          return ListTile(
            title: Text(suggestion.itemName),
          );
        },
        suggestionsBoxDecoration: SuggestionsBoxDecoration(
          hasScrollbar: true,
        ),
        onSuggestionSelected: (Item suggestion) {
          setState(() {
            _selectedMedicine = suggestion.itemName;
            _fieldTextEditingController.text = suggestion.itemName;
          });
          _getMedSizesAndUnits(suggestion.itemName);
        },
      ),
      DropdownButtonFormField<String>(
        value: _selectedUnit,
        items: _medicineUnits.map((String unit) {
          return DropdownMenuItem<String>(
            value: unit,
            child: Text(unit),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _selectedUnit = newValue;
          });
        },
        decoration: InputDecoration(
          labelText: "Unit",
          hintText: "Select Unit",
        ),
      ),

      DropdownButtonFormField<double>(
        decoration: InputDecoration(
          labelText: 'Size',
        ),
        value: _selectedSize,
        items: _medicineSizes.map((size) {
          return DropdownMenuItem(
            child: Text(size.toString()),
            value: size,
          );
        }).toList(),
        onChanged: (double? newValue) {
          setState(() {
            _selectedSize = newValue;
          });
          _updateDistributors();
        },
      ),
      DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Distributor',
        ),
        value: _selectedDistributor,
        items: _distributors
            .map((distributor) => DropdownMenuItem(child: Text(distributor), value: distributor))
            .toList(),
        onChanged: (String? newValue) {
          setState(() {
            _selectedDistributor = newValue;
          });
          _updateCategories();
        },
      ),

      DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: 'Category',
        ),
        value: _selectedCategory,
        items: _categories
            .map((category) => DropdownMenuItem(child: Text(category), value: category))
            .toList(),
        onChanged: (String? newValue) {
          setState(() {
            _selectedCategory = newValue;
          });
          _updateAdditionalInfo();
        },
      ),
      Column(
        children: [
          _buildAdditionalInfoDropdown(),
        ],
      ),
      TextFormField(
        controller: _quantityController, // Added line
        decoration: InputDecoration(
          labelText: 'Quantity',
        ),
        keyboardType: TextInputType.number,
      ),

      SizedBox(height: 16),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildButton("+", Colors.green, () {
            // Handle the "+" button press
          }),
          buildButton("-", Colors.red, () {
            // Handle the "-" button press
          }),
        ],
      ),

      SizedBox(height: 16),
      SizedBox(
        width: double.infinity,
        child: MyButton(
          onPressed: () async {
            int quantityDelta = int.parse(_quantityController.text);
            final response = await updateItemQuantity(
              business: widget.businessName,
              distributorsName: _selectedDistributor ?? '',
              category: _selectedCategory ?? '',
              itemName: _selectedMedicine ?? '',
              itemType: "Medicine",
              size: (_selectedSize?.toInt() ?? 0),
              uom: _selectedUnit ?? '',
              quantityDelta: _selectedButton == "+" ? quantityDelta : -quantityDelta,
              additionalInfo: _selectedAdditionalInfo != null
                  ? parseAdditionalInfo(_selectedAdditionalInfo!)
                  : {},
            );

            if (response.statusCode == 200) {
              Map<String, dynamic> responseBody = jsonDecode(response.body);
              int? itemId = responseBody['item_id'];

              if (_selectedButton == "+") {
                showDialog(
                  context: context,
                  builder: (context) => MyAlertDialog(
                    title: responseBody['message'],
                    content: 'Updated quantity is ${responseBody['updated_quantity']}',
                    buttonText: 'OK',
                    onButtonPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                );
              }
              else {
                if (itemId != null) {
                  void _addItemToCart(int itemId, int quantity) async {
                    try {
                      Map<String, dynamic> response = await addItemToCart(itemId: itemId, quantity: quantity);
                      print('Response: $response');

                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Item added to checkout'),
                          content: Text('Add more items?'),
                          actions: [
                            Row(
                              children: [
                                MyButton(
                                  text: 'Checkout',
                                  onPressed: () {
                                    // Close the dialog
                                    Navigator.of(context).pop();

                                    // Navigate to CheckoutWidget
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => CheckoutWidget(bname: widget.businessName)),
                                    );
                                  },
                                ),
                                SizedBox(height: 5,),
                                MyButton(
                                  text: 'Add More Items',
                                  onPressed: () {
                                    // Stay on dashboard and refresh it
                                    Navigator.of(context).pop(); // Close the dialog
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(builder: (context) => DashboardWidget(businessName: widget.businessName)),
                                    );
                                  },
                                ),
                              ],
                            ),

                          ],
                        ),
                      );
                    } catch (e) {
                      print('Error: $e');
                    }
                  }
                  _addItemToCart(itemId, quantityDelta.abs());
                }
                else {
                  showDialog(
                    context: context,
                    builder: (context) => MyAlertDialog(
                      title: 'Failed',
                      content: 'QR code generation failed!}',
                      buttonText: 'OK',
                      onButtonPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  );
                }
              }
            } else {
              showDialog(
                context: context,
                builder: (context) => MyAlertDialog(
                  title: 'Failed',
                  content: 'Item Quantity is not present!',
                  buttonText: 'OK',
                  onButtonPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              );
            }
          },
          text: 'PROCEED',
        ),


      ),

      SizedBox(height: 16),
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
        return Container();
    },
    );

  }
}


