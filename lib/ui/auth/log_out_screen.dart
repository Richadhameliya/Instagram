import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:instagram_app/constant/app_string.dart';
import 'package:instagram_app/controller/log_out_controller.dart';
import '../main/save_post/saved_post.dart';
import 'login_screen.dart';

class LogOutScreen extends StatelessWidget {
  final LogOutController _authController = Get.put(LogOutController());
  GetStorage box = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: TextButton(
                onPressed: () async {
                  box.erase();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LogInScreen(),
                      ),
                      (route) => false);
                },
                child: Text(
                  AppString.logout,
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SavedPostsPage(),
                      ));
                },
                child: Text(
                  AppString.saved,
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
