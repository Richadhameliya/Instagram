import 'package:flutter/material.dart';
import 'package:instagram_app/profile_screen.dart';
import 'package:instagram_app/search_screen.dart';

import 'add_post_screen.dart';
import 'insta_home.dart';
import 'rells_screen.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  List screenname = [
    HomePage(),
    InstaSearchScreen(),
    AddPostScreen(),
    RellsScreenInsta(),
    ProfileScreen(),
  ];
  int selectedScreen = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        // backgroundColor: Colors.black,
        selectedItemColor: Colors.black,
        selectedIconTheme: const IconThemeData(
          color: Colors.black,
        ),
        elevation: 2,
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.grey,
        currentIndex: selectedScreen,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home_filled,
                // color: Color(0xffFF897E),
                size: 30,
              ),
              label: ""),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                size: 30,
              ),
              label: ""),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.add_box_outlined,
                size: 30,
              ),
              label: ""),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.smart_display_outlined,
                size: 30,
              ),
              label: ""),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person_2_outlined,
                size: 30,
              ),
              label: ""),
        ],
        onTap: (value) {
          selectedScreen = value;
          setState(() {});
        },
      ),
      body: screenname[selectedScreen],
    );
  }
}
