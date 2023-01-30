import 'package:flutter/material.dart';
import 'package:foodpanda_riders_app/models/map_utils.dart';
import 'package:geolocator/geolocator.dart';

class ParcelInProgressScreen extends StatefulWidget {
  var userLat, userLng;
  ParcelInProgressScreen(this.userLat, this.userLng, {super.key});

  @override
  State<ParcelInProgressScreen> createState() => _ParcelInProgressScreenState();
}

class _ParcelInProgressScreenState extends State<ParcelInProgressScreen> {
  Position? position;

  getRiderLocation() async {
    getLocationPermission();
    Position newPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    setState(() {
      position = newPosition;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: Text(
              'Parcel In Progress',
            ),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/images/confirm1.png",
                width: 350,
              ),
              const SizedBox(
                height: 5,
              ),
              GestureDetector(
                onTap: () {},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/restaurant.png',
                      width: 50,
                    ),
                    const SizedBox(
                      width: 7,
                    ),
                    const Text(
                      'Show Cafe/Resturant_Location',
                      style: TextStyle(
                        fontFamily: 'Signatra',
                        fontSize: 18,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  getRiderLocation();
                  print(position);
                  MapUtils.launchMapFromSourceToDestination(position!.latitude,
                      position!.longitude, widget.userLat, widget.userLng);
                },
                child: Text('Order has been Picked-Confirmed'),
              ),
            ],
          )),
    );
  }

  getLocationPermission() async {
    LocationPermission permission;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        getLocationPermission();
      }
    }
  }
}
