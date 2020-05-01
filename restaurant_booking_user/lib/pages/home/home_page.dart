import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:restaurantbookinguser/config/enums.dart';
import 'package:restaurantbookinguser/pages/bookings/upcoming_bookings_page.dart';
import 'package:restaurantbookinguser/pages/profile/profile_page.dart';
import 'package:restaurantbookinguser/pages/restaurants/all_restaurants_page.dart';
import 'package:restaurantbookinguser/widgets/bookings_card.dart';
import 'package:restaurantbookinguser/widgets/loader_error.dart';
import 'package:restaurantbookinguser/widgets/restaurant_button.dart';
import 'package:restaurantbookinguser/widgets/restaurant_card.dart';

///
/// Created by Sunil Kumar on 29-04-2020 10:21 AM.
///
class HomePage extends StatefulWidget {
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
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => ProfilePage()));
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
                child: StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance.collection('users').snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError)
                      return ErrorText('${snapshot.error.toString()}');
                    if (snapshot.hasData) {
                      final List<DocumentSnapshot> documents = snapshot
                          .data.documents
                          .where((element) =>
                              element.data['type'] == UserType.vendor.string)
                          .toList();
                      return ListView.builder(
                        itemCount: documents.length,
                        itemBuilder: (context, index) => RestaurantCard(
                          documents[index].documentID,
                          name: documents[index].data['name'],
                          address: documents[index].data['address'],
                          image: documents[index].data['photo'],
                        ),
                        scrollDirection: Axis.horizontal,
                      );
                    } else {
                      return Loader();
                    }
                  },
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: FlatButton(
                    child: Text('View all'),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (c) => AllRestaurantsPage()));
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
