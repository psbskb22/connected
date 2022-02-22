import 'package:flutter/material.dart';

class Variables {
  static String appName = "Cube Unlocked";

  static bool isLoggedIn = false;

  static bool extendBodyBehindAppBar = false;
  static bool navbarActive = true;
  static bool bottomNavbarActive = true;
  static bool subNavbarActive = true;

  static double navBarHeight = 50;
  static double navBarWidth = 500;

  static double siteMainMargin = 10;
  static double siteBoarderRadius = 15;

  static bool showAddContainer = false;
}

MyGlobals myGlobals = MyGlobals();

class MyGlobals {
  GlobalKey<ScaffoldState>? _scaffoldKey;
  MyGlobals() {
    _scaffoldKey = GlobalKey<ScaffoldState>();
  }
  GlobalKey get scaffoldKey => _scaffoldKey!;
}
