import 'package:flutter/material.dart';

///
/// Created by Sunil Kumar on 28-04-2020 10:17 AM.
///
class RestaurantContainer extends StatelessWidget {
  final EdgeInsetsGeometry margin;
  final Widget child;
  final BoxDecoration decoration;
  final bool isSelected;
  const RestaurantContainer(
      {this.margin, this.child, this.decoration, this.isSelected = false});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: decoration == null
          ? BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(12),
              boxShadow: isSelected
                  ? null
                  : [
                      BoxShadow(
                          color: Color(0xffedeff4),
                          offset: Offset(-5, -5),
                          blurRadius: 5),
                      BoxShadow(
                          color: Color(0xffD2D8E4),
                          offset: Offset(5, 5),
                          blurRadius: 5),
                    ],
              gradient: isSelected
                  ? LinearGradient(colors: [
                      Color(0xffa1c4fd), //4facfe
                      Color(0xffc2e9fb), //00f2fe
                    ], begin: Alignment.topLeft, end: Alignment.bottomRight)
                  : null)
          : decoration.copyWith(
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: isSelected
                  ? null
                  : [
                      BoxShadow(
                          color: Color(0xffedeff4),
                          offset: Offset(-5, -5),
                          blurRadius: 5),
                      BoxShadow(
                          color: Color(0xffD2D8E4),
                          offset: Offset(5, 5),
                          blurRadius: 5),
                    ],
              gradient: isSelected
                  ? LinearGradient(colors: [
                      Color(0xffF1F3F7),
                      Color(0xffD2D8E4),
                    ], begin: Alignment.topLeft, end: Alignment.bottomRight)
                  : null),
      child: child,
    );
  }
}
