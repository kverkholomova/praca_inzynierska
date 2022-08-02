import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wol_pro_1/Refugee/messages_ref.dart';
import 'package:wol_pro_1/Refugee/pageWithChats.dart';
import 'package:wol_pro_1/Refugee/rating.dart';
import 'package:wol_pro_1/screens/info_volunteer_accepted_application.dart';

import 'all_applications.dart';

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
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CategoriesRef()),
        );
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(49, 72, 103, 0.8),
          elevation: 0.0,
          title: Text(
            'Application Info',
            style: TextStyle(fontSize: 16),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back,color: Colors.white,),
            onPressed: () async {
              // await _auth.signOut();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CategoriesRef()),
              );
            },
          ),
        ),
        body: Container(
          color: Color.fromRGBO(234, 191, 213, 0.8),
          child: StreamBuilder (
            stream: FirebaseFirestore.instance
                .collection('applications')
                .where('title', isEqualTo: card_title_ref)
                .where('category', isEqualTo: card_category_ref)
                .where('comment', isEqualTo: card_comment_ref)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
              return ListView.builder(
                  itemCount: !streamSnapshot.hasData? 1:streamSnapshot.data?.docs.length,
                  itemBuilder: (ctx, index) {

                    User? user = FirebaseAuth.instance.currentUser;
                    final docId = streamSnapshot.data!.docs[index]["volunteerID"];
                    print("IIIIIIIIIIIIIIII_______________HHHHHHHHHHHHHHH");
                    print(streamSnapshot.data?.docs[index]['title']);
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
                          padding: const EdgeInsets.only(top: 30,left: 10,right: 10,bottom: 10),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              streamSnapshot.data?.docs[index]['title'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              streamSnapshot.data?.docs[index]['status'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              streamSnapshot.data?.docs[index]['category'],
                              style: TextStyle(color: Colors.grey, fontSize: 14),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              streamSnapshot.data?.docs[index]['comment'],
                              style: TextStyle(color: Colors.black, fontSize: 15),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              streamSnapshot.data?.docs[index]['date'],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Colors.grey[900],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Visibility(
                          visible: streamSnapshot.data?.docs[index]["mess_button_visibility_ref"],
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 10),
                            child: SizedBox(
                              height: 50,
                              width: 300,
                              child: MaterialButton(
                                  child: Text(
                                    "Message",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  color: Color.fromRGBO(18, 56, 79, 0.8),
                                  onPressed: () {
                                    FirebaseFirestore.instance
                                        .collection('applications')
                                        .doc(
                                        streamSnapshot.data?.docs[index].id)
                                        .update({"mess_button_visibility_ref": false});
                                   IdOfChatroomRef = streamSnapshot.data?.docs[index]['chatId_vol'];
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SelectedChatroom_Ref()),
                                      );


                                    //}
                                  }),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: SizedBox(
                            height: 50,
                            width: 300,
                            child: MaterialButton(
                                child: Text(
                                  "Delete",
                                  style: TextStyle(color: Colors.white),
                                ),
                                color: Color.fromRGBO(18, 56, 79, 0.8),
                                onPressed: () {


                                  sendPushMessage();

                                  FirebaseFirestore.instance
                                      .collection('applications')
                                      .doc(streamSnapshot.data?.docs[index].id)
                                      .update({"status": "deleted"});


                                }),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10, bottom: 10),
                          child: SizedBox(
                            height: 50,
                            width: 300,
                            child: MaterialButton(
                                child: Text(
                                  "Look info about volunteer",
                                  style: TextStyle(color: Colors.white),
                                ),
                                color: Color.fromRGBO(18, 56, 79, 0.8),
                                onPressed: () {
                                  IDVolOfApplication = streamSnapshot
                                      .data?.docs[index]['volunteerID'] as String;
                                  print(IDVolOfApplication);
                                  print(
                                      "SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS");

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            PageOfVolunteerRef()),
                                  );
                                }),
                          ),
                        ),
                        // Visibility(
                        //   visible: streamSnapshot.data?.docs[index]["application_accepted"],
                        //   child:
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            child: SizedBox(
                              height: 50,
                              width: 300,
                              child: MaterialButton(
                                  child: Text(
                                    "Mark application as done",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  color: Color.fromRGBO(18, 56, 79, 0.8),
                                  onPressed: () {
                                    IDVolOfApplication = streamSnapshot
                                        .data?.docs[index]['volunteerID'] as String;
                                    print(IDVolOfApplication);
                                    print(
                                        "SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSS");

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              Rating_Page()),
                                    );
                                  }),
                            ),
                          ),
                        // )
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
      ),
    );
  }
}
