import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
              stream: Firestore.instance.collection('order').snapshots(),
              builder: (c, snapshot) {
                if (snapshot.hasError)
                  return ErrorText('${snapshot.error.toString()}');
                if (snapshot.hasData) {
                  final List<DocumentSnapshot> orders = snapshot.data.documents
                      .where((element) =>
                          element.data['restaurantId'] == userSnap.data.uid)
                      .toList();
                      if(orders.isEmpty){
                        return ErrorText('You have no orders yet.');
                      }
                  return ListView.builder(
                      itemCount: orders.length,
                      itemBuilder: (c, i) {
                        return OrderCard();
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

class OrderCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row();
  }
}
