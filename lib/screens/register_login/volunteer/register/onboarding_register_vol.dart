

import 'dart:core';

import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:wol_pro_1/constants.dart';

class OnBoardingVolunteerReg extends StatefulWidget {
  const OnBoardingVolunteerReg({Key? key}) : super(key: key);

  @override
  State<OnBoardingVolunteerReg> createState() => _OnBoardingVolunteerRegState();
}

class _OnBoardingVolunteerRegState extends State<OnBoardingVolunteerReg> {

  final controllerPageView = PageController();

  @override
  void dispose(){
    controllerPageView.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.1),
        child: PageView(
          controller: controllerPageView,
          children: [
            buildPage(
              color: Color(0xffef8f88),
            image: "assets/onboarding/1.jpg",
              title: "Page1",
              subtitle: "Page1 Annotation",
            ),
            buildPage(
              color:  Color(0xffd6e2ef),
              image: "assets/onboarding/2.jpg",
              title: "Page2",
              subtitle: "Page2 Annotation",
            ),
            buildPage(
              color: Color(0xff83bfca),
              image: "assets/onboarding/3.jpg",
              title: "Page3",
              subtitle: "Page3 Annotation",
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: padding,
        height: MediaQuery.of(context).size.height * 0.1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(onPressed: (){
              controllerPageView.jumpToPage(2);
            }, child: Text("Skip", style: textInactiveButtonStyle,)),
            Center(
              child: SmoothPageIndicator(
                controller: controllerPageView,
                count: 3,
                effect: WormEffect(
                  spacing: 16,
                  dotColor: background,
                  activeDotColor: blueColor
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
            }, child: Text("Next", style: textInactiveButtonStyle,)),
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
  buildPage({
    Key? key, required this.color, required this.image, required this.title, required this.subtitle
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(image,
          fit: BoxFit.cover,
            width: double.infinity,),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          Text(title, style: textInactiveButtonStyle,),
          Text(subtitle, style: textInactiveButtonStyle,)
        ],
      ),
    );
  }
}
