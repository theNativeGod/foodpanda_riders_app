import 'package:flutter/material.dart';
import '../models/cart.dart';

class OrderItemDisplay extends StatelessWidget {
  List<CartItem> citems;
  OrderItemDisplay(this.citems, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: ListView.builder(
        itemCount: citems.length,
        itemBuilder: (ctx, i) {
          return SizedBox(
            height: 50,
            child: ListTile(
              title: Text(citems[i].title),
              subtitle: Text('\$${citems[i].price} x ${citems[i].quantity}'),
            ),
          );
        },
      ),
    );
  }
}
