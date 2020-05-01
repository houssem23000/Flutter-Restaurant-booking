import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:restaurantbookinguser/widgets/loader_error.dart';
import 'package:restaurantbookinguser/widgets/restaurant_button.dart';

///
/// Created by Sunil Kumar on 01-05-2020 08:33 PM.
///
class RestaurantDetailsPage extends StatelessWidget {
  final String restaurantId;
  const RestaurantDetailsPage(this.restaurantId);
  @override
  Widget build(BuildContext context) {
    print(restaurantId);
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: Firestore.instance
            .collection('users')
            .document(restaurantId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SafeArea(
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverPersistentHeader(
                    pinned: true,
                    floating: true,
                    delegate: CustomSliverDelegate(
                        expandedHeight: 250,
                        name: snapshot.data.data['name'],
                        photo: snapshot.data.data['photo'],
                        address: snapshot.data.data['address']),
                  ),
                  StreamBuilder<QuerySnapshot>(
                      stream:
                          Firestore.instance.collection('category').snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final List<DocumentSnapshot> documents = snapshot
                              .data.documents
                              .where((element) =>
                                  element.data['restaurantId'] == restaurantId)
                              .toList();
                          if (documents.isEmpty)
                            return SliverList(
                              delegate: SliverChildListDelegate(
                                  [ErrorText('No products are available.')]),
                            );
                          return SliverList(
                            delegate: SliverChildListDelegate(
                                documents.map((document) {
                              return StreamBuilder<QuerySnapshot>(
                                stream: Firestore.instance
                                    .collection('menu')
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasError)
                                    return ErrorText(
                                        '${snapshot.error.toString()}');
                                  if (snapshot.hasData) {
                                    final List<DocumentSnapshot> menu = snapshot
                                        .data.documents
                                        .where((element) =>
                                            element.data['categoryId'] ==
                                            document.documentID)
                                        .toList();
                                    return ExpansionTile(
                                      initiallyExpanded: true,
                                      title: Text(
                                        document.data['name'],
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          color: Theme.of(context)
                                              .primaryColorDark,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      children: menu
                                          .map((e) => Container(
                                                decoration: BoxDecoration(
                                                    border: Border(
                                                        top: BorderSide(
                                                            color:
                                                                Colors.grey))),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 12,
                                                        horizontal: 8),
                                                child: ListTile(
                                                  trailing: Text(
                                                      '${e.data['price']} ₹'),
                                                  title:
                                                      Text('${e.data['name']}'),
                                                  leading:
                                                      FadeInImage.assetNetwork(
                                                          placeholder:
                                                              'assets/food.jpg',
                                                          image:
                                                              e.data['photo']),
                                                ),
                                              ))
                                          .toList(),
                                    );
                                  }
                                  return Container();
                                },
                              );
                            }).toList()),
                          );
                        } else {
                          return SliverList(
                            delegate: SliverChildListDelegate([Loader()]),
                          );
                        }
                      })
                ],
              ),
            );
          }
          return Loader();
        },
      ),
    );
  }

  List _buildList() {
    List<Widget> listItems = List();
    listItems.add(Container(
      color: Colors.grey,
      height: 60,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.all(16),
      child: Text(
        'Products',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
      ),
    ));
    for (int i = 0; i < 20; i++) {
      listItems.add(ListTile(title: Text('Item $i')));
    }
    return listItems;
  }
}

class CustomSliverDelegate extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final bool hideTitleWhenExpanded;
  final String name, address, photo;

  CustomSliverDelegate({
    this.name,
    this.photo,
    this.address,
    @required this.expandedHeight,
    this.hideTitleWhenExpanded = true,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final appBarSize = expandedHeight - shrinkOffset;
    final cardTopPosition = expandedHeight / 1.3 - shrinkOffset;
    final proportion = 2 - (expandedHeight / appBarSize);
    final percent = proportion < 0 || proportion > 1 ? 0.0 : proportion;
    return Container(
        height: expandedHeight,
        child: Stack(children: [
          Container(
            height: appBarSize < kToolbarHeight ? kToolbarHeight : appBarSize,
            child: AppBar(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              leading: Center(
                child: RestaurantBackButton(
                  padding: EdgeInsets.all(0),
                ),
              ),
              elevation: 0.0,
              title: Opacity(
                  opacity: hideTitleWhenExpanded ? 1.0 - percent : 1.0,
                  child: Text("$name")),
            ),
          ),
          Positioned.fill(
              child: Opacity(
                  opacity: percent,
                  child: photo == null
                      ? Image.asset(
                          'assets/food.jpg',
                          fit: BoxFit.cover,
                        )
                      : FadeInImage.assetNetwork(
                          placeholder: 'assets/food.jpg',
                          fit: BoxFit.cover,
                          image: photo))),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 90,
            child: Opacity(
              opacity: percent,
              child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.black87, Colors.transparent],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter)),
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: 8,
            child: SafeArea(
              child: Opacity(
                opacity: percent,
                child: Center(
                    child: GestureDetector(
                  onTap: () => Navigator.maybePop(context),
                  child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                      padding: const EdgeInsets.fromLTRB(14, 10, 10, 10),
                      child: Icon(
                        Icons.arrow_back,
                        color: Theme.of(context).primaryColor,
                      )),
                )),
              ),
            ),
          ),
          Positioned(
            left: 0.0,
            right: 0.0,
            top: cardTopPosition > 0 ? cardTopPosition : 0,
            bottom: 0.0,
            child: Opacity(
              opacity: percent,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30 * percent),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$name',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '$address',
                      style: TextStyle(color: Colors.white70),
                    )
                  ],
                ),
              ),
            ),
          ),
        ]));
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight + 26;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
