import 'package:connected/app/helpers/responsive_widget.dart';
import 'package:connected/app/pages/about/about_page_ls.dart';
import 'package:connected/app/pages/about/about_page_ss.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: ResponsiveWidget(
        largeScreen: AboutPageLS(),
        mediumScreen: AboutPageLS(),
        smallScreen: AboutPageSS(),
      ),
    );
  }
}
