import 'package:flutter/material.dart';
import 'package:inven/code/getbusinessapi.dart';
import 'package:inven/screens/button.dart';
import 'package:inven/screens/customcard.dart';
import 'package:inven/code/registerbusinessapi.dart';
import 'package:inven/code/loginapi.dart';

import 'package:inven/screens/listofbusiness.dart';
import 'package:inven/screens/widgetbackground.dart';

class ConfirmWidget extends StatelessWidget {
  final String businessName;
  final String businessType;
  final String businessAddress;
  final String businessCity;
  final String businessState;
  final String businessCountry;
  final String businessPhone;
  final String businessEmail;

  ConfirmWidget({
    required this.businessName,
    required this.businessType,
    required this.businessAddress,
    required this.businessCity,
    required this.businessState,
    required this.businessCountry,
    required this.businessPhone,
    required this.businessEmail,
  });

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
        body: SingleChildScrollView(
        child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
    child: Column(
    children: [
    Align(
    alignment: Alignment.topCenter,
    child: Padding(
    padding: EdgeInsets.only(top: 70.0),
    child: Text(
    'INVEN©',
    style: TextStyle(
    fontSize: 35,
    color: Colors.black,
    fontFamily: 'Sans Serif',
    ),
    ),
    ),
    ),
    CustomCard(
    child: Padding(
    padding: EdgeInsets.all(16.0),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text('Business Name: $businessName'),
    SizedBox(height: 10),
    Text('Business Type: $businessType'),
    SizedBox(height: 10),
    Text('Business Address: $businessAddress'),
    SizedBox(height: 10),
    Text('Business City: $businessCity'),
    SizedBox(height: 10),
    Text('Business State: $businessState'),
    SizedBox(height: 10),
    Text('Business Country: $businessCountry'),
    SizedBox(height: 10),
    Text('Business Phone: $businessPhone'),
    SizedBox(height: 10),
    Text('Business Email: $businessEmail'),
    SizedBox(height: 20),
      MyButton(
        text: 'CONFIRM AND PROCEED',
        onPressed: () {
          AuthStorage.getToken().then((authToken) {
            if (authToken == null) {
              Navigator.pushNamed(context, '/');
            } else {
              AuthStorage.getUsername().then((username) {
                BusinessRegistration registrationData =
                BusinessRegistration(
                  businessName: businessName,
                  businessType: businessType,
                  businessAddress: businessAddress,
                  businessCity: businessCity,
                  businessState: businessState,
                  businessCountry: businessCountry,
                  businessPhone: businessPhone,
                  businessEmail: businessEmail,
                );
                registerBusiness(registrationData, authToken)
                    .then((responseData) {
                  if (responseData != null) {
                    getBusinessList().then((businesses) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ListBusinessWidget(
                                businesses: businesses,
                                username: username!,
                              ),
                        ),
                      );
                    });
                  }
                });
              });
            }
          });
        },
      ),
    ],
    ),
    ),
    ),
    SizedBox(height: 20),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Need to change details? '),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'GO BACK',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    ],
    ),
        ),
        ),
    );
  }
}

