import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:wol_pro_1/constants.dart';
import 'package:http/http.dart' as http;
import 'package:wol_pro_1/screens/menu/volunteer/messages/messagesVol.dart';
import 'package:wol_pro_1/screens/menu/volunteer/messages/pageWithChatsVol.dart';
import '../../../../models/categories.dart';
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

    // requestPermission();
    //
    // loadFCM();
    //
    // listenFCM();

    // getToken();

    // FirebaseMessaging.instance.subscribeToTopic("Animal");
  }

  // void sendPushMessageDeletedByVol() async {
  //   print(
  //       "SSSSSSSSSSSSSSSSSSSsEEEEEEEEEENNNNNNNNNNNNNNNNNNNNDDDDDDDDDDDDDDDDDDDDD");
  //   try {
  //     await http.post(
  //       Uri.parse('https://fcm.googleapis.com/fcm/send'),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json',
  //         'Authorization':
  //         'key = AAAADY1uR1I:APA91bEruiKUQtfsFz0yWjEovi9GAF9nkGYfmW9H2lU6jrtdCGw2C1ZdEczYXvovHMPqQBYSrDnYsbhsyk-kcCBi6Wht_YrGcSKXw4vk0UUNRlwN9UdM_4rhmf_6hd_xyAXbBsgyx12L  ',
  //       },
  //       body: jsonEncode(
  //         <String, dynamic>{
  //           'notification': <String, dynamic>{
  //             'body':
  //             'The application was deleted by refugee, so your help is not necessary anymore.',
  //             'title': 'Refugee deleted an application'
  //           },
  //           'priority': 'high',
  //           'data': <String, dynamic>{
  //             'click_action': 'FLUTTER_NOTIFICATION_CLICK',
  //             'id': '1',
  //             'status': 'done'
  //           },
  //           "to": "$tokenVolInfoAccepted",
  //         },
  //       ),
  //     );
  //   } catch (e) {
  //     print("error push notification");
  //   }
  // }

  void sendPushMessage() async {
    print(
        "SSSSSSSSSSSSSSSSSSSsEEEEEEEEEENNNNNNNNNNNNNNNNNNNNDDDDDDDDDDDDDDDDDDDDD volunteer decliiined");
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
            'notification':

            <String, dynamic>{
              'body':
              'The volunteer has declined your application.',
              'title': 'Your application was declined by volunteer'
            },
            'sound': 'default',
            'priority': 'high',
            // 'data': {
            //   'title': 'Refugee deleted an application',
            //   'body': 'The application was deleted by refugee, so your help is not necessary anymore.',
            // },

            // <String, dynamic>{
            //   'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            //   'id': '1',
            //   'status': 'done'
            // },
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

  void foregroundMessage(){
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });
  }
  // void sendPushMessageDeclinedApplication() async {
  //   print(
  //       "SSSSSSSSSSSSSSSSSSSsEEEEEEEEEENNNNNNNNNNNNNNNNNNNNDDDDDDDDDDDDDDDDDDDDD");
  //   try {
  //     await http.post(
  //       Uri.parse('https://fcm.googleapis.com/fcm/send'),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json',
  //         'Authorization':
  //             'key = AAAADY1uR1I:APA91bEruiKUQtfsFz0yWjEovi9GAF9nkGYfmW9H2lU6jrtdCGw2C1ZdEczYXvovHMPqQBYSrDnYsbhsyk-kcCBi6Wht_YrGcSKXw4vk0UUNRlwN9UdM_4rhmf_6hd_xyAXbBsgyx12L',
  //       },
  //       body: jsonEncode(
  //         <String, dynamic>{
  //           'notification': <String, dynamic>{
  //             'body': 'The volunteer has declined your application. Your application has sent to other volunteers.',
  //             'title': 'Application is declined by volunteer'
  //           },
  //           'priority': 'high',
  //           'data': <String, dynamic>{
  //             'click_action': 'FLUTTER_NOTIFICATION_CLICK',
  //             'id': '1',
  //             'status': 'done'
  //           },
  //           "to": "$tokenRefNotification",
  //         },
  //       ),
  //     );
  //   } catch (e) {
  //     print("error push notification");
  //   }
  // }

  // void requestPermission() async {
  //   FirebaseMessaging messaging = FirebaseMessaging.instance;
  //
  //   NotificationSettings settings = await messaging.requestPermission(
  //     alert: true,
  //     announcement: false,
  //     badge: true,
  //     carPlay: false,
  //     criticalAlert: false,
  //     provisional: false,
  //     sound: true,
  //   );
  //
  //   if (settings.authorizationStatus == AuthorizationStatus.authorized) {
  //     print('User granted permission');
  //   } else if (settings.authorizationStatus ==
  //       AuthorizationStatus.provisional) {
  //     print('User granted provisional permission');
  //   } else {
  //     print('User declined or has not accepted permission');
  //   }
  // }
  //
  // void listenFCM() async {
  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //     RemoteNotification? notification = message.notification;
  //     AndroidNotification? android = message.notification?.android;
  //     if (notification != null && android != null && !kIsWeb) {
  //       flutterLocalNotificationsPlugin.show(
  //         notification.hashCode,
  //         notification.title,
  //         notification.body,
  //         NotificationDetails(
  //           android: AndroidNotificationDetails(
  //             channel.id,
  //             channel.name,
  //             // TODO add a proper drawable resource to android, for now using
  //             //      one that already exists in example app.
  //             icon: 'launch_background',
  //           ),
  //         ),
  //       );
  //     }
  //   });
  // }
  //
  // void loadFCM() async {
  //   if (!kIsWeb) {
  //     channel = const AndroidNotificationChannel(
  //       'high_importance_channel', // id
  //       'High Importance Notifications', // title
  //       importance: Importance.high,
  //       enableVibration: true,
  //     );
  //
  //     flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  //
  //     /// Create an Android Notification Channel.
  //     ///
  //     /// We use this channel in the `AndroidManifest.xml` file to override the
  //     /// default FCM channel to enable heads up notifications.
  //     await flutterLocalNotificationsPlugin
  //         .resolvePlatformSpecificImplementation<
  //             AndroidFlutterLocalNotificationsPlugin>()
  //         ?.createNotificationChannel(channel);
  //
  //     /// Update the iOS foreground notification presentation options to allow
  //     /// heads up notifications.
  //     await FirebaseMessaging.instance
  //         .setForegroundNotificationPresentationOptions(
  //       alert: true,
  //       badge: true,
  //       sound: true,
  //     );
  //   }
  // }

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
            MaterialPageRoute(builder: (context) => new MainScreen()));
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
                      .where('title', isEqualTo: card_title_accepted)
                      .where('category', isEqualTo: card_category_accepted)
                      .where('comment', isEqualTo: card_comment_accepted)

                      // .where('category', isEqualTo: card_category_vol)
                      // .where('comment', isEqualTo: card_comment_vol)
                      .snapshots(),
                  builder:
                      (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                    return ListView.builder(
                        // physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: !streamSnapshot.hasData
                            ? 1
                            : streamSnapshot.data?.docs.length,
                        itemBuilder: (ctx, index) {
                          if (streamSnapshot.hasData) {
                            switch (streamSnapshot.connectionState) {
                              case ConnectionState.waiting:
                                return Column(children: [
                                  // SizedBox(
                                  //   width: 60,
                                  //   height: 60,
                                  //   child: CircularProgressIndicator(),
                                  // ),
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
                                      //
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
                                                          sendPushMessage();
                                                          // IdOfChatroom = FirebaseFirestore.instance.collection('USERS_COLLECTION').doc().id;
                                                          // print("MMMMMMMMMMMMMMnnnnnnnnnnnHHHHHHHHHHHHHHHHHHvvvvvvvvvvvv");
                                                          // print(IdOfChatroom);
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'applications')
                                                              .doc(
                                                                  streamSnapshot
                                                                      .data
                                                                      ?.docs[
                                                                          index]
                                                                      .id)
                                                              .update({
                                                            "status": status_declined,
                                                            "chatId_vol": "null",
                                                            "date": "null",
                                                            "token_vol": "null",
                                                            "volunteerID": "null",
                                                            "volunteer_name": "null",
                                                            "application_accepted": false,



                                                          });

                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'applications')
                                                              .doc(
                                                                  streamSnapshot
                                                                      .data
                                                                      ?.docs[
                                                                          index]
                                                                      .id)
                                                              .update({
                                                            "mess_button_visibility_ref":
                                                                false
                                                          });
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'applications')
                                                              .doc(
                                                                  streamSnapshot
                                                                      .data
                                                                      ?.docs[
                                                                          index]
                                                                      .id)
                                                              .update({
                                                            "mess_button_visibility_vol":
                                                                true
                                                          });
                                                          // FirebaseFirestore
                                                          //     .instance
                                                          //     .collection(
                                                          //         'applications')
                                                          //     .doc(
                                                          //         streamSnapshot
                                                          //             .data
                                                          //             ?.docs[
                                                          //                 index]
                                                          //             .id)
                                                          //     .update({
                                                          //   "token_vol": "null"
                                                          // });
                                                          // FirebaseFirestore
                                                          //     .instance
                                                          //     .collection(
                                                          //         'applications')
                                                          //     .doc(
                                                          //         streamSnapshot
                                                          //             .data
                                                          //             ?.docs[
                                                          //                 index]
                                                          //             .id)
                                                          //     .update({
                                                          //   "volunteerID":
                                                          //       "null"
                                                          // });
                                                          // FirebaseFirestore
                                                          //     .instance
                                                          //     .collection(
                                                          //         'applications')
                                                          //     .doc(
                                                          //         streamSnapshot
                                                          //             .data
                                                          //             ?.docs[
                                                          //                 index]
                                                          //             .id)
                                                          //     .update({
                                                          //   "volunteer_name":
                                                          //       "null"
                                                          // });

                                                          // print(streamSnapshot.data?.docs[index].id);
                                                          // print(
                                                          //     "AAAAAAAAAAA ${FirebaseFirestore.instance.collection('applications').doc().id}");

                                                          ID_of_vol_application =
                                                              streamSnapshot
                                                                  .data
                                                                  ?.docs[index]
                                                                  .id;

                                                          // FirebaseFirestore.instance.runTransaction((Transaction myTransaction) async {
                                                          //   await myTransaction.delete(streamSnapshot.data?.docs[index]["chatId_vol"]);
                                                          // });
                                                          FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'USERS_COLLECTION')
                                                              .doc(streamSnapshot
                                                                          .data
                                                                          ?.docs[
                                                                      index][
                                                                  "chatId_vol"])
                                                              .delete();
                                                          setState(() {
                                                            controllerTabBottomVol =
                                                                PersistentTabController(
                                                                    initialIndex:
                                                                        1);
                                                          });
                                                          Navigator.of(context,
                                                                  rootNavigator:
                                                                      true)
                                                              .pushReplacement(
                                                                  MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              MainScreen()));
                                                          // Navigator.push(
                                                          //   context,
                                                          //   MaterialPageRoute(
                                                          //       builder: (context) =>
                                                          //           ApplicationsOfVolunteer()),
                                                          // );
                                                        },
                                                      ),
                                                    ),
                                                    // IconButton(
                                                    //   icon: Icon(
                                                    //     Icons.message_rounded,
                                                    //     size: 30,
                                                    //     color: blueColor,
                                                    //   ),
                                                    //   onPressed: () {
                                                    //     setState(() {
                                                    //       controllerTabBottomVol = PersistentTabController(initialIndex: 1);
                                                    //     });
                                                    //     Navigator.of(context, rootNavigator: true).pushReplacement(
                                                    //         MaterialPageRoute(builder: (context) => MainScreen()));
                                                    //
                                                    //   },
                                                    // ),
                                                    // IconButton(
                                                    //   icon: Icon(
                                                    //     Icons.delete_forever,
                                                    //     size: 30,
                                                    //     color: blueColor,
                                                    //   ),
                                                    //   onPressed: () {
                                                    //     setState(() {
                                                    //       controllerTabBottomVol = PersistentTabController(initialIndex: 1);
                                                    //     });
                                                    //     Navigator.of(context, rootNavigator: true).pushReplacement(
                                                    //         MaterialPageRoute(builder: (context) => MainScreen()));
                                                    //
                                                    //   },
                                                    // )
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      // SizedBox(
                                      //   height: MediaQuery.of(context).size.height * 0.01,
                                      // ),
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
                                              // setState(() {
                                              //   firstMessage= true;
                                              //   print("HHHHHHHHHJJJJJJJJJJJJJKKKKKKKKKKKKK");
                                              //   print(firstMessage);
                                              // });
                                              // print(
                                              //     "JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ");
                                              // print(users_chat);
                                              // appId = streamSnapshot.data?.docs[index].id;

                                              if (streamSnapshot
                                                          .data?.docs[index]
                                                      ["chatId_vol"] ==
                                                  "null") {
                                                setState(() {
                                                  messagesNull = true;
                                                });
                                                print("QQQQQQQQQQQQQQQTATATATA");
                                                print(messagesNull);
                                                IdOfChatroomVol = FirebaseFirestore
                                                    .instance
                                                    .collection(
                                                        'USERS_COLLECTION')
                                                    .doc()
                                                    .id;
                                                print(
                                                    "PPPPPPPPPPPPPPPPPPPOOOOOOOOOOOOOOOOWWWWWWWWWWWWWWWWWWWWW");
                                                print(IdOfChatroomVol);
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
                                                      streamSnapshot.data
                                                          ?.docs[index]['title'],
                                                  'last_msg':""
                                                  // "user_message": true
                                                });

                                                // FirebaseFirestore.instance
                                                //     .collection('users')
                                                //     .doc(
                                                //     streamSnapshot.data?.docs[index]["userID"])
                                                //     .set({"chatId_exist": IdOfChatroom});

                                                FirebaseFirestore.instance
                                                    .collection('applications')
                                                    .doc(streamSnapshot
                                                        .data?.docs[index].id)
                                                    .update({
                                                  "chatId_vol": IdOfChatroomVol
                                                });
                                                // VoluntterName = FirebaseFirestore.instance.collection("users").doc(users_chat[1]).get() as String;
                                                // RefugeeName = FirebaseFirestore.instance.collection("users").where("id_vol", isEqualTo: users_chat[0]).get() as String;

                                                Future.delayed(
                                                    Duration(milliseconds: 500),
                                                    () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            SelectedChatroomVol()),
                                                  );
                                                });
                                              } else {
                                                print("QQQQQQQQQQQQQQQTATATATA2222222222");
                                                print(streamSnapshot
                                                    .data?.docs[index]
                                                ["chatId_vol"]);
                                                print(streamSnapshot
                                                    .data?.docs[index]
                                                ["chatId_vol"]=="null");

                                                setState(() {
                                                  changeContainerHeight = false;
                                                  messagesNull = false;
                                                  print("QQQQQQQQQQQQQQQTATATATA2222222222.............");
                                                  print(messagesNull);
                                                  IdOfChatroomVol =
                                                      streamSnapshot
                                                              .data?.docs[index]
                                                          ["chatId_vol"];
                                                });
                                                Future.delayed(
                                                    Duration(milliseconds: 500),
                                                    () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            SelectedChatroomVol()),
                                                  );
                                                });
                                              }
                                              // //LOOOOK HEEEEREEEEE
                                              // FirebaseFirestore.instance
                                              //     .collection('applications')
                                              //     .doc(streamSnapshot
                                              //         .data?.docs[index].id)
                                              //     .update({
                                              //   "mess_button_visibility_vol":
                                              //       false
                                              // });
                                              //
                                              // FirebaseFirestore.instance
                                              //     .collection('applications')
                                              //     .doc(streamSnapshot
                                              //         .data?.docs[index].id)
                                              //     .update({
                                              //   "mess_button_visibility_ref":
                                              //       true
                                              // });

                                              // VoluntterName = FirebaseFirestore.instance.collection("users").where("id_vol", isEqualTo: users_chat[1]) as String?;
                                              // RefugeeName = FirebaseFirestore.instance.collection("users").where("id_vol", isEqualTo: users_chat[0]) as String?;
                                            }),
                                      ),
                                      // Container(
                                      //   width: double.infinity,
                                      //   height: MediaQuery.of(context).size.height *
                                      //       0.085,
                                      //   decoration: buttonInactiveDecoration,
                                      //   child: TextButton(
                                      //       child: Text(
                                      //         "Decline",
                                      //         style: textInactiveButtonStyle,
                                      //       ),
                                      //
                                      //       onPressed: () {
                                      //         sendPushMessage();
                                      //         // IdOfChatroom = FirebaseFirestore.instance.collection('USERS_COLLECTION').doc().id;
                                      //         // print("MMMMMMMMMMMMMMnnnnnnnnnnnHHHHHHHHHHHHHHHHHHvvvvvvvvvvvv");
                                      //         // print(IdOfChatroom);
                                      //         FirebaseFirestore.instance
                                      //             .collection('applications')
                                      //             .doc(
                                      //                 streamSnapshot.data?.docs[index].id)
                                      //             .update({"status": status_declined,
                                      //           "chatId_vol": "null",
                                      //           "date": "null"
                                      //         });
                                      //
                                      //         FirebaseFirestore.instance
                                      //             .collection('applications')
                                      //             .doc(
                                      //             streamSnapshot.data?.docs[index].id)
                                      //             .update({"mess_button_visibility_ref": false});
                                      //         FirebaseFirestore.instance
                                      //             .collection('applications')
                                      //             .doc(
                                      //             streamSnapshot.data?.docs[index].id)
                                      //             .update({"mess_button_visibility_vol": true});
                                      //         FirebaseFirestore.instance
                                      //             .collection('applications')
                                      //             .doc(
                                      //             streamSnapshot.data?.docs[index].id)
                                      //             .update({"token_vol": "null"});
                                      //         FirebaseFirestore.instance
                                      //             .collection('applications')
                                      //             .doc(
                                      //             streamSnapshot.data?.docs[index].id)
                                      //             .update({"volunteerID": "null"});
                                      //         FirebaseFirestore.instance
                                      //             .collection('applications')
                                      //             .doc(
                                      //             streamSnapshot.data?.docs[index].id)
                                      //             .update({"volunteer_name": "null"});
                                      //
                                      //         // print(streamSnapshot.data?.docs[index].id);
                                      //         // print(
                                      //         //     "AAAAAAAAAAA ${FirebaseFirestore.instance.collection('applications').doc().id}");
                                      //
                                      //         ID_of_vol_application =
                                      //             streamSnapshot.data?.docs[index].id;
                                      //
                                      //         // FirebaseFirestore.instance.runTransaction((Transaction myTransaction) async {
                                      //         //   await myTransaction.delete(streamSnapshot.data?.docs[index]["chatId_vol"]);
                                      //         // });
                                      //         FirebaseFirestore.instance.collection('USERS_COLLECTION').doc(streamSnapshot.data?.docs[index]["chatId_vol"]).delete();
                                      //         setState(() {
                                      //           controllerTabBottomVol = PersistentTabController(initialIndex: 1);
                                      //         });
                                      //         Navigator.of(context, rootNavigator: true).pushReplacement(
                                      //             MaterialPageRoute(builder: (context) => MainScreen()));
                                      //         // Navigator.push(
                                      //         //   context,
                                      //         //   MaterialPageRoute(
                                      //         //       builder: (context) =>
                                      //         //           ApplicationsOfVolunteer()),
                                      //         // );
                                      //       }),
                                      // )
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
            ],
          ),
        ),
      ),
    );
  }
}

