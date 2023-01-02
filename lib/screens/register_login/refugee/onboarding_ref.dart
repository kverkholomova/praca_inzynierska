
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:wol_pro_1/constants.dart';
import 'package:wol_pro_1/screens/menu/refugee/main_screen_ref.dart';

import '../../menu/volunteer/main_screen.dart';


class OnBoardingRefugee extends StatefulWidget {
  const OnBoardingRefugee({Key? key}) : super(key: key);

  @override
  State<OnBoardingRefugee> createState() => _OnBoardingRefugeeState();
}

class _OnBoardingRefugeeState extends State<OnBoardingRefugee> {

  final controllerPageView = PageController();


  @override
  void dispose(){
    controllerPageView.dispose();

    super.dispose();
  }

  bool isLastPage = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.1),
        child: PageView(
          controller: controllerPageView,
          onPageChanged: (index){
            setState(() {
              isLastPage = index == 2;
            });
          },
          children: [
            buildPage(
              color: Colors.white,
              buildSizedBox: false,
              image: "assets/onboarding/5.jpg",
              title: "Add your application",
              subtitle: "This app can help you to get an assistance that you need.",
              gap: MediaQuery.of(context).size.height * 0.05,
            ),
            buildPage(
              buildSizedBox: true,
              color:  Colors.white,
              image: "assets/onboarding/6.jpg",
              title: "Contact to volunteer",
              subtitle: "You can contact with volunteers right in this app to give them more information about your application.",
              gap: MediaQuery.of(context).size.height * 0.05,
            ),
            buildPage(
              buildSizedBox: false,
              color: Colors.white,
              image: "assets/onboarding/7.jpg",
              title: "Give feedback of volunteer's assistance",
              subtitle: "After every assistance you can rate the volunteer to let other users know more about them.",
              gap: MediaQuery.of(context).size.height * 0.06,
            ),
          ],
        ),
      ),
      bottomSheet: isLastPage
          ? Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.1,
        color: redColor,
        child: TextButton(

          child: Text("Get started",
            style: GoogleFonts.raleway(
              fontSize: 20,
              color: Colors.white,

            ),
            textAlign: TextAlign.center,
          ),
          onPressed: (){
            setState(() {
              controllerTabBottomVol = PersistentTabController(initialIndex: 2);
            });
            Navigator.of(context, rootNavigator: true).pushReplacement(
                MaterialPageRoute(builder: (context) => new MainScreenRefugee()));
          },
        ),
      )
          :Container(
        padding: padding,
        height: MediaQuery.of(context).size.height * 0.1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(onPressed: (){
              controllerPageView.jumpToPage(2);
            }, child: Text("Skip", style: textInactiveButtonStyleRefugee,)),
            Center(
              child: SmoothPageIndicator(
                controller: controllerPageView,
                count: 3,
                effect: WormEffect(
                    spacing: 16,
                    dotColor: background,
                    activeDotColor: redColor
                ),
                onDotClicked: (index){
                  controllerPageView.animateToPage(
                      index,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeInOut);
                },
              ),
            ),
            TextButton(onPressed: (){
              controllerPageView.nextPage(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeInOut);
            }, child: Text("Next", style: textInactiveButtonStyleRefugee,)),
          ],
        ),
      ),
    );
  }

}

class buildPage extends StatelessWidget {
  Color color;
  String image;
  String title;
  String subtitle;
  double gap;
  bool buildSizedBox;
  buildPage({
    Key? key, required this.color, required this.image, required this.title, required this.subtitle, required this.gap, required this.buildSizedBox
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: Padding(
        padding: padding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildSizedBox?
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.07,
            ):SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Image.asset(image,
              fit: BoxFit.cover,
              width: double.infinity,),
            SizedBox(
              height: gap,
            ),
            Text(title, style: GoogleFonts.raleway(
              fontSize: 20,
              color: Colors.black,
            ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Align(
              alignment: Alignment.center,
              child: Text(subtitle, style: GoogleFonts.raleway(
                fontSize: 15,
                color: Colors.black,
              ),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}