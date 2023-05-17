import 'package:flutter/material.dart';
import 'package:inven/screens/verifyotp.dart';
import 'package:inven/screens/widgetbackground.dart';
import '../code/passresetrequestapi.dart';
import 'button.dart';
import 'customcard.dart';
import 'mydiologbox.dart';

class ForgetPasswordWidget extends StatefulWidget {
  @override
  _ForgetPasswordWidgetState createState() => _ForgetPasswordWidgetState();
}

class _ForgetPasswordWidgetState extends State<ForgetPasswordWidget> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  bool _isLoading = false;

  void _handleOtpRequest() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final response = await requestPasswordReset(_email);

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 201) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => VerifyOtp(email: _email)),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return MyAlertDialog(
            title: 'Error',
            content: 'User not found',
            buttonText: 'Try Again',
            onButtonPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
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
                  _isLoading
                      ? CircularProgressIndicator()
                      : MyButton(
                    onPressed: _handleOtpRequest,
                    text: 'GET OTP',
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
