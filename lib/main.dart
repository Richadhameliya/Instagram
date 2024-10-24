import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:instagram_app/ui/main/bottombar/bottom_bar.dart';
import 'package:instagram_app/ui/main/profile/profile_screen.dart';
import 'ui/auth/login_screen.dart';

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
