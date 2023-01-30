import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodpanda_riders_app/screens/main_screens/parcel_in_progress.dart';
import 'package:geolocator/geolocator.dart';

class ShipmentAddressScreen extends StatefulWidget {
  final String orderID;

  ShipmentAddressScreen(this.orderID, {super.key});

  @override
  State<ShipmentAddressScreen> createState() => _ShipmentAddressScreenState();
}

class _ShipmentAddressScreenState extends State<ShipmentAddressScreen> {
  String orderStatus = "";
  String orderByUser = "";
  var userLat, userLng;
  getUserLocation() async {
    print('HERE IS THE USER' + orderByUser);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(orderByUser)
        .get()
        .then((docSnapshot) async {
      userLat = await docSnapshot.data()!['lat'];
      userLng = await docSnapshot.data()!['long'];
      print('userLat = $userLat');
      print('userLong = $userLng');
    });
  }

  Future<void> getOrderInfo() async {
    print('here' + widget.orderID);
    await FirebaseFirestore.instance
        .collection("AllOrders")
        .doc(widget.orderID)
        .get()
        .then((documentSnapshot) {
      orderStatus = documentSnapshot.data()!['status'];
      orderByUser = documentSnapshot.data()!['userId'];
      print('status= $orderStatus');
      print('userId= $orderByUser');
    });
  }

  bool isInit = true;

  @override
  void didChangeDependencies() {
    if (isInit) {
      getOrderInfo().then((value) {
        getUserLocation();
      });
    }
    isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('AllOrders')
              .doc(widget.orderID)
              .get(),
          builder: ((context, snapshot) {
            Map? dataMap;
            if (snapshot.hasData) {
              dataMap = snapshot.data!.data()! as Map<String, dynamic>;
              orderStatus = dataMap['status'].toString();
            }
            return snapshot.hasData
                ? Container(
                    child: Column(
                      children: [
                        Text('Order Status: $orderStatus'),
                        const SizedBox(
                          height: 10.0,
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.all(8.0),
                        //   child: Text(
                        //     "\$ " + dataMap!['totalAmount'].toString(),
                        //     style: const TextStyle(
                        //       fontSize: 24,
                        //       fontWeight: FontWeight.bold,
                        //     ),
                        //   ),
                        // ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Order at: " + dataMap!['timestamp'].toString(),
                          ),
                        ),
                        const Divider(
                          thickness: 4,
                        ),
                        orderStatus == 'ended'
                            ? Image.asset("assets/images/success.jpg")
                            : Image.asset("assets/images/confirm_pick.png"),
                        const Divider(
                          thickness: 4,
                        ),
                        // FutureBuilder<DocumentSnapshot>(
                        //   future: FirebaseFirestore.instance
                        //       .collection('users')
                        //       .doc(orderByUser)
                        //       .get()
                        //       .then((documentSnapshot) {
                        //     return dataMap!['addressID'] =
                        //         documentSnapshot.data()!['address'];
                        //   }),
                        //   builder: (c, snapshot) {
                        //     return snapshot.hasData
                        //         ? Center(child: Text(dataMap!['addressID']))
                        //         : const Center(
                        //             child: CircularProgressIndicator(),
                        //           );
                        //   },
                        // )

                        ElevatedButton(
                          onPressed: () {
                            print('HERE $userLat, $userLng');
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (c) =>
                                    ParcelInProgressScreen(userLat, userLng),
                              ),
                            );
                          },
                          child: Text(
                            'Confirm Deliver Order',
                          ),
                        )
                      ],
                    ),
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  );
          }),
        ),
      ),
    );
  }
}
