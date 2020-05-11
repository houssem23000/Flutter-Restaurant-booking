import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurantbookinguser/config/theme_config.dart';
import 'package:restaurantbookinguser/model/cart_model.dart';
import 'package:restaurantbookinguser/pages/authentication/login_page.dart';
import 'package:restaurantbookinguser/pages/home/home_page.dart';

void main() {
  runApp(ChangeNotifierProvider(create: (c) => CartModel(), child: MyApp()));
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
