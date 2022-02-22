import 'package:connected/Variables/variables.dart';
import 'package:connected/app/pages/about/about_page.dart';
import 'package:connected/app/pages/home/home_page.dart';
import 'package:connected/app/pages/levels/level_01/level_01_page.dart';
import 'package:connected/layout.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vrouter/vrouter.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // useInheritedMediaQuery: true,
      // locale: DevicePreview.locale(context),
      // builder: DevicePreview.appBuilder,
      home: //VRouterWidget(),
          FutureBuilder(
              future: checkAppCheck(),
              builder: (context, snapshot) {
                return const VRouterWidget();
              }),
    );
  }
}

Future<void> checkAppCheck() async {
  return await FirebaseAppCheck.instance
      .activate(
        webRecaptchaSiteKey: '6LfDOoAeAAAAAP-AmJWg83bRDmLxdcbotD4UwFXM',
      )
      .then((value) async =>
          await FirebaseAppCheck.instance.setTokenAutoRefreshEnabled(true));
}

class VRouterWidget extends StatelessWidget {
  const VRouterWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VRouter(
      debugShowCheckedModeBanner: false,
      title: Variables.appName,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.white,
          textTheme: GoogleFonts.mulishTextTheme(Theme.of(context).textTheme)
              .apply(bodyColor: Colors.black),
          pageTransitionsTheme: const PageTransitionsTheme(builders: {
            TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
          })),
      routes: [
        VNester(
            path: '/',
            widgetBuilder: (child) => SiteLayout(child: child),
            nestedRoutes: [
              VPopHandler(
                  onSystemPop: (vRedirector) async {
                    if (vRedirector.historyCanBack()) {
                      vRedirector.historyBack();
                    }
                  },
                  stackedRoutes: [
                    VRouter(
                      beforeEnter: (vRedirector) async {},
                      routes: [
                        VWidget(
                            path: null, name: 'home', widget: const HomePage()),
                      ],
                    ),
                    VRouter(
                      beforeEnter: (vRedirector) async {},
                      routes: [
                        VWidget(
                            path: 'about',
                            name: 'about',
                            widget: const AboutPage()),
                      ],
                    ),
                    VGuard(
                      beforeEnter: (vRedirector) async {
                        Variables.navbarActive = false;
                        Variables.bottomNavbarActive = true;
                        // FirebaseAuth.instance.currentUser != null
                        //     ? null
                        //     : vRedirector.to('/signin');
                        if (FirebaseAuth.instance.currentUser != null) {
                          print('user present');
                          // Map<String, dynamic>? userData =
                          //     await LocalUserDataController.getLocalUserData();
                          // if (userData == null) {
                          //   print("public id not found");
                          //   LocalUserDataController.addUserData(context);
                          // }
                        } else {
                          print('user not present');
                          vRedirector.to('/signin');
                        }
                      },
                      stackedRoutes: [
                        VWidget(
                            path: 'clubs-list',
                            name: 'clubs-list',
                            widget: const Level01Page()),
                      ],
                    ),
                    VRouteRedirector(path: ':_(.*)', redirectTo: '/')
                  ])
            ])
      ],
    );
  }
}

class SomethingWentWrong extends StatelessWidget {
  const SomethingWentWrong({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
