import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:restaurantbookinguser/config/enums.dart';
import 'package:restaurantbookinguser/model/cart_model.dart';
import 'package:restaurantbookinguser/pages/restaurants/payment_page.dart';
import 'package:restaurantbookinguser/widgets/loader_error.dart';
import 'package:restaurantbookinguser/widgets/restaurant_container.dart';

///
///Created By Sunil Kumar at 10/05/2020
///
class BookingPage extends StatefulWidget {
  final String restaurantId, restaurantname;
  BookingPage(this.restaurantname, this.restaurantId);

  @override
  _BookingPageState createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  String date, tableId;
  OrderTimeSlot slot;
  List<String> items = [];
  int stepIndex = 0, tableNumber, tableSeats;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Book table at ${widget.restaurantname}'),
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
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Stepper(
                steps: [
                  Step(
                      state: stepIndex == 0
                          ? StepState.editing
                          : date != null
                              ? StepState.complete
                              : StepState.indexed,
                      isActive: stepIndex == 0,
                      title: Text(
                          date != null
                              ? 'Your table will be booked on $date'
                              : 'Choose date of booking',
                          style: TextStyle(
                              color: Theme.of(context).primaryColorDark,
                              fontSize: 16,
                              fontWeight: FontWeight.w600)),
                      content: Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: GestureDetector(
                          onTap: () {
                            final DateTime currentDate = DateTime.now();
                            showDatePicker(
                                    context: context,
                                    initialDate:
                                        currentDate.add(Duration(days: 1)),
                                    firstDate:
                                        currentDate.add(Duration(days: 1)),
                                    lastDate:
                                        currentDate.add(Duration(days: 7)))
                                .then((value) {
                              if (value != null)
                                setState(() {
                                  this.date =
                                      DateFormat('dd/MM/yyyy').format(value);
                                  stepIndex = 1;
                                });
                            });
                          },
                          child: RestaurantContainer(
                              child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Click here to choose a date',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          )),
                        ),
                      )),
                  Step(
                      isActive: stepIndex == 1,
                      state: stepIndex == 1
                          ? StepState.editing
                          : slot != null
                              ? StepState.complete
                              : StepState.indexed,
                      title: Text(
                          slot != null
                              ? 'Your time slot will be ${slot.string}'
                              : 'Choose timeslot',
                          style: TextStyle(
                              color: Theme.of(context).primaryColorDark,
                              fontSize: 16,
                              fontWeight: FontWeight.w600)),
                      content: Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Wrap(
                          spacing: 14,
                          runSpacing: 14,
                          children: OrderTimeSlot.values
                              .map(
                                (e) => GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      slot = e;
                                      stepIndex = 2;
                                    });
                                  },
                                  child: RestaurantContainer(
                                      isSelected: slot == e,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: Text(
                                          e.string,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700),
                                        ),
                                      )),
                                ),
                              )
                              .toList(),
                        ),
                      )),
                  Step(
                      isActive: stepIndex == 2,
                      state: stepIndex == 2
                          ? StepState.editing
                          : tableId != null
                              ? StepState.complete
                              : StepState.indexed,
                      title: Text(
                          tableId != null
                              ? 'Your table number will be $tableNumber with $tableSeats seats'
                              : 'Choose your table',
                          style: TextStyle(
                              color: Theme.of(context).primaryColorDark,
                              fontSize: 16,
                              fontWeight: FontWeight.w600)),
                      content: StreamBuilder<QuerySnapshot>(
                        stream: Firestore.instance
                            .collection('table')
                            .orderBy('seats')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError)
                            return ErrorText('${snapshot.error.toString()}');
                          if (snapshot.hasData) {
                            final List<DocumentSnapshot> documents = snapshot
                                .data.documents
                                .where((element) =>
                                    element.data['restaurantId'] ==
                                    widget.restaurantId)
                                .toList();
                            if (documents.isEmpty) {
                              return ErrorText('No tables found.');
                            }
                            return Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Wrap(
                                spacing: 14,
                                runSpacing: 14,
                                children: documents
                                    .map(
                                      (e) => GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            tableId = e.documentID;
                                            tableSeats = e.data['seats'];
                                            tableNumber = e.data['number'];
                                            stepIndex = 3;
                                          });
                                        },
                                        child: RestaurantContainer(
                                            isSelected: tableId == e.documentID,
                                            child: Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Table number ${e.data['number']}',
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Theme.of(context)
                                                            .primaryColorDark),
                                                  ),
                                                  Text(
                                                    '${e.data['seats']} seats',
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                  ),
                                                ],
                                              ),
                                            )),
                                      ),
                                    )
                                    .toList(),
                              ),
                            );
                          } else {
                            return Loader();
                          }
                        },
                      )),
                  Step(
                      isActive: stepIndex == 3,
                      state: stepIndex == 3
                          ? StepState.editing
                          : StepState.indexed,
                      title: Text('Choose your delicious menu',
                          style: TextStyle(
                              color: Theme.of(context).primaryColorDark,
                              fontSize: 16,
                              fontWeight: FontWeight.w600)),
                      content: StreamBuilder<QuerySnapshot>(
                        stream: Firestore.instance
                            .collection('category')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError)
                            return ErrorText('${snapshot.error.toString()}');
                          if (snapshot.hasData) {
                            final List<DocumentSnapshot> documents = snapshot
                                .data.documents
                                .where((element) =>
                                    element.data['restaurantId'] ==
                                    widget.restaurantId)
                                .toList();
                            if (documents.isEmpty) {
                              return ErrorText('Sorry no categories found.');
                            }
                            return Column(
                                children: documents
                                    .map(
                                        (document) =>
                                            StreamBuilder<QuerySnapshot>(
                                              stream: Firestore.instance
                                                  .collection('menu')
                                                  .snapshots(),
                                              builder: (context, snapshot) {
                                                if (snapshot.hasError)
                                                  return ErrorText(
                                                      '${snapshot.error.toString()}');
                                                if (snapshot.hasData) {
                                                  final List<DocumentSnapshot>
                                                      menu = snapshot
                                                          .data.documents
                                                          .where((element) =>
                                                              element.data[
                                                                  'categoryId'] ==
                                                              document
                                                                  .documentID)
                                                          .toList();
                                                  return ExpansionTile(
                                                    tilePadding:
                                                        const EdgeInsets.all(0),
                                                    initiallyExpanded: true,
                                                    title: Text(
                                                      document.data['name'],
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        fontSize: 16.0,
                                                        color: Theme.of(context)
                                                            .primaryColorDark,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                    children: menu
                                                        .map((e) => Container(
                                                            decoration: BoxDecoration(
                                                                border: Border(
                                                                    top: BorderSide(
                                                                        color: Colors
                                                                            .grey))),
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    vertical: 2,
                                                                    horizontal:
                                                                        0),
                                                            child: ListTile(
                                                                contentPadding:
                                                                    const EdgeInsets.all(
                                                                        0),
                                                                dense: true,
                                                                title: Text(
                                                                  '${e.data['name']}',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        14.0,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                  ),
                                                                ),
                                                                subtitle: Text(
                                                                    '${e.data['price']} ₹'),
                                                                leading: FadeInImage.assetNetwork(
                                                                    placeholder:
                                                                        'assets/food.jpg',
                                                                    image: e.data[
                                                                        'photo']),
                                                                trailing:
                                                                    CartAddButton(
                                                                  orderItem:
                                                                      OrderItem
                                                                          .fromDocumentSnapshot(
                                                                              e),
                                                                  onDecrement:
                                                                      () {
                                                                    Provider.of<CartModel>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .remove(
                                                                            OrderItem.fromDocumentSnapshot(e));
                                                                  },
                                                                  onIncrement:
                                                                      () {
                                                                    Provider.of<CartModel>(
                                                                            context,
                                                                            listen:
                                                                                false)
                                                                        .add(OrderItem.fromDocumentSnapshot(
                                                                            e));
                                                                  },
                                                                ))))
                                                        .toList(),
                                                  );
                                                }
                                                return Container();
                                              },
                                            ))
                                    .toList());
                          } else {
                            return Loader();
                          }
                        },
                      )),
                ],
                controlsBuilder: (BuildContext context,
                        {VoidCallback onStepContinue,
                        VoidCallback onStepCancel}) =>
                    Container(),
                currentStep: stepIndex,
                onStepTapped: (index) {
                  setState(() {
                    stepIndex = index;
                  });
                },
              ),
            ),
            Consumer<CartModel>(
              builder: (context, cart, child) => AnimatedSwitcher(
                duration: kThemeAnimationDuration,
                transitionBuilder: (child, animation) {
                  final inAnimation = Tween<Offset>(
                          begin: Offset(0.0, 1.0), end: Offset(0.0, 0.0))
                      .animate(animation);
                  final outAnimation = Tween<Offset>(
                          begin: Offset(0.0, -1.0), end: Offset(0.0, 0.0))
                      .animate(animation);

                  if (child.key == ValueKey('not-empty')) {
                    return ClipRect(
                      child: SlideTransition(
                        position: inAnimation,
                        child: child,
                      ),
                    );
                  } else {
                    return ClipRect(
                      child: SlideTransition(
                        position: outAnimation,
                        child: child,
                      ),
                    );
                  }
                },
                child: cart.items.isEmpty
                    ? Container(
                        key: ValueKey('empty'),
                      )
                    : Container(
                        key: ValueKey('not-empty'),
                        width: double.infinity,
                        height: 54,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                          Color(0xff005bea),
                          Color(0xff00c6fb),
                        ])),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 16,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${cart.totalItems} items',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text('Total ${cart.totalPrice} ₹',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    )),
                              ],
                            ),
                            Spacer(),
                            Text(
                              'Proceed to pay',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              width: 6,
                            ),
                            RawMaterialButton(
                              constraints: BoxConstraints.tightFor(
                                  width: 36, height: 36),
                              highlightColor: Colors.transparent,
                              highlightElevation: 0,
                              onPressed: () {
                                if (date == null || date.isEmpty) {
                                  showSnackBar(
                                      context, 'Please choose your date.');
                                } else if (slot == null) {
                                  showSnackBar(
                                      context, 'Please choose a timeslot.');
                                } else if (tableId == null || tableId.isEmpty) {
                                  showSnackBar(
                                      context, 'Please choose your table.');
                                } else {
                                  Navigator.push<bool>(
                                      context,
                                      MaterialPageRoute(
                                          builder: (c) => PaymentPage(
                                                date: date,
                                                restaurant: widget.restaurantId,
                                                tableId: tableId,
                                                total: cart.totalPrice,
                                                timeSlot: slot.toInt,
                                                items: cart.items,
                                              ))).then((value) {
                                    if (value != null && value) {
                                      Navigator.pop(context);
                                    }
                                  });
                                }
                              },
                              shape: CircleBorder(),
                              fillColor: Colors.white,
                              child: Icon(
                                Icons.arrow_forward,
                                color: Color(0xff00c6fb),
                              ),
                            ),
                            SizedBox(
                              width: 16,
                            ),
                          ],
                        ),
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }

  showSnackBar(BuildContext context, String msg) {
    Scaffold.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      content: Text(msg),
      action: SnackBarAction(
        onPressed: () => Scaffold.of(context).removeCurrentSnackBar(),
        label: 'OK',
      ),
    ));
  }
}

class CartAddButton extends StatelessWidget {
  final OrderItem orderItem;
  final VoidCallback onIncrement, onDecrement;

  CartAddButton({this.onIncrement, this.onDecrement, this.orderItem});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Material(
        shape: StadiumBorder(),
        clipBehavior: Clip.antiAlias,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
                onTap: onIncrement,
                highlightColor: Colors.transparent,
                splashColor: Theme.of(context).primaryColor,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                  child: Icon(
                    Icons.add,
                    color: Theme.of(context).primaryColor,
                  ),
                )),
            Consumer<CartModel>(
              builder: (context, cart, child) => Text(
                '${cart.items.firstWhere((element) => element == orderItem, orElse: () => OrderItem(quantity: 0)).quantity}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
            InkWell(
                onTap: onDecrement,
                highlightColor: Colors.transparent,
                splashColor: Theme.of(context).primaryColor,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
                  child: Icon(
                    Icons.remove,
                    color: Theme.of(context).primaryColor,
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
