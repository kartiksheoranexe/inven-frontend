import 'package:flutter/material.dart';
import 'package:inven/code/getbusinessapi.dart';
import 'button.dart';
import 'package:inven/screens/businesstypes/medicine/alert.dart';
import 'package:inven/code/alertapi.dart';
import 'package:inven/models/alertmodel.dart';
import 'package:inven/screens/businesstypes/medicine/alert.dart';


class BusinessSelectionDialog extends StatefulWidget {
  final List<Business> businesses;
  final Function(String)? onBusinessSelected;

  const BusinessSelectionDialog({Key? key, required this.businesses, this.onBusinessSelected}) : super(key: key);

  @override
  _BusinessSelectionDialogState createState() => _BusinessSelectionDialogState();
}

class _BusinessSelectionDialogState extends State<BusinessSelectionDialog> {
  String? _selectedBusinessName;
  late List<Alert> alerts;

  void _onSelectPressed() async {
    // if (widget.onBusinessSelected != null) {
    //   print('hello');
    //   widget.onBusinessSelected!(_selectedBusinessName!);
    // }
    try {
      alerts = await AlertApi.alertMedicines(businessName: _selectedBusinessName!);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AlertWidget(alerts: alerts, businessName: _selectedBusinessName ?? ''),
        ),
      );
    } catch (e) {
      print('Error loading alerts: $e');
      // You can show a Snackbar or any other error handling mechanism to inform the user about the error
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select a business'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: widget.businesses.map((business) {
            return RadioListTile<String>(
              title: Text(business.businessName),
              value: business.businessName,
              groupValue: _selectedBusinessName,
              onChanged: (String? value) {
                setState(() {
                  _selectedBusinessName = value;
                });
              },
            );
          }).toList(),
        ),
      ),
      actions: [
        MyButton(
          text: 'CANCEL',
          onPressed: () => Navigator.pop(context),
          // onPressed: () {print(widget.businesses);},
        ),
        MyButton(
          text: 'SELECT',

          onPressed:  _onSelectPressed,
        ),
      ],
    );
  }
}
