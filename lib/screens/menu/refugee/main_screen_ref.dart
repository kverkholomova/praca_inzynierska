import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:wol_pro_1/screens/menu/refugee/create_application/create_application.dart';
import 'package:wol_pro_1/screens/menu/refugee/home_page/home_ref.dart';

import '../../../constants.dart';
import '../../intro_screen/option.dart';
import 'maps/map_ref.dart';
import 'messages/pageWithChatsRef.dart';
import 'my_applications/all_applications.dart';

PersistentTabController controllerTabBottomRef = PersistentTabController(initialIndex: 2);

class MainScreenRefugee extends StatefulWidget {
  MainScreenRefugee({Key? key}) : super(key: key);
  String id = "homepage";
  @override
  State<MainScreenRefugee> createState() => _MainScreenRefugeeState();
}

class _MainScreenRefugeeState extends State<MainScreenRefugee> {

  int _selectedIndex = 2;


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> _buildScreens() {
    return [
      ListofChatroomsRef(),
      Application(),
      HomeRef(),
      const HomeMapRef(),
      CategoriesRef(),
      // Text("Add application"),
      // const Categories(),

    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        inactiveIcon: const Icon(Icons.message_rounded,size: 24,),
        icon: const Padding(
          padding: EdgeInsets.only(bottom: 5),
          child: Icon(Icons.message_rounded,size: 28,),
        ),
        title: ("Messages"),
        textStyle: GoogleFonts.raleway(
          fontSize: 11,
          color: Colors.white,
        ),
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.white.withOpacity(0.5),
      ),
      PersistentBottomNavBarItem(
        inactiveIcon:  const Icon(Icons.note_add_rounded, size: 24,),
        icon: const Padding(
          padding: EdgeInsets.only(bottom: 5),
          child: Icon(Icons.note_add_rounded, size: 28,),
        ),
        title: ("Add"),
        textStyle: GoogleFonts.raleway(
          fontSize: 11,
          color: Colors.white,
        ),
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.white.withOpacity(0.5),
      ),

      PersistentBottomNavBarItem(
        inactiveIcon: const Icon(Icons.home, size: 24,),
        activeColorSecondary: Colors.white,
        icon: const Icon(Icons.home, size: 30,),
        title: ("Home"),
        textStyle: GoogleFonts.raleway(
          fontSize: 11,
          color: Colors.white,
        ),
        activeColorPrimary: blueColor.withOpacity(1),
        inactiveColorPrimary: Colors.white.withOpacity(0.5),
      ),
      PersistentBottomNavBarItem(
        inactiveIcon:  const Icon(Icons.map, size: 24,),
        icon: const Padding(
          padding: EdgeInsets.only(bottom: 5),
          child: Icon(Icons.map, size: 28,),
        ),
        title: ("Map"),
        textStyle: GoogleFonts.raleway(
          fontSize: 11,
          color: Colors.white,
        ),
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.white.withOpacity(0.5),
      ),
      PersistentBottomNavBarItem(
        inactiveIcon: const Icon(Icons.folder_special_rounded, size: 24,),
        icon: const Padding(
          padding: EdgeInsets.only(bottom: 5),
          child: Icon(Icons.folder_special_rounded, size: 28,),
        ),
        title: ("Applications"),
        textStyle: GoogleFonts.raleway(
          fontSize: 11,
          color: Colors.white,
        ),
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.white.withOpacity(0.5),
      ),
      // PersistentBottomNavBarItem(
      //   inactiveIcon: const Icon(Icons.note_add_rounded, size: 24,),
      //   icon: const Padding(
      //     padding: EdgeInsets.only(bottom: 5),
      //     child: Icon(Icons.note_add_rounded, size: 28),
      //   ),
      //   title: ("Add app"),
      //   textStyle: GoogleFonts.raleway(
      //     fontSize: 11,
      //     color: Colors.white,
      //   ),
      //   activeColorPrimary: Colors.white,
      //   inactiveColorPrimary: Colors.white.withOpacity(0.5),
      // ),
    ];
  }
  // static const List<Widget> _widgetOptions = <Widget>[
  //   SettingsHomeVol(),
  //   Text(
  //     'Index 1: Business',
  //   ),
  //   Text(
  //     'Index 2: School',
  //   ),
  //   Text(
  //     'Index 2: School',
  //   ),
  //   Text(
  //     'Index 2: School',
  //   ),
  // ];

  @override
  Widget build(BuildContext context) {
    print("Refugee");
    print(FirebaseAuth.instance.currentUser?.uid);
    return WillPopScope(
        onWillPop: () async {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const OptionChoose()),
          );
          return true;
        },
        child: SafeArea(
            child: PersistentTabView(
              context,
              controller: controllerTabBottomRef,
              screens: _buildScreens(),
              items: _navBarsItems(),
              confineInSafeArea: true,
              backgroundColor: blueColor, // Default is Colors.white.
              handleAndroidBackButtonPress: true, // Default is true.
              resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
              stateManagement: true, // Default is true.
              hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
              decoration: NavBarDecoration(
                boxShadow: <BoxShadow>[
                  const BoxShadow(
                    color: Colors.black,
                    blurRadius: 5,
                  ),
                ],
                borderRadius: BorderRadius.circular(0),
                colorBehindNavBar: Colors.white,
              ),
              popAllScreensOnTapOfSelectedTab: true,
              popActionScreens: PopActionScreensType.all,
              itemAnimationProperties: const ItemAnimationProperties( // Navigation Bar's items animation properties.
                duration: Duration(milliseconds: 200),
                curve: Curves.ease,
              ),
              screenTransitionAnimation: const ScreenTransitionAnimation( // Screen transition animation on change of selected tab.
                animateTabTransition: true,
                curve: Curves.ease,
                duration: Duration(milliseconds: 200),
              ),
              navBarStyle: NavBarStyle.style15, // Choose the nav bar style with this property.
            )));
  }
}


