import 'package:flutter/material.dart';
import 'package:restaurantbookinguser/pages/bookings/upcoming_bookings_page.dart';
import 'package:restaurantbookinguser/pages/profile/profile_page.dart';
import 'package:restaurantbookinguser/pages/restaurants/all_restaurants_page.dart';
import 'package:restaurantbookinguser/widgets/bookings_card.dart';
import 'package:restaurantbookinguser/widgets/restaurant_button.dart';
import 'package:restaurantbookinguser/widgets/restaurant_card.dart';

///
/// Created by Sunil Kumar on 29-04-2020 10:21 AM.
///
class HomePage extends StatefulWidget {
  static const routeName = '/';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: RestaurantIconButton(
                    icon: Icons.person,
                    onPressed: () {
                      Navigator.pushNamed(context, ProfilePage.routeName);
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: 'Welcome, ',
                        style: Theme.of(context).textTheme.headline4.copyWith(
                            fontSize: 24,
                            color: Theme.of(context).primaryColorDark,
                            fontWeight: FontWeight.w600)),
                    TextSpan(
                        text: 'Sunil',
                        style: Theme.of(context).textTheme.headline4.copyWith(
                            fontSize: 26,
                            color: Theme.of(context).primaryColorDark,
                            fontWeight: FontWeight.w800)),
                  ]),
                ),
              ),
              SizedBox(
                height: 48,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text('Restaurants',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                        color: Theme.of(context).primaryColorDark)),
              ),
              Container(
                height: 250,
                child: ListView.builder(
                  itemBuilder: (context, index) => RestaurantCard(),
                  scrollDirection: Axis.horizontal,
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: FlatButton(
                    child: Text('View all'),
                    onPressed: () {
                      Navigator.pushNamed(
                          context, AllRestaurantsPage.routeName);
                    },
                    highlightColor: Colors.transparent,
                    textColor: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text('Your upcoming bookings',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                        color: Theme.of(context).primaryColorDark)),
              ),
              Container(
                height: 150,
                child: ListView.builder(
                  itemBuilder: (context, index) =>
                      index % 2 == 0 ? BookingCard() : BookingCard.disabled(),
                  scrollDirection: Axis.horizontal,
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: FlatButton(
                    child: Text('View all'),
                    onPressed: () {
                      Navigator.pushNamed(
                          context, UpcomingBookingsPage.routeName);
                    },
                    highlightColor: Colors.transparent,
                    textColor: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
