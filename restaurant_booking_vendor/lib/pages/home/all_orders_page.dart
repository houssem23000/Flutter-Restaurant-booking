import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurantbookingvendor/config/enums.dart';
import 'package:restaurantbookingvendor/widgets/bookings_card.dart';
import 'package:restaurantbookingvendor/widgets/loader_error.dart';

///
/// Created by Sunil Kumar on 01-05-2020 11:39 PM.
///
class AllOrdersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<FirebaseUser>(
        future: FirebaseAuth.instance.currentUser(),
        builder: (c, userSnap) {
          if (userSnap.hasData && userSnap.data.uid != null)
            return StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection('order')
                  .orderBy('date')
                  .snapshots(),
              builder: (c, snapshot) {
                if (snapshot.hasError)
                  return ErrorText('${snapshot.error.toString()}');
                if (snapshot.hasData) {
                  final List<DocumentSnapshot> orders = snapshot.data.documents
                      .where((element) =>
                          element.data['restaurantId'] == userSnap.data.uid)
                      .toList();
                  if (orders.isEmpty) {
                    return ErrorText('You have no orders yet.');
                  }
                  orders.sort(
                      (a, b) => a.data['status'] > b.data['status'] ? 1 : 0);

                  return ListView.builder(
                      itemCount: orders.length,
                      itemBuilder: (c, i) {
                        if (orders[i].data['status'] ==
                            OrderStatus.onGoing.toInt)
                          return BookingCard.onGoing(
                              tableId: orders[i].data['tableId'],
                              createdBy: orders[i].data['createdBy'],
                              orderId: orders[i].documentID);
                        else if (orders[i].data['status'] ==
                            OrderStatus.cancelled.toInt)
                          return BookingCard.cancelled(
                              tableId: orders[i].data['tableId'],
                              createdBy: orders[i].data['createdBy'],
                              orderId: orders[i].documentID);
                        else if (orders[i].data['status'] ==
                            OrderStatus.completed.toInt)
                          return BookingCard.completed(
                              tableId: orders[i].data['tableId'],
                              createdBy: orders[i].data['createdBy'],
                              orderId: orders[i].documentID);
                        else
                          return BookingCard(
                              tableId: orders[i].data['tableId'],
                              createdBy: orders[i].data['createdBy'],
                              orderId: orders[i].documentID);
                      });
                } else {
                  return Loader();
                }
              },
            );
          else
            return ErrorText('Authentication error');
        },
      ),
    );
  }
}
