import 'package:flutter/material.dart';
import 'package:inven/screens/customcard.dart';
import 'package:inven/screens/businesstypes/medicine/seebusinessdetails.dart';
import 'package:inven/screens/registerbusiness.dart';
import 'package:inven/models/businessmodel.dart';
import 'package:inven/code/businessdetailapi.dart';

class BusinessDetailsWidget extends StatefulWidget {


  const BusinessDetailsWidget({Key? key}) : super(key: key);

  @override
  _BusinessDetailsWidgetState createState() => _BusinessDetailsWidgetState();
}

class _BusinessDetailsWidgetState extends State<BusinessDetailsWidget> {
  int _currentIndex = 0;
  late Future<List<Business>> futureBusinesses;

  @override
  void initState() {
    super.initState();
    futureBusinesses = BusinessApi.fetchBusinesses();
  }

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
              _buildTile(context, 'REGISTER NEW BUSINESS',
                  Colors.blueGrey, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          RegisterBusinessWidget(),
                    ),
                  );
                },),
              _buildTile(context, 'SEE BUSINESS DETAILS', Colors.blueGrey, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FutureBuilder<List<Business>>(
                      future: futureBusinesses,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<Business> businesses = snapshot.data!;
                          return BusinessDetailWidget(businesses: businesses);
                        } else if (snapshot.hasError) {
                          return Text('${snapshot.error}');
                        }
                        return Center(child: CircularProgressIndicator());
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