import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurantbookinguser/config/enums.dart';
import 'package:restaurantbookinguser/widgets/booking_details_card.dart';
import 'package:restaurantbookinguser/widgets/loader_error.dart';
import 'package:restaurantbookinguser/widgets/restaurant_container.dart';

///
/// Created by Sunil Kumar on 01-05-2020 11:39 PM.
///
class AllBookingsPage extends StatefulWidget {
  final OrderStatus initialStatus;
  const AllBookingsPage({this.initialStatus});

  @override
  _AllBookingsPageState createState() => _AllBookingsPageState();
}

class _AllBookingsPageState extends State<AllBookingsPage> {
  OrderStatus _selectedStatus;
  @override
  void initState() {
    super.initState();
    this._selectedStatus = widget.initialStatus;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Center(
          child: GestureDetector(
            onTap: () => Navigator.maybePop(context),
            child: Container(
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).scaffoldBackgroundColor,
                    boxShadow: [
                      BoxShadow(
                          color: Color(0xffE6E9F0),
                          offset: Offset(-5, -5),
                          blurRadius: 5),
                      BoxShadow(
                          color: Color(0xffD2D8E4),
                          offset: Offset(5, 5),
                          blurRadius: 5),
                    ]),
                padding: const EdgeInsets.fromLTRB(14, 10, 10, 10),
                child: Icon(
                  Icons.arrow_back,
                  color: Theme.of(context).primaryColor,
                )),
          ),
        ),
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          'All bookings',
          style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).primaryColorDark),
        ),
      ),
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
                                ? 'All Bookings'
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
                            return element.data['createdBy'] ==
                                    userSnap.data.uid &&
                                element.data['status'] == _selectedStatus.toInt;
                          else
                            return element.data['createdBy'] ==
                                userSnap.data.uid;
                        }).toList();
                        if (orders.isEmpty) {
                          return ErrorText('You have no bookings yet.');
                        }

                        orders.sort((a, b) =>
                            a.data['status'] > b.data['status'] ? 1 : 0);

                        return ListView.builder(
                            itemCount: orders.length,
                            itemBuilder: (c, i) {
                              if (orders[i].data['status'] ==
                                  OrderStatus.onGoing.toInt)
                                return BookingDetailsCard.onGoing(
                                    tableId: orders[i].data['tableId'],
                                    restaurantId:
                                        orders[i].data['restaurantId'],
                                    orderId: orders[i].documentID);
                              else if (orders[i].data['status'] ==
                                  OrderStatus.cancelled.toInt)
                                return BookingDetailsCard.cancelled(
                                    tableId: orders[i].data['tableId'],
                                    restaurantId:
                                        orders[i].data['restaurantId'],
                                    orderId: orders[i].documentID);
                              else if (orders[i].data['status'] ==
                                  OrderStatus.completed.toInt)
                                return BookingDetailsCard.completed(
                                    tableId: orders[i].data['tableId'],
                                    restaurantId:
                                        orders[i].data['restaurantId'],
                                    orderId: orders[i].documentID);
                              else
                                return BookingDetailsCard(
                                    tableId: orders[i].data['tableId'],
                                    restaurantId:
                                        orders[i].data['restaurantId'],
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
