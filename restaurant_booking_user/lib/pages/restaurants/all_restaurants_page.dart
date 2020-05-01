import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restaurantbookinguser/config/enums.dart';
import 'package:restaurantbookinguser/pages/restaurants/restaurant_details_page.dart';
import 'package:restaurantbookinguser/widgets/loader_error.dart';
import 'package:restaurantbookinguser/widgets/restaurant_button.dart';
import 'package:restaurantbookinguser/widgets/restaurant_card.dart';

///
/// Created by Sunil Kumar on 30-04-2020 03:54 PM.
///
class AllRestaurantsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Center(
          child: RestaurantBackButton(
            padding: EdgeInsets.all(0),
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          'All restaurants',
          style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).primaryColorDark),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError)
            return ErrorText('${snapshot.error.toString()}');
          if (snapshot.hasData) {
            final List<DocumentSnapshot> documents = snapshot.data.documents
                .where(
                    (element) => element.data['type'] == UserType.vendor.string)
                .toList();
            return ListView.builder(
              itemCount: documents.length,
              itemBuilder: (context, index) => AllRestaurantCard(
                name: documents[index].data['name'],
                address: documents[index].data['address'],
                image: documents[index].data['photo'],
              ),
            );
          } else {
            return Loader();
          }
        },
      ),
    );
  }
}

class AllRestaurantCard extends StatelessWidget {
  final String name, address, image, id;

  AllRestaurantCard({this.name, this.address, this.image, this.id});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                  color: Color(0xffedeff4),
                  offset: Offset(-5, -5),
                  blurRadius: 5),
              BoxShadow(
                  color: Color(0xffD2D8E4),
                  offset: Offset(5, 5),
                  blurRadius: 5),
            ]),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 10 / 5,
                child: Material(
                  borderRadius: BorderRadius.circular(8),
                  clipBehavior: Clip.antiAlias,
                  child: image == null
                      ? Image.asset('assets/food.jpg', fit: BoxFit.cover)
                      : FadeInImage.assetNetwork(
                          placeholder: 'assets/food.jpg',
                          fit: BoxFit.cover,
                          image: image),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                '$name',
                style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).primaryColorDark,
                    fontWeight: FontWeight.w700),
              ),
              Text(
                '$address',
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).primaryColorDark.withOpacity(0.7)),
              ),
              Align(
                  alignment: Alignment.centerRight,
                  child: FlatButton(
                    textColor: Theme.of(context).primaryColor,
                    child: Text('Book a table'),
                    highlightColor: Colors.transparent,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RestaurantDetailsPage(id)));
                    },
                  ))
            ]));
  }
}
