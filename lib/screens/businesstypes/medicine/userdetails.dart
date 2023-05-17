import 'package:flutter/material.dart';
import 'package:inven/screens/customcard.dart';
import 'package:inven/screens/businesstypes/medicine/businessdetails.dart';
import 'package:inven/screens/businesstypes/medicine/registerupi.dart';
import 'package:inven/screens/widgetbackground.dart';


class UserWidget extends StatefulWidget {
  const UserWidget({Key? key}) : super(key: key);

  @override
  _UserWidgetState createState() => _UserWidgetState();
}

class _UserWidgetState extends State<UserWidget> {
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
              _buildTile(context, 'UPI REGISTER', Colors.blueGrey.shade800, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RegisterUpiWidget(),
                  ),
                );
              }),
              _buildTile(context, 'USER DETAILS', Colors.blueGrey.shade800, () {

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