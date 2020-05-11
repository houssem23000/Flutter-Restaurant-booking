import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurantbookingvendor/widgets/add_table_sheet.dart';
import 'package:restaurantbookingvendor/widgets/alert_dialog.dart';
import 'package:restaurantbookingvendor/widgets/loader_error.dart';
import 'package:restaurantbookingvendor/widgets/restaurant_button.dart';

///
/// Created by Sunil Kumar on 02-05-2020 07:21 PM.
///
class ManageTablesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(8.0),
          child: RestaurantIconButton(
            icon: Icons.add,
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(16))),
                  isScrollControlled: true,
                  barrierColor: Colors.black26,
                  clipBehavior: Clip.antiAlias,
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  builder: (c) {
                    return AddTableSheet();
                  });
            },
          ),
        ),
        body: FutureBuilder<FirebaseUser>(
            future: FirebaseAuth.instance.currentUser(),
            builder: (context, userSnapshot) {
              if (userSnapshot.hasError)
                return ErrorText('${userSnapshot.error.toString()}');
              if (userSnapshot.hasData) {
                if (userSnapshot.data.uid != null &&
                    userSnapshot.data.uid.isNotEmpty) {
                  return StreamBuilder<QuerySnapshot>(
                    stream: Firestore.instance
                        .collection('table')
                        .orderBy('number')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError)
                        return ErrorText('${snapshot.error.toString()}');
                      if (snapshot.hasData) {
                        final List<DocumentSnapshot> documents = snapshot
                            .data.documents
                            .where((element) =>
                                element.data['restaurantId'] ==
                                userSnapshot.data.uid)
                            .toList();
                        if (documents.isEmpty) {
                          return ErrorText('No tables found.');
                        }
                        return ListView.builder(
                          itemCount: documents.length,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemBuilder: (c, i) {
                            return ListTile(
                              leading: Material(
                                type: MaterialType.circle,
                                color: Theme.of(context).primaryColor,
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Text(
                                    '${documents[i].data['number']}',
                                    style: TextStyle(
                                        fontSize: 22, color: Colors.white),
                                  ),
                                ),
                              ),
                              title:
                                  Text('${documents[i].data['seats']} Seats'),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (c) => RestaurantDialog(
                                                positiveAction: () {
                                                  return Firestore.instance
                                                      .collection('table')
                                                      .document(documents[i]
                                                          .documentID)
                                                      .delete();
                                                },
                                                positiveText: 'Delete',
                                                alertTitle:
                                                    'Are you sure to delete this table?',
                                                completedTitle:
                                                    'This table has been deleted',
                                                loadingTitle:
                                                    'Plase wait while deleting',
                                                negativeText: 'Cancel',
                                              ));
                                    },
                                    color: Colors.red,
                                    icon: Icon(Icons.delete),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      showModalBottomSheet(
                                          context: context,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                      top:
                                                          Radius.circular(16))),
                                          isScrollControlled: true,
                                          barrierColor: Colors.black26,
                                          clipBehavior: Clip.antiAlias,
                                          backgroundColor: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                          builder: (c) {
                                            return AddTableSheet(
                                                number:
                                                    '${documents[i].data['number']}',
                                                seats:
                                                    '${documents[i].data['seats']}',
                                                id: documents[i].documentID);
                                          });
                                    },
                                    icon: Icon(Icons.edit),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      } else {
                        return Loader();
                      }
                    },
                  );
                } else {
                  return ErrorText('Authentication error');
                }
              } else {
                return Loader();
              }
            }));
  }
}
