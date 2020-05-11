import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restaurantbookingvendor/pages/authentication/login_page.dart';
import 'package:restaurantbookingvendor/widgets/edit_profile_sheet.dart';
import 'package:restaurantbookingvendor/widgets/loader_error.dart';
import 'package:restaurantbookingvendor/widgets/restaurant_button.dart';

///
/// Created by Sunil Kumar on 28-04-2020 07:58 PM.
///

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: FirebaseAuth.instance.currentUser(),
        builder: (context, userSnapshot) {
          if (userSnapshot.hasError)
            return ErrorText('${userSnapshot.error.toString()}');
          if (userSnapshot.hasData) {
            if (userSnapshot.data.uid != null &&
                userSnapshot.data.uid.isNotEmpty) {
              return StreamBuilder<DocumentSnapshot>(
                stream: Firestore.instance
                    .collection('users')
                    .document(userSnapshot.data.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError)
                    return ErrorText('${snapshot.error.toString()}');
                  if (snapshot.hasData) {
                    final DocumentSnapshot document = snapshot.data;
                    return _ProfileWidget(document);
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
        },
      ),
    );
  }
}

class _ProfileWidget extends StatefulWidget {
  final DocumentSnapshot document;
  _ProfileWidget(this.document);

  @override
  __ProfileWidgetState createState() => __ProfileWidgetState();
}

class __ProfileWidgetState extends State<_ProfileWidget> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return [
          SliverAppBar(
              automaticallyImplyLeading: false,
              leading: Center(
                child: GestureDetector(
                  onTap: () => Navigator.maybePop(context),
                  child: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).scaffoldBackgroundColor,
                          boxShadow: [
                            BoxShadow(
                                color: Color(0xffE6E9F0),
                                offset: Offset(-5, -5),
                                blurRadius: 5),
                            BoxShadow(
                                color: Color(0xffD2D8E4),
                                offset: Offset(5, 5),
                                blurRadius: 5),
                          ]),
                      padding: const EdgeInsets.fromLTRB(14, 10, 10, 10),
                      child: Icon(
                        Icons.arrow_back,
                        color: Theme.of(context).primaryColor,
                      )),
                ),
              ),
              actions: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: RestaurantIconButton(
                      icon: Icons.edit,
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (context) => EditProfileSheet());
                      },
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: RestaurantIconButton(
                      icon: Icons.power_settings_new,
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                backgroundColor:
                                    Theme.of(context).scaffoldBackgroundColor,
                                title: Text('Are you sure to logout?'),
                                actions: [
                                  FlatButton(
                                      child: Text('No'),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      }),
                                  FlatButton(
                                    child: Text('Yes'),
                                    onPressed: () {
                                      FirebaseAuth.instance
                                          .signOut()
                                          .then((value) {
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (c) => LoginPage()),
                                            (route) => false);
                                      });
                                    },
                                  )
                                ],
                              );
                            });
                      },
                    ),
                  ),
                )
              ],
              expandedHeight: 430.0,
              floating: true,
              pinned: true,
              snap: true,
              elevation: 8,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              flexibleSpace: FlexibleSpaceBar(
                  title: Text('Past orders',
                      style: TextStyle(
                        fontSize: 16.0,
                      )),
                  collapseMode: CollapseMode.pin,
                  background: Column(
                    children: [
                      SizedBox(
                        height: 90,
                      ),
                      Center(
                        child: SizedBox(
                          height: 200,
                          width: 200,
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
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
                                  padding: const EdgeInsets.all(12),
                                  child: Stack(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle),
                                        clipBehavior: Clip.antiAlias,
                                        child: widget.document['photo'] ==
                                                    null ||
                                                widget.document['photo'].isEmpty
                                            ? Image.asset(
                                                'assets/dp_placeholder.jpg',
                                                fit: BoxFit.cover,
                                              )
                                            : FadeInImage.assetNetwork(
                                                placeholder:
                                                    'assets/dp_placeholder.jpg',
                                                image: widget.document['photo'],
                                                fit: BoxFit.cover,
                                              ),
                                      ),
                                      if (isLoading)
                                        Positioned.fill(
                                            child: CircularProgressIndicator(
                                          strokeWidth: 3,
                                        )),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 10,
                                right: 10,
                                child: GestureDetector(
                                  onTap: _chooseImage,
                                  child: Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Theme.of(context)
                                              .scaffoldBackgroundColor,
                                          gradient: LinearGradient(
                                              colors: [
                                                Color(0xfff5f6f9),
                                                Color(0xffD2D8E4)
                                              ],
                                              stops: [
                                                0.1,
                                                1
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Color(0xffE6E9F0),
                                                offset: Offset(-1, -1),
                                                blurRadius: 2),
                                            BoxShadow(
                                                color: Color(0xffD2D8E4),
                                                offset: Offset(5, 5),
                                                blurRadius: 5),
                                          ]),
                                      padding: const EdgeInsets.fromLTRB(
                                          14, 10, 10, 10),
                                      child: Icon(
                                        Icons.add_photo_alternate,
                                        color: Theme.of(context).primaryColor,
                                      )),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: Text(
                          '${widget.document['name']}',
                          style: TextStyle(
                              fontSize: 26, fontWeight: FontWeight.w700),
                        ),
                      ),
                      Center(
                        child: Text(
                          '${widget.document['address']}',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${widget.document['phone']} . ',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              '${widget.document['email']}',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )))
        ];
      },
      body: ListView(
          padding: const EdgeInsets.all(0),
          children: List.generate(
              20,
              (index) => ListTile(
                    title: Text('Item $index'),
                  ))),
    );
  }

  _chooseImage() {
    setState(() {
      isLoading = true;
    });
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
            _uploadFile(value);
          } else {
            setState(() {
              isLoading = false;
            });
          }
        }).catchError((error) {
          print(error.toString());
          setState(() {
            isLoading = false;
          });
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    }).catchError((error) {
      print(error.toString());
      setState(() {
        isLoading = false;
      });
    });
  }

  _uploadFile(File file) async {
    try {
      FirebaseAuth.instance.currentUser().then((user) async {
        StorageReference storageReference =
            FirebaseStorage.instance.ref().child("dp/${user.uid}.jpg");

        final StorageUploadTask uploadTask = storageReference.putFile(file);
        final StorageTaskSnapshot downloadUrl = await uploadTask.onComplete;
        final String url = await downloadUrl.ref.getDownloadURL();

        Firestore.instance
            .collection('users')
            .document(user.uid)
            .updateData({'photo': url}).then((value) {
          setState(() {
            isLoading = false;
          });
        });
      });
    } on PlatformException catch (e) {
      Scaffold.of(context).showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(e.message),
      ));
      setState(() {
        isLoading = false;
      });
    }
  }
}
