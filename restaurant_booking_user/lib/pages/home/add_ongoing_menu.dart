import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:restaurantbookinguser/model/cart_model.dart';
import 'package:restaurantbookinguser/widgets/loader_error.dart';

///
/// Created by Sunil Kumar on 22-05-2020 02:31 PM.
///
class AddOnGoingMenuPage extends StatefulWidget {
  final String restaurantId, restaurantName, orderId;
  AddOnGoingMenuPage(this.restaurantName, this.restaurantId, this.orderId);

  @override
  _AddOnGoingMenuPageState createState() => _AddOnGoingMenuPageState();
}

class _AddOnGoingMenuPageState extends State<AddOnGoingMenuPage> {
  final List<OrderItem> _orderItems = [];
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Choose menu from ${widget.restaurantName}',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).primaryColorDark)),
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
      body: IgnorePointer(
        ignoring: isLoading,
        child: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('category').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError)
              return ErrorText('${snapshot.error.toString()}');
            if (snapshot.hasData) {
              final List<DocumentSnapshot> documents = snapshot.data.documents
                  .where((element) =>
                      element.data['restaurantId'] == widget.restaurantId)
                  .toList();
              if (documents.isEmpty) {
                return ErrorText('Sorry no categories found.');
              }
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                    children: documents
                        .map((document) => StreamBuilder<QuerySnapshot>(
                              stream: Firestore.instance
                                  .collection('menu')
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasError)
                                  return ErrorText(
                                      '${snapshot.error.toString()}');
                                if (snapshot.hasData) {
                                  final List<DocumentSnapshot> menu = snapshot
                                      .data.documents
                                      .where((element) =>
                                          element.data['categoryId'] ==
                                          document.documentID)
                                      .toList();
                                  return ExpansionTile(
                                    tilePadding: const EdgeInsets.all(0),
                                    initiallyExpanded: true,
                                    title: Text(
                                      document.data['name'],
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color:
                                            Theme.of(context).primaryColorDark,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    children: menu
                                        .map((e) => Container(
                                            decoration: BoxDecoration(
                                                border: Border(
                                                    top: BorderSide(
                                                        color: Colors.grey))),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 2, horizontal: 0),
                                            child: ListTile(
                                                contentPadding:
                                                    const EdgeInsets.all(0),
                                                dense: true,
                                                title: Text(
                                                  '${e.data['name']}',
                                                  style: TextStyle(
                                                    fontSize: 14.0,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                subtitle: Text(
                                                    '${e.data['price']} ₹'),
                                                leading:
                                                    FadeInImage.assetNetwork(
                                                        placeholder:
                                                            'assets/food.jpg',
                                                        image: e.data['photo']),
                                                trailing: CartAddButton(
                                                  orderItem: _orderItems
                                                      .firstWhere(
                                                          (element) =>
                                                              element ==
                                                              OrderItem
                                                                  .fromDocumentSnapshot(
                                                                      e),
                                                          orElse: () =>
                                                              OrderItem(
                                                                  quantity: 0))
                                                      .quantity,
                                                  onDecrement: () {
                                                    setState(() {
                                                      remove(OrderItem
                                                          .fromDocumentSnapshot(
                                                              e));
                                                    });
                                                  },
                                                  onIncrement: () {
                                                    setState(() {
                                                      add(OrderItem
                                                          .fromDocumentSnapshot(
                                                              e));
                                                    });
                                                  },
                                                ))))
                                        .toList(),
                                  );
                                }
                                return Container();
                              },
                            ))
                        .toList()),
              );
            } else {
              return Loader();
            }
          },
        ),
      ),
      bottomNavigationBar: AnimatedSwitcher(
        duration: kThemeAnimationDuration,
        transitionBuilder: (child, animation) {
          final inAnimation =
              Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset(0.0, 0.0))
                  .animate(animation);
          final outAnimation =
              Tween<Offset>(begin: Offset(0.0, -1.0), end: Offset(0.0, 0.0))
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
        child: _orderItems.isEmpty
            ? Container(
                key: ValueKey('empty'),
                height: 1,
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
                          '$totalItems items',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text('Total $totalPrice ₹',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            )),
                      ],
                    ),
                    Spacer(),
                    Text(
                      'Add items',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    RawMaterialButton(
                      constraints:
                          BoxConstraints.tightFor(width: 36, height: 36),
                      highlightColor: Colors.transparent,
                      highlightElevation: 0,
                      onPressed: isLoading
                          ? null
                          : () {
                              setState(() {
                                isLoading = true;
                              });
                              Firestore.instance
                                  .collection('order')
                                  .document(widget.orderId)
                                  .get()
                                  .then((order) async {
                                _orderItems.forEach((element) async {
                                  final item = element;
                                  item.name += ' (OnGoing)';
                                  await order.reference
                                      .collection('orderItems')
                                      .add(item.toJson());
                                });
                                final double total = order.data['amount'];
                                await order.reference
                                    .updateData({'amount': total + totalPrice});
                                Navigator.pop(context);
                              }).whenComplete(() {
                                setState(() {
                                  isLoading = false;
                                });
                              }).catchError((e) {
                                if (e is PlatformException)
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                    behavior: SnackBarBehavior.floating,
                                    content: Text(e.message),
                                  ));
                                else
                                  print(e);
                              });
                            },
                      shape: CircleBorder(),
                      fillColor: isLoading ? null : Colors.white,
                      child: isLoading
                          ? Center(
                              child: SizedBox(
                              height: 26,
                              width: 26,
                              child: CircularProgressIndicator(
                                strokeWidth: 3,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ))
                          : Icon(
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
    );
  }

  double get totalPrice {
    double total = 0;
    _orderItems.forEach((element) {
      total += element.quantity * element.price;
    });
    return total;
  }

  int get totalItems {
    int total = 0;
    _orderItems.forEach((element) {
      total += element.quantity * 1;
    });
    return total;
  }

  void add(OrderItem item) {
    if (_orderItems.contains(item)) {
      _orderItems[_orderItems.indexOf(item)].quantity++;
    } else {
      _orderItems.add(item);
    }
  }

  void remove(OrderItem item) {
    for (int i = 0; i < _orderItems.length; i++) {
      if (_orderItems[i] == item) {
        if (_orderItems[i].quantity <= 1) {
          _orderItems.removeAt(i);
        } else {
          _orderItems[i].quantity--;
        }
      }
    }
  }
}

class CartAddButton extends StatelessWidget {
  final int orderItem;
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
            Text(
              '$orderItem',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
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
