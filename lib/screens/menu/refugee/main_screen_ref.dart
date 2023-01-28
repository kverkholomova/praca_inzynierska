import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:wol_pro_1/screens/menu/refugee/all_applications/all_app_ref.dart';
import 'package:wol_pro_1/screens/menu/refugee/home_page/home_ref.dart';

import '../../../constants.dart';
import 'accepted_applications/accepted_applications.dart';
import 'maps/map_ref.dart';
import 'messages/pageWithChatsRef.dart';

PersistentTabController controllerTabBottomRef =
    PersistentTabController(initialIndex: 2);

class MainScreenRefugee extends StatefulWidget {
  MainScreenRefugee({Key? key}) : super(key: key);
  String id = "homepage";

  @override
  State<MainScreenRefugee> createState() => _MainScreenRefugeeState();
}

class _MainScreenRefugeeState extends State<MainScreenRefugee> {
  List<Widget> _buildScreens() {
    return [
      const ListofChatroomsRef(),
      const CategoriesRef(),
      const HomeRef(),
      const HomeMapRef(),
      const AllApplicationsRef()
    ];
  }

  List<PersistentBottomNavBarItem> navBarsItemsRefugee() {
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
          color: Colors.white,
        ),
        activeColorPrimary: redColor,
        inactiveColorPrimary: redColor.withOpacity(0.7),
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
          color: Colors.white,
        ),
        activeColorPrimary: redColor,
        inactiveColorPrimary: redColor.withOpacity(0.7),
      ),
      PersistentBottomNavBarItem(
        inactiveIcon: const Icon(
          Icons.home,
          size: 24,
        ),
        activeColorSecondary: Colors.white,
        icon: const Icon(
          Icons.home,
          size: 30,
        ),
        title: ("Home"),
        textStyle: GoogleFonts.raleway(
          fontSize: 11,
          color: Colors.white,
        ),
        activeColorPrimary: redColor.withOpacity(1),
        inactiveColorPrimary: backgroundRefugee,
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
        activeColorPrimary: redColor,
        inactiveColorPrimary: redColor.withOpacity(0.7),
      ),
      PersistentBottomNavBarItem(
        inactiveIcon: const Icon(
          Icons.note_alt_rounded,
          size: 24,
        ),
        icon: const Padding(
          padding: EdgeInsets.only(bottom: 5),
          child: Icon(
            Icons.note_alt_rounded,
            size: 28,
          ),
        ),
        title: ("Applications"),
        textStyle: GoogleFonts.raleway(
          fontSize: 11,
          color: Colors.white,
        ),
        activeColorPrimary: redColor,
        inactiveColorPrimary: redColor.withOpacity(0.7),
      ),
    ];
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // foregroundMessage();
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
          controller: controllerTabBottomRef,
          screens: _buildScreens(),
          items: navBarsItemsRefugee(),
          confineInSafeArea: true,
          backgroundColor: backgroundRefugee,
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
