import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../global/global.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart.dart';

class OrderItem {
  String id;
  String address;
  List<CartItem> cartItems;

  OrderItem({
    required this.id,
    required this.address,
    required this.cartItems,
  });
}

class Orders with ChangeNotifier {
  final firestoreClxnRef = FirebaseFirestore.instance.collection('AllOrders');
  List<OrderItem> _orders = [];
  List<OrderItem> get orders {
    return [..._orders];
  }

  fetchAndSetOrders() async {
    QuerySnapshot querySnapshot = await firestoreClxnRef.get();
    List<dynamic> ordersListData =
        querySnapshot.docs.map((doc) => doc.data()).toList();
    //print(ordersListData);
    List<OrderItem> loadedOrders = [];
    ordersListData.forEach((ordData) {
      loadedOrders.add(
        OrderItem(
          id: ordData['timestamp'],
          address: ordData['address'],
          cartItems: (ordData['Items'] as List<dynamic>)
              .map((item) => CartItem(
                  id: item['id'],
                  userId: item['userId'],
                  itemId: item['itemId'],
                  title: item['title'],
                  imageUrl: item['imageUrl'],
                  price: item['price'],
                  quantity: item['quantity']))
              .toList(),
        ),
      );
    });
    _orders = loadedOrders.reversed.toList();
    print(_orders);
    notifyListeners();
  }

  addOrder(List<CartItem> cartItems, String userAddress) async {
    final timestamp = DateTime.now();
    print("order ");
    await firestoreClxnRef.doc(timestamp.toIso8601String()).set({
      'timestamp': timestamp.toIso8601String(),
      'Items': cartItems
          .map((item) => {
                'itemId': item.id,
                'title': item.title,
                'price': item.price,
                'quantity': item.quantity,
                'userId': item.userId,
                'id': item.id,
                'imageUrl': item.imageUrl,
              })
          .toList(),
      'address': userAddress,
    });
    notifyListeners();
  }
}
