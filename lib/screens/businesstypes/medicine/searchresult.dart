import 'package:flutter/material.dart';
import 'package:inven/models/inventorymodel.dart';
import 'package:inven/screens/footer.dart';
import 'package:inven/screens/header.dart';
import 'package:inven/screens/businesstypes/medicine/customtable.dart';
import 'package:inven/screens/customcard.dart';
import 'package:inven/screens/widgetbackground.dart';

class SearchResultWidget extends StatefulWidget {
  final String businessName;
  List<Item> medicines = [];
  SearchResultWidget({Key? key, required this.medicines, required this.businessName}) : super(key: key);

  @override
  _SearchResultWidgetState createState() => _SearchResultWidgetState();
}

class _SearchResultWidgetState extends State<SearchResultWidget> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: Header(title: widget.businessName),
      body: Center(
        child: Container(
          width: 400,
          child: CustomCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                Text(
                  'Search Results',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                CustomTable(
                  items: widget.medicines,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Footer(
        currentIndex: _currentIndex,
        onTabTapped: _onTabTapped,
        businessName: widget.businessName,
      ),
    );
  }
}
