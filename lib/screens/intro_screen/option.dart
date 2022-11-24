import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wol_pro_1/constants.dart';
import 'package:wol_pro_1/widgets/wrapper.dart';
import '../../widgets/loading.dart';


var optionRefugee=true;
List categoriesVolunteer = [];
class OptionChoose extends StatefulWidget {
  const OptionChoose({Key? key}) : super(key: key);


  @override
  State<OptionChoose> createState() => _OptionChooseState();
}


class _OptionChooseState extends State<OptionChoose> {

  bool selected = true;
  Timer? timer;
  double levelOpacity = 0.9;
  late FirebaseMessaging messaging;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(const Duration(seconds: 2),(timer){
      setState(() {
        selected = !selected;
        levelOpacity = 0.3;
      });
    });
    messaging = FirebaseMessaging.instance;
    messaging.getToken().then((value){
      print(value);
    });}

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: blueColor,
      body: Stack(
        children: [
          // Align(
          //   alignment: Alignment.center,
          //   child: Padding(
          //     padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.35),
          //     child: Padding(
          //       padding: const EdgeInsets.symmetric(horizontal: 30),
          //               child: SvgPicture.asset('assets/logo.svg')
          //     ),
          //   ),
          // ),

          Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.25),
            child: Align(
              alignment: Alignment.topCenter,
              child: Text("Helpmate ",
                style: GoogleFonts.sairaStencilOne(
                  fontSize: 50,
                  color: background,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.38),
            child: Align(
              alignment: Alignment.topCenter,
              child: Shimmer.fromColors(
                period: const Duration(seconds: 5),
                baseColor: Colors.white,
                highlightColor: blueColor,
                child: Text("Get ready now",
                style: GoogleFonts.raleway(
                  fontSize: 24,
                  color: blueColor,
                ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.7),
            child: Column(
              children: const [
                Center(
                  child: StartButton(buttonName: 'Refugee', optionRef: true,),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Center(
                    child: StartButton(buttonName: 'Volunteer', optionRef: false,)
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

    );
  }
}

class StartButton extends StatelessWidget {
  final String buttonName;
  final bool optionRef;
  const StartButton({
    Key? key, required this.buttonName, required this.optionRef
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.085,
        decoration: buttonDecoration,
        child: TextButton(
        child: Text(buttonName,
          style: textButtonStyle,
        ),
        onPressed: () async{
          optionRefugee=optionRef;
          Navigator.push(context, MaterialPageRoute(builder: (context) => Wrapper()));
        },
        ),
      ),
    );
  }
}
