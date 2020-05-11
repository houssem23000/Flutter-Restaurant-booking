import 'package:flutter/material.dart';
import 'package:restaurantbookingvendor/pages/home/all_category_page.dart';
import 'package:restaurantbookingvendor/pages/home/all_orders_page.dart';
import 'package:restaurantbookingvendor/pages/profile/profile_page.dart';
import 'package:restaurantbookingvendor/widgets/backdrop.dart';
import 'package:restaurantbookingvendor/widgets/restaurant_button.dart';

import 'all_tables_page.dart';

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
  int _currentIndex = 1;
  final List<Widget> _frontLayers = [
    AllCategoriesPage(),
    AllOrdersPage(),
    ManageTablesPage(),
  ];

  String getTitle() {
    switch (_currentIndex) {
      case 0:
        return 'Your categories';
      case 1:
        return 'Your orders';
      case 2:
        return 'Manage tables';
      case 3:
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackdropScaffold(
      headerHeight: MediaQuery.of(context).size.height / 2,
      frontLayerBorderRadius: BorderRadius.circular(20),
      title: Text(getTitle()),
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
          ListTile(title: Text("View orders")),
          ListTile(title: Text("Manage tables")),
        ],
        onTap: (int position) => {setState(() => _currentIndex = position)},
      ),
    );
  }
}
