import 'package:flutter/material.dart';

///
/// Created by Sunil Kumar on 28-04-2020 10:17 AM.
///
class RestaurantContainer extends StatelessWidget {
  final EdgeInsetsGeometry margin;
  final Widget child;
  final BoxDecoration decoration;
  const RestaurantContainer({this.margin, this.child, this.decoration});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: decoration == null
          ? BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                  BoxShadow(
                      color: Color(0xffedeff4),
                      offset: Offset(-5, -5),
                      blurRadius: 5),
                  BoxShadow(
                      color: Color(0xffD2D8E4),
                      offset: Offset(5, 5),
                      blurRadius: 5),
                ])
          : decoration.copyWith(
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [
                  BoxShadow(
                      color: Color(0xffedeff4),
                      offset: Offset(-5, -5),
                      blurRadius: 5),
                  BoxShadow(
                      color: Color(0xffD2D8E4),
                      offset: Offset(5, 5),
                      blurRadius: 5),
                ]),
      child: child,
    );
  }
}