// import 'dart:async';
// import 'dart:convert';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
// import 'package:wol_pro_1/constants.dart';
// import 'package:wol_pro_1/screens/menu/volunteer/all_applications/page_of_application_vol.dart';
// import 'package:http/http.dart' as http;
// import '../../../../Refugee/SettingRefugee.dart';
// import '../../../../models/categories.dart';
// import '../../../../volunteer/chat/message.dart';
// import '../../refugee/accepted_applications/accepted_applications.dart';
// import '../main_screen.dart';
// import 'applications_vol.dart';
//
// String roomExist ='';
// // bool isvisible = true;
// bool firstMessage = false;
// String? IdOfChatroom = '';
//
// String VoluntterName = '';
// String RefugeeName = '';
// String nameOfApplication = '';
//
//
// class SettingsOfApplication extends StatefulWidget {
//   const SettingsOfApplication({Key? key}) : super(key: key);
//
//   @override
//   State<SettingsOfApplication> createState() => _SettingsOfApplicationState();
// }
//
// // List<String> users_chat = [];
// // var ID_of_vol_application;
// // String? appId = '';
//
// class _SettingsOfApplicationState extends State<SettingsOfApplication> {
//
//   late AndroidNotificationChannel channel;
//   late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
//
//   String? token = " ";
//   // late StreamSubscription<User?> user;
//   // void deleteChat(){
//   //   user = FirebaseAuth.instance.authStateChanges().listen((user) async {
//   //     if (user == null) {
//   //       print('User is currently signed out!');
//   //     } else {
//   //       print('User is signed in!');
//   //       // loadImage();
//   //       DocumentSnapshot variable = await FirebaseFirestore.instance.
//   //       collection('USERS_COLLECTION').
//   //       doc(IdOfChatroom).
//   //       get();
//   //
//   //       await FirebaseFirestore.instance.runTransaction((Transaction myTransaction) async {
//   //         await myTransaction.delete(variable);
//   //       });
//   //     }
//   //   });
//   // }
//
//   @override
//   void initState() {
//     super.initState();
//
//     requestPermission();
//
//     loadFCM();
//
//     listenFCM();
//
//     // getToken();
//
//     FirebaseMessaging.instance.subscribeToTopic("Animal");
//   }
//
//   void sendPushMessage() async {
//     print("SSSSSSSSSSSSSSSSSSSsEEEEEEEEEENNNNNNNNNNNNNNNNNNNNDDDDDDDDDDDDDDDDDDDDD");
//     try {
//       await http.post(
//         Uri.parse('https://fcm.googleapis.com/fcm/send'),
//         headers: <String, String>{
//           'Content-Type': 'application/json',
//           'Authorization':
//           'key = AAAADY1uR1I:APA91bEruiKUQtfsFz0yWjEovi9GAF9nkGYfmW9H2lU6jrtdCGw2C1ZdEczYXvovHMPqQBYSrDnYsbhsyk-kcCBi6Wht_YrGcSKXw4vk0UUNRlwN9UdM_4rhmf_6hd_xyAXbBsgyx12L  ',
//         },
//         body: jsonEncode(
//           <String, dynamic>{
//             'notification': <String, dynamic>{
//               'body': 'Volunteer has decided to decline your application',
//               'title': 'Acceptance decline'
//             },
//             'priority': 'high',
//             'data': <String, dynamic>{
//               'click_action': 'FLUTTER_NOTIFICATION_CLICK',
//               'id': '1',
//               'status': 'done'
//             },
//             "to": "$token_ref",
//           },
//         ),
//       );
//     } catch (e) {
//       print("error push notification");
//     }
//   }
//
//   void requestPermission() async {
//     FirebaseMessaging messaging = FirebaseMessaging.instance;
//
//     NotificationSettings settings = await messaging.requestPermission(
//       alert: true,
//       announcement: false,
//       badge: true,
//       carPlay: false,
//       criticalAlert: false,
//       provisional: false,
//       sound: true,
//     );
//
//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       print('User granted permission');
//     } else if (settings.authorizationStatus ==
//         AuthorizationStatus.provisional) {
//       print('User granted provisional permission');
//     } else {
//       print('User declined or has not accepted permission');
//     }
//   }
//
//   void listenFCM() async {
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       RemoteNotification? notification = message.notification;
//       AndroidNotification? android = message.notification?.android;
//       if (notification != null && android != null && !kIsWeb) {
//         flutterLocalNotificationsPlugin.show(
//           notification.hashCode,
//           notification.title,
//           notification.body,
//           NotificationDetails(
//             android: AndroidNotificationDetails(
//               channel.id,
//               channel.name,
//               // TODO add a proper drawable resource to android, for now using
//               //      one that already exists in example app.
//               icon: 'launch_background',
//             ),
//           ),
//         );
//       }
//     });
//   }
//
//   void loadFCM() async {
//     if (!kIsWeb) {
//       channel = const AndroidNotificationChannel(
//         'high_importance_channel', // id
//         'High Importance Notifications', // title
//         importance: Importance.high,
//         enableVibration: true,
//       );
//
//       flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
//
//       /// Create an Android Notification Channel.
//       ///
//       /// We use this channel in the `AndroidManifest.xml` file to override the
//       /// default FCM channel to enable heads up notifications.
//       await flutterLocalNotificationsPlugin
//           .resolvePlatformSpecificImplementation<
//           AndroidFlutterLocalNotificationsPlugin>()
//           ?.createNotificationChannel(channel);
//
//       /// Update the iOS foreground notification presentation options to allow
//       /// heads up notifications.
//       await FirebaseMessaging.instance
//           .setForegroundNotificationPresentationOptions(
//         alert: true,
//         badge: true,
//         sound: true,
//       );
//     }
//   }
//
//   String status_declined = 'Sent to volunteer';
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         setState(() {
//           controllerTabBottomVol = PersistentTabController(initialIndex: 1);
//         });
//         Navigator.of(context, rootNavigator: true).pushReplacement(
//             MaterialPageRoute(builder: (context) => MainScreen()));
//         return true;
//       },
//       child: Scaffold(
//         backgroundColor: background,
//         floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
//         floatingActionButton: IconButton(
//           icon: Icon(
//             Icons.arrow_back_ios_new_rounded,
//             size: 30,
//             color: blueColor,
//           ),
//           onPressed: () {
//             setState(() {
//               controllerTabBottomVol = PersistentTabController(initialIndex: 1);
//             });
//             Navigator.of(context, rootNavigator: true).pushReplacement(
//                 MaterialPageRoute(builder: (context) => MainScreen()));
//
//           },
//         ),
//         // appBar: AppBar(
//         //   backgroundColor: Color.fromRGBO(49, 72, 103, 0.8),
//         //   elevation: 0.0,
//         //   title: Text(
//         //     'Application Info',
//         //     style: TextStyle(fontSize: 16),
//         //   ),
//         //   leading: IconButton(onPressed: () {
//         //     Navigator.push(
//         //       context,
//         //       MaterialPageRoute(builder: (context) => ApplicationsOfVolunteer()),
//         //     );
//         //   }, icon: Icon(Icons.arrow_back),
//         //
//         //   ),
//         // ),
//         body: StreamBuilder(
//           stream: FirebaseFirestore.instance
//               .collection('applications')
//           .where('Id', isEqualTo: applicationIDVol)
//           //     .where('title', isEqualTo: card_title_accepted)
//           //     .where('category', isEqualTo: card_category_accepted)
//           //     .where('comment', isEqualTo: card_comment_accepted)
//               .snapshots(),
//           builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
//             return ListView.builder(
//                 itemCount: !streamSnapshot.hasData? 1:streamSnapshot.data?.docs.length,
//                 itemBuilder: (ctx, index) {
//                 if (streamSnapshot.hasData){
//                   switch (streamSnapshot.connectionState){
//                     case ConnectionState.waiting:
//                       return  Column(
//                       children: [
//                         SizedBox(
//                         width: 60,
//                         height: 60,
//                         child: CircularProgressIndicator(),
//                         ),
//                         Padding(
//                         padding: EdgeInsets.only(top: 16),
//                         child: Text('Awaiting data...'),
//                         )
//                   ]
//
//                 );
//
//                 case ConnectionState.active:
//                 return Column(
//                       children: [
//                         Padding(
//                           padding: EdgeInsets.only(
//                               top: MediaQuery.of(context).size.height * 0.02),
//                           child: Align(
//                             alignment: Alignment.topCenter,
//                             child: Text(
//                               "Application details",
//                               style: GoogleFonts.raleway(
//                                 fontSize: 18,
//                                 color: Colors.black,
//                               ),
//                             ),
//                           ),
//                         ),
//                         SizedBox(
//                           height:
//                           MediaQuery.of(context).size.height * 0.05,
//                         ),
//                         Padding(
//                           padding: padding,
//                           child: Container(
//                             width: double.infinity,
//                             height: MediaQuery.of(context).size.height *
//                                 0.45,
//                             decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius:
//                                 BorderRadius.circular(24)),
//                             child: Padding(
//                               padding: padding,
//                               child: Column(
//                                 children: [
//                                   Padding(
//                                     padding: const EdgeInsets.all(20),
//                                     child: Icon(
//                                       streamSnapshot.data?.docs[index]['category'] as String==categoriesListAll[3]
//                                           ?Icons.pets_rounded
//                                           :streamSnapshot.data?.docs[index]['category'] as String==categoriesListAll[4]
//                                           ?Icons.local_grocery_store
//                                           :streamSnapshot.data?.docs[index]['category'] as String==categoriesListAll[2]
//                                           ?Icons.emoji_transportation_rounded
//                                           :streamSnapshot.data?.docs[index]['category'] as String==categoriesListAll[1]
//                                           ?Icons.house
//                                           :streamSnapshot.data?.docs[index]['category'] as String==categoriesListAll[6]
//                                           ?Icons.sign_language_rounded
//                                           :streamSnapshot.data?.docs[index]['category'] as String==categoriesListAll[5]
//                                           ?Icons.child_care_outlined
//                                           :streamSnapshot.data?.docs[index]['category'] as String==categoriesListAll[7]
//                                           ?Icons.menu_book
//                                           :streamSnapshot.data?.docs[index]['category'] as String==categoriesListAll[8]
//                                           ?Icons.medical_information_outlined
//                                           :streamSnapshot.data?.docs[index]['category'] as String==categoriesListAll[0]
//                                           ?Icons.check_box
//                                           :Icons.new_label_sharp,
//                                       size: 30,
//                                       color: Colors.black,
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     height: MediaQuery.of(context)
//                                         .size
//                                         .height *
//                                         0.02,
//                                   ),
//                                   Align(
//                                     alignment: Alignment.topLeft,
//                                     child: Text(
//                                       // "Title",
//                                       streamSnapshot.data?.docs[index]['title'],
//                                       style: GoogleFonts.raleway(
//                                         fontSize: 18,
//                                         color: Colors.black,
//                                       ),
//                                     ),
//                                   ),
//                                   SizedBox(
//                                     height: MediaQuery.of(context)
//                                         .size
//                                         .height *
//                                         0.007,
//                                   ),
//                                   Align(
//                                     alignment: Alignment.topLeft,
//                                     child: Text(
//                                         streamSnapshot.data?.docs[index]['category'],
//                                         style: GoogleFonts.raleway(
//                                           fontSize: 14,
//                                           color: Colors.black,
//                                         )),
//                                   ),
//                                   SizedBox(
//                                     height: MediaQuery.of(context)
//                                         .size
//                                         .height *
//                                         0.05,
//                                   ),
//                                   Align(
//                                     alignment: Alignment.topLeft,
//                                     child: Text(streamSnapshot.data?.docs[index]['comment'],
//                                       style: GoogleFonts.raleway(
//                                         fontSize: 14,
//                                         color: Colors.black,
//                                       ),
//                                     ),
//                                   ),
//                                   // SizedBox(
//                                   //   height: MediaQuery.of(context)
//                                   //       .size
//                                   //       .height *
//                                   //       0.3,
//                                   // ),
//                                   // Align(
//                                   //   alignment: Alignment.bottomCenter,
//                                   //   child: Center(
//                                   //     child: Container(
//                                   //       width: double.infinity,
//                                   //       height: MediaQuery.of(context).size.height *
//                                   //           0.075,
//                                   //       decoration: BoxDecoration(
//                                   //           color: Colors.white,
//                                   //           borderRadius:
//                                   //           BorderRadius.circular(24)),
//                                   //       child: TextButton(
//                                   //           child: Text(
//                                   //             "Accept application",
//                                   //             style: textButtonStyle,
//                                   //           ),
//                                   //           onPressed: () async {
//                                   //             sendPushMessage();
//                                   //             date = DateTime.now().toString();
//                                   //             FirebaseFirestore.instance
//                                   //                 .collection('applications')
//                                   //                 .doc(streamSnapshot.data?.docs[index].id).update({"status": status_updated});
//                                   //             FirebaseFirestore.instance
//                                   //                 .collection('applications')
//                                   //                 .doc(streamSnapshot.data?.docs[index].id).update({"volunteerID": volID});
//                                   //             FirebaseFirestore.instance
//                                   //                 .collection('applications')
//                                   //                 .doc(streamSnapshot.data?.docs[index].id).update({"date": date});
//                                   //             FirebaseFirestore.instance
//                                   //                 .collection('applications')
//                                   //                 .doc(streamSnapshot.data?.docs[index].id).update({"token_vol": token_vol});
//                                   //             FirebaseFirestore.instance
//                                   //                 .collection('applications')
//                                   //                 .doc(streamSnapshot.data?.docs[index].id).update({"volunteer_name": currentNameVol});
//                                   //
//                                   //             FirebaseFirestore.instance
//                                   //                 .collection('applications')
//                                   //                 .doc(streamSnapshot.data?.docs[index].id).update({"application_accepted": true});
//                                   //
//                                   //
//                                   //             Id_Of_current_application = streamSnapshot.data?.docs[index].id;
//                                   //             ID_of_vol_application=streamSnapshot.data?.docs[index].id;
//                                   //             Navigator.push(
//                                   //               context,
//                                   //               MaterialPageRoute(
//                                   //                   builder: (context) => ApplicationsOfVolunteer()),
//                                   //             );
//                                   //           }),
//                                   //     ),
//                                   //   ),
//                                   // ),
//                                   // MaterialButton(
//                                   //     child: Text("Accept",style: TextStyle(color: Colors.white),),
//                                   //     color: Color.fromRGBO(18, 56, 79, 0.8),
//                                   //
//                                   //     onPressed: () {
//                                   //       sendPushMessage();
//                                   //       date = DateTime.now().toString();
//                                   //       FirebaseFirestore.instance
//                                   //           .collection('applications')
//                                   //           .doc(streamSnapshot.data?.docs[index].id).update({"status": status_updated});
//                                   //       FirebaseFirestore.instance
//                                   //           .collection('applications')
//                                   //           .doc(streamSnapshot.data?.docs[index].id).update({"volunteerID": volID});
//                                   //       FirebaseFirestore.instance
//                                   //           .collection('applications')
//                                   //           .doc(streamSnapshot.data?.docs[index].id).update({"date": date});
//                                   //       FirebaseFirestore.instance
//                                   //           .collection('applications')
//                                   //           .doc(streamSnapshot.data?.docs[index].id).update({"token_vol": token_vol});
//                                   //       FirebaseFirestore.instance
//                                   //           .collection('applications')
//                                   //           .doc(streamSnapshot.data?.docs[index].id).update({"volunteer_name": currentNameVol});
//                                   //
//                                   //       FirebaseFirestore.instance
//                                   //           .collection('applications')
//                                   //           .doc(streamSnapshot.data?.docs[index].id).update({"application_accepted": true});
//                                   //      //  FirebaseFirestore.instance
//                                   //      //      .collection('applications')
//                                   //      //      .doc(streamSnapshot.data?.docs[index].id).update({"Id": streamSnapshot.data?.docs[index].id});
//                                   //      //  print(streamSnapshot.data?.docs[index].id);
//                                   //      // print("AAAAAAAAAAA ${FirebaseFirestore.instance
//                                   //      //  .collection('applications').doc().id}");
//                                   //
//                                   //
//                                   //
//                                   //      Id_Of_current_application = streamSnapshot.data?.docs[index].id;
//                                   //      ID_of_vol_application=streamSnapshot.data?.docs[index].id;
//                                   //       Navigator.push(
//                                   //         context,
//                                   //         MaterialPageRoute(
//                                   //             builder: (context) => ApplicationsOfVolunteer()),
//                                   //       );
//                                   //
//                                   // }
//                                   // )
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                         SizedBox(
//                           height: streamSnapshot.data?.docs[index]["mess_button_visibility_vol"]
//                               ?MediaQuery.of(context).size.height * 0.2
//                           :MediaQuery.of(context).size.height * 0.27,
//                         ),
//                         // Padding(
//                         //   padding: const EdgeInsets.only(top: 20, left: 10),
//                         //   child: Align(
//                         //     alignment: Alignment.topLeft,
//                         //     child: Text(
//                         //       streamSnapshot.data?.docs[index]['title'],
//                         //       // "Title",
//                         //       style: TextStyle(
//                         //         fontWeight: FontWeight.bold,
//                         //         fontSize: 20,
//                         //         color: Colors.black,
//                         //       ),
//                         //       textAlign: TextAlign.center,
//                         //     ),
//                         //   ),
//                         // ),
//                         // Padding(
//                         //   padding: const EdgeInsets.only(left: 10),
//                         //   child: Align(
//                         //     alignment: Alignment.topLeft,
//                         //     child: Text(
//                         //       streamSnapshot.data?.docs[index]['category'],
//                         //       style: TextStyle(color: Colors.grey, fontSize: 16),
//                         //       textAlign: TextAlign.center,
//                         //     ),
//                         //   ),
//                         // ),
//                         // Padding(
//                         //   padding: const EdgeInsets.only(top: 15, left: 10),
//                         //   child: Align(
//                         //     alignment: Alignment.topLeft,
//                         //     child: Text(
//                         //       streamSnapshot.data?.docs[index]['comment'],
//                         //       style:
//                         //           TextStyle(color: Colors.grey, fontSize: 14),
//                         //       textAlign: TextAlign.center,
//                         //     ),
//                         //   ),
//                         // ),
//                         Padding(
//                           padding: padding,
//                           child: Visibility(
//                             visible: streamSnapshot.data?.docs[index]["mess_button_visibility_vol"],
//                             child: Container(
//                               width: double.infinity,
//                               height: MediaQuery.of(context).size.height *
//                                   0.085,
//                               decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius:
//                                   BorderRadius.circular(24)),
//                               child: TextButton(
//                                   child: Text(
//                                     "Message",
//                                     style: textActiveButtonStyle,
//                                   ),
//                                   onPressed: () {
//                                     setState(() {
//                                       firstMessage= true;
//                                       print("HHHHHHHHHJJJJJJJJJJJJJKKKKKKKKKKKKK");
//                                       print(firstMessage);
//                                     });
//                                     print(
//                                         "JJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJJ");
//                                     // print(users_chat);
//                                     // appId = streamSnapshot.data?.docs[index].id;
//
//
//                                      if (streamSnapshot.data?.docs[index]["chatId_vol"] == "null"){
//                                        IdOfChatroom = FirebaseFirestore.instance.collection('USERS_COLLECTION').doc().id;
//                                        print("PPPPPPPPPPPPPPPPPPPOOOOOOOOOOOOOOOOWWWWWWWWWWWWWWWWWWWWW");
//                                        print(IdOfChatroom);
//                                        FirebaseFirestore.instance
//                                            .collection('USERS_COLLECTION')
//                                            .doc(IdOfChatroom)
//                                            .set({
//                                          'IdVolunteer': streamSnapshot
//                                              .data?.docs[index]['volunteerID'],
//                                          'IdRefugee': streamSnapshot
//                                              .data?.docs[index]["userID"],
//                                          'chatId': IdOfChatroom,
//                                          'Refugee_Name': streamSnapshot
//                                              .data?.docs[index]['refugee_name'],
//                                          'Volunteer_Name': streamSnapshot
//                                              .data?.docs[index]['volunteer_name'],
//                                          'Id_Of_Chat': "null",
//                                          'Application_Name': streamSnapshot
//                                              .data?.docs[index]['title']
//                                        });
//
//                                        // FirebaseFirestore.instance
//                                        //     .collection('users')
//                                        //     .doc(
//                                        //     streamSnapshot.data?.docs[index]["userID"])
//                                        //     .set({"chatId_exist": IdOfChatroom});
//
//                                        FirebaseFirestore.instance
//                                            .collection('applications')
//                                            .doc(
//                                            streamSnapshot.data?.docs[index].id)
//                                            .update({"chatId_vol": IdOfChatroom});
//                                        // VoluntterName = FirebaseFirestore.instance.collection("users").doc(users_chat[1]).get() as String;
//                                        // RefugeeName = FirebaseFirestore.instance.collection("users").where("id_vol", isEqualTo: users_chat[0]).get() as String;
//                                        Navigator.push(
//                                          context,
//                                          MaterialPageRoute(
//                                              builder: (context) =>
//                                                  SelectedChatroom()),
//                                        );
//                                      }
//                                     //LOOOOK HEEEEREEEEE
//                                      FirebaseFirestore.instance
//                                         .collection('applications')
//                                         .doc(
//                                         streamSnapshot.data?.docs[index].id)
//                                         .update({"mess_button_visibility_vol": false});
//
//                                     FirebaseFirestore.instance
//                                         .collection('applications')
//                                         .doc(
//                                         streamSnapshot.data?.docs[index].id)
//                                         .update({"mess_button_visibility_ref": true});
//
//
//                                     // VoluntterName = FirebaseFirestore.instance.collection("users").where("id_vol", isEqualTo: users_chat[1]) as String?;
//                                     // RefugeeName = FirebaseFirestore.instance.collection("users").where("id_vol", isEqualTo: users_chat[0]) as String?;
//                                   }
//                                   ),
//                             ),
//                           ),
//                         ),
//                         SizedBox(
//                           height:
//                           MediaQuery.of(context).size.height * 0.015,
//                         ),
//                         Padding(
//                           padding: padding,
//                           child: Container(
//                             width: double.infinity,
//                             height: MediaQuery.of(context).size.height *
//                                 0.085,
//                             decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius:
//                                 BorderRadius.circular(24)),
//                             child: TextButton(
//                                 child: Text(
//                                   "Decline",
//                                   style: textActiveButtonStyle,
//                                 ),
//
//                                 onPressed: () {
//                                   sendPushMessage();
//                                   // IdOfChatroom = FirebaseFirestore.instance.collection('USERS_COLLECTION').doc().id;
//                                   // print("MMMMMMMMMMMMMMnnnnnnnnnnnHHHHHHHHHHHHHHHHHHvvvvvvvvvvvv");
//                                   // print(IdOfChatroom);
//                                   FirebaseFirestore.instance
//                                       .collection('applications')
//                                       .doc(
//                                           streamSnapshot.data?.docs[index].id)
//                                       .update({"status": status_declined,
//                                     "chatId_vol": "null",
//                                     "date": "null"
//                                   });
//
//                                   FirebaseFirestore.instance
//                                       .collection('applications')
//                                       .doc(
//                                       streamSnapshot.data?.docs[index].id)
//                                       .update({"mess_button_visibility_ref": false});
//                                   FirebaseFirestore.instance
//                                       .collection('applications')
//                                       .doc(
//                                       streamSnapshot.data?.docs[index].id)
//                                       .update({"mess_button_visibility_vol": true});
//                                   FirebaseFirestore.instance
//                                       .collection('applications')
//                                       .doc(
//                                       streamSnapshot.data?.docs[index].id)
//                                       .update({"token_vol": "null"});
//                                   FirebaseFirestore.instance
//                                       .collection('applications')
//                                       .doc(
//                                       streamSnapshot.data?.docs[index].id)
//                                       .update({"volunteerID": "null"});
//                                   FirebaseFirestore.instance
//                                       .collection('applications')
//                                       .doc(
//                                       streamSnapshot.data?.docs[index].id)
//                                       .update({"volunteer_name": "null"});
//
//                                   // print(streamSnapshot.data?.docs[index].id);
//                                   // print(
//                                   //     "AAAAAAAAAAA ${FirebaseFirestore.instance.collection('applications').doc().id}");
//
//                                   ID_of_vol_application =
//                                       streamSnapshot.data?.docs[index].id;
//
//                                   // FirebaseFirestore.instance.runTransaction((Transaction myTransaction) async {
//                                   //   await myTransaction.delete(streamSnapshot.data?.docs[index]["chatId_vol"]);
//                                   // });
//                                   FirebaseFirestore.instance.collection('USERS_COLLECTION').doc(streamSnapshot.data?.docs[index]["chatId_vol"]).delete();
//                                   setState(() {
//                                     controllerTabBottomVol = PersistentTabController(initialIndex: 1);
//                                   });
//                                   Navigator.of(context, rootNavigator: true).pushReplacement(
//                                       MaterialPageRoute(builder: (context) => MainScreen()));
//                                   // Navigator.push(
//                                   //   context,
//                                   //   MaterialPageRoute(
//                                   //       builder: (context) =>
//                                   //           ApplicationsOfVolunteer()),
//                                   // );
//                                 }),
//                           ),
//                         )
//                       ],
//                     );}}
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
//                 });
//           },
//         ),
//       ),
//     );
//   }
// }
