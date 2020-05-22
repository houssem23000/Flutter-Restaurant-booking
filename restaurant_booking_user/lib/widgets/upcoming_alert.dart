import 'package:flutter/material.dart';
import 'package:restaurantbookinguser/config/enums.dart';
import 'package:restaurantbookinguser/pages/home/all_bookings_page.dart';

///
/// Created by Sunil Kumar on 22-05-2020 02:11 PM.
///
class UpcomingAlert extends StatelessWidget {
  final String name, date, slot;
  const UpcomingAlert({this.name, this.date, this.slot});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 300,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              top: 55,
              child: AlertDialog(
                elevation: 0,
                titleTextStyle: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                    fontFamily: 'Nunito',
                    fontSize: 20),
                titlePadding: const EdgeInsets.only(top: 32),
                contentPadding: const EdgeInsets.only(
                    left: 16, right: 16, bottom: 0, top: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                title: Center(
                  child: Text('You have an booking today.'),
                ),
                content: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      style: TextStyle(
                        color: Theme.of(context).primaryColorDark,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Nunito',
                      ),
                      children: [
                        TextSpan(text: 'Hi, You have an upcoming booking at '),
                        TextSpan(text: '$name on '),
                        TextSpan(text: '$date '),
                        TextSpan(text: '$slot.')
                      ]),
                ),
                actions: [
                  FlatButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('CANCEL'),
                  ),
                  FlatButton(
                    onPressed: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (c) => AllBookingsPage(
                                  initialStatus: OrderStatus.created,
                                ))),
                    child: Text('VIEW'),
                  ),
                ],
              ),
            ),
            Positioned(
                left: 0,
                right: 0,
                child: Image.asset(
                  'assets/alert.png',
                  height: 100,
                  width: 100,
                )),
          ],
        ),
      ),
    );
  }
}
/*
 AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          title: Center(
                            child: Text('You have an booking today.'),
                          ),
                          content: RichText(
                            text: TextSpan(
                                style: TextStyle(color: Colors.blue),
                                children: [
                                  TextSpan(
                                      style: TextStyle(color: Colors.blue),
                                      text:
                                          'Hi, You have an upcoming booking at '),
                                  TextSpan(
                                      style: TextStyle(color: Colors.blue),
                                      text: '${restaurant.data['name']} on '),
                                  TextSpan(
                                      style: TextStyle(color: Colors.blue),
                                      text: '${order[0].data['date']}} '),
                                  TextSpan(
                                      style: TextStyle(color: Colors.blue),
                                      text:
                                          '${slotFromIntToString(order[0].data['slotNo'])}.')
                                ]),
                          ),
                          actions: [
                            FlatButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('CANCEL'),
                            ),
                            FlatButton(
                              onPressed: () => Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (c) => AllBookingsPage(
                                            initialStatus: OrderStatus.created,
                                          ))),
                              child: Text('VIEW'),
                            ),
                          ],
                        )
*
*/
