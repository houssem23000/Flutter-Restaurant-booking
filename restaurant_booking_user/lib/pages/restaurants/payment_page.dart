import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:restaurantbookinguser/config/enums.dart';
import 'package:restaurantbookinguser/model/cart_model.dart';
import 'package:restaurantbookinguser/widgets/loader_error.dart';

///
/// Created by Sunil Kumar on 11-05-2020 12:06 AM.
///
class PaymentPage extends StatefulWidget {
  final String date, restaurant;
  final int timeSlot;
  final String tableId;
  final double total;
  final List<OrderItem> items;

  const PaymentPage(
      {this.date,
      this.timeSlot,
      this.total,
      this.tableId,
      this.items,
      this.restaurant});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  Map<String, dynamic> options;
  bool isLoading = false;
  String loadingText = '', orderId, transactionId;
  final Razorpay _razorpay = Razorpay();
  @override
  void initState() {
    super.initState();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    initPayment();
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    setState(() {
      loadingText = 'Validating payment.';
    });
    Firestore.instance
        .collection('transaction')
        .document(transactionId)
        .updateData({
      'paymentId': response.paymentId,
      'status': PaymentStatus.success.toInt
    }).then((value) {
      Firestore.instance.collection('order').document(orderId).updateData({
        'transactionId': this.transactionId,
        'status': OrderStatus.created.toInt
      }).then((value) {
        setState(() {
          loadingText = 'Payment success.';
          isLoading = false;
        });
        Future.delayed(Duration(seconds: 2)).then((value) {
          Provider.of<CartModel>(context, listen: false).removeAll();
          Navigator.pop(context, true);
        });
      });
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    setState(() {
      isLoading = false;
      loadingText = '${response.message}';
    });
  }

  initPayment() {
    setState(() {
      isLoading = true;
      loadingText = 'Initializing payment.';
    });
    FirebaseAuth.instance.currentUser().then((value) {
      if (value != null && value.uid != null) {
        Firestore.instance
            .collection('users')
            .document(value.uid)
            .get()
            .then((userDoc) {
          Firestore.instance.collection('order').add({
            'amount': widget.total,
            'createdBy': value.uid,
            "date": widget.date,
            'restaurantId': widget.restaurant,
            "slotNo": widget.timeSlot,
            'tableId': widget.tableId,
            'status': -1
          }).then((DocumentReference doc) {
            widget.items.forEach((element) async {
              await doc.collection('orderItems').add(element.toJson());
            });
            Firestore.instance.collection('transaction').add({
              'amount': widget.total,
              'createdBy': value.uid,
              'status': PaymentStatus.initiated.toInt
            }).then((tsnDoc) {
              options = {
                'key': 'rzp_test_cIOVPpM3WgAt47',
                'amount': widget.total * 100,
                'name': 'Restaurant Booking',
                'description': 'Book restaurant anytime anywhere.',
                'prefill': {
                  'contact': '91' + userDoc.data['phone'],
                  'email': userDoc.data['email'],
                },
                'notes': {
                  'name': userDoc.data['name'],
                  'restaurantId': widget.restaurant,
                  'createdBy': value.uid,
                }
              };
              setState(() {
                loadingText = 'Processing payment';
              });
              this.orderId = doc.documentID;
              this.transactionId = tsnDoc.documentID;
              _razorpay.open(options);
            });
          });
        });
      } else {
        setState(() {
          isLoading = false;
          loadingText = 'Authentication error.';
        });
      }
    }).catchError((e) {
      setState(() {
        isLoading = false;
        loadingText = e.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return !isLoading;
      },
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (isLoading) CircularProgressIndicator(),
            SizedBox(
              height: 8,
            ),
            ErrorText(loadingText),
            if (isLoading) Text('Please do not back or close the app.')
          ],
        ),
      ),
    );
  }
}
