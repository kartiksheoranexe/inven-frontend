import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final Color color;
  final double elevation;
  final double borderRadius;
  final BorderSide borderSide;

  const CustomCard({
    Key? key,
    required this.child,
    this.color = Colors.white,
    this.elevation = 20.0,
    this.borderRadius = 20.0,
    this.borderSide = BorderSide.none,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: borderSide,
      ),
      elevation: elevation,
      color: color,
      child: SingleChildScrollView( // Add SingleChildScrollView here
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: child,
        ),
      ),
    );
  }
}
