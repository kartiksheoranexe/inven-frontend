import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:inven/screens/businesstypes/medicine/dashboard.dart';
import 'package:inven/screens/businesstypes/medicine/search.dart';
import 'package:inven/screens/listofbusiness.dart';
import 'package:inven/screens/businesstypes/medicine/inventory.dart';
import 'package:inven/code/getbusinessapi.dart';
import 'package:inven/code/loginapi.dart';


class Footer extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabTapped;
  final String businessName;

  const Footer({
    Key? key,
    required this.currentIndex,
    required this.onTabTapped,
    required this.businessName,
  }) : super(key: key);

  Future<void> navigateToListBusinessWidget(BuildContext context) async {
    try {
      String? username = await AuthStorage.getUsername();
      List<Business> businesses = await getBusinessList();
      if (username != null){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ListBusinessWidget(
              businesses: businesses,
              username: username,
            ),
          ),
        );
      } else {
        // Handle the case when username is null
      }
    } catch (e) {
      // Handle exceptions
    }
  }


  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.black,
      fixedColor: Colors.grey.shade400,
      currentIndex: currentIndex,
      unselectedItemColor: Colors.white,
      iconSize: 32,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      onTap: (index) {
        print(index);
        if (index == 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => DashboardWidget(businessName: businessName,)),
          );
        } else if (index == 1) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SearchWidget(businessName: businessName,)),
          );
        } else if (index == 2)  {
          navigateToListBusinessWidget(context);
        } else if (index == 3) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => InventoryWidget(businessName: businessName,)),
          );
        }
        onTabTapped(index);
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.dashboard,
            color: currentIndex == 0 ? Colors.grey.shade300 : Colors.white,
            size: 32,
            semanticLabel: '',
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.search,
            color: currentIndex == 1 ? Colors.grey.shade300 : Colors.white,
            size: 32,
            semanticLabel: '',
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.face,
            color: currentIndex == 2 ? Colors.grey.shade300 : Colors.white,
            size: 32,
            semanticLabel: '',
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.inventory,
            color: currentIndex == 3 ? Colors.grey.shade300 : Colors.white,
            size: 32,
            semanticLabel: '',
          ),
          label: '',
        ),
      ],
    );
  }
}
