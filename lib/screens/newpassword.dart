import 'package:flutter/material.dart';
import 'package:inven/screens/welcome.dart';

import '../code/newpasswordapi.dart';
import 'button.dart';
import 'customcard.dart';
import 'mydiologbox.dart';

class NewPasswordWidget extends StatefulWidget {
  final String email;
  final String otp;

  NewPasswordWidget({required this.email, required this.otp});

  @override
  _NewPasswordWidgetState createState() => _NewPasswordWidgetState();
}
class _NewPasswordWidgetState extends State<NewPasswordWidget> {
  final _formKey = GlobalKey<FormState>();
  String _newPassword = '';
  String _confirmPassword = '';

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
                    obscureText: true,
                    decoration: InputDecoration(labelText: 'New Password'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a new password';
                      }
                      return null;
                    },
                    onChanged: (value) => _newPassword = value,
                  ),
                  TextFormField(
                    obscureText: true,
                    decoration: InputDecoration(labelText: 'Confirm New Password'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm the new password';
                      } else if (value != _newPassword) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                    onChanged: (value) => _confirmPassword = value,
                  ),
                  SizedBox(height: 24),
                  MyButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final response = await resetPassword(
                          email: widget.email,
                          otp: widget.otp,
                          newPassword: _newPassword,
                        );

                        if (response.statusCode == 200) {
                          showDialog(
                            context: context,
                            builder: (context) => MyAlertDialog(
                              title: 'Password reset successful',
                              content: 'Password has been changed successfully!',
                              buttonText: 'LOGIN',
                              onButtonPressed: () {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (context) => MyHomePage()),
                                      (Route<dynamic> route) => false,
                                );
                              },
                            ),
                          );
                        } else {
                          // Handle error cases
                        }
                      }
                    },
                    text: 'Proceed',
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