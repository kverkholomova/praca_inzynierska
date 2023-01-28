import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:wol_pro_1/constants.dart';
import 'package:http/http.dart' as http;
import 'package:wol_pro_1/screens/menu/volunteer/messages/messagesVol.dart';
import 'package:wol_pro_1/screens/menu/volunteer/messages/pageWithChatsVol.dart';
import '../../../../models/categories.dart';
import '../all_applications/page_of_application_vol.dart';
import '../main_screen.dart';
import '../home_page/home_vol.dart';
import '../my_applications/applications_vol.dart';

String roomExist = '';
bool firstMessage = false;

String VoluntterName = '';
String RefugeeName = '';
String nameOfApplication = '';

DateTime date = DateTime.now();

class SettingsOfApplicationAccepted extends StatefulWidget {
  const SettingsOfApplicationAccepted({Key? key}) : super(key: key);

  @override
  State<SettingsOfApplicationAccepted> createState() =>
      _SettingsOfApplicationAcceptedState();
}

var ID_of_vol_application;

class _SettingsOfApplicationAcceptedState
    extends State<SettingsOfApplicationAccepted> {
  late AndroidNotificationChannel channel;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  String status_declined = 'Sent to volunteer';
  String? token = " ";

  @override
  void initState() {
    super.initState();
  }

  void sendPushMessage() async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key = AAAADY1uR1I:APA91bEruiKUQtfsFz0yWjEovi9GAF9nkGYfmW9H2lU6jrtdCGw2C1ZdEczYXvovHMPqQBYSrDnYsbhsyk-kcCBi6Wht_YrGcSKXw4vk0UUNRlwN9UdM_4rhmf_6hd_xyAXbBsgyx12L  ',
        },
        body: jsonEncode(
          {
            'notification':
                // {
                {
              "body":
                  'The application was deleted by refugee, so your help is not necessary anymore.',
              'title': 'Your application was declined by volunteer',
            },
            'sound': 'default',
            "to": "$tokenRefNotification",
          },
        ),
      );
    } catch (e) {
      print("error push notification");
    }
  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  final CollectionReference applications =
      FirebaseFirestore.instance.collection('applications');

  String status_updated = 'Application is accepted';
  String volID = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        setState(() {
          controllerTabBottomVol = PersistentTabController(initialIndex: 1);
        });
        Navigator.of(context, rootNavigator: true).pushReplacement(
            MaterialPageRoute(builder: (context) => MainScreen()));
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
              setState(() {
                controllerTabBottomVol =
                    PersistentTabController(initialIndex: 1);
              });
              Navigator.of(context, rootNavigator: true).pushReplacement(
                  MaterialPageRoute(builder: (context) => MainScreen()));
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
                height: MediaQuery.of(context).size.height * 0.99,
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('applications')
                      .where('volunteerID',
                          isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                      .where('title', isEqualTo: cardTitleAccepted)
                      .where('category', isEqualTo: cardCategoryAccepted)
                      .where('comment', isEqualTo: cardCommentAccepted)
                      .snapshots(),
                  builder:
                      (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: !streamSnapshot.hasData
                            ? 1
                            : streamSnapshot.data?.docs.length,
                        itemBuilder: (ctx, index) {
                          if (streamSnapshot.hasData) {
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
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            20),
                                                    child: Icon(
                                                      streamSnapshot.data?.docs[index]
                                                                      ['category']
                                                                  as String ==
                                                              categoriesListAll[
                                                                  3]
                                                          ? Icons.pets_rounded
                                                          : streamSnapshot.data?.docs[index]
                                                                          ['category']
                                                                      as String ==
                                                                  categoriesListAll[
                                                                      4]
                                                              ? Icons
                                                                  .local_grocery_store
                                                              : streamSnapshot.data?.docs[index]
                                                                              ['category']
                                                                          as String ==
                                                                      categoriesListAll[
                                                                          2]
                                                                  ? Icons
                                                                      .emoji_transportation_rounded
                                                                  : streamSnapshot
                                                                              .data
                                                                              ?.docs[index]['category'] as String ==
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
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.02,
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Text(
                                                      // "Title",
                                                      streamSnapshot
                                                              .data?.docs[index]
                                                          ['title'],
                                                      style:
                                                          GoogleFonts.raleway(
                                                        fontSize: 18,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.007,
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Text(
                                                        streamSnapshot.data
                                                                ?.docs[index]
                                                            ['category'],
                                                        style:
                                                            GoogleFonts.raleway(
                                                          fontSize: 14,
                                                          color: Colors.black,
                                                        )),
                                                  ),
                                                  SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.05,
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Text(
                                                      streamSnapshot
                                                              .data?.docs[index]
                                                          ['comment'],
                                                      style:
                                                          GoogleFonts.raleway(
                                                        fontSize: 14,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Align(
                                                alignment:
                                                    Alignment.bottomCenter,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              15.0),
                                                      child: IconButton(
                                                        icon: Icon(
                                                          Icons.delete_forever,
                                                          size: 30,
                                                          color: blueColor,
                                                        ),
                                                        onPressed: () {
                                                          dialogBuilderDeclineApplication(
                                                              context);
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.05,
                                      ),
                                      Container(
                                        width: double.infinity,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.085,
                                        decoration: buttonActiveDecoration,
                                        child: TextButton(
                                            child: Text(
                                              "Message",
                                              style: textActiveButtonStyle,
                                            ),
                                            onPressed: () {
                                              if (streamSnapshot
                                                          .data?.docs[index]
                                                      ["chatId_vol"] ==
                                                  "null") {
                                                setState(() {
                                                  messagesNull = true;
                                                });

                                                IdOfChatroomVol =
                                                    FirebaseFirestore.instance
                                                        .collection(
                                                            'USERS_COLLECTION')
                                                        .doc()
                                                        .id;

                                                FirebaseFirestore.instance
                                                    .collection(
                                                        'USERS_COLLECTION')
                                                    .doc(IdOfChatroomVol)
                                                    .set({
                                                  'IdVolunteer': streamSnapshot
                                                          .data?.docs[index]
                                                      ['volunteerID'],
                                                  'IdRefugee': streamSnapshot
                                                      .data
                                                      ?.docs[index]["userID"],
                                                  'chatId': IdOfChatroomVol,
                                                  'Refugee_Name': streamSnapshot
                                                          .data?.docs[index]
                                                      ['refugee_name'],
                                                  'Volunteer_Name':
                                                      streamSnapshot
                                                              .data?.docs[index]
                                                          ['volunteer_name'],
                                                  'Id_Of_Chat': "null",
                                                  'Application_Name':
                                                      streamSnapshot
                                                              .data?.docs[index]
                                                          ['title'],
                                                  'last_msg': ""
                                                  // "user_message": true
                                                });

                                                FirebaseFirestore.instance
                                                    .collection('applications')
                                                    .doc(streamSnapshot
                                                        .data?.docs[index].id)
                                                    .update({
                                                  "chatId_vol": IdOfChatroomVol
                                                });

                                                Future.delayed(
                                                    const Duration(
                                                        milliseconds: 500), () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const SelectedChatroomVol()),
                                                  );
                                                });
                                              } else {
                                                setState(() {
                                                  changeContainerHeight = false;
                                                  messagesNull = false;

                                                  IdOfChatroomVol =
                                                      streamSnapshot
                                                              .data?.docs[index]
                                                          ["chatId_vol"];
                                                });
                                                Future.delayed(
                                                    const Duration(
                                                        milliseconds: 500), () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const SelectedChatroomVol()),
                                                  );
                                                });
                                              }
                                            }),
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

  Future<void> dialogBuilderDeclineApplication(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text('Decline application?'),
          titleTextStyle: GoogleFonts.raleway(
            fontSize: 16,
            color: blueColor,
          ),
          content: const Text(
              "You are about to decline this application. If you are ready to do it, refugee will get the notification that you have declined this application and will have to wait until another volunteer accept this application."),
          contentTextStyle: GoogleFonts.raleway(
            fontSize: 13,
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
                          'Keep application',
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
                          "Decline application",
                          style: textInactiveButtonStyle,
                        ),
                        onPressed: () async {
                          sendPushMessage();

                          FirebaseFirestore.instance
                              .collection('applications')
                              .doc(Id_Of_current_application)
                              .update({
                            "status": status_declined,
                            "chatId_vol": "null",
                            "date": "null",
                            "token_vol": "null",
                            "volunteerID": "null",
                            "volunteer_name": "null",
                            "application_accepted": false,
                          });

                          FirebaseFirestore.instance
                              .collection('applications')
                              .doc(Id_Of_current_application)
                              .update({"mess_button_visibility_ref": false});
                          FirebaseFirestore.instance
                              .collection('applications')
                              .doc(Id_Of_current_application)
                              .update({"mess_button_visibility_vol": true});

                          ID_of_vol_application = Id_Of_current_application;

                          FirebaseFirestore.instance
                              .collection('USERS_COLLECTION')
                              .doc(chatIdDialog)
                              .delete();
                          setState(() {
                            controllerTabBottomVol =
                                PersistentTabController(initialIndex: 1);
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
