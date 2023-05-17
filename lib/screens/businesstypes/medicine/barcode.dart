import 'dart:typed_data';
import 'package:inven/screens/widgetbackground.dart';

import '../../../code/deletecartitemapi.dart';
import 'dashboard.dart';
import 'package:flutter/material.dart';
import 'package:inven/screens/button.dart';
import 'package:inven/screens/customcard.dart';
import 'package:inven/code/updatetransactionapi.dart';

class BarCodeWidget extends StatefulWidget {
  final Uint8List? barCodePng;
  final String bname;
  final List<String> tids;
  final List<int> cids;

  BarCodeWidget({required this.barCodePng, required this.bname, required this.tids, required this.cids});

  @override
  _BarCodeWidgetState createState() => _BarCodeWidgetState();
}

class _BarCodeWidgetState extends State<BarCodeWidget> {

  Future<void> deleteAllCartItems() async {
    for (int cartItemId in widget.cids) {
      try {
        await deleteCartItem(cartItemId);
      } catch (e) {
        print('Error deleting cart item: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      body: Center(
        child: CustomCard(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widget.barCodePng != null
                  ? Image.memory(
                widget.barCodePng!,
                fit: BoxFit.contain,
              )
                  : CircularProgressIndicator(),
              SizedBox(height: 8),
              Center(
                // child: Text(
                //     'Transaction ID: ${widget.tid}'
                // ),
              ),
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: MyButton(
                    onPressed: () async {
                      await updateTransactionStatus(transactionIds: widget.tids, identifier: 'Y');
                      await deleteAllCartItems();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DashboardWidget(businessName: widget.bname),
                        ),
                      );
                    },
                    text: 'Success',
                  ),
                ),
              ),
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: MyButton(
                    onPressed: () async {
                      await updateTransactionStatus(transactionIds: widget.tids, identifier: 'N');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DashboardWidget(businessName: widget.bname),
                        ),
                      );
                    },
                    text: 'Failed',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
