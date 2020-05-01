import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///
/// Created by Sunil Kumar on 30-04-2020 07:05 PM.
///
class RestaurantCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
                color: Color(0xffedeff4),
                offset: Offset(-5, -5),
                blurRadius: 5),
            BoxShadow(
                color: Color(0xffD2D8E4), offset: Offset(5, 5), blurRadius: 5),
          ]),
      width: 220,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Material(
              borderRadius: BorderRadius.circular(8),
              clipBehavior: Clip.antiAlias,
              child: FadeInImage.assetNetwork(
                  placeholder: 'assets/food.jpg',
                  fit: BoxFit.cover,
                  width: 220,
                  image:
                      'https://cdn.dribbble.com/users/4470689/screenshots/11127964/media/e3a9b76719554a062325f6e2903f76f4.jpg'),
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 12, 8, 0),
                  child: Text(
                    'Name',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).primaryColorDark),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                  child: Text('AddressAd',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          height: 1.1,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context)
                              .primaryColorDark
                              .withOpacity(0.7))),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
