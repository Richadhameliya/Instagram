import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:instagram_app/controller/bottombar_controller.dart';
import 'package:instagram_app/controller/home_controller.dart';
import '../home/insta_home.dart';
import '../profile/profile_screen.dart';
import '../reels/rells_screen.dart';
import '../search/search_screen.dart';

class BottomNavBar extends StatefulWidget {
  BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

final HomeController controller = Get.put(HomeController());
final BottombarController bottombarController = Get.put(BottombarController());

class _BottomNavBarState extends State<BottomNavBar> {
  List<Widget> screenname = [
    HomePage(),
    InstaSearchScreen(),
    Container(),
    RellsScreenInsta(),
    ProfileScreen(),
  ];

  int selectedScreen = 0;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.black,
        selectedIconTheme: const IconThemeData(
          color: Colors.black,
        ),
        elevation: 2,
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.grey,
        currentIndex: selectedScreen,
        items: [
          const BottomNavigationBarItem(
              icon: Icon(Icons.home_filled, size: 30), label: ""),
          const BottomNavigationBarItem(
              icon: Icon(Icons.search, size: 30), label: ""),
          const BottomNavigationBarItem(
              icon: Icon(Icons.add_box_outlined, size: 30), label: ""),
          const BottomNavigationBarItem(
              icon: Icon(Icons.smart_display_outlined, size: 30), label: ""),
          BottomNavigationBarItem(
            icon: CircleAvatar(
              radius: height * 0.02,
              backgroundColor: Colors.grey,
              child: CachedNetworkImage(
                imageUrl: controller.userProfileImageUrl.value.isNotEmpty
                    ? controller.userProfileImageUrl.value
                    : 'https://via.placeholder.com/150',
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            label: "",
          ),
        ],
        onTap: (value) {
          if (value == 2) {
            // Open gallery to select an image or video
            bottombarController.pickMedia();
          } else {
            // Update selected screen for other tabs
            setState(() {
              selectedScreen = value;
            });
          }
        },
      ),
      body: screenname[selectedScreen],
    );
  }
}
