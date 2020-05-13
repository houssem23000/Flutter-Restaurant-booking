import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:restaurantbookingvendor/widgets/restaurant_button.dart';

///
///Created By Sunil Kumar at 10/05/2020
///
class EditProfileSheet extends StatefulWidget {
  final String phone, name, address;
  final String documentId;
  const EditProfileSheet(this.documentId,
      {this.phone = '', this.name = '', this.address = ''});
  @override
  _EditProfileSheetState createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<EditProfileSheet> {
  TextEditingController _name, _address, _phone;
  final GlobalKey<RestaurantButtonState> buttonKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.name)
      ..addListener(() {
        setState(() {});
      });
    _address = TextEditingController(text: widget.address)
      ..addListener(() {
        setState(() {});
      });
    _phone = TextEditingController(text: widget.phone)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _name.dispose();
    _address.dispose();
    _phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: ListView(
        shrinkWrap: true,
        children: [
          SizedBox(height: 16),
          Center(
            child: Text(
              'Edit profile',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).primaryColorDark),
            ),
          ),
          SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 22, vertical: 8),
            child: TextField(
                controller: _name,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    labelText: 'Name',
                    hintText: 'Your name')),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 22, vertical: 8),
            child: TextField(
                controller: _phone,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  WhitelistingTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10)
                ],
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    labelText: 'Phone',
                    hintText: 'Your phone number')),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 22, vertical: 8),
            child: TextField(
                controller: _address,
                keyboardType: TextInputType.multiline,
                minLines: 3,
                maxLines: 4,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 12),
                    labelText: 'Address',
                    hintText: 'Your restaurant address')),
          ),
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
                    onPressed: _name.text.trim().isNotEmpty &&
                            _address.text.trim().isNotEmpty &&
                            _phone.text.trim().isNotEmpty
                        ? () {
                            FocusScope.of(context).unfocus();
                            buttonKey.currentState.showLoader();
                            try {
                              Firestore.instance
                                  .collection('users')
                                  .document(widget.documentId)
                                  .updateData({
                                'phone': _phone.text.trim(),
                                'address': _address.text.trim(),
                                'name': _name.text.trim()
                              }).then((value) {
                                Navigator.pop(context, 'Profile updated');
                              }).whenComplete(() {
                                buttonKey.currentState.hideLoader();
                              });
                            } catch (e) {
                              if (e is PlatformException)
                                Navigator.pop(context, e.message);
                              else
                                Navigator.pop(context, e.toString());
                            }
                          }
                        : null,
                    text: 'Update',
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
