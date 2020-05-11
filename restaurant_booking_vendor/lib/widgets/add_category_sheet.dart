import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:restaurantbookingvendor/widgets/restaurant_button.dart';

///
/// Created by Sunil Kumar on 01-05-2020 08:46 AM.
///
class AddCategorySheet extends StatefulWidget {
  final String id, name;
  const AddCategorySheet({this.id = '', this.name = ''});
  @override
  _AddCategorySheetState createState() => _AddCategorySheetState();
}

class _AddCategorySheetState extends State<AddCategorySheet> {
  TextEditingController _name;
  final GlobalKey<RestaurantButtonState> buttonKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.name)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 16),
          Text('${widget.id.isNotEmpty ? 'Edit' : 'Add'} category'),
          SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 22, vertical: 8),
            child: TextField(
              controller: _name,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name',
                  hintText: 'Name of the category'),
            ),
          ),
          SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 22, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: FlatButton(
                    child: Text('Cancel'),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: RestaurantButton(
                    onPressed: _name.text.trim().isNotEmpty
                        ? () {
                            buttonKey.currentState.showLoader();
                            if (widget.id.isEmpty) {
                              FirebaseAuth.instance.currentUser().then((value) {
                                Firestore.instance.collection('category').add({
                                  'name': _name.text.trim(),
                                  'restaurantId': value.uid
                                }).whenComplete(() {
                                  Navigator.pop(context);
                                  buttonKey.currentState.hideLoader();
                                });
                              }).catchError((e) {
                                buttonKey.currentState.hideLoader();
                              });
                            } else {
                              FirebaseAuth.instance.currentUser().then((value) {
                                Firestore.instance
                                    .collection('category')
                                    .document(widget.id)
                                    .updateData({
                                  'name': _name.text.trim(),
                                  'restaurantId': value.uid
                                }).whenComplete(() {
                                  Navigator.pop(context);
                                  buttonKey.currentState.hideLoader();
                                });
                              }).catchError((e) {
                                buttonKey.currentState.hideLoader();
                              });
                            }
                          }
                        : null,
                    text: widget.id.isEmpty ? 'Add' : 'Edit',
                    key: buttonKey,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
