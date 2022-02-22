import 'package:connected/Variables/variables.dart';
import 'package:flutter/material.dart';

class SiteLayout extends StatefulWidget {
  final Widget child;
  const SiteLayout({required this.child, Key? key}) : super(key: key);

  @override
  _SiteLayoutState createState() => _SiteLayoutState();
}

class _SiteLayoutState extends State<SiteLayout> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          key: myGlobals.scaffoldKey,
          extendBodyBehindAppBar: Variables.extendBodyBehindAppBar,
          body: widget.child,
        ),
      ],
    );
  }
}
