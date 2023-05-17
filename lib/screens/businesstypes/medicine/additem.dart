import 'package:flutter/material.dart';
import 'package:inven/code/additemapi.dart';
import 'package:inven/screens/button.dart';
import 'package:inven/screens/customcard.dart';
import 'package:inven/screens/mydiologbox.dart';
import 'package:inven/screens/widgetbackground.dart';

class AddItemForm extends StatefulWidget {
  final List<String> businessNames;

  AddItemForm({required this.businessNames});

  @override
  _AddItemFormState createState() => _AddItemFormState();
}

class _AddItemFormState extends State<AddItemForm> {
  String? selectedBusinessName;
  String? selectedUnitOfMeasurement;
  List<MapEntry<String, String>> _additionalInfoFields = [];
  TextEditingController medicineNameController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController distributorController = TextEditingController();
  TextEditingController sizeController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController alertquantityController = TextEditingController();
  TextEditingController additionalKeyController = TextEditingController();
  TextEditingController additionalValueController = TextEditingController();

  @override
  void initState() {
    super.initState();
    selectedBusinessName = widget.businessNames.first;
    selectedUnitOfMeasurement = 'gm';
  }

  List<Widget> _buildAdditionalInfoFields() {
    List<Widget> additionalInfoFields = [];

    _additionalInfoFields.asMap().forEach((index, entry) {
      additionalInfoFields.add(
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(labelText: 'Additional Info - Key'),
                onChanged: (newValue) {
                  setState(() {
                    _additionalInfoFields[index] =
                        MapEntry(newValue, entry.value);
                  });
                },
                controller: TextEditingController(text: entry.key),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: TextField(
                decoration: InputDecoration(labelText: 'Additional Info - Value'),
                onChanged: (newValue) {
                  setState(() {
                    _additionalInfoFields[index] =
                        MapEntry(entry.key, newValue);
                  });
                },
                controller: TextEditingController(text: entry.value),
              ),
            ),
            IconButton(
              icon: Icon(Icons.remove_circle_outline),
              onPressed: () {
                setState(() {
                  _additionalInfoFields.removeAt(index);
                });
              },
            ),
          ],
        ),
      );
    });

    return additionalInfoFields;
  }

  void _submitForm() async {
    if (selectedBusinessName == null ||
        selectedUnitOfMeasurement == null ||
        medicineNameController.text.isEmpty ||
        categoryController.text.isEmpty ||
        distributorController.text.isEmpty ||
        sizeController.text.isEmpty ||
        quantityController.text.isEmpty ||
        priceController.text.isEmpty ) {
      return;
    }

    Map<String, String>? additionalInfo;
    if (_additionalInfoFields.isNotEmpty) {
      additionalInfo = Map<String, String>.fromEntries(_additionalInfoFields);
    }


    bool result = await addItem(
      businessName: selectedBusinessName!,
      category: categoryController.text,
      distributorName: distributorController.text,
      itemName: medicineNameController.text,
      size: sizeController.text,
      unitOfMeasurement: selectedUnitOfMeasurement!,
      quantity: int.parse(quantityController.text),
      price: double.parse(priceController.text),
      alertquantity: int.parse(alertquantityController.text),
      additionalInfo: additionalInfo,
    );

    showDialog(
      context: context,
      builder: (_) => MyAlertDialog(
        title: result ? 'Success' : 'Failed',
        content: result
            ? 'Item created successfully!'
            : 'Failed - item not created',
        buttonText: 'OK',
        onButtonPressed: () => Navigator.pop(context),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isButtonEnabled = selectedBusinessName != null &&
        selectedUnitOfMeasurement != null &&
        medicineNameController.text.isNotEmpty &&
        categoryController.text.isNotEmpty &&
        distributorController.text.isNotEmpty &&
        sizeController.text.isNotEmpty &&
        quantityController.text.isNotEmpty;

    return GradientScaffold(
      body: Center(
        child: Container(
          color: Colors.white,
          child: CustomCard(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: 'Business Name'),
                    value: selectedBusinessName,
                    items: widget.businessNames
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedBusinessName = newValue;
                      });
                    },
                  ),
                  TextField(
                    controller: medicineNameController,
                    decoration: InputDecoration(labelText: 'Item Name'),
                  ),
                  TextField(
                    controller: categoryController,
                    decoration: InputDecoration(labelText: 'Category'),
                  ),
                  TextField(
                    controller: distributorController,
                    decoration: InputDecoration(labelText: 'Distributor Name'),
                  ),
                  TextField(
                    controller: sizeController,
                    decoration: InputDecoration(labelText: 'Size'),
                  ),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(labelText: 'Unit of Measurement'),
                    value: selectedUnitOfMeasurement,
                    items: ['gm', 'kg', 'l', 'ml']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedUnitOfMeasurement = newValue;
                      });
                    },
                  ),
                  TextField(
                    controller: quantityController,
                    decoration: InputDecoration(labelText: 'Quantity'),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: alertquantityController,
                    decoration: InputDecoration(labelText: 'Alert Quantity'),
                    keyboardType: TextInputType.number,
                  ),
                  TextField(
                    controller: priceController,
                    decoration: InputDecoration(labelText: 'Price'),
                    keyboardType: TextInputType.number,
                  ),
                  SizedBox(height: 10),
                  Column(
                    children: [
                      Text(
                        'Additional Info',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: 200),
                        child: SingleChildScrollView(
                          child: Column(
                            children: _buildAdditionalInfoFields(),
                          ),
                        ),
                      ),
                    ],
                  ),

                  IconButton(
                    icon: Icon(Icons.add_circle_outline),
                    onPressed: () {
                      setState(() {
                        _additionalInfoFields.add(MapEntry('', ''));
                      });
                    },
                  ),
                  SizedBox(height: 20),
                  MyButton(
                    text: 'Add',
                    onPressed: isButtonEnabled ? _submitForm : () {},
                  ),
                ],
              ),
            ),
          ),
      ),
        ),
      ),
    );
  }


}
