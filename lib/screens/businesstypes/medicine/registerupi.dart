import 'package:flutter/material.dart';
import 'package:inven/screens/customcard.dart';
import 'package:inven/screens/button.dart';
import 'package:inven/screens/mydiologbox.dart';
import 'package:inven/code/registerupiapi.dart';

import '../../../code/deleteupiapi.dart';
import '../../../code/showupidetailsapi.dart';

class RegisterUpiWidget extends StatefulWidget {
  @override
  _RegisterUpiWidgetState createState() => _RegisterUpiWidgetState();
}

class _RegisterUpiWidgetState extends State<RegisterUpiWidget> {
  final _formKey = GlobalKey<FormState>();
  String _payeeVpa = '';
  String _payeeName = '';
  String _merchantCode = '';
  String _url = '';

  List<dynamic> upiDetails = [];

  void fetchUpiDetails() async {
    try {
      List<dynamic> details = await getUpiDetails();
      setState(() {
        upiDetails = details;
      });
    } catch (e) {
      print('Error: $e');
    }
  }


  @override
  void initState() {
    super.initState();
    fetchUpiDetails(); // Fetch the UPI details when the widget is initialized
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            CustomCard(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Payee VPA'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a payee VPA';
                          }
                          return null;
                        },
                        onChanged: (value) => _payeeVpa = value,
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Payee Name'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a payee name';
                          }
                          return null;
                        },
                        onChanged: (value) => _payeeName = value,
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Merchant Code (optional)'),
                        onChanged: (value) => _merchantCode = value,
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'URL (optional)'),
                        onChanged: (value) => _url = value,
                      ),
                      SizedBox(height: 24),
                      MyButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            try {
                              final response = await registerUpi(
                                payeeVpa: _payeeVpa,
                                payeeName: _payeeName,
                                merchantCode: _merchantCode,
                                url: _url,
                              );

                              if (response.statusCode == 201) {
                                showDialog(
                                  context: context,
                                  builder: (context) => MyAlertDialog(
                                    title: 'Registration successful',
                                    content: 'Your UPI registeration is successful',
                                    buttonText: 'OK',
                                    onButtonPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                );
                              } else if (response.statusCode == 400){
                                showDialog(
                                  context: context,
                                  builder: (context) => MyAlertDialog(
                                    title: 'Registration Unsuccessful',
                                    content: 'This UPI already exists!',
                                    buttonText: 'OK',
                                    onButtonPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                );
                              }
                              else{
                                print('failed!');
                              }
                            } catch (e) {
                              // Handle API call error
                            }
                          }
                        },
                        text: 'REGISTER',
                      ),
                    ],
                  ),
                ),
              ),
            ),
            CustomCard(
              child: upiDetails.length > 0
                  ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ACTIVE',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'SansSerif',
                    ),
                  ),
                  SizedBox(height: 25),
                  Text('UPI: ${upiDetails[0]['payee_vpa']}', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 20),
                  Text('Name: ${upiDetails[0]['payee_name']}', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 20),
                  Text('Merchant Code: ${upiDetails[0]['merchant_code']}', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 20),
                  Text('URL: ${upiDetails[0]['url']}', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 16),
                  MyButton(
                    text: 'DELETE',
                    onPressed: () async {
                      try {
                        await deleteUpiDetails(upiDetails[0]['payee_vpa']);
                        // Call a function to refresh the UPI details shown on the screen
                        fetchUpiDetails();
                      } catch (e) {
                        print('Error: $e');
                        // Optionally, you can show a dialog or a Snackbar with an error message
                      }
                    },
                  ),
                ],
              )
                  : Text('No active UPI details'),
            )
          ],
        ),
      ),
    );
  }
}
