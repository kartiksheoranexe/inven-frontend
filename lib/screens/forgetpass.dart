import 'package:flutter/material.dart';
import 'package:inven/screens/verifyotp.dart';
import '../code/passresetrequestapi.dart';
import 'button.dart';
import 'customcard.dart';

class ForgetPasswordWidget extends StatefulWidget {
  @override
  _ForgetPasswordWidgetState createState() => _ForgetPasswordWidgetState();
}

class _ForgetPasswordWidgetState extends State<ForgetPasswordWidget> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';

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
                    decoration: InputDecoration(labelText: 'Enter your email'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email';
                      }
                      return null;
                    },
                    onChanged: (value) => _email = value,
                  ),
                  SizedBox(height: 24),
                  MyButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // Call API to send OTP to the entered email
                        final response = await requestPasswordReset(_email);
                        // Navigate to VerifyOtp widget
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => VerifyOtp(email: _email)),
                        );
                      }
                    },
                    text: 'Get OTP',
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
