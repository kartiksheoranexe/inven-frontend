import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:inven/screens/welcome.dart';
import 'package:inven/screens/widgetbackground.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:inven/screens/button.dart';
import 'package:inven/screens/customcard.dart';
import 'package:inven/screens/businesstypes/medicine/dashboard.dart';
import 'package:inven/screens/registerbusiness.dart';
import 'package:inven/screens/businessalertdiologbox.dart';
import 'package:inven/screens/businesstypes/medicine/business.dart';
import 'package:inven/screens/businesstypes/medicine/userdetails.dart';
import 'package:inven/screens/businesstypes/medicine/sales.dart';
import 'package:inven/code/getbusinessapi.dart';
import 'package:inven/code/alertcountapi.dart';
import 'package:inven/code/logoutapi.dart';

class CancellationToken {
  bool _isCanceled = false;

  void cancel() {
    _isCanceled = true;
  }

  bool get isCanceled => _isCanceled;
}

class ListBusinessWidget extends StatefulWidget {
  final List<Business> businesses;
  final String username;

  ListBusinessWidget({required this.businesses, required this.username});

  @override
  _ListBusinessWidgetState createState() => _ListBusinessWidgetState();
}

class _ListBusinessWidgetState extends State<ListBusinessWidget> {
  String _selectedBusinessName = '';
  final _cancellationToken = CancellationToken();

  @override
  void dispose() {
    _cancellationToken.cancel();
    super.dispose();
  }

  Color _getColorForBusinessType(String type) {
    switch (type) {
      case 'Medicine':
        return Colors.green.shade300;
      case 'Stationary':
        return Colors.lightBlue.shade300;
      case 'Grocery':
        return Colors.orange.shade300;
      case 'Restaurant':
        return Colors.red.shade300;
      default:
        return Colors.grey;
    }
  }

  Widget _getWidgetForBusinessType(BuildContext context, String type,
      String businessName) {
    switch (type) {
      case 'Medicine':
        return DashboardWidget(businessName: businessName);
      case 'Stationary':
      // return StationaryWidget();
      // Add more cases for other business types
      default:
        return Container(); // Return an empty container for unknown business types
    }
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<bool> _onWillPop() async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: <Widget>[
            MyButton(
              text: 'CANCEL',
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            MyButton(
              text: 'CONFIRM',
              onPressed: () async {
                String? token = await _getToken();
                print('Token value: $token');
                if (token != null) {
                  try {
                    await LogoutApi.logoutUser(token);
                    Navigator.pop(context, true);
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => MyHomePage()),
                          (route) => false,
                    );
                  } catch (e) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Logout Failed'),
                          content: Text('Error: $e'),
                          actions: <Widget>[
                            MyButton(
                              text: 'OK',
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }
                }
              },
            ),
          ],
        );
      },
    ) ??
        false;
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: FutureBuilder<String?>(
        future: _getToken(),
    builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
    return Center(child: CircularProgressIndicator());
    } else {
    if (snapshot.hasData && snapshot.data != null) {
    return GradientScaffold(
      appBar: AppBar(
        title: Text(
          'Hi ${widget.username}!',
          style: TextStyle(
            fontFamily: 'SansSerif',
            fontSize: 30,
            color: Colors.blueGrey.shade800,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      CustomCard(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 16.0),
                                child: Text(
                                  'ACTIVE',
                                  style: TextStyle(fontSize: 24),
                                ),
                              ),
                              ...widget.businesses.map((business) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            _getWidgetForBusinessType(
                                                context,
                                                business.businessType,
                                                business.businessName),
                                      ),
                                    );
                                  },
                                  child: Card(
                                    color: _getColorForBusinessType(
                                        business.businessType),
                                    child: ListTile(
                                      title: Text(
                                          business.businessName),
                                      subtitle: Text(
                                          business.businessType),
                                    ),
                                  ),
                                );
                              }).toList(),
                              SizedBox(height: 20),
                              // Add some spacing before the Register button
                              MyButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          RegisterBusinessWidget(),
                                    ),
                                  );
                                },
                                text: 'REGISTER A BUSINESS',
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      CustomCard(
                        child: GridView.count(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          crossAxisCount: 2,
                          children: [
                            _buildTile(context, 'SALES',
                                Colors.blueGrey.shade800, () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          SalesWidget(),
                                    ),
                                  );
                                }),
                            _AlertbuildTile(context, 'ALERT', Colors.blueGrey.shade800, () {
                              void _showBusinessListDialog() async {
                                String? selectedBusinessName = await showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return BusinessSelectionDialog(
                                      businesses: widget.businesses,
                                      onBusinessSelected: (
                                          businessName) {
                                        Navigator.pop(
                                            context, businessName);
                                      },
                                    );
                                  },
                                );
                              }
                              _showBusinessListDialog();
                            }),
                            _buildTile(context, 'BUSINESS',
                                Colors.blueGrey.shade800, () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          BusinessWidget(),
                                    ),
                                  );
                                }),
                            _buildTile(context, 'USER',
                                Colors.blueGrey.shade800, () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          UserWidget(),
                                    ),
                                  );
                                }),

                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    } else {
      return MyHomePage();
    }
    }
    }),
    );
  }



  Widget _buildTile(BuildContext context, String title, Color color, Function()? onTap) {
    return Card(
      color: color,
      child: InkWell(
        onTap: onTap,
        child: Center(
          child: Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'SansSerif'),
          ),
        ),
      ),
    );
  }

  Widget _AlertbuildTile(BuildContext context, String title, Color color, Function()? onTap) {
    final cancellationToken = CancellationToken();
    return FutureBuilder<int>(
      future: _fetchAlertCount(cancellationToken),
      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
        return Card(
          color: color,
          child: InkWell(
            onTap: onTap,
            child: Stack(
              children: [
                Center(
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'SansSerif'),
                  ),
                ),
                if (snapshot.hasData && snapshot.data! > 0)
                  Positioned(
                    top: 4,
                    right: 4,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${snapshot.data}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'SansSerif',
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }


  Future<int> _fetchAlertCount(CancellationToken token) async {
    int alertCount = 0;
    try {
      String businessName = widget.businesses.isNotEmpty ? widget.businesses.first.businessName : '';

      String response = (await AlertCountApi.alertMedicines(businessName: businessName));
      print(response);

      if (token.isCanceled) return 0;

      Map<String, dynamic> jsonResponse = jsonDecode(response);
      alertCount = jsonResponse['alert_items_count'];
    } catch (e) {
      print('Error fetching alert count: $e');
    }
    return alertCount;
  }





}



