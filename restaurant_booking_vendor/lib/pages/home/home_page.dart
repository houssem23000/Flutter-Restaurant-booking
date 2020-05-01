import 'package:flutter/material.dart';
import 'package:restaurantbookingvendor/pages/home/all_category_page.dart';
import 'package:restaurantbookingvendor/pages/home/all_orders_page.dart';
import 'package:restaurantbookingvendor/pages/profile/profile_page.dart';
import 'package:restaurantbookingvendor/widgets/backdrop.dart';
import 'package:restaurantbookingvendor/widgets/restaurant_button.dart';

///
/// Created by Sunil Kumar on 29-04-2020 10:21 AM.
///
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return HomeBody();
  }
}

class HomeBody extends StatefulWidget {
  @override
  _HomeBodyState createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  int _currentIndex = 0;
  final List<Widget> _frontLayers = [AllCategoriesPage(), AllOrdersPage()];

  @override
  Widget build(BuildContext context) {
    return BackdropScaffold(
      headerHeight: MediaQuery.of(context).size.height / 1.5,
      frontLayerBorderRadius: BorderRadius.circular(20),
      title: Text(_currentIndex == 0 ? 'Your categories' : 'Your orders'),
      actions: [
        Center(
            child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: RestaurantIconButton(
                    icon: Icons.person,
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (c) => ProfilePage()));
                    })))
      ],
      frontLayer: _frontLayers[_currentIndex],
      backLayer: BackdropNavigationBackLayer(
        items: [
          ListTile(title: Text("All categories")),
          ListTile(title: Text("All orders")),
        ],
        onTap: (int position) => {setState(() => _currentIndex = position)},
      ),
    );
  }
}
