import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///
/// Created by Sunil Kumar on 28-04-2020 09:36 AM.
///
class RestaurantButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData trailingIcon;
  const RestaurantButton(
      {Key key,
      this.text: '',
      this.onPressed,
      this.trailingIcon: Icons.keyboard_arrow_right})
      : super(key: key);

  @override
  RestaurantButtonState createState() => RestaurantButtonState();
}

class RestaurantButtonState extends State<RestaurantButton> {
  bool _isLoading = false;
  void showLoader() {
    setState(() {
      _isLoading = true;
    });
  }

  void hideLoader() {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(4),
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                widget.text,
                style:
                    TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
              ),
              _isLoading
                  ? SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white)),
                    )
                  : Icon(
                      Icons.keyboard_arrow_right,
                      color: Colors.white,
                    ),
            ],
          )),
    );
  }
}

class RestaurantIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  const RestaurantIconButton({this.icon, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
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
            icon,
            color: Theme.of(context).primaryColor,
          )),
    );
  }
}

class RestaurantBackButton extends StatelessWidget {
  final EdgeInsets padding;
  const RestaurantBackButton({this.padding = const EdgeInsets.all(12)});
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: padding,
        child: RestaurantIconButton(
            icon: Icons.arrow_back,
            onPressed: () => Navigator.maybePop(context)),
      ),
    );
  }
}
