import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:restaurantbookingvendor/widgets/restaurant_button.dart';

///
/// Created by Sunil Kumar on 02-05-2020 07:25 PM.
///
class AddTableSheet extends StatefulWidget {
  final String number, seats, id;
  const AddTableSheet({this.number = '', this.seats = '', this.id = ''});
  @override
  _AddTableSheetState createState() => _AddTableSheetState();
}

class _AddTableSheetState extends State<AddTableSheet> {
  TextEditingController _number, _seats;
  final GlobalKey<RestaurantButtonState> buttonKey = GlobalKey();
  @override
  void initState() {
    super.initState();

    _number = TextEditingController(text: '${widget.number}')
      ..addListener(() {
        setState(() {});
      });
    _seats = TextEditingController(text: '${widget.seats}')
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _seats.dispose();
    _number.dispose();
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
          Text('Add Table'),
          SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 22, vertical: 8),
            child: TextField(
              controller: _number,
              keyboardType: TextInputType.number,
              inputFormatters: [
                WhitelistingTextInputFormatter.digitsOnly,
              ],
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Table number'),
            ),
          ),
          SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 22, vertical: 8),
            child: TextField(
              controller: _seats,
              keyboardType: TextInputType.number,
              inputFormatters: [
                WhitelistingTextInputFormatter.digitsOnly,
              ],
              decoration: InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Table capacity'),
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
                    onPressed: _number.text.trim().isNotEmpty &&
                            _seats.text.trim().isNotEmpty
                        ? () {
                            buttonKey.currentState.showLoader();
                            FirebaseAuth.instance.currentUser().then((value) {
                              if (widget.id.isEmpty) {
                                Firestore.instance.collection('table').add({
                                  'number': int.parse(_number.text.trim()),
                                  'restaurantId': value.uid,
                                  'seats': int.parse(_seats.text.trim())
                                }).whenComplete(() {
                                  Navigator.pop(context);
                                  buttonKey.currentState.hideLoader();
                                });
                              } else {
                                Firestore.instance
                                    .collection('table')
                                    .document(widget.id)
                                    .updateData({
                                  'number': _number.text.trim(),
                                  'restaurantId': value.uid,
                                  'seats': _seats.text.trim()
                                }).whenComplete(() {
                                  Navigator.pop(context);
                                  buttonKey.currentState.hideLoader();
                                });
                              }
                            }).catchError((e) {
                              buttonKey.currentState.hideLoader();
                            });
                          }
                        : null,
                    text: widget.id.isEmpty ? 'Add' : 'Update',
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
