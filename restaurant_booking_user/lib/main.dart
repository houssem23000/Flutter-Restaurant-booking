import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurantbookinguser/config/theme_config.dart';
import 'package:restaurantbookinguser/pages/authentication/login_page.dart';
import 'package:restaurantbookinguser/pages/home/home_page.dart';
import 'package:restaurantbookinguser/widgets/loader_error.dart';

import 'config/page_router.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant booking',
      debugShowCheckedModeBanner: false,
      theme: ThemeConfig.lightThemeData,
      darkTheme: ThemeConfig.lightThemeData,
      home: FutureBuilder<FirebaseUser>(
        future: FirebaseAuth.instance.currentUser(),
        builder: (c, s) {
          if (s.hasError) {
            return LoginPage();
          }
          if (s.hasData) {
            if (s.data.uid != null && s.data.uid.isNotEmpty) {
              return HomePage();
            } else {
              return LoginPage();
            }
          } else {
            return LoginPage();
          }
        },
      ),
      onGenerateRoute: Router.generateRoute,
    );
  }
}
