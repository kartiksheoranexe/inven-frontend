import 'package:flutter/material.dart';
import 'package:inven/screens/customcard.dart';
import 'package:inven/screens/widgetbackground.dart';
import 'supplier.dart';
import 'listallsupp.dart';
import 'package:inven/code/listallsuppliers.dart';

class SupplierDetailsWidget extends StatefulWidget {
  final List<String> businessNames;

  const SupplierDetailsWidget({Key? key, required this.businessNames}) : super(key: key);

  @override
  _SupplierDetailsWidgetState createState() => _SupplierDetailsWidgetState();
}

class _SupplierDetailsWidgetState extends State<SupplierDetailsWidget> {
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
              _buildTile(context, 'EDIT SUPPLIER',
                  Colors.blueGrey.shade800, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SupplierEditWidget(businessNames: widget.businessNames),
                      ),
                    );
                  }),
              _buildTile(context, 'LIST ALL SUPPLIER',
                  Colors.blueGrey.shade800, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CategoryListWidget(
                            businessNames: widget.businessNames,
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
