import 'package:flutter/material.dart';

///
/// Created by Sunil Kumar on 01-05-2020 11:39 PM.
///
class AllOrdersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: 20,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Order $index'),
          );
        },
      ),
    );
  }
}
