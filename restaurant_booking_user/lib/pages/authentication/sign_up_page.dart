import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:restaurantbookinguser/config/enums.dart';
import 'package:restaurantbookinguser/pages/home/home_page.dart';
import 'package:restaurantbookinguser/widgets/restaurant_button.dart';
import 'package:restaurantbookinguser/widgets/restaurant_container.dart';

///
/// Created by Sunil Kumar on 28-04-2020 10:09 AM.
///
class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

/*
* Name
Email
Photo
Phone
*/
class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<RestaurantButtonState> _buttonKey =
      GlobalKey<RestaurantButtonState>();

  bool isObscure = true;

  TextEditingController _emailController,
      _nameController,
      _phoneController,
      _passwordController,
      _confirmPassword;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _nameController = TextEditingController();
    _confirmPassword = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _confirmPassword.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Builder(
          builder: (c) => SingleChildScrollView(
            child: Column(
              children: <Widget>[
                RestaurantBackButton(),
                Text(
                  'Signup',
                  style: TextStyle(
                      fontSize: 26,
                      color: Color(0xff3C5E7E),
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 20,
                ),
                RestaurantContainer(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: TextField(
                    controller: _nameController,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 20),
                        hintText: 'Your Name'),
                  ),
                ),
                RestaurantContainer(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 20),
                        hintText: 'Your Email'),
                  ),
                ),
                RestaurantContainer(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: <TextInputFormatter>[
                      WhitelistingTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 20),
                        hintText: 'Your Phone'),
                  ),
                ),
                RestaurantContainer(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                              controller: _passwordController,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.done,
                              obscureText: isObscure,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Your Password',
                                contentPadding:
                                    const EdgeInsets.only(left: 20, right: 12),
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isObscure = !isObscure;
                                });
                              },
                              child: Icon(
                                isObscure
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Theme.of(context).primaryColor,
                              )),
                        )
                      ],
                    )),
                RestaurantContainer(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                              controller: _confirmPassword,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.done,
                              obscureText: isObscure,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Confirm Password',
                                contentPadding:
                                    const EdgeInsets.only(left: 20, right: 12),
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  isObscure = !isObscure;
                                });
                              },
                              child: Icon(
                                isObscure
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Theme.of(context).primaryColor,
                              )),
                        )
                      ],
                    )),
                RestaurantButton(
                    key: _buttonKey,
                    text: 'Create account',
                    trailingIcon: Icons.keyboard_arrow_right,
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      final String name = _nameController.text.trim();
                      final String email = _emailController.text.trim();
                      final String pass = _passwordController.text.trim();
                      final String confirmPass = _confirmPassword.text.trim();
                      final String phone = _phoneController.text.trim();
                      if (name.isEmpty) {
                        Scaffold.of(c).showSnackBar(SnackBar(
                          behavior: SnackBarBehavior.floating,
                          content: Text('Name is requiered!'),
                        ));
                      } else if (email.isEmpty) {
                        Scaffold.of(c).showSnackBar(SnackBar(
                          behavior: SnackBarBehavior.floating,
                          content: Text('Email is requiered!'),
                        ));
                      } else if (pass.isEmpty) {
                        Scaffold.of(c).showSnackBar(SnackBar(
                          behavior: SnackBarBehavior.floating,
                          content: Text('Password is requiered!'),
                        ));
                      } else if (confirmPass.isEmpty || pass != confirmPass) {
                        Scaffold.of(c).showSnackBar(SnackBar(
                          behavior: SnackBarBehavior.floating,
                          content: Text('Passwords not match!'),
                        ));
                      } else if (phone.isEmpty) {
                        Scaffold.of(c).showSnackBar(SnackBar(
                          behavior: SnackBarBehavior.floating,
                          content: Text('Phone is requiered!'),
                        ));
                      } else {
                        _buttonKey.currentState.showLoader();
                        FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                                email: email, password: pass)
                            .then((AuthResult result) {
                          if (result.user != null &&
                              result.user.uid != null &&
                              result.user.uid.isNotEmpty) {
                            Firestore.instance
                                .collection('users')
                                .document(result.user.uid)
                                .setData({
                              'createdAt': DateTime.now(),
                              'email': email,
                              'name': name,
                              'phone': phone,
                              'type': UserType.user.string
                            }).then((value) {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (_) => HomePage()),
                                  (_) => false);
                            }).catchError((e) {
                              if (e is PlatformException)
                                Scaffold.of(c).showSnackBar(SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  content: Text(e.message),
                                ));
                              else
                                Scaffold.of(c).showSnackBar(SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  content: Text('Some error occurred!'),
                                ));
                              FirebaseAuth.instance.currentUser().then((value) {
                                value.delete();
                              });
                            });
                          } else {
                            Scaffold.of(c).showSnackBar(SnackBar(
                              behavior: SnackBarBehavior.floating,
                              content: Text('Some error occurred!'),
                            ));
                          }
                        }).catchError((e) {
                          if (e is PlatformException)
                            Scaffold.of(c).showSnackBar(SnackBar(
                              behavior: SnackBarBehavior.floating,
                              content: Text(e.message),
                            ));
                          else
                            Scaffold.of(c).showSnackBar(SnackBar(
                              behavior: SnackBarBehavior.floating,
                              content: Text('Some error occurred!'),
                            ));
                        }).whenComplete(() {
                          _buttonKey.currentState.hideLoader();
                        });
                      }
                    }),
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Already have an account? Login here',
                      style: TextStyle(
                          fontSize: 12, color: Theme.of(context).primaryColor),
                    )),
                SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
