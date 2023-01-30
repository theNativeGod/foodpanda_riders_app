import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import './global/global.dart';

import './screens/splash_screen/splash_screen.dart';
import 'models/orders.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();
  await Firebase.initializeApp();
  return runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => Orders(),
      child: MaterialApp(
        title: 'FoodPanda Riders',
        theme: ThemeData(primarySwatch: Colors.red),
        home: const SplashScreen(),
      ),
    );
  }
}
