import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inven/screens/button.dart';
import 'package:inven/screens/customcard.dart';
import 'package:inven/screens/welcome.dart';

import '../code/verifyotpapi.dart';
import 'mydiologbox.dart';
import 'newpassword.dart';

class VerifyOtp extends StatefulWidget {
  final String email;

  VerifyOtp({required this.email});

  @override
  _VerifyOtpState createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp> {
  List<TextEditingController> _otpControllers = List.generate(6, (index) => TextEditingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomCard(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: _otpControllers
                    .asMap()
                    .entries
                    .map((entry) => _otpTextField(entry.key))
                    .toList(),
              ),
              SizedBox(height: 24),
              MyButton(
                onPressed: () async {
                  // Combine the OTP digits from the individual controllers
                  String combinedOtp = _otpControllers.map((controller) => controller.text).join('');

                  // Call the verifyOtp function with the email from the widget and combined OTP
                  bool isOtpVerified = await verifyOtp(identifier: widget.email, otp: combinedOtp);

                  if (isOtpVerified) {
                    // Show a dialog indicating that the OTP is verified
                    showDialog(
                      context: context,
                      builder: (context) => MyAlertDialog(
                        title: 'OTP Verified!',
                        content: 'Click on New Password',
                        buttonText: 'NEW PASSWORD',
                        onButtonPressed: () {
                          // Navigate to the NewPassword widget (you'll need to create this)
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => NewPasswordWidget(email: widget.email, otp: combinedOtp)),
                          );
                        },
                      ),
                    );
                  } else {
                    // Show a dialog indicating that the OTP verification failed
                    showDialog(
                      context: context,
                      builder: (context) => MyAlertDialog(
                        title: 'OTP Verification failed',
                        content: 'OTP didn\'t match!',
                        buttonText: 'OKAY',
                        onButtonPressed: () {
                          // Navigate back to MyHomePage() widget
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => MyHomePage()),
                                (Route<dynamic> route) => false,
                          );
                        },
                      ),
                    );
                  }
                },
                text: 'Verify',
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _otpTextField(int index) {
    return SizedBox(
      width: 40,
      child: TextField(
        controller: _otpControllers[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        decoration: InputDecoration(
          counterText: "",
          border: OutlineInputBorder(),
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < _otpControllers.length - 1) {
            FocusScope.of(context).nextFocus();
          }
        },
      ),
    );
  }
}
