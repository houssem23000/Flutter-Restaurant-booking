import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurantbookingvendor/config/theme_config.dart';
import 'package:restaurantbookingvendor/pages/authentication/login_page.dart';
import 'package:restaurantbookingvendor/pages/home/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant booking : Vendor',
      debugShowCheckedModeBanner: false,
      theme: ThemeConfig.lightThemeData,
      darkTheme: ThemeConfig.lightThemeData,
      home: FutureBuilder<FirebaseUser>(
        future: FirebaseAuth.instance.currentUser(),
        builder: (c, s) {
          if (s.hasError) print('ERROR ${s.error.toString()}');
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
    );
  }
}
