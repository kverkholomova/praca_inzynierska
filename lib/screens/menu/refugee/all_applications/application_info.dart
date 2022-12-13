import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:wol_pro_1/screens/menu/refugee/main_screen_ref.dart';
import 'package:wol_pro_1/to_delete/messages_ref.dart';
import 'package:wol_pro_1/to_delete/pageWithChats.dart';
import 'package:wol_pro_1/Refugee/rating.dart';
import 'package:wol_pro_1/screens/info_volunteer_accepted_application.dart';

import '../../../../constants.dart';
import '../../../../models/categories.dart';
import '../../volunteer/main_screen.dart';
import '../accepted_applications/accepted_applications.dart';
import '../home_page/home_ref.dart';
import 'all_app_ref.dart';

String IDVolOfApplication = '';
// String? token;
final FirebaseFirestore _db = FirebaseFirestore.instance;
final FirebaseMessaging _fcm = FirebaseMessaging.instance;

class PageOfApplicationRef extends StatefulWidget {
  const PageOfApplicationRef({Key? key}) : super(key: key);

  @override
  State<PageOfApplicationRef> createState() => _PageOfApplicationRefState();
}

class _PageOfApplicationRefState extends State<PageOfApplicationRef> {
  late AndroidNotificationChannel channel;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  String? token = " ";

  @override
  void initState() {
    super.initState();

    requestPermission();

    loadFCM();

    listenFCM();

    // getToken();

    // FirebaseMessaging.instance.subscribeToTopic("Animal");
  }

