import 'package:flutter/material.dart';
import 'package:inven/screens/businesstypes/medicine/salesperformance.dart';
import 'package:inven/screens/customcard.dart';
import 'package:inven/code/businessdetailapi.dart';
import 'package:inven/models/businessmodel.dart';
import 'package:inven/screens/businesstypes/medicine/showtransactions.dart';
import 'package:inven/screens/widgetbackground.dart';

class SalesWidget extends StatefulWidget {
  const SalesWidget({Key? key}) : super(key: key);

  @override
  _SalesWidgetState createState() => _SalesWidgetState();
}

class _SalesWidgetState extends State<SalesWidget> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      body: Center(
        child: CustomCard(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildTile(context, 'SALES', Colors.blueGrey.shade800, () {
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
                          return SalesPerformanceWidget(businessNames: businessNames);
                        } else if (snapshot.hasError) {
                          return Text('${snapshot.error}');
                        }
                        return Center(child: CircularProgressIndicator());
                      },
                    ),
                  ),
                );
              }),
              _buildTile(context, 'TRANSACTIONS', Colors.blueGrey.shade800, () {
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
                          return ShowTransactionWidget(businessNames: businessNames);
                        } else if (snapshot.hasError) {
                          return Text('${snapshot.error}');
                        }
                        return Center(child: CircularProgressIndicator());
                      },
                    ),
                  ),
                );
              }),
              _buildTile(context, 'PLACE ORDER', Colors.blueGrey.shade800, () {

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