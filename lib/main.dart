import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:instagram_app/profile_screen.dart';
import 'package:instagram_app/storyy.dart';
import 'auth/login_screen.dart';
import 'auth/register_screen.dart';
import 'bottom_bar.dart';
import 'controller/home_controller.dart';
import 'demo.dart';
import 'insta_home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await GetStorage.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  GetStorage box = GetStorage();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    var UId = box.read('uid');
    return GetMaterialApp(
      getPages: [
        GetPage(name: '/profile', page: () => ProfileScreen()),
        // Other routes...
      ],
      title: 'Instagram App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: UId == null ? LogInScreen() : BottomNavBar(),
      //home: StoriesScreen(),
      // home: RegistrationScreen(),
    );
  }
}