  void sendPushMessage() async {
    print("SSSSSSSSSSSSSSSSSSSsEEEEEEEEEENNNNNNNNNNNNNNNNNNNNDDDDDDDDDDDDDDDDDDDDD");
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
              'body': 'The application was deleted by refugee, so your help is not necessary anymore.',
              'title': 'Refugee deleted an application'
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            "to": "$token_vol",
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
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        setState(() {
          controllerTabBottomRef = PersistentTabController(initialIndex: 4);
        });
        Navigator.of(context, rootNavigator: true).pushReplacement(
            MaterialPageRoute(builder: (context) => new AllApplicationsRef()));
        return true;
      },
      child: Scaffold(
        backgroundColor: background,
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        floatingActionButton: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 30,
            color: blueColor,
          ),
          onPressed: () {
            setState(() {
              controllerTabBottomRef = PersistentTabController(initialIndex: 4);
            });
            Navigator.of(context, rootNavigator: true).pushReplacement(
                MaterialPageRoute(builder: (context) => AllApplicationsRef()));

          },
        ),
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

                      .where('Id', isEqualTo: applicationIDRef)
                      // .where('category', isEqualTo: card_category_ref)
                      // .where('comment', isEqualTo: card_comment_ref)
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
                          if (streamSnapshot.hasData) {
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
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: MediaQuery.of(context).size.height * 0.02),
                                        child: Align(
                                          alignment: Alignment.topCenter,
                                          child: Text(
                                            "Application details",
                                            style: GoogleFonts.raleway(
                                              fontSize: 18,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: MediaQuery.of(context).size.height * 0.05,
                                      ),
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
                                            decoration: buttonInactiveDecoration,
                                            child: TextButton(
                                                child: Text(
                                                  "Delete",
                                                  style: textInactiveButtonStyle,
                                                ),
                                                onPressed: () async {
                                                  sendPushMessage();
                                                  FirebaseFirestore.instance
                                                                                    .collection('applications')
                                                                                    .doc(streamSnapshot.data?.docs[index].id).delete();
                                                  setState(() {
                                                    controllerTabBottomRef = PersistentTabController(initialIndex: 4);
                                                  });
                                                  Navigator.of(context, rootNavigator: true).pushReplacement(
                                                      MaterialPageRoute(builder: (context) => MainScreenRefugee()));
                                                }),
                                          ),
                                        ),
                                      ),

                          // Padding(
                          //                       padding: const EdgeInsets.only(top: 20),
                          //                       child: SizedBox(
                          //                         height: 50,
                          //                         width: 300,
                          //                         child: MaterialButton(
                          //                             child: Text(
                          //                               "Delete",
                          //                               style: TextStyle(color: Colors.white),
                          //                             ),
                          //                             color: Color.fromRGBO(18, 56, 79, 0.8),
                          //                             onPressed: () {
                          //
                          //
                          //                               sendPushMessage();
                          //
                          //                               FirebaseFirestore.instance
                          //                                   .collection('applications')
                          //                                   .doc(streamSnapshot.data?.docs[index].id)
                          //                                   .update({"status": "deleted"});
                          //
                          //
                          //                             }),
                          //                       ),
                          //                     ),
                          //                     Padding(
                          //                       padding: const EdgeInsets.only(top: 10, bottom: 10),
                          //                       child: SizedBox(
                          //                         height: 50,
                          //                         width: 300,
                          //                         child: MaterialButton(
                          //                             child: Text(
                          //                               "Look info about volunteer",
                          //                               style: TextStyle(color: Colors.white),
                          //                             ),
                          //                             color: Color.fromRGBO(18, 56, 79, 0.8),
                          //                             onPressed: () {
                          //                               IDVolOfApplication = streamSnapshot
                          //                                   .data?.docs[index]['volunteerID'] as String;
                          //                               print(IDVolOfApplication);
                          //                               print(
                          //                                   "SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS");
                          //
                          //                               Navigator.push(
                          //                                 context,
                          //                                 MaterialPageRoute(
                          //                                     builder: (context) =>
                          //                                         PageOfVolunteerRef()),
                          //                               );
                          //                             }),
                          //                       ),
                          //                     ),
                          //                     // Visibility(
                          //                     //   visible: streamSnapshot.data?.docs[index]["application_accepted"],
                          //                     //   child:
                          //                       Padding(
                          //                         padding: const EdgeInsets.only(top: 10, bottom: 10),
                          //                         child: SizedBox(
                          //                           height: 50,
                          //                           width: 300,
                          //                           child: MaterialButton(
                          //                               child: Text(
                          //                                 "Mark application as done",
                          //                                 style: TextStyle(color: Colors.white),
                          //                               ),
                          //                               color: Color.fromRGBO(18, 56, 79, 0.8),
                          //                               onPressed: () {
                          //                                 IDVolOfApplication = streamSnapshot
                          //                                     .data?.docs[index]['volunteerID'] as String;
                          //                                 print(IDVolOfApplication);
                          //                                 print(
                          //                                     "SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS");
                          //
                          //                                 Navigator.push(
                          //                                   context,
                          //                                   MaterialPageRoute(
                          //                                       builder: (context) =>
                          //                                           Rating_Page()),
                          //                                 );
                          //                               }),
                          //                         ),
                          //                       ),
                                    ],
                                  ),
                                );
                            }
                          }
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: 100),
                              child: Column(
                                children: [
                                  SpinKitChasingDots(
                                    color: Colors.brown,
                                    size: 50.0,
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text("Waiting...",
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
  // @override
  // Widget build(BuildContext context) {
  //   return WillPopScope(
  //     onWillPop: () async {
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (context) => CategoriesRef()),
  //       );
  //       return true;
  //     },
  //     child: Scaffold(
  //       backgroundColor: background,
  //       // appBar: AppBar(
  //       //   backgroundColor: Color.fromRGBO(49, 72, 103, 0.8),
  //       //   elevation: 0.0,
  //       //   title: Text(
  //       //     'Application Info',
  //       //     style: TextStyle(fontSize: 16),
  //       //   ),
  //       //   leading: IconButton(
  //       //     icon: const Icon(Icons.arrow_back,color: Colors.white,),
  //       //     onPressed: () async {
  //       //       // await _auth.signOut();
  //       //       Navigator.push(
  //       //         context,
  //       //         MaterialPageRoute(builder: (context) => CategoriesRef()),
  //       //       );
  //       //     },
  //       //   ),
  //       // ),
  //       body: StreamBuilder (
  //         stream: FirebaseFirestore.instance
  //             .collection('applications')
  //             .where('title', isEqualTo: card_title_ref)
  //             .where('category', isEqualTo: card_category_ref)
  //             .where('comment', isEqualTo: card_comment_ref)
  //             .snapshots(),
  //         builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
  //           return ListView.builder(
  //               itemCount: !streamSnapshot.hasData? 1:streamSnapshot.data?.docs.length,
  //               itemBuilder: (ctx, index) {
  //
  //                 User? user = FirebaseAuth.instance.currentUser;
  //                 final docId = streamSnapshot.data!.docs[index]["volunteerID"];
  //                 print("IIIIIIIIIIIIIIII_______________HHHHHHHHHHHHHHH");
  //                 print(streamSnapshot.data?.docs[index]['title']);
  //                 if (streamSnapshot.hasData){
  //                   switch (streamSnapshot.connectionState){
  //                     case ConnectionState.waiting:
  //                       return  Column(
  //                         children: [
  //                           SizedBox(
  //                           width: 60,
  //                           height: 60,
  //                           child: CircularProgressIndicator(),
  //                           ),
  //                           Padding(
  //                           padding: EdgeInsets.only(top: 16),
  //                           child: Text('Awaiting data...'),
  //                           )
  //                 ]
  //
  //                 );
  //
  //                 case ConnectionState.active:
  //                 return Column(
  //                   children: [
  //                     Padding(
  //                       padding: const EdgeInsets.only(top: 30,left: 10,right: 10,bottom: 10),
  //                       child: Align(
  //                         alignment: Alignment.topLeft,
  //                         child: Text(
  //                           streamSnapshot.data?.docs[index]['title'],
  //                           style: TextStyle(
  //                             fontWeight: FontWeight.bold,
  //                             fontSize: 18,
  //                             color: Colors.black,
  //                           ),
  //                           textAlign: TextAlign.center,
  //                         ),
  //                       ),
  //                     ),
  //                     Padding(
  //                       padding: const EdgeInsets.all(10.0),
  //                       child: Align(
  //                         alignment: Alignment.topLeft,
  //                         child: Text(
  //                           streamSnapshot.data?.docs[index]['status'],
  //                           style: TextStyle(
  //                             fontWeight: FontWeight.bold,
  //                             fontSize: 14,
  //                             color: Colors.grey,
  //                           ),
  //                           textAlign: TextAlign.center,
  //                         ),
  //                       ),
  //                     ),
  //                     Padding(
  //                       padding: const EdgeInsets.all(10.0),
  //                       child: Align(
  //                         alignment: Alignment.topLeft,
  //                         child: Text(
  //                           streamSnapshot.data?.docs[index]['category'],
  //                           style: TextStyle(color: Colors.grey, fontSize: 14),
  //                           textAlign: TextAlign.center,
  //                         ),
  //                       ),
  //                     ),
  //                     Padding(
  //                       padding: const EdgeInsets.all(10.0),
  //                       child: Align(
  //                         alignment: Alignment.topLeft,
  //                         child: Text(
  //                           streamSnapshot.data?.docs[index]['comment'],
  //                           style: TextStyle(color: Colors.black, fontSize: 15),
  //                           textAlign: TextAlign.center,
  //                         ),
  //                       ),
  //                     ),
  //                     Padding(
  //                       padding: const EdgeInsets.all(10.0),
  //                       child: Align(
  //                         alignment: Alignment.topLeft,
  //                         child: Text(
  //                           streamSnapshot.data?.docs[index]['date'],
  //                           style: TextStyle(
  //                             fontWeight: FontWeight.bold,
  //                             fontSize: 12,
  //                             color: Colors.grey[900],
  //                           ),
  //                           textAlign: TextAlign.center,
  //                         ),
  //                       ),
  //                     ),
  //                     Visibility(
  //                       visible: streamSnapshot.data?.docs[index]["mess_button_visibility_ref"],
  //                       child: Padding(
  //                         padding: const EdgeInsets.only(top: 20, bottom: 10),
  //                         child: SizedBox(
  //                           height: 50,
  //                           width: 300,
  //                           child: MaterialButton(
  //                               child: Text(
  //                                 "Message",
  //                                 style: TextStyle(color: Colors.white),
  //                               ),
  //                               color: Color.fromRGBO(18, 56, 79, 0.8),
  //                               onPressed: () {
  //                                 FirebaseFirestore.instance
  //                                     .collection('applications')
  //                                     .doc(
  //                                     streamSnapshot.data?.docs[index].id)
  //                                     .update({"mess_button_visibility_ref": false});
  //                                // IdOfChatroomRef = streamSnapshot.data?.docs[index]['chatId_vol'];
  //                                   // Navigator.push(
  //                                   //   context,
  //                                   //   MaterialPageRoute(
  //                                   //       builder: (context) =>
  //                                   //           SelectedChatroom_Ref()),
  //                                   // );
  //
  //
  //                                 //}
  //                               }),
  //                         ),
  //                       ),
  //                     ),
  //                     Padding(
  //                       padding: const EdgeInsets.only(top: 20),
  //                       child: SizedBox(
  //                         height: 50,
  //                         width: 300,
  //                         child: MaterialButton(
  //                             child: Text(
  //                               "Delete",
  //                               style: TextStyle(color: Colors.white),
  //                             ),
  //                             color: Color.fromRGBO(18, 56, 79, 0.8),
  //                             onPressed: () {
  //
  //
  //                               sendPushMessage();
  //
  //                               FirebaseFirestore.instance
  //                                   .collection('applications')
  //                                   .doc(streamSnapshot.data?.docs[index].id)
  //                                   .update({"status": "deleted"});
  //
  //
  //                             }),
  //                       ),
  //                     ),
  //                     Padding(
  //                       padding: const EdgeInsets.only(top: 10, bottom: 10),
  //                       child: SizedBox(
  //                         height: 50,
  //                         width: 300,
  //                         child: MaterialButton(
  //                             child: Text(
  //                               "Look info about volunteer",
  //                               style: TextStyle(color: Colors.white),
  //                             ),
  //                             color: Color.fromRGBO(18, 56, 79, 0.8),
  //                             onPressed: () {
  //                               IDVolOfApplication = streamSnapshot
  //                                   .data?.docs[index]['volunteerID'] as String;
  //                               print(IDVolOfApplication);
  //                               print(
  //                                   "SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS");
  //
  //                               Navigator.push(
  //                                 context,
  //                                 MaterialPageRoute(
  //                                     builder: (context) =>
  //                                         PageOfVolunteerRef()),
  //                               );
  //                             }),
  //                       ),
  //                     ),
  //                     // Visibility(
  //                     //   visible: streamSnapshot.data?.docs[index]["application_accepted"],
  //                     //   child:
  //                       Padding(
  //                         padding: const EdgeInsets.only(top: 10, bottom: 10),
  //                         child: SizedBox(
  //                           height: 50,
  //                           width: 300,
  //                           child: MaterialButton(
  //                               child: Text(
  //                                 "Mark application as done",
  //                                 style: TextStyle(color: Colors.white),
  //                               ),
  //                               color: Color.fromRGBO(18, 56, 79, 0.8),
  //                               onPressed: () {
  //                                 IDVolOfApplication = streamSnapshot
  //                                     .data?.docs[index]['volunteerID'] as String;
  //                                 print(IDVolOfApplication);
  //                                 print(
  //                                     "SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS");
  //
  //                                 Navigator.push(
  //                                   context,
  //                                   MaterialPageRoute(
  //                                       builder: (context) =>
  //                                           Rating_Page()),
  //                                 );
  //                               }),
  //                         ),
  //                       ),
  //                     // )
  //                   ],
  //                 );}}
  //                 return Center(
  //                   child: Padding(padding: EdgeInsets.only(top: 100),
  //                     child: Column(
  //                       children: [
  //                         SpinKitChasingDots(
  //                           color: Colors.brown,
  //                           size: 50.0,
  //                         ),
  //                         Align(
  //                           alignment: Alignment.center,
  //                           child: Text(
  //                               "Waiting...",
  //                               style: TextStyle(
  //                                 fontWeight: FontWeight.bold,fontSize: 24,color: Colors.black,)
  //                           ),
  //                         ),
  //                         Padding(padding: EdgeInsets.only(top: 20),)
  //                       ],
  //                     ),
  //                   ),
  //                 );
  //               });
  //         },
  //       ),
  //     ),
  //   );
  // }
}