import 'package:flutter/material.dart';
import 'package:inven/models/alertmodel.dart';
import 'package:inven/screens/footer.dart';
import 'package:inven/screens/header.dart';
import 'package:inven/screens/customcard.dart';
import 'alerttable.dart';

class AlertWidget extends StatefulWidget {
  final String businessName;
  final List<Alert> alerts;
  AlertWidget({required this.businessName, required this.alerts});

  @override
  _AlertWidgetState createState() => _AlertWidgetState();
}

class _AlertWidgetState extends State<AlertWidget> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(title: widget.businessName),
      body: Center(
        child: Container(
          width: 400,
          child: CustomCard(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_alert,
                        color: Colors.red,
                        size: 30,
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  AlertCustomTable(
                    data: widget.alerts, // Pass the list of Alert objects to AlertCustomTable
                  ),
                ],
              ),
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