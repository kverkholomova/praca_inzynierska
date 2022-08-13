import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wol_pro_1/screens/wrapper.dart';
import '../../shared/loading.dart';


var optionRefugee=true;

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

    timer = Timer.periodic(Duration(seconds: 2),(timer){
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
      body: Container(
        color: Color.fromRGBO(233, 242, 253, 8),
        child: Stack(
          children: [
            // Padding(
            //   padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.45),
            //   child: Padding(
            //     padding: const EdgeInsets.symmetric(horizontal: 20),
            //     child: SizedBox(
            //         width: double.infinity,
            //         child: SvgPicture.asset('assets/logo-02.svg')),
            //   ),
            // ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.35),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  // child:
                  // AnimatedOpacity(
                  //     opacity: levelOpacity,
                  //     duration: Duration(seconds: 2),
                  //     onEnd: (){
                  //       setState(() {
                  //         levelOpacity =0.9;
                  //       });
                  //     },
                  //     child: Shimmer.fromColors(
                  //             period: Duration(seconds: 5),
                  //             baseColor: Colors.black,
                  //             highlightColor: Colors.white,
                          child: SvgPicture.asset('assets/logo.svg')
                      // )
                  // ),

                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.4),
              child: Align(
                alignment: Alignment.topCenter,
                child: Shimmer.fromColors(
                  period: Duration(seconds: 5),
                  baseColor: Colors.black,
                  highlightColor: Color.fromRGBO(233, 242, 253, 8),
                  child: Text("Get ready now",
                  style: GoogleFonts.raleway(
                    fontSize: 25,
                    color: Colors.black,
                  ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.7),
              child: Column(
                children: [
                  Center(
                    child: StartButton(buttonName: 'Volunteer', optionRef: false,),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20),
                    child: Center(
                      child: StartButton(buttonName: 'Refugee', optionRef: true,)
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
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
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        height: 63,
        decoration: BoxDecoration(
            color: const Color.fromRGBO(2, 62, 99, 20),
          borderRadius: BorderRadius.circular(24)
        ),
        child: TextButton(

        child: Text(buttonName,
          style: GoogleFonts.raleway(
            fontSize: 23,
            color: Colors.white,
          ),
        ),
        onPressed: () async{

          optionRefugee=optionRef;
          Navigator.push(context, MaterialPageRoute(builder: (context) => const Wrapper()));
        },
        ),
      ),
    );
  }
}
