import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:wol_pro_1/screens/menu/volunteer/maps/map.dart';
import 'package:wol_pro_1/screens/menu/volunteer/all_applications/new_screen_with_applications.dart';
import '../../../constants.dart';
import '../../intro_screen/option.dart';
import 'home_page/home_vol.dart';
import 'messages/pageWithChatsVol.dart';
import 'my_applications/applications_vol.dart';

bool isVisibleTabBar = true;
PersistentTabController controllerTabBottomVol = PersistentTabController(initialIndex: 2);

class MainScreen extends StatefulWidget {
  MainScreen({Key? key}) : super(key: key);
  String id = "homepage";
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {


  void foregroundMessage(){
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    foregroundMessage();
    print("FFFFFFFFFFFFFFFFFFFFFFFFFFFFFTTTTTTTTTT");
    print(categoriesVolunteer);

  }
  int _selectedIndex = 2;


  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> _buildScreens() {
    return [
      const ListofChatroomsVol(),
      const ApplicationsOfVolunteer(),
      const HomeVol(),
      const HomeMap(),
      const Categories(),

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
          color: blueColor,
        ),
        activeColorPrimary: blueColor,
        inactiveColorPrimary: blueColor.withOpacity(0.7),
      ),
      PersistentBottomNavBarItem(
        inactiveIcon: const Icon(Icons.folder_special_rounded, size: 24,),
        icon: const Padding(
          padding: EdgeInsets.only(bottom: 5),
          child: Icon(Icons.folder_special_rounded, size: 28,),
        ),
        title: ("Accepted"),
        textStyle: GoogleFonts.raleway(
          fontSize: 11,
          color: blueColor,
        ),
        activeColorPrimary: blueColor,
        inactiveColorPrimary: blueColor.withOpacity(0.7),
      ),
      PersistentBottomNavBarItem(
        // contentPadding: 1.0,
        inactiveIcon: Container(
          height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width * 0.3,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: blueColor
            ),
            child: Icon(Icons.home, size: 26, color: background,)),
        inactiveColorSecondary: background,
        activeColorSecondary: background,
        icon: Container(
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width * 0.3,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: blueColor
            ),child: Icon(Icons.home, size: 30,)),
        // title: ("Home"),
        // textStyle: GoogleFonts.raleway(
        //   fontSize: 11,
        //   color: blueColor,
        // ),
        activeColorPrimary: blueColor.withOpacity(1),
        inactiveColorPrimary: blueColor.withOpacity(0.7),
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
        activeColorPrimary: blueColor,
        inactiveColorPrimary: blueColor.withOpacity(0.7),
      ),
      PersistentBottomNavBarItem(
        inactiveIcon: const Icon(Icons.note_alt_rounded, size: 24,),
        icon: const Padding(
          padding: EdgeInsets.only(bottom: 5),
          child: Icon(Icons.note_alt_rounded, size: 28),
        ),
        title: ("Applications"),
        textStyle: GoogleFonts.raleway(
          fontSize: 11,
          color: Colors.white,
        ),
        activeColorPrimary: blueColor,
        inactiveColorPrimary: blueColor.withOpacity(0.7),
      ),
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
    return WillPopScope(
        onWillPop: () async {
          SystemNavigator.pop();
          return true;
        },
        child: SafeArea(
            child: PersistentTabView(
        context,
        // hideNavigationBar: !isVisibleTabBar,
        controller: controllerTabBottomVol,
        screens: _buildScreens(),
        items: _navBarsItems(),
        confineInSafeArea: true,
        backgroundColor: background, // Default is Colors.white.
        handleAndroidBackButtonPress: true, // Default is true.
        resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
        stateManagement: true, // Default is true.
        hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
        decoration: NavBarDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 2,
              //5
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


// import 'dart:math';
//
// import 'package:flutter/material.dart';
// import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
// import 'package:wol_pro_1/volunteer/home/home_vol.dart';
//
// import '../constants.dart';
// import 'intro_screen/option.dart';
//
// class MainScreen extends StatefulWidget {
//   const MainScreen({Key? key}) : super(key: key);
//
//   @override
//   State<MainScreen> createState() => _MainScreenState();
// }
//
// class _MainScreenState extends State<MainScreen> {
//   int _selectedIndex = 2;
//   PersistentTabController controllerTabBottom = PersistentTabController(initialIndex: 2);
//
//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }
//
//   static const List<Widget> _widgetOptions = <Widget>[
//     SettingsHomeVol(),
//     Text(
//       'Index 1: Business',
//     ),
//     Text(
//       'Index 2: School',
//     ),
//     Text(
//       'Index 2: School',
//     ),
//     Text(
//       'Index 2: School',
//     ),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//         onWillPop: () async {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => const OptionChoose()),
//           );
//           return true;
//         },
//         child: SafeArea(
//             child: Scaffold(
//           resizeToAvoidBottomInset: true,
//           backgroundColor: const Color.fromRGBO(233, 242, 253, 8),
//           body: _widgetOptions.elementAt(_selectedIndex),
//           bottomNavigationBar: BottomNavigationBar(
//
//             backgroundColor: blueColor,
//             items: <BottomNavigationBarItem>[
//               BottomNavigationBarItem(
//                 icon: Icon(
//                   Icons.message_rounded,
//                   color: Colors.white,
//                   size: 30,
//                 ),
//                 label: 'Messages',
//                   backgroundColor: blueColor
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(
//                   Icons.folder_special_rounded,
//                   color: Colors.white,
//                   size: 30,
//                 ),
//                 label: 'Accepted',
//                 backgroundColor: blueColor
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(
//                   Icons.home,
//                   color: Colors.white,
//                   size: 30,
//                 ),
//                 label: 'Home',
//                   backgroundColor: blueColor
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(
//                   Icons.map,
//                   color: Colors.white,
//                   size: 30,
//                 ),
//                 label: 'Map',
//                   backgroundColor: blueColor
//               ),
//               BottomNavigationBarItem(
//                 icon: Icon(
//                   Icons.note_alt_rounded,
//                   color: Colors.white,
//                   size: 30,
//                 ),
//                 label: 'Applications',
//                   backgroundColor: blueColor
//               ),
//             ],
//             currentIndex: _selectedIndex,
//             selectedItemColor: Colors.white,
//             // selectedFontSize: 12,
//             selectedLabelStyle: GoogleFonts.raleway(
//               fontSize: 12,
//               color: Colors.white,
//             ),
//             showUnselectedLabels: false,
//
//             onTap: _onItemTapped,
//           ),
//         )));
//   }
// }
