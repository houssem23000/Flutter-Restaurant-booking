import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:restaurantbookinguser/config/enums.dart';
import 'package:restaurantbookinguser/pages/authentication/forgot_password_page.dart';
import 'package:restaurantbookinguser/pages/authentication/sign_up_page.dart';
import 'package:restaurantbookinguser/pages/home/home_page.dart';
import 'package:restaurantbookinguser/widgets/restaurant_button.dart';
import 'package:restaurantbookinguser/widgets/restaurant_container.dart';

///
/// Created by Sunil Kumar on 28-04-2020 08:48 AM.
///
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<RestaurantButtonState> _buttonKey =
      GlobalKey<RestaurantButtonState>();
  bool isObscure = true;
  TextEditingController _emailController, _passwordController;
  @override
  void initState() {
    super.initState();

    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (c) => SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height / 7,
              ),
              Image.asset(
                'assets/logo.png',
                height: 200,
                width: 200,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height / 8,
              ),
              Text(
                'Login',
                style: TextStyle(
                    fontSize: 26,
                    color: Color(0xff3C5E7E),
                    fontWeight: FontWeight.w700),
              ),
              SizedBox(height: 20),
              RestaurantContainer(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: TextField(
                  autofocus: false,
                  controller: _emailController,
                  onSubmitted: (s) {
                    FocusScope.of(context).nextFocus();
                  },
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
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                            autofocus: false,
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
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => ForgotPasswordPage(
                                    email: _emailController.text)));
                      },
                      child: Text(
                        'Forgot password?',
                        style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).primaryColor),
                      )),
                ),
              ),
              RestaurantButton(
                key: _buttonKey,
                text: 'Continue',
                trailingIcon: Icons.keyboard_arrow_right,
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  final String email = _emailController.text.trim();
                  final String pass = _passwordController.text.trim();
                  if (email.isEmpty) {
                    Scaffold.of(c).showSnackBar(SnackBar(
                      behavior: SnackBarBehavior.floating,
                      content: Text('Email is requiered!'),
                    ));
                  } else if (pass.isEmpty) {
                    Scaffold.of(c).showSnackBar(SnackBar(
                      behavior: SnackBarBehavior.floating,
                      content: Text('Password is required!'),
                    ));
                  } else {
                    _buttonKey.currentState.showLoader();
                    FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                            email: email, password: pass)
                        .then((AuthResult result) {
                      if (result.user != null &&
                          result.user.uid != null &&
                          result.user.uid.isNotEmpty) {
                        Firestore.instance
                            .collection('users')
                            .document(result.user.uid)
                            .get()
                            .then((value) {
                          if (value.data['type'] == UserType.user.string) {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (_) => HomePage()),
                                (_) => false);
                          } else {
                            Scaffold.of(c).showSnackBar(SnackBar(
                              behavior: SnackBarBehavior.floating,
                              content: Text(
                                  'You are an restaurant user. Sign in to your restaurant app to continue.'),
                            ));
                            FirebaseAuth.instance.signOut();
                          }
                          _buttonKey.currentState.hideLoader();
                        }).whenComplete(() {
                          _buttonKey.currentState.hideLoader();
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
                },
              ),
              GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => SignUpPage()));
                  },
                  child: Text(
                    'New user? Sign up here.',
                    style: TextStyle(
                        fontSize: 12, color: Theme.of(context).primaryColor),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
