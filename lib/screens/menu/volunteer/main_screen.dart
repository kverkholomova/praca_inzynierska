import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:wol_pro_1/screens/menu/volunteer/maps/map.dart';
import 'package:wol_pro_1/screens/menu/volunteer/all_applications/new_screen_with_applications.dart';
import '../../../constants.dart';
import 'home_page/home_vol.dart';
import 'messages/pageWithChatsVol.dart';
import 'my_applications/applications_vol.dart';

bool isVisibleTabBar = true;
PersistentTabController controllerTabBottomVol =
    PersistentTabController(initialIndex: 2);

class MainScreen extends StatefulWidget {
  MainScreen({Key? key}) : super(key: key);
  String id = "homepage";

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
        inactiveIcon: const Icon(
          Icons.message_rounded,
          size: 24,
        ),
        icon: const Padding(
          padding: EdgeInsets.only(bottom: 5),
          child: Icon(
            Icons.message_rounded,
            size: 28,
          ),
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
        inactiveIcon: const Icon(
          Icons.folder_special_rounded,
          size: 24,
        ),
        icon: const Padding(
          padding: EdgeInsets.only(bottom: 5),
          child: Icon(
            Icons.folder_special_rounded,
            size: 28,
          ),
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
            decoration: BoxDecoration(shape: BoxShape.circle, color: blueColor),
            child: Icon(
              Icons.home,
              size: 26,
              color: background,
            )),
        inactiveColorSecondary: background,
        activeColorSecondary: background,
        icon: Container(
            height: MediaQuery.of(context).size.height * 0.3,
            width: MediaQuery.of(context).size.width * 0.3,
            decoration: BoxDecoration(shape: BoxShape.circle, color: blueColor),
            child: const Icon(
              Icons.home,
              size: 30,
            )),

        activeColorPrimary: blueColor.withOpacity(1),
        inactiveColorPrimary: blueColor.withOpacity(0.7),
      ),
      PersistentBottomNavBarItem(
        inactiveIcon: const Icon(
          Icons.map,
          size: 24,
        ),
        icon: const Padding(
          padding: EdgeInsets.only(bottom: 5),
          child: Icon(
            Icons.map,
            size: 28,
          ),
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
        inactiveIcon: const Icon(
          Icons.note_alt_rounded,
          size: 24,
        ),
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
          backgroundColor: background,
          // Default is Colors.white.
          handleAndroidBackButtonPress: true,
          // Default is true.
          resizeToAvoidBottomInset: true,
          // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
          stateManagement: true,
          // Default is true.
          hideNavigationBarWhenKeyboardShows: true,
          // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
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
          itemAnimationProperties: const ItemAnimationProperties(
            // Navigation Bar's items animation properties.
            duration: Duration(milliseconds: 200),
            curve: Curves.ease,
          ),
          screenTransitionAnimation: const ScreenTransitionAnimation(
            // Screen transition animation on change of selected tab.
            animateTabTransition: true,
            curve: Curves.ease,
            duration: Duration(milliseconds: 200),
          ),
          navBarStyle: NavBarStyle
              .style17, // Choose the nav bar style with this property.
        )));
  }
}
