import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:restaurantbookinguser/config/enums.dart';
import 'package:restaurantbookinguser/pages/profile/profile_page.dart';

///
/// Created by Sunil Kumar on 30-04-2020 07:48 PM.
///
class BookingCard extends StatelessWidget {
  final OrderStatus status;
  final String orderId, restaurantId;
  final String tableId;

  const BookingCard({this.restaurantId, this.orderId, this.tableId})
      : status = OrderStatus.created;
  const BookingCard.cancelled({this.restaurantId, this.orderId, this.tableId})
      : status = OrderStatus.cancelled;
  const BookingCard.onGoing({this.restaurantId, this.orderId, this.tableId})
      : status = OrderStatus.onGoing;
  const BookingCard.completed({this.restaurantId, this.orderId, this.tableId})
      : status = OrderStatus.completed;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Color(0xffedeff4), offset: Offset(-5, -5), blurRadius: 5),
          BoxShadow(
              color: Color(0xffD2D8E4), offset: Offset(5, 5), blurRadius: 5),
        ],
      ),
      foregroundDecoration: status == OrderStatus.created
          ? null
          : BoxDecoration(
              backgroundBlendMode: BlendMode.hue,
              color: status == OrderStatus.completed
                  ? Colors.green
                  : status == OrderStatus.onGoing
                      ? Color(0xff6a11cb)
                      : Colors.red,
              borderRadius: BorderRadius.circular(12),
            ),
      width: 240,
      child: StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance
            .collection('order')
            .document(orderId)
            .snapshots(),
        builder: (c, snapshot) => StreamBuilder<DocumentSnapshot>(
          stream: Firestore.instance
              .collection('users')
              .document(restaurantId)
              .snapshots(),
          builder: (c, restaurantSnapshot) => StreamBuilder<DocumentSnapshot>(
            stream: Firestore.instance
                .collection('table')
                .document(tableId)
                .snapshots(),
            builder: (c, tableSnapshot) => GestureDetector(
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (c) => ProfilePage()));
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
                      child: Text(
                        snapshot.hasData
                            ? '${snapshot.data['date']}, ${slotFromIntToString(snapshot.data['slotNo'])}'
                            : '',
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: 12,
                            letterSpacing: 0.4,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).primaryColor),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                      child: Text(
                        restaurantSnapshot.hasData
                            ? '${restaurantSnapshot.data['name']}'
                            : '',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Theme.of(context).primaryColorDark),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                      child: Text(
                          restaurantSnapshot.hasData
                              ? '${restaurantSnapshot.data['address']}'
                              : '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              height: 1.1,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context)
                                  .primaryColorDark
                                  .withOpacity(0.7))),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8, 6, 8, 0),
                      child: Text(
                          tableSnapshot.hasData
                              ? 'Table number ${tableSnapshot.data['number']}, ${tableSnapshot.data['seats']} seats'
                              : '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              height: 1.1,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context)
                                  .primaryColorDark
                                  .withOpacity(0.7))),
                    ),
                    StreamBuilder<QuerySnapshot>(
                      stream: Firestore.instance
                          .collection('order')
                          .document(orderId)
                          .collection('orderItems')
                          .snapshots(),
                      builder: (c, itemsSnapshot) => Padding(
                        padding: const EdgeInsets.fromLTRB(8, 6, 8, 0),
                        child: Text(
                            itemsSnapshot.hasData
                                ? itemsSnapshot.data.documents.length == 1
                                    ? '${itemsSnapshot.data.documents[0].data['name']}'
                                    : '${itemsSnapshot.data.documents[0].data['name']} and ${itemsSnapshot.data.documents.length - 1} more items'
                                : '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                height: 1.1,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context)
                                    .primaryColorDark
                                    .withOpacity(0.7))),
                      ),
                    ),
                    Row(
                      children: [
                        if (status != OrderStatus.created)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 8, 4, 0),
                            child: Text(status.string,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: status == OrderStatus.completed
                                        ? Colors.green
                                        : status == OrderStatus.onGoing
                                            ? Colors.orange
                                            : Colors.red)),
                          ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 4, 4, 0),
                          child: Text('View booking >',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor)),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
