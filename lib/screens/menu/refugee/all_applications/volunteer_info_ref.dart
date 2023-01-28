import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import 'package:wol_pro_1/constants.dart';
import 'package:wol_pro_1/screens/menu/refugee/accepted_applications/application_info_accepted.dart';
import 'package:wol_pro_1/screens/menu/refugee/main_screen_ref.dart';
import 'package:wol_pro_1/widgets/loading.dart';

import '../home_page/home_ref.dart';
import 'all_app_ref.dart';
import 'application_info.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

final FirebaseFirestore db = FirebaseFirestore.instance;
final FirebaseMessaging fcm = FirebaseMessaging.instance;
String? idAppDeleteVol;

class InfoVolforRef extends StatefulWidget {
  const InfoVolforRef({Key? key}) : super(key: key);

  @override
  State<InfoVolforRef> createState() => _InfoVolforRefState();
}

class _InfoVolforRefState extends State<InfoVolforRef> {
  late StreamSubscription<User?> user;

  @override
  void initState() {
    // TODO: implement initState
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
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body':
                  'The refugee preferred to wait another volunteer, so your assistance is not necessary anymore.',
              'title': 'The refugee preferred to wait another volunteer'
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
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text(
            "Volunteer Info",
            style: GoogleFonts.raleway(
              fontSize: 20,
              color: Colors.black,
            ),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 30,
              color: redColor,
            ),
            onPressed: () {
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
        body: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.85,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .where('id_vol', isEqualTo: idVolunteerOfApplication)
                    .snapshots(),
                builder:
                    (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                  return ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: streamSnapshot.data?.docs.length,
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
                            return SingleChildScrollView(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: padding,
                                    child: Container(
                                      // padding: padding,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.75,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(15),
                                        ),
                                      ),
                                      // color: Colors.white,
                                      child: Padding(
                                        padding: padding,
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.05,
                                            ),
                                            Align(
                                              alignment: Alignment.topLeft,
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                  bottom: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.005,
                                                ),
                                                child: Text(
                                                  streamSnapshot
                                                          .data?.docs[index]
                                                      ['user_name'],
                                                  style: GoogleFonts.raleway(
                                                    fontSize: 24,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.015,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.02),
                                              child: Align(
                                                alignment: Alignment.topLeft,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    streamSnapshot.data?.docs[
                                                                        index][
                                                                    'ranking'] /
                                                                streamSnapshot
                                                                        .data
                                                                        ?.docs[index]
                                                                    [
                                                                    'num_ranking'] >=
                                                            1
                                                        ? Icon(
                                                            Icons.star,
                                                            color: redColor,
                                                            size: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.06,
                                                          )
                                                        : streamSnapshot.data?.docs[
                                                                            index]
                                                                        [
                                                                        'ranking'] /
                                                                    streamSnapshot
                                                                            .data
                                                                            ?.docs[index]
                                                                        ['num_ranking'] ==
                                                                0.5
                                                            ? Icon(
                                                                Icons.star_half,
                                                                color: redColor,
                                                                size: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.06,
                                                              )
                                                            : Icon(
                                                                Icons
                                                                    .star_border,
                                                                color: redColor,
                                                                size: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.06,
                                                              ),
                                                    streamSnapshot.data?.docs[
                                                                        index][
                                                                    'ranking'] /
                                                                streamSnapshot
                                                                        .data
                                                                        ?.docs[index]
                                                                    [
                                                                    'num_ranking'] >=
                                                            2
                                                        ? Icon(
                                                            Icons.star_rate,
                                                            color: redColor,
                                                            size: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.06,
                                                          )
                                                        : streamSnapshot.data?.docs[
                                                                            index]
                                                                        [
                                                                        'ranking'] /
                                                                    streamSnapshot
                                                                            .data
                                                                            ?.docs[index]
                                                                        ['num_ranking'] ==
                                                                1.5
                                                            ? Icon(
                                                                Icons.star_half,
                                                                color: redColor,
                                                                size: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.06,
                                                              )
                                                            : Icon(
                                                                Icons
                                                                    .star_border,
                                                                color: redColor,
                                                                size: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.06,
                                                              ),
                                                    streamSnapshot.data?.docs[
                                                                        index][
                                                                    'ranking'] /
                                                                streamSnapshot
                                                                        .data
                                                                        ?.docs[index]
                                                                    [
                                                                    'num_ranking'] >=
                                                            3
                                                        ? Icon(
                                                            Icons.star_rate,
                                                            color: redColor,
                                                            size: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.06,
                                                          )
                                                        : streamSnapshot.data?.docs[
                                                                            index]
                                                                        [
                                                                        'ranking'] /
                                                                    streamSnapshot
                                                                            .data
                                                                            ?.docs[index]
                                                                        ['num_ranking'] ==
                                                                2.5
                                                            ? Icon(
                                                                Icons.star_half,
                                                                color: redColor,
                                                                size: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.06,
                                                              )
                                                            : Icon(
                                                                Icons
                                                                    .star_border,
                                                                color: redColor,
                                                                size: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.06,
                                                              ),
                                                    streamSnapshot.data?.docs[
                                                                        index][
                                                                    'ranking'] /
                                                                streamSnapshot
                                                                        .data
                                                                        ?.docs[index]
                                                                    [
                                                                    'num_ranking'] >=
                                                            4
                                                        ? Icon(
                                                            Icons.star_rate,
                                                            color: redColor,
                                                            size: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.06,
                                                          )
                                                        : streamSnapshot.data?.docs[
                                                                            index]
                                                                        [
                                                                        'ranking'] /
                                                                    streamSnapshot
                                                                            .data
                                                                            ?.docs[index]
                                                                        ['num_ranking'] ==
                                                                3.5
                                                            ? Icon(
                                                                Icons.star_half,
                                                                color: redColor,
                                                                size: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.06,
                                                              )
                                                            : Icon(
                                                                Icons
                                                                    .star_border,
                                                                color: redColor,
                                                                size: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.06,
                                                              ),
                                                    streamSnapshot.data?.docs[
                                                                        index][
                                                                    'ranking'] /
                                                                streamSnapshot
                                                                        .data
                                                                        ?.docs[index]
                                                                    [
                                                                    'num_ranking'] >=
                                                            5
                                                        ? Icon(
                                                            Icons.star_rate,
                                                            color: redColor,
                                                            size: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.06,
                                                          )
                                                        : streamSnapshot.data?.docs[
                                                                            index]
                                                                        [
                                                                        'ranking'] /
                                                                    streamSnapshot
                                                                            .data
                                                                            ?.docs[index]
                                                                        ['num_ranking'] ==
                                                                4.5
                                                            ? Icon(
                                                                Icons.star_half,
                                                                color: redColor,
                                                                size: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.06,
                                                              )
                                                            : Icon(
                                                                Icons
                                                                    .star_border,
                                                                color: redColor,
                                                                size: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.06,
                                                              ),
                                                  ],
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
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                  bottom: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.005,
                                                ),
                                                child: Text(
                                                  "Volunteer's phone number:",
                                                  style: GoogleFonts.raleway(
                                                    fontSize: 12,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.topLeft,
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                  bottom: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.005,
                                                ),
                                                child: Row(
                                                  children: [
                                                    IconButton(
                                                        onPressed: () {
                                                          UrlLauncher.launch(
                                                              "tel://${streamSnapshot.data?.docs[index]['phone_number']}");
                                                        },
                                                        icon: const Icon(
                                                            Icons.phone)),
                                                    Text(
                                                      streamSnapshot
                                                              .data?.docs[index]
                                                          ['phone_number'],
                                                      style:
                                                          GoogleFonts.raleway(
                                                        fontSize: 14,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.015,
                                            ),
                                            Divider(color: redColor),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.015,
                                  ),
                                  Padding(
                                    padding: padding,
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Center(
                                        child: Container(
                                          width: double.infinity,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.085,
                                          decoration:
                                              buttonActiveDecorationRefugee,
                                          child: TextButton(
                                              child: Text(
                                                "Decline this volunteer",
                                                style:
                                                    textActiveButtonStyleRefugee,
                                              ),
                                              onPressed: () {
                                                dialogBuilderDeclineVolunteer(
                                                    context);
                                              }),
                                        ),
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
                        return const LoadingRefugee();
                      });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> dialogBuilderDeclineVolunteer(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: backgroundRefugee,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text('Decline volunteer?'),
          titleTextStyle: GoogleFonts.raleway(
            fontSize: 16,
            color: redColor,
          ),
          content: const Text(
              "You are about to decline this volunteer. If you are ready to do it, your application would become active for other volunteers and you would have to wait until another volunteer accept your application to help you."),
          contentTextStyle: GoogleFonts.raleway(
            fontSize: 13,
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
                    decoration: buttonActiveDecorationRefugee,
                    child: TextButton(
                        child: Text(
                          'Keep volunteer',
                          style: textActiveButtonStyleRefugee,
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
                    decoration: buttonInactiveDecorationRefugee,
                    child: TextButton(
                        child: Text(
                          "Decline volunteer",
                          style: textInactiveButtonStyleRefugee,
                        ),
                        onPressed: () async {
                          sendPushMessage();
                          setState(() {
                            controllerTabBottomRef =
                                PersistentTabController(initialIndex: 4);

                            FirebaseFirestore.instance
                                .collection('applications')
                                .doc(applicationIDRef)
                                .update({
                              "volunteerID": "",
                              "application_accepted": false,
                              "chatId_vol": "null",
                              "date": "",
                              "mess_button_visibility_ref": false,
                              "mess_button_visibility_vol": true,
                              "status": "Sent to volunteer",
                              "token_vol": "",
                              "voluneer_rating": 5,
                              "volunteer_name": ""
                            });

                            iiIdApplicationVolInfo != ""
                                ? FirebaseFirestore.instance
                                    .collection('USERS_COLLECTION')
                                    .doc(iiIdApplicationVolInfo)
                                    .delete()
                                : null;
                          });
                          Future.delayed(const Duration(milliseconds: 500), () {
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
