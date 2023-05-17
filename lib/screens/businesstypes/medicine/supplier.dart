import 'package:flutter/material.dart';
import 'package:inven/screens/customcard.dart';
import 'package:inven/screens/button.dart';
import 'package:inven/screens/mydiologbox.dart';
import 'package:inven/code/addsupplier.dart';
import 'package:inven/code/delsupplier.dart';
import 'package:inven/screens/widgetbackground.dart';

class SupplierEditWidget extends StatefulWidget {
  final List<String> businessNames;

  const SupplierEditWidget({Key? key, required this.businessNames}) : super(key: key);

  @override
  _SupplierEditWidgetState createState() => _SupplierEditWidgetState();
}

class _SupplierEditWidgetState extends State<SupplierEditWidget> {
  late TextEditingController _categoryController;
  late TextEditingController _distributorController;
  String? selectedBusinessName;

  @override
  void initState() {
    super.initState();
    _categoryController = TextEditingController();
    _distributorController = TextEditingController();
  }

  @override
  void dispose() {
    _categoryController.dispose();
    _distributorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      body: Center(
        child: CustomCard(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                      });
                    }
                  },
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _categoryController,
                  decoration: InputDecoration(labelText: 'Category'),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _distributorController,
                  decoration: InputDecoration(labelText: 'Distributor'),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MyButton(
                      text: 'Add',
                      onPressed: () async {
                        if (_distributorController.text.isNotEmpty && _categoryController.text.isEmpty) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return MyAlertDialog(
                                title: 'Error',
                                content: 'Distributor name cannot be given alone. Please provide a category.',
                                buttonText: 'Ok',
                              );
                            },
                          );
                        } else {
                          final response = await createSupplier(
                            selectedBusinessName!,
                            _categoryController.text,
                            _distributorController.text,
                          );
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              if (response['statusCode'] == 201) {
                                return MyAlertDialog(
                                  title: 'Success',
                                  content: 'Category "${_categoryController.text}" and distributor name "${_distributorController.text}" are successfully added under $selectedBusinessName',
                                  buttonText: 'Ok',
                                );
                              } else {
                                return MyAlertDialog(
                                  title: 'Error',
                                  content: response['body']['message'],
                                  buttonText: 'Ok',
                                );
                              }
                            },
                          );
                        }
                      },
                    ),
                    // MyButton(
                    //   text: 'Update',
                    //   onPressed: () {
                    //     print('Update button pressed');
                    //   },
                    // ),
                    MyButton(
                      text: 'Delete',
                      onPressed: () {
                        if (_categoryController.text.isEmpty) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return MyAlertDialog(
                                title: 'Error',
                                content: 'Please enter a category to delete a distributor.',
                                buttonText: 'Ok',
                              );
                            },
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return MyAlertDialog(
                                title: 'Confirm Delete',
                                content: 'Are you sure you want to delete?',
                                buttonText: 'Confirm',
                                onButtonPressed: () async {
                                  Navigator.pop(context);
                                  final response = await deleteSupplier(selectedBusinessName!, _categoryController.text, _distributorController.text.isEmpty ? '' : _distributorController.text);
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      if (response['statusCode'] == 200) {
                                        return MyAlertDialog(
                                          title: 'Success',
                                          content: 'Category "${_categoryController.text}" and distributor name "${_distributorController.text.isEmpty ? '' : _distributorController.text}" under $selectedBusinessName are deleted successfully',
                                          buttonText: 'Ok',
                                        );
                                      } else {
                                        return MyAlertDialog(
                                          title: 'Error',
                                          content: response['body']['message'],
                                          buttonText: 'Ok',
                                        );
                                      }
                                    },
                                  );
                                },
                              );
                            },
                          );
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
