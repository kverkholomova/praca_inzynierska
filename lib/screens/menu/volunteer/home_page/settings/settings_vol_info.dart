import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:wol_pro_1/constants.dart';
import 'package:wol_pro_1/screens/menu/volunteer/home_page/settings/upload_photo.dart';
import 'package:wol_pro_1/screens/menu/volunteer/main_screen.dart';
import 'package:wol_pro_1/widgets/datepicker.dart';

import '../../../../../widgets/wrapper.dart';
import '../../../../../services/auth.dart';

bool visErrorNameVol = false;
bool visErrorPhoneNumVol = false;
bool phoneLengthEnoughVol = false;
var currentStreamSnapshot;
String dateOfBirth =
    DateFormat('dd, MMMM yyyy').format(DateTime.now()).toString();
String? tokenVol;
final FirebaseFirestore db = FirebaseFirestore.instance;
final FirebaseMessaging fcm = FirebaseMessaging.instance;

class SettingsVol extends StatefulWidget {
  const SettingsVol({Key? key}) : super(key: key);

  @override
  State<SettingsVol> createState() => _SettingsVolState();
}

class _SettingsVolState extends State<SettingsVol> {
  storeNotificationToken() async {
    String? token = await FirebaseMessaging.instance.getToken();

    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({'token': token}, SetOptions(merge: true));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseMessaging.instance.getInitialMessage();
    storeNotificationToken();
    FirebaseMessaging.instance.subscribeToTopic('subscription');
  }

  final AuthService _auth = AuthService();

