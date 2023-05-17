import 'package:flutter/material.dart';
import 'screens/welcometoinven.dart';
import 'screens/widgetbackground.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inven',
      home: GradientScaffold(
        appBar: null,
        body: WelcomeWidget(),
        bottomNavigationBar: null,
      ),
    );
  }
}