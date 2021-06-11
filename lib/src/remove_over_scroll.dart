import 'package:flutter/material.dart';

// this file is used to add custom scroll bar,
// in case user wants to show a larger list in drop down overlay
class OverScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
