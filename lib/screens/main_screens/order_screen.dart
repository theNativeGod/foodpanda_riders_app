import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import '../../models/orders.dart';
import '../../models/cart.dart';
import '../../widgets/order_item_display.dart';
import 'shipment_screen.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  bool isInit = true;
  bool _isLoading = false;

  @override
  didChangeDependencies() {
    if (isInit) {
      getOrders();
    }
    isInit = false;

    super.didChangeDependencies();
  }

  getOrders() async {
    setState(() {
      _isLoading = true;
    });
    //final cartList = Provider.of<Cart>(context).items;
    await Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ordersData = Provider.of<Orders>(context);
    print(ordersData.orders);
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.red,
                Colors.amber,
              ],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        title: Text('Your Orders'),
        centerTitle: true,
      ),
      // drawer: const MyDrawer(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              height: MediaQuery.of(context).size.height * .8,
              child: ListView.builder(
                itemCount: ordersData.orders.length,
                itemBuilder: (ctx, i) {
                  return Column(
                    children: [
                      SizedBox(height: 50),
                      Text(ordersData.orders[i].id.toString()),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 10,
                        ),
                        child: Center(
                            child: Text(
                          ordersData.orders[i].address,
                          textAlign: TextAlign.center,
                        )),
                      ),
                      InkWell(
                        onTap: () {
                          print(ordersData.orders[i].id);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ShipmentAddressScreen(
                                  ordersData.orders[i].id as String,
                                ),
                              ));
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * .7,
                          child: Card(
                            elevation: 5,
                            child: OrderItemDisplay(
                                ordersData.orders[i].cartItems),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
    );
  }
}
