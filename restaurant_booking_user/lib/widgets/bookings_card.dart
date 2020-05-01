import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

///
/// Created by Sunil Kumar on 30-04-2020 07:48 PM.
///
class BookingCard extends StatelessWidget {
  final isDisabled;
  const BookingCard() : isDisabled = false;
  const BookingCard.disabled() : isDisabled = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Color(0xffedeff4), offset: Offset(-5, -5), blurRadius: 5),
          BoxShadow(
              color: Color(0xffD2D8E4), offset: Offset(5, 5), blurRadius: 5),
        ],
      ),
      foregroundDecoration: isDisabled
          ? BoxDecoration(
              backgroundBlendMode: BlendMode.hue,
              color: Colors.black,
              borderRadius: BorderRadius.circular(12),
            )
          : null,
      width: 220,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                  child: Text(
                    '21st April, 12:00 PM',
                    style: TextStyle(
                        fontSize: 15,
                        letterSpacing: 0.4,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).primaryColor),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                  child: Text(
                    'Dosa Plaza',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).primaryColorDark),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                  child: Text('Chandrasekharpur',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          height: 1.1,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context)
                              .primaryColorDark
                              .withOpacity(0.7))),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 6, 8, 0),
                  child: Text('Table number : 12',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          height: 1.1,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context)
                              .primaryColorDark
                              .withOpacity(0.7))),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 8, 4, 0),
                    child: Text('View booking >',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style:
                            TextStyle(color: Theme.of(context).primaryColor)),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
