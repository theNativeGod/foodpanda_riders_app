import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../global/global.dart';
import '../models/items.dart';

class CartItem {
  String userId;
  String id;
  String itemId;
  String title;
  String imageUrl;
  double price;
  int quantity;

  CartItem({
    required this.id,
    required this.userId,
    required this.itemId,
    required this.title,
    required this.imageUrl,
    required this.price,
    required this.quantity,
  });
}

class Cart with ChangeNotifier {
  double totalAmount = 0;
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  final firestoreUserCart = FirebaseFirestore.instance
      .collection('users')
      .doc(sharedPreferences!.getString('uid'))
      .collection('userCart');

  fetchAndSetData() async {
    QuerySnapshot querySnapshot = await firestoreUserCart.get();
    final cartListData = querySnapshot.docs.map((doc) {
      return doc.data();
    });
    print(cartListData);
    final loadedItems = [];
    for (dynamic it in cartListData) {
      _items.putIfAbsent(
          it['itemId'],
          () => CartItem(
                id: it['itemId'],
                itemId: it['itemId'],
                title: it['title'],
                userId: it['userId'],
                quantity: it['quantity'],
                price: it['price'],
                imageUrl: it['imageUrl'],
              ));
    }
    calculateTotalAmount();
    notifyListeners();
  }

  Future<void> addToCart(Items newItem) async {
    if (_items.containsKey(newItem.itemID)) {
      updateCartItem(newItem);
    } else {
      await firestoreUserCart.doc(newItem.itemID).set({
        'userId': sharedPreferences!.getString('uid'),
        'itemId': newItem.itemID,
        'title': newItem.title,
        'imageUrl': newItem.thumbnailUrl,
        'price': newItem.price as double,
        'quantity': 1,
      });
    }
    fetchAndSetData();
    notifyListeners();
  }

  Future<void> updateCartItem(Items it) async {
    int updatedQuantity = 1;
    _items.update(it.itemID as String, (existingCartItem) {
      updatedQuantity = existingCartItem.quantity + 1;
      return CartItem(
        id: existingCartItem.id,
        imageUrl: existingCartItem.imageUrl,
        price: existingCartItem.price,
        title: existingCartItem.title,
        itemId: existingCartItem.itemId,
        userId: existingCartItem.userId,
        quantity: existingCartItem.quantity + 1,
      );
    });
    await firestoreUserCart
        .doc(it.itemID)
        .update({'quantity': updatedQuantity});
    notifyListeners();
  }

  Future<void> removeItem(String id, BuildContext ctx) async {
    if (_items[id]!.quantity <= 1) {
      ScaffoldMessenger.of(ctx).hideCurrentSnackBar();
      ScaffoldMessenger.of(ctx).showSnackBar(
        const SnackBar(
          content: Text('Removing This Item...'),
        ),
      );
      await firestoreUserCart.doc(id).delete();
      _items.remove(id);
      ScaffoldMessenger.of(ctx).showSnackBar(
        const SnackBar(
          content: Text('Item Removed'),
        ),
      );
    } else {
      var newQ = _items[id]!.quantity - 1;
      firestoreUserCart.doc(id).update({'quantity': newQ});
      _items.update(
        id,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          itemId: existingCartItem.itemId,
          imageUrl: existingCartItem.imageUrl,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity - 1,
          title: existingCartItem.title,
          userId: existingCartItem.userId,
        ),
      );
    }
    calculateTotalAmount();
    notifyListeners();
  }

  Future<void> clearAll(BuildContext context) async {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Clearing Cart'),
      ),
    );
    _items.forEach((id, item) async {
      await firestoreUserCart.doc(id).delete();
      _items.remove(id);
    });
    _items = {};
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cart Cleared'),
      ),
    );
    calculateTotalAmount();
    notifyListeners();
  }

  calculateTotalAmount() {
    totalAmount = 0;
    _items.forEach((id, cartItem) {
      totalAmount += cartItem.price * cartItem.quantity;
    });

    notifyListeners();
  }
}
