import 'dart:async';
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:wol_pro_1/constants.dart';

import '../../../widgets/wrapper.dart';
import '../../intro_screen/option.dart';
import '../../register_login/volunteer/login/sign_in_volunteer.dart';
import 'main_screen_ref.dart';

class WelcomeScreenRefugee extends StatefulWidget {
  const WelcomeScreenRefugee({Key? key}) : super(key: key);

  @override
  State<WelcomeScreenRefugee> createState() => _WelcomeScreenRefugeeState();
}

class _WelcomeScreenRefugeeState extends State<WelcomeScreenRefugee> {
  final controllerPageView = PageController();

  loadImageRef() async {
    DocumentSnapshot variable = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    //a list of images names (i need only one)
    var img_urlRef = variable['image'];
    //select the image url
    Reference ref = FirebaseStorage.instance
        .ref()
        .child("user_pictures/")
        .child(img_urlRef);

    //get image url from firebase storage
    var urlRef = await ref.getDownloadURL();

    // put the URL in the state, so that the UI gets rerendered
    setState(() {
      urlImageRefugee = urlRef;
    });
  }

  bool _isLoading = true;
  late StreamSubscription<User?> user;

  @override
  void initState() {
    super.initState();
    // foregroundMessage();
    if (justSignedIn) {}
    user = FirebaseAuth.instance.authStateChanges().listen((user) async {
      loadImageRef();
      DocumentSnapshot variable = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      var currentRole = variable['role'];

      categoriesVolunteer = [];
      var cList = variable["category"];
      cList.forEach((element) {
        categoriesVolunteer.add(element);
      });
    });
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    controllerPageView.dispose();

    super.dispose();
  }

  bool isLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BuildPageRef(
        color: Colors.white,
        image: "assets/onboarding/8.jpg",
        title: "Get help wherever you need",
        subtitle:
            "This app can help you to ask for an assistance at any time. Enjoy this app and don't worry.",
      ),
      bottomSheet: Padding(
        padding: padding,
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.09,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Center(
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.085,
                decoration: buttonActiveDecorationRefugee,
                child: TextButton(
                    child: Text(
                      "Get started",
                      style: textActiveButtonStyleRefugee,
                    ),
                    onPressed: () {
                      setState(() {
                        controllerTabBottomRef =
                            PersistentTabController(initialIndex: 2);
                      });
                      Future.delayed(const Duration(milliseconds: 500), () {
                        Navigator.of(context, rootNavigator: true)
                            .pushReplacement(MaterialPageRoute(
                                builder: (context) => MainScreenRefugee()));
                      });
                    }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BuildPageRef extends StatelessWidget {
  Color color;
  String image;
  String title;
  String subtitle;

  BuildPageRef(
      {Key? key,
      required this.color,
      required this.image,
      required this.title,
      required this.subtitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: color,
        child: Padding(
          padding: padding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                image,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Text(
                title,
                style: GoogleFonts.raleway(
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Align(
                alignment: Alignment.center,
                child: Text(
                  subtitle,
                  style: GoogleFonts.raleway(
                    fontSize: 16,
                    color: blueColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
