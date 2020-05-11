import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

///
///Created By Sunil Kumar at 10/05/2020
///
class CartModel extends ChangeNotifier {
  final List<OrderItem> _items = [];
  UnmodifiableListView<OrderItem> get items => UnmodifiableListView(_items);
  double get totalPrice {
    double total = 0;
    _items.forEach((element) {
      total += element.quantity * element.price;
    });
    return total;
  }

  int get totalItems {
    int total = 0;
    _items.forEach((element) {
      total += element.quantity * 1;
    });
    return total;
  }

  void add(OrderItem item) {
    print(item.name);
    if (_items.contains(item)) {
      _items[_items.indexOf(item)].quantity++;
    } else {
      _items.add(item);
    }
    notifyListeners();
  }

  void remove(OrderItem item) {
    for (int i = 0; i < _items.length; i++) {
      if (_items[i] == item) {
        if (_items[i].quantity <= 1) {
          _items.removeAt(i);
          notifyListeners();
        } else {
          _items[i].quantity--;
          notifyListeners();
        }
      }
    }
  }

  void removeAll() {
    _items.clear();
    notifyListeners();
  }
}

class OrderItem {
  String menuId, name, photo;
  double price;
  int quantity;
  OrderItem(
      {this.menuId = '',
      this.name = '',
      this.photo = '',
      this.price = 0,
      this.quantity = 1});
  OrderItem.fromDocumentSnapshot(DocumentSnapshot doc)
      : menuId = doc.documentID,
        name = doc.data['name'],
        photo = doc.data['photo'],
        price = doc.data['price'],
        quantity = 1;
  Map<String, dynamic> toJson() {
    return {
      'menuId': this.menuId,
      'name': this.name,
      'price': this.price,
      'quantity': this.quantity
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderItem &&
          runtimeType == other.runtimeType &&
          menuId == other.menuId;

  @override
  int get hashCode => menuId.hashCode;
}