  String changedName = '';
  int changedAge = 0;
  String changedPhone = '';
  List changedCategories = [];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        setState(() {
          controllerTabBottomVol = PersistentTabController(initialIndex: 2);
        });
        Navigator.of(context, rootNavigator: true).pushReplacement(
            MaterialPageRoute(builder: (context) => MainScreen()));
        return true;
      },
      child: Scaffold(
        backgroundColor: background,
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        floatingActionButton: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 30,
            color: background,
          ),
          onPressed: () {
            setState(() {
              controllerTabBottomVol = PersistentTabController(initialIndex: 2);
            });
            Navigator.of(context, rootNavigator: true).pushReplacement(
                MaterialPageRoute(builder: (context) => MainScreen()));
          },
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.31,
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .where('id_vol',
                          isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                      .snapshots(),
                  builder:
                      (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                    return ListView.builder(
                        itemCount: streamSnapshot.data?.docs.length,
                        itemBuilder: (ctx, index) {
                          return ClipPath(
                            clipper: OvalBottomBorderClipper(),
                            child: Container(
                              decoration: BoxDecoration(
                                color: blueColor,
                                boxShadow: const <BoxShadow>[
                                  BoxShadow(
                                    color: Colors.black,
                                    blurRadius: 5,
                                  ),
                                ],
                              ),
                              height: MediaQuery.of(context).size.height * 0.25,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 30, top: 10),
                                  child: GestureDetector(
                                    onTap: () {
                                      currentStreamSnapshot =
                                          streamSnapshot.data?.docs[index].id;
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ImageUploads()));
                                    },
                                    child: SizedBox(
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                        child: url_image == ""
                                            ? Stack(children: [
                                                const Image(
                                                    image: AssetImage(
                                                        "assets/user.png")),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                    top: MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                        0.125,
                                                    left: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.3,
                                                  ),
                                                  child: GestureDetector(
                                                      onTap: () {
                                                        currentStreamSnapshot =
                                                            streamSnapshot
                                                                .data
                                                                ?.docs[index]
                                                                .id;
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        ImageUploads()));
                                                      },
                                                      child: Container(
                                                          width: 50,
                                                          height: 50,
                                                          decoration:
                                                              BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  color:
                                                                      background),
                                                          child: Center(
                                                              child: Icon(
                                                            Icons.add_rounded,
                                                            color: blueColor,
                                                          )))),
                                                )
                                              ])
                                            : Stack(children: [
                                                CircleAvatar(
                                                    radius: 70.0,
                                                    backgroundImage:
                                                        NetworkImage(url_image
                                                            .toString())),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                    top: MediaQuery.of(context)
                                                            .size
                                                            .height *
                                                        0.125,
                                                    left: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.3,
                                                  ),
                                                  child: GestureDetector(
                                                      onTap: () {
                                                        currentStreamSnapshot =
                                                            streamSnapshot
                                                                .data
                                                                ?.docs[index]
                                                                .id;
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        ImageUploads()));
                                                      },
                                                      child: Container(
                                                          width: 40,
                                                          height: 40,
                                                          decoration:
                                                              BoxDecoration(
                                                                  shape: BoxShape
                                                                      .circle,
                                                                  color:
                                                                      background),
                                                          child: Center(
                                                              child: Icon(
                                                            Icons.add_rounded,
                                                            color: blueColor,
                                                            size: 35,
                                                          )))),
                                                ),
                                              ])),
                                  ),
                                ),
                              ),
                            ),
                          );
                        });
                  },
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.69,
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .where('id_vol',
                          isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                      .snapshots(),
                  builder:
                      (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                    return ListView.builder(
                        itemCount: streamSnapshot.data?.docs.length,
                        itemBuilder: (ctx, index) {
                          return SingleChildScrollView(
                            child: Padding(
                              padding: padding,
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        bottom:
                                            MediaQuery.of(context).size.height *
                                                0.005,
                                      ),
                                      child: Text(
                                        "Your name",
                                        style: textLabelSeparated,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.085,
                                    child: TextFormField(
                                      onChanged: (val) {
                                        if ((val.contains(RegExp(r'[0-9]'))) ||
                                            (val.contains(
                                                RegExp(r'[#?!@$%^&*-]')))) {
                                          setState(() {
                                            visErrorNameVol = true;
                                          });
                                        } else {
                                          setState(() {
                                            visErrorNameVol = false;
                                          });
                                          changedName = val;
                                        }

                                        // changedName = val;
                                      },
                                      // controller: TextEditingController(text: streamSnapshot.data?.docs[index]['user_name']),
                                      decoration: InputDecoration(
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: const BorderSide(
                                            color: Colors.red,
                                            width: 1.5,
                                          ),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: const BorderSide(
                                            color: Colors.red,
                                            width: 1.5,
                                          ),
                                        ),
                                        errorStyle:
                                            const TextStyle(color: Colors.red),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: BorderSide(
                                            color: blueColor,
                                            // color: Color.fromRGBO(2, 62, 99, 20),
                                            width: 1.5,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: const BorderSide(
                                            color: Colors.white,
                                            width: 0,
                                          ),
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                        hintText: streamSnapshot
                                            .data?.docs[index]['user_name'],
                                        hintStyle: hintStyleText,
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: visErrorNameVol,
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.005,
                                        ),
                                        child: Text(
                                          "Your name should contain only letters (A-Z,a-z)",
                                          style: GoogleFonts.raleway(
                                            fontSize: 12,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.015,
                                  ),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        bottom:
                                            MediaQuery.of(context).size.height *
                                                0.005,
                                      ),
                                      child: Text(
                                        "Your date of birth",
                                        style: textLabelSeparated,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.085,
                                    child: TextFormField(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const DatePicker()),
                                        );
                                      },
                                      // controller: TextEditingController(text: streamSnapshot.data?.docs[index]['phone_number']),
                                      decoration: InputDecoration(
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: const BorderSide(
                                            color: Colors.red,
                                            width: 1.5,
                                          ),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: const BorderSide(
                                            color: Colors.red,
                                            width: 1.5,
                                          ),
                                        ),
                                        errorStyle:
                                            const TextStyle(color: Colors.red),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: BorderSide(
                                            color: blueColor,
                                            // color: Color.fromRGBO(2, 62, 99, 20),
                                            width: 1.5,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          borderSide: const BorderSide(
                                            color: Colors.white,
                                            width: 0,
                                          ),
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                        hintText: dateOfBirth ==
                                                DateFormat('dd, MMMM yyyy')
                                                    .format(DateTime.now())
                                                    .toString()
                                            ? "Please supply data"
                                            : dateOfBirth,
                                        hintStyle: hintStyleText,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.015,
                                  ),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        bottom:
                                            MediaQuery.of(context).size.height *
                                                0.005,
                                      ),
                                      child: Text(
                                        "Your phone number",
                                        style: textLabelSeparated,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.085,
                                    child: TextFormField(
                                      onChanged: (val) {
                                        if (val.contains(RegExp(r'[A-Z]')) ||
                                            val.contains(RegExp(r'[a-z]')) ||
                                            val.contains(
                                                RegExp(r'[#?!@$%^&()*-]'))) {
                                          setState(() {
                                            visErrorPhoneNumVol = true;
                                          });
                                        } else {
                                          if (val.length > 9) {
                                            setState(() {
                                              visErrorPhoneNumVol = true;
                                              phoneLengthEnoughVol = true;
                                            });
                                          } else {
                                            setState(() {
                                              visErrorPhoneNumVol = false;
                                            });
                                          }
                                        }
                                      },
                                      decoration: InputDecoration(
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            borderSide: const BorderSide(
                                              color: Colors.red,
                                              width: 1.5,
                                            ),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            borderSide: const BorderSide(
                                              color: Colors.red,
                                              width: 1.5,
                                            ),
                                          ),
                                          errorStyle: const TextStyle(
                                              color: Colors.red),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            borderSide: BorderSide(
                                              color: blueColor,
                                              // color: Color.fromRGBO(2, 62, 99, 20),
                                              width: 1.5,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            borderSide: const BorderSide(
                                              color: Colors.white,
                                              width: 0,
                                            ),
                                          ),
                                          filled: true,
                                          fillColor: Colors.white,
                                          hintText: streamSnapshot.data
                                              ?.docs[index]['phone_number'],
                                          hintStyle: hintStyleText),
                                    ),
                                  ),
                                  Visibility(
                                    visible: visErrorPhoneNumVol,
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.005,
                                        ),
                                        child: Text(
                                          phoneLengthEnoughVol
                                              ? "Your phone should contain only 9 numbers"
                                              : "Your phone should contain only numbers (0-9)",
                                          style: GoogleFonts.raleway(
                                            fontSize: 12,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.015,
                                  ),
                                  Divider(color: blueColor),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.015,
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.01),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Center(
                                      child: Container(
                                        width: double.infinity,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.085,
                                        decoration: buttonActiveDecoration,
                                        child: TextButton(
                                            child: Text(
                                              "Save changes",
                                              style: textActiveButtonStyle,
                                            ),
                                            onPressed: () async {
                                              if (changedName == "" &&
                                                  changedAge == "" &&
                                                  changedPhone == '') {
                                                dialogBuilderEmpty(context);
                                              } else {
                                                setState(() {
                                                  FirebaseFirestore.instance
                                                      .collection('users')
                                                      .doc(streamSnapshot
                                                          .data?.docs[index].id)
                                                      .update({
                                                    "user_name": changedName !=
                                                            ""
                                                        ? changedName
                                                        : streamSnapshot.data
                                                                ?.docs[index]
                                                            ['user_name'],
                                                    "age": currentAgeVolunteer !=
                                                            0
                                                        ? currentAgeVolunteer
                                                        : streamSnapshot.data
                                                                ?.docs[index]
                                                            ['age'],
                                                    "phone_number":
                                                        changedPhone != ""
                                                            ? changedPhone
                                                            : streamSnapshot
                                                                    .data
                                                                    ?.docs[index]
                                                                [
                                                                'phone_number'],
                                                    "birth_day": dateOfBirth ==
                                                            DateFormat(
                                                                    'dd, MMMM yyyy')
                                                                .format(DateTime
                                                                    .now())
                                                                .toString()
                                                        ? "Please supply data"
                                                        : dateOfBirth
                                                  });
                                                });

                                                Future.delayed(
                                                    const Duration(
                                                        milliseconds: 500), () {
                                                  Navigator.of(context,
                                                          rootNavigator: true)
                                                      .pushReplacement(
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  MainScreen()));
                                                });
                                              }
                                            }),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.015,
                                  ),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Center(
                                      child: Container(
                                        width: double.infinity,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.085,
                                        decoration: buttonInactiveDecoration,
                                        child: TextButton(
                                            child: Text(
                                              "Sign Out",
                                              style: textInactiveButtonStyle,
                                            ),
                                            onPressed: () async {
                                              await _auth.signOut();
                                              SystemNavigator.pop();
                                            }),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.015,
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                  },
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
          backgroundColor: background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text('Change your info'),
          titleTextStyle: GoogleFonts.raleway(
            fontSize: 16,
            color: blueColor,
          ),
          content: const Text(
              "You haven't supply any changes, please supply any change to save something"
              ' or leave your previous information'),
          contentTextStyle: GoogleFonts.raleway(
            fontSize: 14,
            color: blueColor,
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
                    decoration: buttonActiveDecoration,
                    child: TextButton(
                        child: Text(
                          'Change info',
                          style: textActiveButtonStyle,
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
                    decoration: buttonInactiveDecoration,
                    child: TextButton(
                        child: Text(
                          'Leave my info',
                          style: textInactiveButtonStyle,
                        ),
                        onPressed: () async {
                          setState(() {
                            controllerTabBottomVol =
                                PersistentTabController(initialIndex: 2);
                          });
                          Navigator.of(context, rootNavigator: true)
                              .pushReplacement(MaterialPageRoute(
                                  builder: (context) => MainScreen()));
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
