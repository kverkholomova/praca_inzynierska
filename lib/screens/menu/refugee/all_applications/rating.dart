import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:wol_pro_1/widgets/loading.dart';
import '../../../../constants.dart';
import '../accepted_applications/application_info_accepted.dart';
import '../home_page/home_ref.dart';
import '../main_screen_ref.dart';
import 'all_app_ref.dart';
import 'application_info.dart';

String iiiIDVolOfApplication = '';

class Rating extends StatefulWidget {
  const Rating({Key? key}) : super(key: key);

  @override
  State<Rating> createState() => _RatingState();
}

class _RatingState extends State<Rating> {
  late double _rating;

  double _initialRating = 5.0;
  bool _isVertical = false;

  IconData? _selectedIcon;

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
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body':
                  'The application was marked as done by refugee, so your help is not necessary anymore.',
              'title': 'Refugee marked an application as done'
            },
            'sound': 'default',
            'priority': 'high',
            "to": "$tokenVolApplication",
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

  String? token = " ";

  @override
  void initState() {
    _rating = _initialRating;
    super.initState();
  }

  final CollectionReference applications =
      FirebaseFirestore.instance.collection('applications');

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (isAcceptedApplicationRefugee == true) {
          Navigator.of(context, rootNavigator: true).pushReplacement(
              MaterialPageRoute(
                  builder: (context) => const AcceptedPageOfApplicationRef()));
        } else {
          Navigator.of(context, rootNavigator: true).pushReplacement(
              MaterialPageRoute(
                  builder: (context) => const PageOfApplicationRef()));
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: backgroundRefugee,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: Text(
            'Application is done',
            style: GoogleFonts.raleway(
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 30,
              color: redColor,
            ),
            onPressed: () async {
              if (isAcceptedApplicationRefugee == true) {
                Navigator.of(context, rootNavigator: true).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) =>
                            const AcceptedPageOfApplicationRef()));
              } else {
                Navigator.of(context, rootNavigator: true).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) => const PageOfApplicationRef()));
              }
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: padding,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        "Your application is done now!",
                        style: GoogleFonts.raleway(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Text(
                      "We are happy that our app helped you to find an assistance.",
                      style: GoogleFonts.raleway(
                        fontSize: 12,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                    ),
                    _heading('Rate volunteer assistance'),
                    RatingBar.builder(
                      glowColor: redColor,
                      unratedColor: redColor.withOpacity(0.2),
                      initialRating: _initialRating,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemSize: 40.0,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => Icon(
                        _selectedIcon ?? Icons.star,
                        color: redColor,
                      ),
                      onRatingUpdate: (rating) {
                        setState(() {
                          _rating = rating;
                        });
                      },
                    ),
                    Text(
                      'Rating: $_rating',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.39,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('applications')
                        .where('Id', isEqualTo: applicationIDRef)
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
                            if (streamSnapshot.hasData) {
                              switch (streamSnapshot.connectionState) {
                                case ConnectionState.active:
                                  return Align(
                                    alignment: Alignment.topCenter,
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
                                              "Mark application as done",
                                              style:
                                                  textActiveButtonStyleRefugee,
                                            ),
                                            onPressed: () async {
                                              setState(() {
                                                sendPushMessage();
                                                FirebaseFirestore.instance
                                                    .collection('applications')
                                                    .doc(streamSnapshot
                                                        .data?.docs[index].id)
                                                    .update({
                                                  "voluneer_rating": _rating
                                                });
                                                FirebaseFirestore.instance
                                                    .collection('users')
                                                    .doc(iiiIDVolOfApplication)
                                                    .update({
                                                  "num_ranking":
                                                      (numberRating + 1),
                                                  "ranking":
                                                      (ratingSum + _rating),
                                                });
                                                FirebaseFirestore.instance
                                                    .collection('applications')
                                                    .doc(streamSnapshot
                                                        .data?.docs[index].id)
                                                    .update({"status": "done"});
                                              });

                                              iiIdApplicationVolInfo != ""
                                                  ? FirebaseFirestore.instance
                                                      .collection(
                                                          'USERS_COLLECTION')
                                                      .doc(
                                                          iiIdApplicationVolInfo)
                                                      .delete()
                                                  : null;
                                              Future.delayed(
                                                  const Duration(
                                                      milliseconds: 500), () {
                                                controllerTabBottomRef =
                                                    PersistentTabController(
                                                        initialIndex: 4);
                                                Navigator.of(context,
                                                        rootNavigator: true)
                                                    .pushReplacement(
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                MainScreenRefugee()));
                                              });
                                            }),
                                      ),
                                    ),
                                  );
                                case ConnectionState.none:
                                  // TODO: Handle this case.
                                  break;
                                case ConnectionState.waiting:
                                  // TODO: Handle this case.
                                  break;
                                case ConnectionState.done:
                                  // TODO: Handle this case.
                                  break;
                              }
                            }
                            return const LoadingRefugee();
                          });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _ratingBar() {
    return RatingBar.builder(
      glowColor: redColor,
      unratedColor: redColor.withOpacity(0.2),
      initialRating: _initialRating,
      minRating: 1,
      direction: _isVertical ? Axis.vertical : Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      itemSize: 40.0,
      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => Icon(
        _selectedIcon ?? Icons.star,
        color: redColor,
      ),
      onRatingUpdate: (rating) {
        setState(() {
          _rating = rating;
        });
      },
      updateOnDrag: true,
    );
  }

  Widget _heading(String text) => Column(
        children: [
          Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 16.0,
            ),
          ),
          const SizedBox(
            height: 20.0,
          ),
        ],
      );
}
