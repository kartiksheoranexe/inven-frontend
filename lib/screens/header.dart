import 'package:flutter/material.dart';
import 'businesstypes/medicine/checkout.dart';// Import the CheckoutWidget here

class Header extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  Header({required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.shopping_cart,
        color: Colors.blueGrey.shade800,),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CheckoutWidget(bname: title,),
            ),
          );
        },
      ),
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.blueGrey.shade800,
              fontSize: 24,
              fontFamily: 'Sans Serif',
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 16),
          child: Align(
            alignment: Alignment.bottomRight,
            child: Text(
              'INVEN©',
              style: TextStyle(
                color: Colors.blueGrey.shade800,
                fontSize: 15,
                fontFamily: 'Sans Serif',
              ),
            ),
          ),
        ),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 20);
}
