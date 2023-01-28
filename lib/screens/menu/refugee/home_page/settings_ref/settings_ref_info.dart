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
import 'package:wol_pro_1/screens/menu/refugee/home_page/settings_ref/upload_picture_refugee.dart';
import 'package:wol_pro_1/screens/menu/refugee/main_screen_ref.dart';
import 'package:wol_pro_1/screens/menu/volunteer/home_page/settings/upload_photo.dart';
import 'package:wol_pro_1/widgets/datepicker.dart';
import 'package:wol_pro_1/widgets/wrapper.dart';

import '../../../../../widgets/datepicker_ref.dart';
import '../../../../register_login/volunteer/register/register_volunteer_1.dart';
import '../../../../../services/auth.dart';

bool visErrorName = false;
bool visErrorPhoneNum = false;
bool phoneLengthEnough = false;
var currentStreamSnapshotRef;
String dateOfBirthRefugee =
    DateFormat('dd, MMMM yyyy').format(DateTime.now()).toString();
// String? tokenVol;
final FirebaseFirestore db = FirebaseFirestore.instance;
final FirebaseMessaging fcm = FirebaseMessaging.instance;

class SettingsRef extends StatefulWidget {
  const SettingsRef({Key? key}) : super(key: key);

  @override
  State<SettingsRef> createState() => _SettingsRefState();
}

