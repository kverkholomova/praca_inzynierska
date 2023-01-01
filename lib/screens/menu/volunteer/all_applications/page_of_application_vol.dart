import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:wol_pro_1/to_delete/SettingRefugee.dart';
import 'package:wol_pro_1/constants.dart';
import 'package:http/http.dart' as http;
import 'package:wol_pro_1/screens/menu/volunteer/all_applications/your_app_vol.dart';

import '../../../../models/categories.dart';
import '../../refugee/home_page/create_application/create_application.dart';
import '../main_screen.dart';
import 'chosen_category_applications.dart';
import 'new_screen_with_applications.dart';
import '../home_page/home_vol.dart';
import '../my_applications/applications_vol.dart';

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

  // String? token = " ";

  @override
  void initState() {
    super.initState();

    // requestPermission();
    //
    // loadFCM();
    //
    // listenFCM();

    // getToken();

    // FirebaseMessaging.instance.subscribeToTopic("Animal");
  }

  void sendPushMessageAccepted() async {
    print(
        "Send Info that application is accepted");
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key = AAAADY1uR1I:APA91bEruiKUQtfsFz0yWjEovi9GAF9nkGYfmW9H2lU6jrtdCGw2C1ZdEczYXvovHMPqQBYSrDnYsbhsyk-kcCBi6Wht_YrGcSKXw4vk0UUNRlwN9UdM_4rhmf_6hd_xyAXbBsgyx12L  ',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': 'The volunteer has chosen your application to help you.',
              'title': 'Application is accepted'
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
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

  void listenFCM() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              // TODO add a proper drawable resource to android, for now using
              //      one that already exists in example app.
              icon: 'launch_background',
            ),
          ),
        );
      }
    });
  }

  void loadFCM() async {
    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        importance: Importance.high,
        enableVibration: true,
      );

      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      /// Create an Android Notification Channel.
      ///
      /// We use this channel in the `AndroidManifest.xml` file to override the
      /// default FCM channel to enable heads up notifications.
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      /// Update the iOS foreground notification presentation options to allow
      /// heads up notifications.
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
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
        // setState(() {
        //   controllerTabBottomVol = PersistentTabController(initialIndex: 4);
        // });
        if(myCategories==true){
          Navigator.of(context, rootNavigator: true).pushReplacement(
              MaterialPageRoute(builder: (context) => new YourCategories()));
        } else {
          Navigator.of(context, rootNavigator: true).pushReplacement(
              MaterialPageRoute(builder: (context) => new ChosenCategory()));
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
              if(myCategories==true){
                Navigator.of(context, rootNavigator: true).pushReplacement(
                    MaterialPageRoute(builder: (context) => new YourCategories()));
              } else {
                Navigator.of(context, rootNavigator: true).pushReplacement(
                    MaterialPageRoute(builder: (context) => new ChosenCategory()));
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

        // appBar: AppBar(
        //   backgroundColor: Color.fromRGBO(49, 72, 103, 0.8),
        //   elevation: 0.0,
        //   title: Text('Application Info',style: TextStyle(fontSize: 16),),
        //
        // ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.99,
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('applications')
                      .where('title', isEqualTo: card_title_vol)
                      .where('category', isEqualTo: card_category_vol)
                      .where('comment', isEqualTo: card_comment_vol)
                      .snapshots(),
                  builder:
                      (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                    return ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: !streamSnapshot.hasData
                            ? 1
                            : streamSnapshot.data?.docs.length,
                        itemBuilder: (ctx, index) {
                          //Toooooooooooooooookeeeeeeeeeeeeen heeeeeeeeeeeereeeeeeeeeeeeeeee
                          // tokenRefApplication =
                          // streamSnapshot.data?.docs[index]['token_ref'];
                          // if (streamSnapshot.hasData) {
                            switch (streamSnapshot.connectionState) {
                              case ConnectionState.waiting:
                                return Column(children: [
                                  SizedBox(
                                    width: 60,
                                    height: 60,
                                    child: CircularProgressIndicator(),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 16),
                                    child: Text('Awaiting data...'),
                                  )
                                ]);
                              case ConnectionState.active:
                                return Padding(
                                  padding: padding,
                                  child: Column(
                                    children: [
                                      // Padding(
                                      //   padding: EdgeInsets.only(
                                      //       top: MediaQuery.of(context).size.height * 0.02),
                                      //   child: Align(
                                      //     alignment: Alignment.topCenter,
                                      //     child: Text(
                                      //       "Application details",
                                      //       style: GoogleFonts.raleway(
                                      //         fontSize: 18,
                                      //         color: Colors.black,
                                      //       ),
                                      //     ),
                                      //   ),
                                      // ),
                                      // SizedBox(
                                      //   height: MediaQuery.of(context).size.height * 0.05,
                                      // ),
                                      Container(
                                        width: double.infinity,
                                        height: MediaQuery.of(context).size.height *
                                            0.47,
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
                                                  streamSnapshot.data?.docs[index]['category'] as String==categoriesListAll[3]
                                                      ?Icons.pets_rounded
                                                      :streamSnapshot.data?.docs[index]['category'] as String==categoriesListAll[4]
                                                      ?Icons.local_grocery_store
                                                      :streamSnapshot.data?.docs[index]['category'] as String==categoriesListAll[2]
                                                      ?Icons.emoji_transportation_rounded
                                                      :streamSnapshot.data?.docs[index]['category'] as String==categoriesListAll[1]
                                                      ?Icons.house
                                                      :streamSnapshot.data?.docs[index]['category'] as String==categoriesListAll[6]
                                                      ?Icons.sign_language_rounded
                                                      :streamSnapshot.data?.docs[index]['category'] as String==categoriesListAll[5]
                                                      ?Icons.child_care_outlined
                                                      :streamSnapshot.data?.docs[index]['category'] as String==categoriesListAll[7]
                                                      ?Icons.menu_book
                                                      :streamSnapshot.data?.docs[index]['category'] as String==categoriesListAll[8]
                                                      ?Icons.medical_information_outlined
                                                      :streamSnapshot.data?.docs[index]['category'] as String==categoriesListAll[0]
                                                      ?Icons.check_box
                                                      :Icons.new_label_sharp,
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
                                                    streamSnapshot.data?.docs[index]
                                                        ['category'],
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
                                              // SizedBox(
                                              //   height: MediaQuery.of(context)
                                              //       .size
                                              //       .height *
                                              //       0.3,
                                              // ),
                                              // Align(
                                              //   alignment: Alignment.bottomCenter,
                                              //   child: Center(
                                              //     child: Container(
                                              //       width: double.infinity,
                                              //       height: MediaQuery.of(context).size.height *
                                              //           0.075,
                                              //       decoration: BoxDecoration(
                                              //           color: Colors.white,
                                              //           borderRadius:
                                              //           BorderRadius.circular(24)),
                                              //       child: TextButton(
                                              //           child: Text(
                                              //             "Accept application",
                                              //             style: textButtonStyle,
                                              //           ),
                                              //           onPressed: () async {
                                              //             sendPushMessage();
                                              //             date = DateTime.now().toString();
                                              //             FirebaseFirestore.instance
                                              //                 .collection('applications')
                                              //                 .doc(streamSnapshot.data?.docs[index].id).update({"status": status_updated});
                                              //             FirebaseFirestore.instance
                                              //                 .collection('applications')
                                              //                 .doc(streamSnapshot.data?.docs[index].id).update({"volunteerID": volID});
                                              //             FirebaseFirestore.instance
                                              //                 .collection('applications')
                                              //                 .doc(streamSnapshot.data?.docs[index].id).update({"date": date});
                                              //             FirebaseFirestore.instance
                                              //                 .collection('applications')
                                              //                 .doc(streamSnapshot.data?.docs[index].id).update({"token_vol": token_vol});
                                              //             FirebaseFirestore.instance
                                              //                 .collection('applications')
                                              //                 .doc(streamSnapshot.data?.docs[index].id).update({"volunteer_name": currentNameVol});
                                              //
                                              //             FirebaseFirestore.instance
                                              //                 .collection('applications')
                                              //                 .doc(streamSnapshot.data?.docs[index].id).update({"application_accepted": true});
                                              //
                                              //
                                              //             Id_Of_current_application = streamSnapshot.data?.docs[index].id;
                                              //             ID_of_vol_application=streamSnapshot.data?.docs[index].id;
                                              //             Navigator.push(
                                              //               context,
                                              //               MaterialPageRoute(
                                              //                   builder: (context) => ApplicationsOfVolunteer()),
                                              //             );
                                              //           }),
                                              //     ),
                                              //   ),
                                              // ),
                                              // MaterialButton(
                                              //     child: Text("Accept",style: TextStyle(color: Colors.white),),
                                              //     color: Color.fromRGBO(18, 56, 79, 0.8),
                                              //
                                              //     onPressed: () {
                                              //       sendPushMessage();
                                              //       date = DateTime.now().toString();
                                              //       FirebaseFirestore.instance
                                              //           .collection('applications')
                                              //           .doc(streamSnapshot.data?.docs[index].id).update({"status": status_updated});
                                              //       FirebaseFirestore.instance
                                              //           .collection('applications')
                                              //           .doc(streamSnapshot.data?.docs[index].id).update({"volunteerID": volID});
                                              //       FirebaseFirestore.instance
                                              //           .collection('applications')
                                              //           .doc(streamSnapshot.data?.docs[index].id).update({"date": date});
                                              //       FirebaseFirestore.instance
                                              //           .collection('applications')
                                              //           .doc(streamSnapshot.data?.docs[index].id).update({"token_vol": token_vol});
                                              //       FirebaseFirestore.instance
                                              //           .collection('applications')
                                              //           .doc(streamSnapshot.data?.docs[index].id).update({"volunteer_name": currentNameVol});
                                              //
                                              //       FirebaseFirestore.instance
                                              //           .collection('applications')
                                              //           .doc(streamSnapshot.data?.docs[index].id).update({"application_accepted": true});
                                              //      //  FirebaseFirestore.instance
                                              //      //      .collection('applications')
                                              //      //      .doc(streamSnapshot.data?.docs[index].id).update({"Id": streamSnapshot.data?.docs[index].id});
                                              //      //  print(streamSnapshot.data?.docs[index].id);
                                              //      // print("AAAAAAAAAAA ${FirebaseFirestore.instance
                                              //      //  .collection('applications').doc().id}");
                                              //
                                              //
                                              //
                                              //      Id_Of_current_application = streamSnapshot.data?.docs[index].id;
                                              //      ID_of_vol_application=streamSnapshot.data?.docs[index].id;
                                              //       Navigator.push(
                                              //         context,
                                              //         MaterialPageRoute(
                                              //             builder: (context) => ApplicationsOfVolunteer()),
                                              //       );
                                              //
                                              // }
                                              // )
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: MediaQuery.of(context).size.height * 0.27,
                                      ),
                                      Align(
                                        alignment: Alignment.topCenter,
                                        child: Center(
                                          child: Container(
                                            width: double.infinity,
                                            height:
                                            MediaQuery.of(context).size.height *
                                                0.085,
                                            decoration: buttonActiveDecoration,
                                            child: TextButton(
                                                child: Text(
                                                  "Accept application",
                                                  style: textActiveButtonStyle,
                                                ),
                                                onPressed: () async {
                                                  sendPushMessageAccepted();
                                                  date = DateTime.now().toString();
                                                  FirebaseFirestore.instance
                                                      .collection('applications')
                                                      .doc(streamSnapshot
                                                      .data?.docs[index].id)
                                                      .update({
                                                    "status": status_updated
                                                  });
                                                  FirebaseFirestore.instance
                                                      .collection('applications')
                                                      .doc(streamSnapshot
                                                      .data?.docs[index].id)
                                                      .update(
                                                      {"volunteerID": volID});
                                                  FirebaseFirestore.instance
                                                      .collection('applications')
                                                      .doc(streamSnapshot
                                                      .data?.docs[index].id)
                                                      .update({"date": date});
                                                  FirebaseFirestore.instance
                                                      .collection('applications')
                                                      .doc(streamSnapshot
                                                      .data?.docs[index].id)
                                                      .update(
                                                      {"token_vol": tokenVol});
                                                  FirebaseFirestore.instance
                                                      .collection('applications')
                                                      .doc(streamSnapshot
                                                      .data?.docs[index].id)
                                                      .update({
                                                    "volunteer_name": currentNameVol
                                                  });

                                                  FirebaseFirestore.instance
                                                      .collection('applications')
                                                      .doc(streamSnapshot
                                                      .data?.docs[index].id)
                                                      .update({
                                                    "application_accepted": true
                                                  });

                                                  Id_Of_current_application =
                                                      streamSnapshot
                                                          .data?.docs[index].id;
                                                  ID_of_vol_application =
                                                      streamSnapshot
                                                          .data?.docs[index].id;
                                                  setState(() {
                                                    controllerTabBottomVol = PersistentTabController(initialIndex: 1);
                                                  });
                                                  Navigator.of(context, rootNavigator: true).pushReplacement(
                                                      MaterialPageRoute(builder: (context) => MainScreen()));
                                                }),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                            }

                          return Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: 100),
                              child: Column(
                                children: [
                                  // SpinKitChasingDots(
                                  //   color: Colors.brown,
                                  //   size: 50.0,
                                  // ),
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
              // SizedBox(
              //   height: MediaQuery.of(context).size.height * 0.015,
              // ),
              // SizedBox(
              //   height: MediaQuery.of(context).size.height * 0.1,
              //   child: StreamBuilder(
              //     stream: FirebaseFirestore.instance
              //         .collection('applications')
              //         .where('title', isEqualTo: card_title_vol)
              //         .where('category', isEqualTo: card_category_vol)
              //         .where('comment', isEqualTo: card_comment_vol)
              //         .snapshots(),
              //     builder:
              //         (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
              //       return ListView.builder(
              //           physics: NeverScrollableScrollPhysics(),
              //           shrinkWrap: true,
              //           itemCount: !streamSnapshot.hasData
              //               ? 1
              //               : streamSnapshot.data?.docs.length,
              //           itemBuilder: (ctx, index) {
              //             if (streamSnapshot.hasData) {
              //               switch (streamSnapshot.connectionState) {
              //                 case ConnectionState.waiting:
              //                   return Column(children: [
              //                     SizedBox(
              //                       width: 60,
              //                       height: 60,
              //                       child: CircularProgressIndicator(),
              //                     ),
              //                     Padding(
              //                       padding: EdgeInsets.only(top: 16),
              //                       child: Text('Awaiting data...'),
              //                     )
              //                   ]);
              //                 case ConnectionState.active:
              //                   return Padding(
              //                     padding: padding,
              //                     child:
              //                         // Column(
              //                         //   children: [
              //                         // SizedBox(
              //                         //   height: MediaQuery.of(context)
              //                         //       .size
              //                         //       .height *
              //                         //       0.1,
              //                         // ),
              //                         // Align(
              //                         //   alignment: Alignment.topLeft,
              //                         //   child: Text(
              //                         //     // "Title",
              //                         //     streamSnapshot.data?.docs[index]['title'],
              //                         //     style: GoogleFonts.raleway(
              //                         //       fontSize: 18,
              //                         //       color: Colors.black,
              //                         //     ),
              //                         //   ),
              //                         // ),
              //                         // SizedBox(
              //                         //   height: MediaQuery.of(context)
              //                         //       .size
              //                         //       .height *
              //                         //       0.015,
              //                         // ),
              //                         // Align(
              //                         //   alignment: Alignment.topLeft,
              //                         //   child: Text(
              //                         //       streamSnapshot.data?.docs[index]['category'],
              //                         //       style: GoogleFonts.raleway(
              //                         //         fontSize: 14,
              //                         //         color: Colors.black,
              //                         //       )),
              //                         // ),
              //                         // SizedBox(
              //                         //   height: MediaQuery.of(context)
              //                         //       .size
              //                         //       .height *
              //                         //       0.1,
              //                         // ),
              //                         // Align(
              //                         //   alignment: Alignment.topLeft,
              //                         //   child: Text(streamSnapshot.data?.docs[index]['comment'],
              //                         //     style: GoogleFonts.raleway(
              //                         //       fontSize: 14,
              //                         //       color: Colors.black,
              //                         //     ),
              //                         //   ),
              //                         // ),
              //                         // SizedBox(
              //                         //   height: MediaQuery.of(context)
              //                         //       .size
              //                         //       .height *
              //                         //       0.3,
              //                         // ),
              //                         Align(
              //                       alignment: Alignment.topCenter,
              //                       child: Center(
              //                         child: Container(
              //                           width: double.infinity,
              //                           height:
              //                               MediaQuery.of(context).size.height *
              //                                   0.085,
              //                           decoration: BoxDecoration(
              //                               color: Colors.white,
              //                               borderRadius:
              //                                   BorderRadius.circular(24)),
              //                           child: TextButton(
              //                               child: Text(
              //                                 "Accept application",
              //                                 style: textButtonStyle,
              //                               ),
              //                               onPressed: () async {
              //                                 sendPushMessage();
              //                                 date = DateTime.now().toString();
              //                                 FirebaseFirestore.instance
              //                                     .collection('applications')
              //                                     .doc(streamSnapshot
              //                                         .data?.docs[index].id)
              //                                     .update({
              //                                   "status": status_updated
              //                                 });
              //                                 FirebaseFirestore.instance
              //                                     .collection('applications')
              //                                     .doc(streamSnapshot
              //                                         .data?.docs[index].id)
              //                                     .update(
              //                                         {"volunteerID": volID});
              //                                 FirebaseFirestore.instance
              //                                     .collection('applications')
              //                                     .doc(streamSnapshot
              //                                         .data?.docs[index].id)
              //                                     .update({"date": date});
              //                                 FirebaseFirestore.instance
              //                                     .collection('applications')
              //                                     .doc(streamSnapshot
              //                                         .data?.docs[index].id)
              //                                     .update(
              //                                         {"token_vol": token_vol});
              //                                 FirebaseFirestore.instance
              //                                     .collection('applications')
              //                                     .doc(streamSnapshot
              //                                         .data?.docs[index].id)
              //                                     .update({
              //                                   "volunteer_name": currentNameVol
              //                                 });
              //
              //                                 FirebaseFirestore.instance
              //                                     .collection('applications')
              //                                     .doc(streamSnapshot
              //                                         .data?.docs[index].id)
              //                                     .update({
              //                                   "application_accepted": true
              //                                 });
              //
              //                                 Id_Of_current_application =
              //                                     streamSnapshot
              //                                         .data?.docs[index].id;
              //                                 ID_of_vol_application =
              //                                     streamSnapshot
              //                                         .data?.docs[index].id;
              //                                 Navigator.push(
              //                                   context,
              //                                   MaterialPageRoute(
              //                                       builder: (context) =>
              //                                           ApplicationsOfVolunteer()),
              //                                 );
              //                               }),
              //                         ),
              //                       ),
              //                     ),
              //                     // MaterialButton(
              //                     //     child: Text("Accept",style: TextStyle(color: Colors.white),),
              //                     //     color: Color.fromRGBO(18, 56, 79, 0.8),
              //                     //
              //                     //     onPressed: () {
              //                     //       sendPushMessage();
              //                     //       date = DateTime.now().toString();
              //                     //       FirebaseFirestore.instance
              //                     //           .collection('applications')
              //                     //           .doc(streamSnapshot.data?.docs[index].id).update({"status": status_updated});
              //                     //       FirebaseFirestore.instance
              //                     //           .collection('applications')
              //                     //           .doc(streamSnapshot.data?.docs[index].id).update({"volunteerID": volID});
              //                     //       FirebaseFirestore.instance
              //                     //           .collection('applications')
              //                     //           .doc(streamSnapshot.data?.docs[index].id).update({"date": date});
              //                     //       FirebaseFirestore.instance
              //                     //           .collection('applications')
              //                     //           .doc(streamSnapshot.data?.docs[index].id).update({"token_vol": token_vol});
              //                     //       FirebaseFirestore.instance
              //                     //           .collection('applications')
              //                     //           .doc(streamSnapshot.data?.docs[index].id).update({"volunteer_name": currentNameVol});
              //                     //
              //                     //       FirebaseFirestore.instance
              //                     //           .collection('applications')
              //                     //           .doc(streamSnapshot.data?.docs[index].id).update({"application_accepted": true});
              //                     //      //  FirebaseFirestore.instance
              //                     //      //      .collection('applications')
              //                     //      //      .doc(streamSnapshot.data?.docs[index].id).update({"Id": streamSnapshot.data?.docs[index].id});
              //                     //      //  print(streamSnapshot.data?.docs[index].id);
              //                     //      // print("AAAAAAAAAAA ${FirebaseFirestore.instance
              //                     //      //  .collection('applications').doc().id}");
              //                     //
              //                     //
              //                     //
              //                     //      Id_Of_current_application = streamSnapshot.data?.docs[index].id;
              //                     //      ID_of_vol_application=streamSnapshot.data?.docs[index].id;
              //                     //       Navigator.push(
              //                     //         context,
              //                     //         MaterialPageRoute(
              //                     //             builder: (context) => ApplicationsOfVolunteer()),
              //                     //       );
              //                     //
              //                     // }
              //                     // )
              //                     //   ],
              //                     // ),
              //                   );
              //               }
              //             }
              //             return Center(
              //               child: Padding(
              //                 padding: EdgeInsets.only(top: 10),
              //                 child: Column(
              //                   children: [
              //                     SpinKitChasingDots(
              //                       color: Colors.brown,
              //                       size: 50.0,
              //                     ),
              //                     Align(
              //                       alignment: Alignment.center,
              //                       child: Text("Waiting...",
              //                           style: TextStyle(
              //                             fontWeight: FontWeight.bold,
              //                             fontSize: 24,
              //                             color: Colors.black,
              //                           )),
              //                     ),
              //                     Padding(
              //                       padding: EdgeInsets.only(top: 20),
              //                     )
              //                   ],
              //                 ),
              //               ),
              //             );
              //           });
              //     },
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
