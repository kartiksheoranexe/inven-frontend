import 'package:flutter/material.dart';
import 'package:inven/models/businessmodel.dart';
import 'package:inven/screens/customcard.dart';

class BusinessDetailWidget extends StatelessWidget {
  final List<Business> businesses;

  const BusinessDetailWidget({Key? key, required this.businesses})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      body: Center(
        child: CustomCard(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: businesses.map((business) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          business.businessName,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(business.businessType),
                        Text(business.businessAddress),
                        Text(
                            '${business.businessCity}, ${business.businessState}, ${business.businessCountry}'),
                        Text(business.businessPhone),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