class _SettingsRefState extends State<SettingsRef> {
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
    visErrorName = false;
    visErrorPhoneNum = false;
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
        Navigator.of(context, rootNavigator: true).pushReplacement(
            MaterialPageRoute(builder: (context) => MainScreenRefugee()));
        return true;
      },
      child: Scaffold(
        backgroundColor: backgroundRefugee,
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        floatingActionButton: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 30,
            color: backgroundRefugee,
          ),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pushReplacement(
                MaterialPageRoute(builder: (context) => MainScreenRefugee()));
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
                                color: redColor,
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
                                      currentStreamSnapshotRef =
                                          streamSnapshot.data?.docs[index].id;
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ImageUploadsRef()));
                                    },
                                    child: SizedBox(
                                        height:
                                            MediaQuery.of(context).size.width *
                                                0.5,
                                        child: urlImageRefugee == ""
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
                                                        currentStreamSnapshotRef =
                                                            streamSnapshot
                                                                .data
                                                                ?.docs[index]
                                                                .id;
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        ImageUploadsRef()));
                                                      },
                                                      child: Container(
                                                          width: 50,
                                                          height: 50,
                                                          decoration: BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color:
                                                                  backgroundRefugee),
                                                          child: Center(
                                                              child: Icon(
                                                            Icons.add_rounded,
                                                            color: redColor,
                                                            size: 30,
                                                          )))),
                                                )
                                              ])
                                            : Stack(children: [
                                                CircleAvatar(
                                                    radius: 70.0,
                                                    backgroundImage:
                                                        NetworkImage(
                                                            urlImageRefugee
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
                                                        currentStreamSnapshotRef =
                                                            streamSnapshot
                                                                .data
                                                                ?.docs[index]
                                                                .id;
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        ImageUploadsRef()));
                                                      },
                                                      child: Container(
                                                          width: 40,
                                                          height: 40,
                                                          decoration: BoxDecoration(
                                                              shape: BoxShape
                                                                  .circle,
                                                              color:
                                                                  backgroundRefugee),
                                                          child: Center(
                                                              child: Icon(
                                                            Icons.add_rounded,
                                                            color: redColor,
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
                                            visErrorName = true;
                                          });
                                        } else {
                                          setState(() {
                                            visErrorName = false;
                                          });
                                          changedName = val;
                                        }
                                      },
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
                                            color: redColor,
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
                                    visible: visErrorName,
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
                                      onChanged: (val) {
                                        changedAge = currentAgeVolunteer;
                                      },
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const DatePickerRefugee()),
                                        );
                                      },
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
                                            color: redColor,
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
                                        hintText: dateOfBirthRefugee ==
                                                DateFormat('dd, MMMM yyyy')
                                                    .format(DateTime.now())
                                                    .toString()
                                            ? "Please supply data"
                                            : dateOfBirthRefugee,
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
                                            visErrorPhoneNum = true;
                                          });
                                        } else {
                                          if (val.length > 9) {
                                            setState(() {
                                              visErrorPhoneNum = true;
                                              phoneLengthEnough = true;
                                            });
                                          } else {
                                            setState(() {
                                              visErrorPhoneNum = false;
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
                                              color: redColor,
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
                                    visible: visErrorPhoneNum,
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
                                          phoneLengthEnough
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
                                  Divider(color: redColor),
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
                                        decoration:
                                            buttonActiveDecorationRefugee,
                                        child: TextButton(
                                            child: Text(
                                              "Save changes",
                                              style:
                                                  textActiveButtonStyleRefugee,
                                            ),
                                            onPressed: () async {
                                              if (visErrorName ||
                                                  visErrorPhoneNum) {
                                                dialogBuilderError(context);
                                              } else {
                                                setState(() {
                                                  FirebaseFirestore.instance
                                                      .collection('users')
                                                      .doc(streamSnapshot
                                                          .data?.docs[index].id)
                                                      .update({
                                                    "category":
                                                        changedCategories !=
                                                                []
                                                            ? changedCategories
                                                            : streamSnapshot
                                                                        .data
                                                                        ?.docs[
                                                                    index]
                                                                ['category'],
                                                    "user_name": changedName !=
                                                            ""
                                                        ? changedName
                                                        : streamSnapshot.data
                                                                ?.docs[index]
                                                            ['user_name'],
                                                    "age": currentAgeRefugee !=
                                                            0
                                                        ? currentAgeRefugee
                                                        : streamSnapshot.data
                                                                ?.docs[index]
                                                            ['age'],
                                                    "phone_number":
                                                        changedPhone != ""
                                                            ? changedPhone
                                                            : streamSnapshot
                                                                    .data
                                                                    ?.docs[index]
                                                                ['phone_number']
                                                  });
                                                });
                                                Navigator.of(context,
                                                        rootNavigator: true)
                                                    .pushReplacement(
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                MainScreenRefugee()));
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
                                        decoration:
                                            buttonInactiveDecorationRefugee,
                                        child: TextButton(
                                            child: Text(
                                              "Sign Out",
                                              style:
                                                  textInactiveButtonStyleRefugee,
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

  GestureDetector buildCategorySettings(
      BuildContext context, String text, IconData icon) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (changedCategories.contains(text)) {
            changedCategories.remove(text);
          } else {
            changedCategories.add(text);
          }
        });
      },
      child: AnimatedContainer(
        height: MediaQuery.of(context).size.height * 0.075,
        duration: const Duration(milliseconds: 500),
        decoration: BoxDecoration(
          color: chosenCategoryListChanges.contains(text)
              ? redColor
              : Colors.white,
          borderRadius: const BorderRadius.all(
            Radius.circular(24),
          ),
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.05,
                right: MediaQuery.of(context).size.width * 0.04,
              ),
              child: Icon(
                icon,
                size: 27,
                color: chosenCategoryListChanges.contains(text)
                    ? Colors.white
                    : Colors.black,
              ),
            ),
            Text(
              text,
              style: GoogleFonts.raleway(
                fontSize: 14,
                color: chosenCategoryListChanges.contains(text)
                    ? Colors.white
                    : Colors.black,
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> dialogBuilderError(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: backgroundRefugee,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadiusApplication,
          ),
          title: const Text('You provided wrong data'),
          titleTextStyle: GoogleFonts.raleway(
            fontSize: 16,
            color: redColor,
          ),
          content: const Text(
              "You have provided wrong data, so please supply correct data or leave previous data"),
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
                          "Leave previous data",
                          style: GoogleFonts.raleway(
                            fontSize: 16,
                            color: redColor,
                          ),
                        ),
                        onPressed: () async {
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
}
