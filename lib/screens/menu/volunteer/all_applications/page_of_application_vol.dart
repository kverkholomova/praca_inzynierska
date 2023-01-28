import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:wol_pro_1/constants.dart';
import 'package:http/http.dart' as http;
import 'package:wol_pro_1/screens/menu/volunteer/all_applications/your_app_vol.dart';

import '../../../../models/categories.dart';

import '../main_screen.dart';
import 'chosen_category_applications.dart';
import 'new_screen_with_applications.dart';
import '../home_page/home_vol.dart';

String date = '';

String? Id_Of_current_application = '';

// DateTime date = DateTime.now();
class PageOfApplication extends StatefulWidget {
  const PageOfApplication({Key? key}) : super(key: key);

  @override
  State<PageOfApplication> createState() => _PageOfApplicationState();
}

var ID_of_vol_application;

class _PageOfApplicationState extends State<PageOfApplication> {
  late AndroidNotificationChannel channel;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  void sendPushMessage() async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key = AAAADY1uR1I:APA91bEruiKUQtfsFz0yWjEovi9GAF9nkGYfmW9H2lU6jrtdCGw2C1ZdEczYXvovHMPqQBYSrDnYsbhsyk-kcCBi6Wht_YrGcSKXw4vk0UUNRlwN9UdM_4rhmf_6hd_xyAXbBsgyx12L  ',
        },
        body: jsonEncode(<String, dynamic>{
          "to": "$tokenRefNotification",
          // remove this
          "notification": {
            'title': 'Your application was accepted',
            'body': 'Your application was accepted by the volunteer.',
          },
        }),
      );
    } catch (e) {
      print("error push notification");
    }
  }

  final CollectionReference applications =
      FirebaseFirestore.instance.collection('applications');

  String status_updated = 'Application is accepted';
  String volID = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    print("Lalololoollololol");
    print(idCurrentApplicationInfo);
    return WillPopScope(
      onWillPop: () async {
        // setState(() {
        //   controllerTabBottomVol = PersistentTabController(initialIndex: 4);
        // });
        if (myCategories == true) {
          Navigator.of(context, rootNavigator: true).pushReplacement(
              MaterialPageRoute(builder: (context) => const YourCategories()));
        } else {
          Navigator.of(context, rootNavigator: true).pushReplacement(
              MaterialPageRoute(builder: (context) => const ChosenCategory()));
        }

        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 30,
              color: blueColor,
            ),
            onPressed: () {
              if (myCategories == true) {
                Navigator.of(context, rootNavigator: true).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) => const YourCategories()));
              } else {
                Navigator.of(context, rootNavigator: true).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) => const ChosenCategory()));
              }
            },
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Align(
            alignment: Alignment.topLeft,
            child: Text(
              "Manage chosen application",
              style: GoogleFonts.raleway(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
          ),
        ),
        backgroundColor: background,
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.85,
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('applications')
                      .where('Id', isEqualTo: idCurrentApplicationInfo)
                      .snapshots(),
                  builder:
                      (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                    return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: !streamSnapshot.hasData
                            ? 1
                            : streamSnapshot.data?.docs.length,
                        itemBuilder: (ctx, index) {
                          switch (streamSnapshot.connectionState) {
                            case ConnectionState.waiting:
                              return Column(children: const [
                                Padding(
                                  padding: EdgeInsets.only(top: 16),
                                  child: Text(''),
                                )
                              ]);
                            case ConnectionState.active:
                              return Padding(
                                padding: padding,
                                child: Column(
                                  children: [
                                    Container(
                                      width: double.infinity,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.7,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Padding(
                                        padding: padding,
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(20),
                                              child: Icon(
                                                streamSnapshot.data?.docs[index]
                                                                ['category']
                                                            as String ==
                                                        categoriesListAll[3]
                                                    ? Icons.pets_rounded
                                                    : streamSnapshot.data?.docs[index]
                                                                    ['category']
                                                                as String ==
                                                            categoriesListAll[4]
                                                        ? Icons
                                                            .local_grocery_store
                                                        : streamSnapshot.data?.docs[index]
                                                                        ['category']
                                                                    as String ==
                                                                categoriesListAll[
                                                                    2]
                                                            ? Icons
                                                                .emoji_transportation_rounded
                                                            : streamSnapshot.data?.docs[index]
                                                                            ['category']
                                                                        as String ==
                                                                    categoriesListAll[1]
                                                                ? Icons.house
                                                                : streamSnapshot.data?.docs[index]['category'] as String == categoriesListAll[6]
                                                                    ? Icons.sign_language_rounded
                                                                    : streamSnapshot.data?.docs[index]['category'] as String == categoriesListAll[5]
                                                                        ? Icons.child_care_outlined
                                                                        : streamSnapshot.data?.docs[index]['category'] as String == categoriesListAll[7]
                                                                            ? Icons.menu_book
                                                                            : streamSnapshot.data?.docs[index]['category'] as String == categoriesListAll[8]
                                                                                ? Icons.medical_information_outlined
                                                                                : streamSnapshot.data?.docs[index]['category'] as String == categoriesListAll[0]
                                                                                    ? Icons.check_box
                                                                                    : Icons.new_label_sharp,
                                                size: 30,
                                                color: Colors.black,
                                              ),
                                            ),
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.02,
                                            ),
                                            Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                // "Title",
                                                streamSnapshot.data?.docs[index]
                                                    ['title'],
                                                style: GoogleFonts.raleway(
                                                  fontSize: 18,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.007,
                                            ),
                                            Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                  streamSnapshot.data
                                                      ?.docs[index]['category'],
                                                  style: GoogleFonts.raleway(
                                                    fontSize: 14,
                                                    color: Colors.black,
                                                  )),
                                            ),
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.05,
                                            ),
                                            Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                streamSnapshot.data?.docs[index]
                                                    ['comment'],
                                                style: GoogleFonts.raleway(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.04,
                                    ),
                                    Align(
                                      alignment: Alignment.topCenter,
                                      child: Center(
                                        child: Container(
                                          width: double.infinity,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.085,
                                          decoration: buttonActiveDecoration,
                                          child: TextButton(
                                              child: Text(
                                                "Accept application",
                                                style: textActiveButtonStyle,
                                              ),
                                              onPressed: () async {
                                                sendPushMessage();
                                                date =
                                                    DateTime.now().toString();
                                                FirebaseFirestore.instance
                                                    .collection('applications')
                                                    .doc(streamSnapshot
                                                        .data?.docs[index].id)
                                                    .update({
                                                  "status": status_updated,
                                                  "volunteerID": volID,
                                                  "date": date,
                                                  "token_vol": tokenVol,
                                                  "volunteer_name":
                                                      currentNameVol,
                                                  "application_accepted": true,
                                                });

                                                Id_Of_current_application =
                                                    streamSnapshot
                                                        .data?.docs[index].id;
                                                ID_of_vol_application =
                                                    streamSnapshot
                                                        .data?.docs[index].id;
                                                setState(() {
                                                  controllerTabBottomVol =
                                                      PersistentTabController(
                                                          initialIndex: 1);
                                                });
                                                Navigator.of(context,
                                                        rootNavigator: true)
                                                    .pushReplacement(
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                MainScreen()));
                                              }),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            case ConnectionState.none:
                              // TODO: Handle this case.
                              break;
                            case ConnectionState.done:
                              // TODO: Handle this case.
                              break;
                          }

                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 100),
                              child: Column(
                                children: const [
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text("",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24,
                                          color: Colors.black,
                                        )),
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
}
