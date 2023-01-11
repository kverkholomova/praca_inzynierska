
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:wol_pro_1/screens/menu/refugee/all_applications/all_app_ref.dart';
import 'package:wol_pro_1/screens/menu/refugee/home_page/home_ref.dart';

import '../../../constants.dart';
import '../../intro_screen/option.dart';
import 'accepted_applications/accepted_applications.dart';
import 'home_page/create_application/create_application.dart';
import 'maps/map_ref.dart';
import 'messages/pageWithChatsRef.dart';

PersistentTabController controllerTabBottomRef = PersistentTabController(initialIndex: 2);

class MainScreenRefugee extends StatefulWidget {
  MainScreenRefugee({Key? key}) : super(key: key);
  String id = "homepage";
  @override
  State<MainScreenRefugee> createState() => _MainScreenRefugeeState();
}

class _MainScreenRefugeeState extends State<MainScreenRefugee> {

  // void _onItemTapped(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //   });
  // }

  List<Widget> _buildScreens() {
    return [
      ListofChatroomsRef(),
      CategoriesRef(),
      HomeRef(),
      const HomeMapRef(),
      AllApplicationsRef()
      // AllCategoriesRef(),
      // Text("Add application"),
      // const Categories(),

    ];
  }

  List<PersistentBottomNavBarItem> navBarsItemsRefugee() {
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
        activeColorPrimary: redColor,
        inactiveColorPrimary: redColor.withOpacity(0.7),
      ),
      PersistentBottomNavBarItem(
        inactiveIcon:  const Icon(Icons.folder_special_rounded, size: 24,),
        icon: const Padding(
          padding: EdgeInsets.only(bottom: 5),
          child: Icon(Icons.folder_special_rounded, size: 28,),
        ),
        title: ("Accepted"),
        textStyle: GoogleFonts.raleway(
          fontSize: 11,
          color: Colors.white,
        ),
        activeColorPrimary: redColor,
        inactiveColorPrimary: redColor.withOpacity(0.7),
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
        activeColorPrimary: redColor.withOpacity(1),
        inactiveColorPrimary: backgroundRefugee,
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
        activeColorPrimary: redColor,
        inactiveColorPrimary: redColor.withOpacity(0.7),
      ),
      PersistentBottomNavBarItem(
        inactiveIcon: const Icon(Icons.note_alt_rounded, size: 24,),
        icon: const Padding(
          padding: EdgeInsets.only(bottom: 5),
          child: Icon(Icons.note_alt_rounded, size: 28,),
        ),
        title: ("Applications"),
        textStyle: GoogleFonts.raleway(
          fontSize: 11,
          color: Colors.white,
        ),
        activeColorPrimary: redColor,
        inactiveColorPrimary: redColor.withOpacity(0.7),
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
  void initState() {
    // TODO: implement initState
    super.initState();
    // foregroundMessage();
  }

  // void foregroundMessage(){
  //   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  //
  //     print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAALLLLLLLLLLLLLLLLLLLLL");
  //     print(message.sentTime);
  //   });
  //   // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //   //   print('Got a message whilst in the foreground!');
  //   //   print('Message data: ${message.data}');
  //   //
  //   //   if (message.notification != null) {
  //   //     print('Message also contained a notification: ${message.notification}');
  //   //   }
  //   // });
  //
  // }
  @override
  Widget build(BuildContext context) {
    print("Refugee");
    print(FirebaseAuth.instance.currentUser?.uid);
    return WillPopScope(
        onWillPop: () async {
          SystemNavigator.pop();
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => const OptionChoose()),
          // );
          return true;
        },
        child: SafeArea(
            child: PersistentTabView(
              context,
              controller: controllerTabBottomRef,
              screens: _buildScreens(),
              items: navBarsItemsRefugee(),
              confineInSafeArea: true,
              backgroundColor: backgroundRefugee, // Default is Colors.white.
              handleAndroidBackButtonPress: true, // Default is true.
              resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
              stateManagement: true, // Default is true.
              hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
              decoration: NavBarDecoration(
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    blurRadius: 2,
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
              navBarStyle: NavBarStyle.style17, // Choose the nav bar style with this property.
            )));
  }
}


