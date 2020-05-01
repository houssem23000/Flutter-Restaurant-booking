import 'package:flutter/material.dart';
import 'package:restaurantbookinguser/pages/authentication/forgot_password_page.dart';
import 'package:restaurantbookinguser/pages/authentication/login_page.dart';
import 'package:restaurantbookinguser/pages/authentication/sign_up_page.dart';
import 'package:restaurantbookinguser/pages/bookings/upcoming_bookings_page.dart';
import 'package:restaurantbookinguser/pages/home/home_page.dart';
import 'package:restaurantbookinguser/pages/profile/profile_page.dart';
import 'package:restaurantbookinguser/pages/restaurants/all_restaurants_page.dart';

///
/// Created by Sunil Kumar on 28-04-2020 08:52 AM.
///
class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => HomePage());
      case LoginPage.routeName:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case SignUpPage.routeName:
        return MaterialPageRoute(builder: (_) => SignUpPage());
      case ForgotPasswordPage.routeName:
        String email = settings.arguments as String;
        return MaterialPageRoute(
            builder: (_) => ForgotPasswordPage(email: email));
      case ProfilePage.routeName:
        return MaterialPageRoute(builder: (_) => ProfilePage());
      case AllRestaurantsPage.routeName:
        return MaterialPageRoute(builder: (_) => AllRestaurantsPage());
      case UpcomingBookingsPage.routeName:
        return MaterialPageRoute(builder: (_) => UpcomingBookingsPage());
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}
