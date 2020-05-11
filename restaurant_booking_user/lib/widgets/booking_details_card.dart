import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:restaurantbookinguser/config/enums.dart';

///
/// Created by Sunil Kumar on 11-05-2020 11:52 AM.
///

class BookingDetailsCard extends StatelessWidget {
  final OrderStatus status;
  final String orderId, restaurantId;
  final String tableId;

  const BookingDetailsCard({this.restaurantId, this.orderId, this.tableId})
      : status = OrderStatus.created;
  const BookingDetailsCard.cancelled(
      {this.restaurantId, this.orderId, this.tableId})
      : status = OrderStatus.cancelled;
  const BookingDetailsCard.onGoing(
      {this.restaurantId, this.orderId, this.tableId})
      : status = OrderStatus.onGoing;
  const BookingDetailsCard.completed(
      {this.restaurantId, this.orderId, this.tableId})
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
                      ? Colors.deepOrange
                      : Colors.black,
              borderRadius: BorderRadius.circular(12),
            ),
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
            builder: (c, tableSnapshot) => Padding(
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
                            ? 'Table number : ${tableSnapshot.data['number']}, ${tableSnapshot.data['seats']} seats'
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
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 4, 4),
                    child: Text(
                      'Items',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance
                        .collection('order')
                        .document(orderId)
                        .collection('orderItems')
                        .snapshots(),
                    builder: (c, itemsSnapshot) => itemsSnapshot.hasData
                        ? Column(
                            children: itemsSnapshot.data.documents
                                .map((e) => Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text('${e.data['name']}'),
                                              Spacer(),
                                              Text(
                                                  '${e.data['quantity']} x ${e.data['price']} ₹')
                                            ],
                                          ),
                                          Divider(
                                            color: Colors.grey,
                                          )
                                        ],
                                      ),
                                    ))
                                .toList(),
                          )
                        : Container(),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 4, 4),
                      child: Text(
                        'Total : ${snapshot.hasData ? snapshot.data.data['amount'] : ''} ₹',
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).primaryColorDark,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
