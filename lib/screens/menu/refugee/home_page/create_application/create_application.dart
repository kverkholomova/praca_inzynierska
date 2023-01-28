import 'dart:async';

import 'package:cool_dropdown/cool_dropdown.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:wol_pro_1/constants.dart';

import '../../../../../models/categories.dart';
import '../../main_screen_ref.dart';

String tokenRefApplication = '';
var count = 0;

String status = "Sent to volunteer";
String volID = "";
int numChart = 0;

class Application extends StatefulWidget {
  const Application({Key? key}) : super(key: key);

  @override
  State<Application> createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  var id;
  var ID;
  String title = '';
  String currentCategory = '';
  String comment = '';

  final height = 100;

  String valueChosen = dropdownItemList[3]["value"];
  late StreamSubscription<User?> user;
  String? userNameRefugee;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    user = FirebaseAuth.instance.authStateChanges().listen((user) async {
      DocumentSnapshot variable = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();

      userNameRefugee = variable['user_name'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        currentCategory = '';
        title = '';
        comment = '';
        numChart = 0;
        controllerTabBottomRef = PersistentTabController(initialIndex: 2);
        Navigator.of(context, rootNavigator: true).pushReplacement(
            MaterialPageRoute(builder: (context) => MainScreenRefugee()));
        return true;
      },
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        floatingActionButton: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 30,
            color: redColor,
          ),
          onPressed: () {
            currentCategory = '';
            title = '';
            comment = '';
            numChart = 0;
            controllerTabBottomRef = PersistentTabController(initialIndex: 2);
            Navigator.of(context, rootNavigator: true).pushReplacement(
                MaterialPageRoute(builder: (context) => MainScreenRefugee()));
          },
        ),
        backgroundColor: backgroundRefugee,
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: padding,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height * 0.08,
                    top: MediaQuery.of(context).size.height * 0.02),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    "Add new application",
                    style: GoogleFonts.raleway(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height * 0.005,
                  ),
                  child: Text(
                    "What the title of your application?",
                    style: textLabelSeparated,
                  ),
                ),
              ),
              TextFormField(
                decoration: InputDecoration(
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: borderRadiusApplication,
                    borderSide: const BorderSide(
                      color: Colors.red,
                      width: 1.5,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: borderRadiusApplication,
                    borderSide: const BorderSide(
                      color: Colors.red,
                      width: 1.5,
                    ),
                  ),
                  errorStyle: const TextStyle(color: Colors.red),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: borderRadiusApplication,
                    borderSide: BorderSide(
                      color: Colors.black.withOpacity(0.7),
                      // color: Color.fromRGBO(2, 62, 99, 20),
                      width: 1.5,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: borderRadiusApplication,
                    borderSide: const BorderSide(
                      color: Colors.white,
                      width: 0,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (val) => val!.isEmpty ? 'Enter the title' : null,
                onChanged: (val) {
                  setState(() => title = val);
                },
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height * 0.005,
                  ),
                  child: Text(
                    "Choose category that refers to your application",
                    style: textLabelSeparated,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: CoolDropdown(
                  resultMainAxis: MainAxisAlignment.start,
                  unselectedItemTS:
                      const TextStyle(color: Colors.black, fontSize: 14),
                  dropdownItemPadding:
                      const EdgeInsets.symmetric(horizontal: 20),
                  isTriangle: false,
                  gap: -30,
                  dropdownItemReverse: true,
                  dropdownItemMainAxis: MainAxisAlignment.start,
                  resultHeight: MediaQuery.of(context).size.height * 0.09,
                  resultBD: BoxDecoration(
                      color: backgroundRefugee,
                      borderRadius: borderRadiusApplication,
                      border: Border.all(width: 0.5, color: redColor)),
                  resultTS: TextStyle(color: redColor, fontSize: 14),
                  placeholderTS:
                      TextStyle(color: backgroundRefugee, fontSize: 14),
                  selectedItemTS: TextStyle(color: redColor, fontSize: 14),
                  selectedItemBD: BoxDecoration(color: backgroundRefugee),
                  dropdownBD: BoxDecoration(
                    color: Colors.white,
                    borderRadius: borderRadiusApplication,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  resultWidth: double.infinity,
                  dropdownWidth: MediaQuery.of(context).size.width * 0.8,
                  dropdownList: dropdownItemList,
                  onChange: (newVal) {
                    setState(() {
                      valueChosen = newVal["value"];
                      currentCategory = valueChosen;
                    });
                    // valueIcon = newVal["icon"].toString();
                  },
                  defaultValue: dropdownItemList[3],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height * 0.005,
                  ),
                  child: Text(
                    "Add description to your application \n(min 30 signs) $numChart/30",
                    style: textLabelSeparated,
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Colors.white, borderRadius: borderRadiusApplication),
                child: TextFormField(
                  maxLines: height ~/ 15,
                  decoration: InputDecoration(
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: borderRadiusApplication,
                      borderSide: const BorderSide(
                        color: Colors.red,
                        width: 1.5,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: borderRadiusApplication,
                      borderSide: const BorderSide(
                        color: Colors.red,
                        width: 1.5,
                      ),
                    ),
                    errorStyle: const TextStyle(color: Colors.red),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: borderRadiusApplication,
                      borderSide: BorderSide(
                        color: Colors.black.withOpacity(0.7),
                        // color: Color.fromRGBO(2, 62, 99, 20),
                        width: 1.5,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: borderRadiusApplication,
                      borderSide: const BorderSide(
                        color: Colors.white,
                        width: 0,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (val) => val!.isEmpty ? 'Enter the comment' : null,
                  onChanged: (val) {
                    setState(() {
                      numChart = val.length;
                      comment = val;
                    });
                  },
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Center(
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.085,
                    decoration: buttonActiveDecorationRefugee,
                    child: TextButton(
                        child: Text(
                          "Add new application",
                          style: textActiveButtonStyleRefugee,
                        ),
                        onPressed: () async {
                          if ((title.trim() == '') || (comment.trim() == '')) {
                            dialogBuilderEmpty(context);
                          } else if ((comment.length < 30)) {
                            dialogBuilderLength(context);
                          } else {
                            ID = FirebaseAuth.instance.currentUser?.uid;
                            await FirebaseFirestore.instance
                                .collection('applications')
                                .add({
                              'title': (title == Null) ? ("Title") : (title),
                              'category': (currentCategory == '')
                                  ? (valueChosen)
                                  : (currentCategory),
                              'comment':
                                  (comment == Null) ? ("Comment") : (comment),
                              'status': status,
                              'userID': ID,
                              'volunteerID': volID,
                              'date': "null",
                              'token_vol': "null",
                              'token_ref': tokenRefApplication,
                              'chatId_vol': "null",
                              'mess_button_visibility_vol': true,
                              'mess_button_visibility_ref': false,
                              'refugee_name': userNameRefugee!,
                              'volunteer_name': 'null',
                              'Id': 'null',
                              'voluneer_rating': 5,
                              "application_accepted": false,
                            });
                            currentCategory = '';
                            title = '';
                            comment = '';
                            numChart = 0;

                            controllerTabBottomRef =
                                PersistentTabController(initialIndex: 4);
                            Navigator.of(context, rootNavigator: true)
                                .pushReplacement(MaterialPageRoute(
                                    builder: (context) => MainScreenRefugee()));
                          }
                        }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> dialogBuilderEmpty(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: backgroundRefugee,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadiusApplication,
          ),
          title: const Text('Fill the form'),
          titleTextStyle: GoogleFonts.raleway(
            fontSize: 16,
            color: redColor,
          ),
          content:
              const Text("You haven't filled the form, please supply the data"),
          contentTextStyle: GoogleFonts.raleway(
            fontSize: 14,
            color: redColor,
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Center(
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.085,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: borderRadiusApplication),
                    child: TextButton(
                        child: Text(
                          'Supply the data',
                          style: GoogleFonts.raleway(
                            fontSize: 16,
                            color: redColor,
                          ),
                        ),
                        onPressed: () async {
                          Navigator.of(context).pop();
                        }),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Center(
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.085,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15)),
                    child: TextButton(
                        child: Text(
                          "Don't need any help",
                          style: GoogleFonts.raleway(
                            fontSize: 16,
                            color: redColor,
                          ),
                        ),
                        onPressed: () async {
                          currentCategory = '';
                          title = '';
                          comment = '';
                          numChart = 0;
                          Future.delayed(const Duration(seconds: 1), () {
                            controllerTabBottomRef =
                                PersistentTabController(initialIndex: 2);
                            Navigator.of(context, rootNavigator: true)
                                .pushReplacement(MaterialPageRoute(
                                    builder: (context) => MainScreenRefugee()));
                          });
                        }),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
          ],
        );
      },
    );
  }

  Future<void> dialogBuilderLength(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: backgroundRefugee,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadiusApplication,
          ),
          title: const Text('Fill the comment form'),
          titleTextStyle: GoogleFonts.raleway(
            fontSize: 16,
            color: redColor,
          ),
          content: const Text(
              "You haven't filled the comment form properly, please supply more characters to detail your application"),
          contentTextStyle: GoogleFonts.raleway(
            fontSize: 14,
            color: redColor,
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Center(
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.085,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: borderRadiusApplication),
                    child: TextButton(
                        child: Text(
                          'Supply the data',
                          style: GoogleFonts.raleway(
                            fontSize: 16,
                            color: redColor,
                          ),
                        ),
                        onPressed: () async {
                          Navigator.of(context).pop();
                        }),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
          ],
        );
      },
    );
  }
}
