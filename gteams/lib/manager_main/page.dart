import 'package:flutter/material.dart';

class Page extends StatelessWidget {
  final LinearGradient background;
  final String title;
  final Widget child;

  const Page(
      {@required this.title,
        @required this.background,
        @required this.child});

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
