import 'dart:typed_data';

import 'package:flutter/material.dart';
import '../../../code/barcodeapi.dart';
import '../../../code/deletecartitemapi.dart';
import '../../../code/getcartitems.dart';
import '../../button.dart';
import '../../customcard.dart';
import 'barcode.dart';

class CheckoutWidget extends StatefulWidget {
  final String bname;
  // List<int> cartItemIds = [];

  CheckoutWidget({required this.bname});

  @override
  _CheckoutWidgetState createState() => _CheckoutWidgetState();
}

class _CheckoutWidgetState extends State<CheckoutWidget> {
  List<dynamic> cartItems = [];
  double totalPrice = 0;
  double discount = 0;
  List<String> transactionIds = [];
  List<int> cartItemIds = [];

  @override
  void initState() {
    super.initState();
    fetchCartItems();
  }

  void fetchCartItems() async {
    try {
      List<dynamic> items = await getCartItems();
      setState(() {
        cartItems = items;
        totalPrice = items.fold(0, (sum, item) => sum + item['total_price']);
        transactionIds = items.map((item) => item['transaction_id']).toList().cast<String>();
        cartItemIds = items.map((item) => item['cart_item_id']).toList().cast<int>();
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> handleCartItemDeletion(int cartItemId) async {
    try {
      await deleteCartItem(cartItemId);
      fetchCartItems(); // Refresh the cart items after deletion
    } catch (e) {
      print('Error: $e');
    }
  }

  void handlePayment() {
    if (totalPrice * (1 - discount / 100) == 0) {
      return;
    }
    try {
      final finalPayment = totalPrice * (1 - discount / 100);
      generateQrCode(price: finalPayment).then((qrResponse) {
        if (qrResponse.statusCode == 200) {
          Uint8List barCodeUint8List = Uint8List.fromList(qrResponse.bodyBytes);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BarCodeWidget(
                barCodePng: barCodeUint8List,
                bname: widget.bname,
                tids: transactionIds,
                cids: cartItemIds,
              ),
            ),
          );
        }
      });
    } catch (e) {
      print('Error: $e');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return CustomCard(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Item: ${item['item']}'),
                      Text('Size: ${item['size']}'),
                      Text('Unit Sold: ${item['unit']}'),
                      Text('Price: ${item['total_price']}'),
                      IconButton(
                        icon: Icon(Icons.remove, size: 24),
                        onPressed: () {
                          handleCartItemDeletion(item['cart_item_id']);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
            CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total: $totalPrice', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(labelText: 'Discount (%)'),
                    onChanged: (value) {
                      setState(() {
                        discount = double.tryParse(value) ?? 0;
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  Text('Final Payment: ${totalPrice * (1 - discount / 100)}', style: TextStyle(fontSize: 18)),
                ],
              ),
            ),
            MyButton(
              text: 'PAYMENT',
              onPressed: handlePayment,
            ),
          ],
        ),
      ),
    );
  }
}
