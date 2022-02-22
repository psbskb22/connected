import 'package:connected/app/helpers/responsive_widget.dart';
import 'package:connected/app/pages/levels/level_01/level_01_page_ms.dart';
import 'package:connected/app/pages/levels/level_01/level_01_page_ss.dart';
import 'package:flutter/material.dart';

class Level01Page extends StatelessWidget {
  const Level01Page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ResponsiveWidget(
        largeScreen: Level01PageMS(),
        mediumScreen: Level01PageMS(),
        smallScreen: Level01PageSS(),
      ),
    );
  }
}
