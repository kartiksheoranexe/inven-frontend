import 'package:flutter/material.dart';
import 'package:inven/code/businessdetailapi.dart';
import 'package:inven/models/businessmodel.dart';
import 'package:inven/screens/customcard.dart';
import 'package:inven/screens/businesstypes/medicine/businessdetails.dart';
import 'package:inven/screens/businesstypes/medicine/supplierdetails.dart';
import 'package:inven/screens/businesstypes/medicine/medicinedetails.dart';

class BusinessWidget extends StatefulWidget {
  const BusinessWidget({Key? key}) : super(key: key);

  @override
  _BusinessWidgetState createState() => _BusinessWidgetState();
}

class _BusinessWidgetState extends State<BusinessWidget> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomCard(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTile(context, 'BUSINESS', Colors.blueGrey, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BusinessDetailsWidget(),
                  ),
                );
              }),
              _buildTile(context, 'SUPPLIER', Colors.blueGrey, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FutureBuilder<List<Business>>(
                      future: BusinessApi.fetchBusinesses(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<String> businessNames = snapshot.data!
                              .map((business) => business.businessName)
                              .toList();
                          return SupplierDetailsWidget(businessNames: businessNames);
                        } else if (snapshot.hasError) {
                          return Text('${snapshot.error}');
                        }
                        return Center(child: CircularProgressIndicator());
                      },
                    ),
                  ),
                );
              }),
                _buildTile(context, 'ITEM',
                    Colors.blueGrey, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FutureBuilder<List<Business>>(
                            future: BusinessApi.fetchBusinesses(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                List<String> businessNames = snapshot.data!
                                    .map((business) => business.businessName)
                                    .toList();
                                return ItemDetailsWidget(businessNames: businessNames);
                              } else if (snapshot.hasError) {
                                return Text('${snapshot.error}');
                              }
                              return CircularProgressIndicator();
                            },
                          ),
                        ),
                      );
                    }),
              ],
            ),
          ),
        ),
      );
  }


  Widget _buildTile(BuildContext context, String title, Color color,
      Function()? onTap, {double width = 400, double height = 100}) {
    return Container(
      width: width,
      height: height,
      child: Card(
        color: color,
        child: InkWell(
          onTap: onTap,
          child: Center(
            child: Text(
              title,
              style: TextStyle(fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'SansSerif'),
            ),
          ),
        ),
      ),
    );
  }
}