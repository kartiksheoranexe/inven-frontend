import 'package:flutter/material.dart';
import 'package:inven/screens/customcard.dart';
import 'package:inven/screens/button.dart';
import 'package:inven/screens/mydiologbox.dart';
import 'package:inven/code/registerupiapi.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomCard(
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
      ),
    );
  }
}
