import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:wol_pro_1/constants.dart';
import 'package:wol_pro_1/screens/menu/volunteer/all_applications/page_of_application_vol.dart';
import 'package:wol_pro_1/volunteer/chat/message.dart';
import 'package:http/http.dart' as http;

import '../../../../Refugee/SettingRefugee.dart';
import '../main_screen.dart';
import 'applications_vol.dart';

String roomExist ='';
// bool isvisible = true;

String? IdOfChatroom = '';

String VoluntterName = '';
String RefugeeName = '';

class SettingsOfApplication extends StatefulWidget {
  const SettingsOfApplication({Key? key}) : super(key: key);

  @override
  State<SettingsOfApplication> createState() => _SettingsOfApplicationState();
}

// List<String> users_chat = [];
// var ID_of_vol_application;
// String? appId = '';

class _SettingsOfApplicationState extends State<SettingsOfApplication> {

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

    FirebaseMessaging.instance.subscribeToTopic("Animal");
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
              'body': 'Volunteer has decided to decline your application',
              'title': 'Acceptance decline'
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            "to": "$token_ref",
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

  String status_declined = 'Sent to volunteer';
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        setState(() {
          controllerTabBottom = PersistentTabController(initialIndex: 1);
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
            color: blueColor,
          ),
          onPressed: () {
            setState(() {
              controllerTabBottom = PersistentTabController(initialIndex: 1);
            });
            Navigator.of(context, rootNavigator: true).pushReplacement(
                MaterialPageRoute(builder: (context) => MainScreen()));

          },
        ),
        // appBar: AppBar(
        //   backgroundColor: Color.fromRGBO(49, 72, 103, 0.8),
        //   elevation: 0.0,
        //   title: Text(
        //     'Application Info',
        //     style: TextStyle(fontSize: 16),
        //   ),
        //   leading: IconButton(onPressed: () {
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(builder: (context) => ApplicationsOfVolunteer()),
        //     );
        //   }, icon: Icon(Icons.arrow_back),
        //
        //   ),
        // ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('applications')
          // .where('Id', isEqualTo: Id_Of_current_application)
              .where('title', isEqualTo: card_title_accepted)
              .where('category', isEqualTo: card_category_accepted)
              .where('comment', isEqualTo: card_comment_accepted)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            return ListView.builder(
                itemCount: !streamSnapshot.hasData? 1:streamSnapshot.data?.docs.length,
                itemBuilder: (ctx, index) {
                if (streamSnapshot.hasData){
                  switch (streamSnapshot.connectionState){
                    case ConnectionState.waiting:
                      return  Column(
                      children: [
                        SizedBox(
                        width: 60,
                        height: 60,
                        child: CircularProgressIndicator(),
                        ),
                        Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Text('Awaiting data...'),
                        )
                  ]

                );

                case ConnectionState.active:
                return Column(
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
                          height:
                          MediaQuery.of(context).size.height * 0.05,
                        ),
                        Padding(
                          padding: padding,
                          child: Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height *
                                0.7,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                BorderRadius.circular(24)),
                            child: Padding(
                              padding: padding,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: MediaQuery.of(context)
                                        .size
                                        .height *
                                        0.1,
                                  ),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      // "Title",
                                      streamSnapshot.data?.docs[index]['title'],
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
                                        0.015,
                                  ),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                        streamSnapshot.data?.docs[index]['category'],
                                        style: GoogleFonts.raleway(
                                          fontSize: 14,
                                          color: Colors.black,
                                        )),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context)
                                        .size
                                        .height *
                                        0.1,
                                  ),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Text(streamSnapshot.data?.docs[index]['comment'],
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
                        ),
                        SizedBox(
                          height:
                          MediaQuery.of(context).size.height * 0.015,
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.only(top: 20, left: 10),
                        //   child: Align(
                        //     alignment: Alignment.topLeft,
                        //     child: Text(
                        //       streamSnapshot.data?.docs[index]['title'],
                        //       // "Title",
                        //       style: TextStyle(
                        //         fontWeight: FontWeight.bold,
                        //         fontSize: 20,
                        //         color: Colors.black,
                        //       ),
                        //       textAlign: TextAlign.center,
                        //     ),
                        //   ),
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.only(left: 10),
                        //   child: Align(
                        //     alignment: Alignment.topLeft,
                        //     child: Text(
                        //       streamSnapshot.data?.docs[index]['category'],
                        //       style: TextStyle(color: Colors.grey, fontSize: 16),
                        //       textAlign: TextAlign.center,
                        //     ),
                        //   ),
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.only(top: 15, left: 10),
                        //   child: Align(
                        //     alignment: Alignment.topLeft,
                        //     child: Text(
                        //       streamSnapshot.data?.docs[index]['comment'],
                        //       style:
                        //           TextStyle(color: Colors.grey, fontSize: 14),
                        //       textAlign: TextAlign.center,
                        //     ),
                        //   ),
                        // ),
                        Padding(
                          padding: padding,
                          child: Visibility(
                            visible: streamSnapshot.data?.docs[index]["mess_button_visibility_vol"],
                            child: Container(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height *
                                  0.085,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                  BorderRadius.circular(24)),
                              child: TextButton(
                                  child: Text(
                                    "Message",
                                    style: textButtonStyle,
                                  ),
                                  onPressed: () {
                                    print(
                                        "JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ");
                                    // print(users_chat);
                                    // appId = streamSnapshot.data?.docs[index].id;


                                     if (streamSnapshot.data?.docs[index]["chatId_vol"] == "null"){
                                       IdOfChatroom = FirebaseFirestore.instance.collection('USERS_COLLECTION').doc().id;
                                       print("PPPPPPPPPPPPPPPPPPPOOOOOOOOOOOOOOOOWWWWWWWWWWWWWWWWWWWWW");
                                       print(IdOfChatroom);
                                       FirebaseFirestore.instance
                                           .collection('USERS_COLLECTION')
                                           .doc(IdOfChatroom)
                                           .set({
                                         'IdVolunteer': streamSnapshot
                                             .data?.docs[index]['volunteerID'],
                                         'IdRefugee': streamSnapshot
                                             .data?.docs[index]["userID"],
                                         'chatId': IdOfChatroom,
                                         'Refugee_Name': streamSnapshot
                                             .data?.docs[index]['refugee_name'],
                                         'Volunteer_Name': streamSnapshot
                                             .data?.docs[index]['volunteer_name'],
                                         'Id_Of_Chat': "null"
                                       });

                                       // FirebaseFirestore.instance
                                       //     .collection('users')
                                       //     .doc(
                                       //     streamSnapshot.data?.docs[index]["userID"])
                                       //     .set({"chatId_exist": IdOfChatroom});

                                       FirebaseFirestore.instance
                                           .collection('applications')
                                           .doc(
                                           streamSnapshot.data?.docs[index].id)
                                           .update({"chatId_vol": IdOfChatroom});
                                       // VoluntterName = FirebaseFirestore.instance.collection("users").doc(users_chat[1]).get() as String;
                                       // RefugeeName = FirebaseFirestore.instance.collection("users").where("id_vol", isEqualTo: users_chat[0]).get() as String;
                                       Navigator.push(
                                         context,
                                         MaterialPageRoute(
                                             builder: (context) =>
                                                 SelectedChatroom()),
                                       );
                                     }
                                    //LOOOOK HEEEEREEEEE
                                     FirebaseFirestore.instance
                                        .collection('applications')
                                        .doc(
                                        streamSnapshot.data?.docs[index].id)
                                        .update({"mess_button_visibility_vol": false});

                                    FirebaseFirestore.instance
                                        .collection('applications')
                                        .doc(
                                        streamSnapshot.data?.docs[index].id)
                                        .update({"mess_button_visibility_ref": true});


                                    // VoluntterName = FirebaseFirestore.instance.collection("users").where("id_vol", isEqualTo: users_chat[1]) as String?;
                                    // RefugeeName = FirebaseFirestore.instance.collection("users").where("id_vol", isEqualTo: users_chat[0]) as String?;
                                  }
                                  ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height:
                          MediaQuery.of(context).size.height * 0.015,
                        ),
                        Padding(
                          padding: padding,
                          child: Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height *
                                0.085,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                BorderRadius.circular(24)),
                            child: TextButton(
                                child: Text(
                                  "Decline",
                                  style: textButtonStyle,
                                ),

                                onPressed: () {
                                  sendPushMessage();
                                  FirebaseFirestore.instance
                                      .collection('applications')
                                      .doc(
                                          streamSnapshot.data?.docs[index].id)
                                      .update({"status": status_declined,
                                    "chatId_vol": "null",
                                    "date": "null"
                                  });

                                  FirebaseFirestore.instance
                                      .collection('applications')
                                      .doc(
                                      streamSnapshot.data?.docs[index].id)
                                      .update({"mess_button_visibility_ref": false});
                                  FirebaseFirestore.instance
                                      .collection('applications')
                                      .doc(
                                      streamSnapshot.data?.docs[index].id)
                                      .update({"mess_button_visibility_vol": true});
                                  FirebaseFirestore.instance
                                      .collection('applications')
                                      .doc(
                                      streamSnapshot.data?.docs[index].id)
                                      .update({"token_vol": "null"});
                                  FirebaseFirestore.instance
                                      .collection('applications')
                                      .doc(
                                      streamSnapshot.data?.docs[index].id)
                                      .update({"volunteerID": "null"});
                                  FirebaseFirestore.instance
                                      .collection('applications')
                                      .doc(
                                      streamSnapshot.data?.docs[index].id)
                                      .update({"volunteer_name": "null"});

                                  print(streamSnapshot.data?.docs[index].id);
                                  print(
                                      "AAAAAAAAAAA ${FirebaseFirestore.instance.collection('applications').doc().id}");

                                  ID_of_vol_application =
                                      streamSnapshot.data?.docs[index].id;
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ApplicationsOfVolunteer()),
                                  );
                                }),
                          ),
                        )
                      ],
                    );}}
                return Center(
                  child: Padding(padding: EdgeInsets.only(top: 100),
                    child: Column(
                      children: [
                        SpinKitChasingDots(
                          color: Colors.brown,
                          size: 50.0,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                              "Waiting...",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,fontSize: 24,color: Colors.black,)
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(top: 20),)
                      ],
                    ),
                  ),
                );
                });
          },
        ),
      ),
    );
  }
}
