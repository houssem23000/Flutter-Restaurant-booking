import 'package:flutter/material.dart';

///
///Created By Sunil Kumar at 10/05/2020
///
class EditProfileSheet extends StatefulWidget {
  @override
  _EditProfileSheetState createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<EditProfileSheet> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(),
          TextField(),
          TextField(),
        ],
      ),
    );
  }
}