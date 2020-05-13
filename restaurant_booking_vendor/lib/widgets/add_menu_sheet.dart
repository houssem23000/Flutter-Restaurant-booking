import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restaurantbookingvendor/widgets/restaurant_button.dart';

///
/// Created by Sunil Kumar on 01-05-2020 09:39 AM.
///
class AddMenuSheet extends StatefulWidget {
  final String categoryId, category;
  final String name, photo, menuId;
  final double price;
  AddMenuSheet(this.categoryId,
      {this.category, this.price, this.name, this.photo, this.menuId});

  @override
  _AddMenuSheetState createState() => _AddMenuSheetState();
}

class _AddMenuSheetState extends State<AddMenuSheet> {
  TextEditingController _name, _price;
  File _photo;
  final GlobalKey<RestaurantButtonState> buttonKey = GlobalKey();
  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.name ?? '')
      ..addListener(() {
        setState(() {});
      });
    _price = TextEditingController(text: '${widget.price ?? ''}')
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _name.dispose();
    _price.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 16),
            Text(
              '${widget.menuId == null ? 'Add' : 'Edit'} ${widget.category} menu',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).primaryColorDark),
            ),
            SizedBox(height: 16),
            Center(
                child: GestureDetector(
                    onTap: _chooseImage,
                    child: Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context).scaffoldBackgroundColor,
                            gradient: LinearGradient(
                                colors: [
                                  Color(0xffF1F3F7),
                                  Color(0xffD2D8E4),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight),
                            boxShadow: [
                              BoxShadow(
                                  color: Color(0xffF1F3F7),
                                  offset: Offset(-5, -5),
                                  blurRadius: 5),
                              BoxShadow(
                                  color: Color(0xffD2D8E4),
                                  offset: Offset(5, 5),
                                  blurRadius: 5),
                            ]),
                        padding: const EdgeInsets.all(6),
                        child: Container(
                          decoration: BoxDecoration(shape: BoxShape.circle),
                          clipBehavior: Clip.antiAlias,
                          alignment: Alignment.center,
                          child: this._photo == null && widget.photo == null
                              ? Text(
                                  'Click here to add photo',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 16),
                                )
                              : this._photo == null
                                  ? Image.network(widget.photo,
                                      fit: BoxFit.cover)
                                  : Image.file(
                                      this._photo,
                                      fit: BoxFit.cover,
                                    ),
                        )))),
            SizedBox(height: 16),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 22, vertical: 8),
              child: TextField(
                controller: _name,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Name',
                    hintText: 'Name of the menu'),
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 22, vertical: 8),
              child: TextField(
                controller: _price,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Price',
                    hintText: 'Price of the menu',
                    suffixText: '₹'),
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
                      onPressed: _name.text.trim().isNotEmpty &&
                                  _price.text.trim().isNotEmpty &&
                                  this._photo != null ||
                              widget.menuId != null
                          ? () {
                              FocusScope.of(context).unfocus();
                              buttonKey.currentState.showLoader();
                              if (widget.menuId == null)
                                _uploadFile(
                                    photo: this._photo,
                                    name: _name.text.trim(),
                                    price: _price.text.trim());
                              else {
                                _editMenu(
                                    name: _name.text.trim(),
                                    photo: this._photo,
                                    price: _price.text.trim(),
                                    photoUrl: widget.photo,
                                    menuId: widget.menuId);
                              }
                            }
                          : null,
                      text: widget.menuId == null ? 'Add' : 'Edit',
                      key: buttonKey,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _chooseImage() {
    ImagePicker.pickImage(source: ImageSource.gallery).then((file) {
      if (file != null && file.path != null && file.path.isNotEmpty) {
        ImageCropper.cropImage(
                sourcePath: file.path,
                aspectRatioPresets: [
                  CropAspectRatioPreset.square,
                ],
                androidUiSettings: AndroidUiSettings(
                  toolbarTitle: 'Crop Your Image',
                  toolbarColor: Theme.of(context).primaryColor,
                  toolbarWidgetColor: Colors.white,
                  initAspectRatio: CropAspectRatioPreset.square,
                  lockAspectRatio: true,
                ),
                iosUiSettings: IOSUiSettings(
                    minimumAspectRatio: 1.0,
                    title: 'Crop Your Image',
                    aspectRatioLockEnabled: true,
                    showCancelConfirmationDialog: true))
            .then((File value) {
          if (value != null && value.path != null && value.path.isNotEmpty) {
            setState(() {
              this._photo = value;
            });
          }
        }).catchError((error) {
          print(error.toString());
        });
      }
    }).catchError((error) {
      print(error.toString());
    });
  }

  _uploadFile({File photo, String name, String price}) async {
    try {
      StorageReference storageReference = FirebaseStorage.instance
          .ref()
          .child("menu/${widget.categoryId}_${name.replaceAll(' ', '_')}.jpg");

      final StorageUploadTask uploadTask = storageReference.putFile(photo);
      final StorageTaskSnapshot downloadUrl = await uploadTask.onComplete;
      final String url = await downloadUrl.ref.getDownloadURL();

      Firestore.instance.collection('menu').add({
        'name': name,
        'price': double.parse(price),
        'photo': url,
        'categoryId': widget.categoryId,
      }).whenComplete(() {
        buttonKey.currentState.hideLoader();
        Navigator.pop(context);
      });
    } on PlatformException catch (e) {
      buttonKey.currentState.hideLoader();
      Scaffold.of(context).showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(e.message),
      ));
    }
  }

  _editMenu({
    File photo,
    String name,
    String price,
    String photoUrl,
    String menuId,
  }) async {
    try {
      if (photo == null) {
        Firestore.instance.collection('menu').document(menuId).updateData({
          'name': name,
          'price': double.parse(price),
        }).whenComplete(() {
          buttonKey.currentState.hideLoader();
          Navigator.pop(context);
        });
      } else {
        FirebaseStorage.instance
            .getReferenceFromUrl(photoUrl)
            .then((value) async {
          final StorageUploadTask uploadTask = value.putFile(photo);
          final StorageTaskSnapshot downloadUrl = await uploadTask.onComplete;
          final String url = await downloadUrl.ref.getDownloadURL();
          Firestore.instance.collection('menu').document(menuId).updateData({
            'name': name,
            'price': double.parse(price),
            'photo': url
          }).whenComplete(() {
            buttonKey.currentState.hideLoader();
            Navigator.pop(context);
          });
        });
      }
    } on PlatformException catch (e) {
      buttonKey.currentState.hideLoader();
      Scaffold.of(context).showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(e.message),
      ));
    }
  }
}
