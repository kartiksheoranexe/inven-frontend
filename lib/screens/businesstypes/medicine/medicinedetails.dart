import 'package:flutter/material.dart';
import 'package:inven/screens/customcard.dart';
import 'additem.dart';

class ItemDetailsWidget extends StatefulWidget {
  final List<String> businessNames;

  const ItemDetailsWidget({Key? key, required this.businessNames}) : super(key: key);

  @override
  _ItemDetailsWidgetState createState() => _ItemDetailsWidgetState();
}

class _ItemDetailsWidgetState extends State<ItemDetailsWidget> {
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
              _buildTile(context, 'ADD A NEW ITEM',
                  Colors.blueGrey, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddItemForm(businessNames: widget.businessNames),
                      ),
                    );
                  }),
              // _buildTile(context, 'UPDATE MEDICINE DETAILS',
              //     Colors.blueGrey, () {}),
              // _buildTile(context, 'DELETE MEDICINE',
              //     Colors.blueGrey, () {}),
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
