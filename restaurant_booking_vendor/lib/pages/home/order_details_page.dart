import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restaurantbookingvendor/config/enums.dart';
import 'package:restaurantbookingvendor/widgets/loader_error.dart';

///
/// Created by Sunil Kumar on 11-05-2020 02:03 PM.
///
class OrderDetailsPage extends StatefulWidget {
  final String orderId, createdBy;
  final String tableId;

  OrderDetailsPage({this.orderId, this.createdBy, this.tableId});

  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
          )),
      body: StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance
            .collection('users')
            .document(widget.createdBy)
            .snapshots(),
        builder: (c, userSnapshot) {
          if (userSnapshot.hasError)
            return ErrorText('${userSnapshot.error.toString()}');
          if (userSnapshot.hasData) {
            return ListView(
              children: [
                Row(
                  children: [
                    Hero(
                      tag: widget.orderId,
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          height: 120,
                          width: 120,
                          margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).scaffoldBackgroundColor,
                              gradient: LinearGradient(
                                  colors: [
                                    Color(0xffF1F3F7),
                                    Color(0xffD2D8E4),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight),
                              boxShadow: [
                                BoxShadow(
                                    color: Color(0xffF1F3F7),
                                    offset: Offset(-5, -5),
                                    blurRadius: 5),
                                BoxShadow(
                                    color: Color(0xffD2D8E4),
                                    offset: Offset(5, 5),
                                    blurRadius: 5),
                              ]),
                          padding: const EdgeInsets.all(6),
                          child: Container(
                            decoration: BoxDecoration(shape: BoxShape.circle),
                            clipBehavior: Clip.antiAlias,
                            child: userSnapshot.data['photo'] == null ||
                                    userSnapshot.data['photo'].isEmpty
                                ? Image.asset(
                                    'assets/dp_placeholder.jpg',
                                    fit: BoxFit.cover,
                                  )
                                : FadeInImage.assetNetwork(
                                    placeholder: 'assets/dp_placeholder.jpg',
                                    image: userSnapshot.data['photo'],
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${userSnapshot.data['name']}',
                            style: TextStyle(
                                fontSize: 26, fontWeight: FontWeight.w700),
                          ),
                          Text(
                            '${userSnapshot.data['phone']} . ${userSnapshot.data['email']}',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    )
                  ],
                ),
                SizedBox(height: 8),
                StreamBuilder<DocumentSnapshot>(
                    stream: Firestore.instance
                        .collection('order')
                        .document(widget.orderId)
                        .snapshots(),
                    builder: (c, orderSnapshot) => Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Booked for ${orderSnapshot.hasData ? orderSnapshot.data.data['date'] : ''}',
                                style: TextStyle(
                                    fontSize: 18,
                                    letterSpacing: 0.4,
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context).primaryColor),
                              ),
                              Text(
                                'Time ${orderSnapshot.hasData ? slotFromIntToString(orderSnapshot.data.data['slotNo']) : ''}',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 18,
                                    letterSpacing: 0.4,
                                    fontWeight: FontWeight.w600),
                              ),
                              StreamBuilder<DocumentSnapshot>(
                                  stream: Firestore.instance
                                      .collection('table')
                                      .document(widget.tableId)
                                      .snapshots(),
                                  builder: (c, tableSnapshot) => Text(
                                        tableSnapshot.hasData
                                            ? 'Table number ${tableSnapshot.data.data['number']}, ${tableSnapshot.data.data['seats']} seats'
                                            : '',
                                        style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontSize: 18,
                                            letterSpacing: 0.4,
                                            fontWeight: FontWeight.w600),
                                      )),
                              SizedBox(
                                height: 12,
                              ),
                              Text(
                                'Items',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Theme.of(context).primaryColorDark,
                                    letterSpacing: 1.4),
                              ),
                              StreamBuilder<QuerySnapshot>(
                                  stream: Firestore.instance
                                      .collection('order')
                                      .document(widget.orderId)
                                      .collection('orderItems')
                                      .snapshots(),
                                  builder: (c, itemsSnapshot) =>
                                      itemsSnapshot.hasData
                                          ? Column(
                                              children:
                                                  itemsSnapshot.data.documents
                                                      .map((e) => Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .fromLTRB(
                                                                    8, 8, 8, 0),
                                                            child: Column(
                                                              children: [
                                                                ListTile(
                                                                  contentPadding:
                                                                      const EdgeInsets
                                                                          .all(0),
                                                                  dense: true,
                                                                  leading:
                                                                      StreamBuilder<
                                                                          DocumentSnapshot>(
                                                                    stream: Firestore
                                                                        .instance
                                                                        .collection(
                                                                            'menu')
                                                                        .document(
                                                                            e.data['menuId'])
                                                                        .snapshots(),
                                                                    builder: (c, menuSnapshot) => menuSnapshot
                                                                            .hasData
                                                                        ? FadeInImage.assetNetwork(
                                                                            placeholder: 'assets/food.jpg',
                                                                            fit: BoxFit.cover,
                                                                            imageErrorBuilder: (c, _, __) => Image.asset(
                                                                                  'assets/food.jpg',
                                                                                  fit: BoxFit.cover,
                                                                                ),
                                                                            image: e.data['photo'] ?? '')
                                                                        : Image.asset(
                                                                            'assets/food.jpg',
                                                                            fit:
                                                                                BoxFit.cover,
                                                                          ),
                                                                  ),
                                                                  title: Text(
                                                                    '${e.data['name']}',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight.w600),
                                                                  ),
                                                                  trailing:
                                                                      Text(
                                                                    '${e.data['quantity']} x ${e.data['price']} ₹',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            16,
                                                                        fontWeight:
                                                                            FontWeight.w600),
                                                                  ),
                                                                ),
                                                                Divider(
                                                                  color: Colors
                                                                      .grey,
                                                                )
                                                              ],
                                                            ),
                                                          ))
                                                      .toList(),
                                            )
                                          : Loader()),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 8, 4, 4),
                                  child: Text(
                                    'Total : ${orderSnapshot.hasData ? orderSnapshot.data.data['amount'] : ''} ₹',
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: 18,
                                        color:
                                            Theme.of(context).primaryColorDark,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                              if (orderSnapshot.hasData &&
                                  orderSnapshot.data.data['transactionId'] !=
                                      null)
                                StreamBuilder<DocumentSnapshot>(
                                  stream: Firestore.instance
                                      .collection('transaction')
                                      .document(orderSnapshot
                                          .data.data['transactionId'])
                                      .snapshots(),
                                  builder: (c, tsnSnapshot) => Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(8, 8, 4, 0),
                                      child: Text(
                                        'Payment ${tsnSnapshot.hasData ? paymentFromIntToString(tsnSnapshot.data.data['status'] ?? -1) : ''}',
                                        maxLines: 1,
                                        style: TextStyle(
                                            fontSize: 18,
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                  ),
                                ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 0, 4, 4),
                                  child: Text(
                                    'Order ${orderSnapshot.hasData ? orderFromIntToString(orderSnapshot.data.data['status']) : ''}',
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 18,
                              ),
                              if (orderSnapshot.hasData &&
                                      orderSnapshot.data.data['status'] ==
                                          OrderStatus.created.toInt ||
                                  orderSnapshot.data.data['status'] ==
                                      OrderStatus.onGoing.toInt)
                                Align(
                                    alignment: Alignment.center,
                                    child: isLoading
                                        ? FloatingActionButton(
                                            onPressed: () {},
                                            child: CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      Colors.white),
                                            ),
                                          )
                                        : FloatingActionButton.extended(
                                            onPressed: () {
                                              setState(() {
                                                isLoading = true;
                                              });
                                              Firestore.instance
                                                  .collection('order')
                                                  .document(widget.orderId)
                                                  .updateData({
                                                    'status': orderSnapshot.data
                                                            .data['status'] +
                                                        1
                                                  })
                                                  .then((value) {})
                                                  .whenComplete(() {
                                                    setState(() {
                                                      isLoading = false;
                                                    });
                                                  });
                                            },
                                            label: Text(
                                              'Change to ${orderFromIntToString(orderSnapshot.data.data['status'] + 1)}',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ))),
                            ],
                          ),
                        ))
              ],
            );
          } else {
            return Loader();
          }
        },
      ),
    );
  }
}
/*
ListTile(
                                                title:
                                                    Text('${e.data['name']}'),
                                                leading:
                                                    FadeInImage.assetNetwork(
                                                        placeholder:
                                                            'assets/food.jpg',
                                                        image: e.data['photo']),
                                                trailing: IconButton(
                                                  onPressed: () {
                                                    showDialog(
                                                        context: context,
                                                        barrierDismissible:
                                                            false,
                                                        builder: (c) =>
                                                            RestaurantDialog(
                                                              positiveAction:
                                                                  () {
                                                                return Firestore
                                                                    .instance
                                                                    .collection(
                                                                        'menu')
                                                                    .document(e
                                                                        .documentID)
                                                                    .delete();
                                                              },
                                                              positiveText:
                                                                  'Delete',
                                                              alertTitle:
                                                                  'Are you sure to delete this menu?',
                                                              completedTitle:
                                                                  'This menu has been deleted',
                                                              loadingTitle:
                                                                  'Plase wait while deleting',
                                                              negativeText:
                                                                  'Cancel',
                                                            ));
                                                  },
                                                  color: Colors.red,
                                                  icon: Icon(Icons.delete),
                                                ),
                                              ),
* */
