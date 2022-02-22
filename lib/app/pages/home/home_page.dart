import 'package:connected/app/helpers/responsive_widget.dart';
import 'package:connected/app/pages/home/home_page_ls.dart';
import 'package:connected/app/pages/home/home_page_ss.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ResponsiveWidget(
        largeScreen: HomePageLS(),
        mediumScreen: HomePageLS(),
        smallScreen: HomePageSS(),
      ),
    );
  }
}
