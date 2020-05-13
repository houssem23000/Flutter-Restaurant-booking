import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurantbookingvendor/config/enums.dart';
import 'package:restaurantbookingvendor/widgets/bookings_card.dart';
import 'package:restaurantbookingvendor/widgets/loader_error.dart';
import 'package:restaurantbookingvendor/widgets/restaurant_container.dart';

///
/// Created by Sunil Kumar on 01-05-2020 11:39 PM.
///
class AllOrdersPage extends StatefulWidget {
  @override
  _AllOrdersPageState createState() => _AllOrdersPageState();
}

class _AllOrdersPageState extends State<AllOrdersPage> {
  OrderStatus _selectedStatus;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 54,
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: OrderStatus.values.length + 1,
              itemBuilder: (c, i) => Center(
                child: Padding(
                  padding: const EdgeInsets.only(right: 14),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        if (i == 0) {
                          _selectedStatus = null;
                        } else {
                          _selectedStatus = OrderStatus.values[i - 1];
                        }
                      });
                    },
                    child: RestaurantContainer(
                        isSelected: _selectedStatus == null && i == 0
                            ? true
                            : i == 0
                                ? false
                                : _selectedStatus == OrderStatus.values[i - 1],
                        child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            i == 0
                                ? 'All Orders'
                                : OrderStatus.values[i - 1].string,
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        )),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<FirebaseUser>(
              future: FirebaseAuth.instance.currentUser(),
              builder: (c, userSnap) {
                if (userSnap.hasData) if (userSnap.data.uid != null)
                  return StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance
                        .collection('order')
                        .orderBy('date')
                        .snapshots(),
                    builder: (c, snapshot) {
                      if (snapshot.hasError)
                        return ErrorText('${snapshot.error.toString()}');
                      if (snapshot.hasData) {
                        final List<DocumentSnapshot> orders =
                            snapshot.data.documents.where((element) {
                          if (_selectedStatus != null)
                            return element.data['restaurantId'] ==
                                    userSnap.data.uid &&
                                element.data['status'] == _selectedStatus.toInt;
                          else
                            return element.data['restaurantId'] ==
                                userSnap.data.uid;
                        }).toList();
                        if (orders.isEmpty) {
                          return ErrorText('You have no orders yet.');
                        }

                        orders.sort((a, b) =>
                            a.data['status'] > b.data['status'] ? 1 : 0);

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
                else
                  return Loader();
              },
            ),
          ),
        ],
      ),
    );
  }
}
