import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:restaurantbookinguser/widgets/restaurant_button.dart';
import 'package:restaurantbookinguser/widgets/restaurant_container.dart';

///
/// Created by Sunil Kumar on 28-04-2020 10:09 AM.
///
class ForgotPasswordPage extends StatefulWidget {
  final String email;
  const ForgotPasswordPage({this.email = ''});
  static const String routeName = 'forgot-passowrd';

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final GlobalKey<RestaurantButtonState> _buttonKey =
      GlobalKey<RestaurantButtonState>();
  TextEditingController _emailController;
  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.email);
  }

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Builder(
            builder: (c) => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RestaurantBackButton(),
                    Spacer(flex: 2),
                    Text(
                      'Reset password',
                      style: TextStyle(
                          fontSize: 26,
                          color: Color(0xff3C5E7E),
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    RestaurantContainer(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 20),
                            hintText: 'Enter registered email'),
                      ),
                    ),
                    RestaurantButton(
                      key: _buttonKey,
                      text: 'Send verification mail',
                      trailingIcon: Icons.keyboard_arrow_right,
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        if (_emailController.text.trim().isEmpty) {
                          Scaffold.of(c).showSnackBar(SnackBar(
                            behavior: SnackBarBehavior.floating,
                            content: Text('Enter registered email.'),
                          ));
                        } else {
                          _buttonKey.currentState.showLoader();

                          FirebaseAuth.instance
                              .sendPasswordResetEmail(
                                  email: _emailController.text.trim())
                              .then((value) {
                            Scaffold.of(c).showSnackBar(SnackBar(
                              behavior: SnackBarBehavior.floating,
                              content:
                                  Text('Reset email link sent successfully.'),
                            ));
                            Future.delayed(Duration(milliseconds: 1500))
                                .then((value) {
                              Navigator.pop(context);
                            });
                          }).catchError((e) {
                            if (e is PlatformException)
                              Scaffold.of(c).showSnackBar(SnackBar(
                                behavior: SnackBarBehavior.floating,
                                content: Text(e.message),
                              ));
                            else
                              Scaffold.of(c).showSnackBar(SnackBar(
                                behavior: SnackBarBehavior.floating,
                                content: Text('Some error occurred.'),
                              ));
                          }).whenComplete(() {
                            _buttonKey.currentState.hideLoader();
                          });
                        }
                      },
                    ),
                    Spacer(flex: 3),
                  ],
                )),
      ),
    );
  }
}
