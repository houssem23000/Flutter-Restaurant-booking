import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restaurantbookingvendor/widgets/add_category_sheet.dart';
import 'package:restaurantbookingvendor/widgets/add_menu_sheet.dart';
import 'package:restaurantbookingvendor/widgets/alert_dialog.dart';
import 'package:restaurantbookingvendor/widgets/loader_error.dart';
import 'package:restaurantbookingvendor/widgets/restaurant_button.dart';

///
/// Created by Sunil Kumar on 30-04-2020 11:07 PM.
///
class AllCategoriesPage extends StatelessWidget {
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
                    return AddCategorySheet();
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
                    stream:
                        Firestore.instance.collection('category').snapshots(),
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
                          return ErrorText('No categories found.');
                        }
                        return ListView.builder(
                          itemCount: documents.length,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemBuilder: (c, i) {
                            return StreamBuilder<QuerySnapshot>(
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
                                          documents[i].documentID)
                                      .toList();
                                  return ExpansionTile(
                                    initiallyExpanded: true,
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            showModalBottomSheet(
                                                context: context,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.vertical(
                                                            top:
                                                                Radius.circular(
                                                                    16))),
                                                isScrollControlled: true,
                                                barrierColor: Colors.black26,
                                                clipBehavior: Clip.antiAlias,
                                                backgroundColor: Theme.of(
                                                        context)
                                                    .scaffoldBackgroundColor,
                                                builder: (c) {
                                                  return AddCategorySheet(
                                                    id: documents[i].documentID,
                                                    name: documents[i]
                                                        .data['name'],
                                                  );
                                                });
                                          },
                                          icon: Icon(Icons.edit),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            showDialog(
                                                context: context,
                                                barrierDismissible: false,
                                                builder: (c) =>
                                                    RestaurantDialog(
                                                      positiveAction: () {
                                                        return Firestore
                                                            .instance
                                                            .collection(
                                                                'category')
                                                            .document(
                                                                documents[i]
                                                                    .documentID)
                                                            .delete();
                                                      },
                                                      positiveText: 'Delete',
                                                      alertTitle:
                                                          'Are you sure to delete this category?',
                                                      completedTitle:
                                                          'This category has been deleted',
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
                                                                Radius.circular(
                                                                    16))),
                                                isScrollControlled: true,
                                                barrierColor: Colors.black26,
                                                clipBehavior: Clip.antiAlias,
                                                backgroundColor: Theme.of(
                                                        context)
                                                    .scaffoldBackgroundColor,
                                                builder: (c) {
                                                  return AddMenuSheet(
                                                    documents[i].documentID,
                                                    category: documents[i]
                                                        .data['name'],
                                                  );
                                                });
                                          },
                                          icon: Icon(Icons.add),
                                        ),
                                      ],
                                    ),
                                    title: Text(
                                      documents[i].data['name'],
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color:
                                            Theme.of(context).primaryColorDark,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    children: menu
                                        .map((e) => Container(
                                              decoration: BoxDecoration(
                                                  border: Border(
                                                      top: BorderSide(
                                                          color: Colors.grey))),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12,
                                                      horizontal: 8),
                                              child: ListTile(
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
                                            ))
                                        .toList(),
                                  );
                                }
                                return Container();
                              },
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
