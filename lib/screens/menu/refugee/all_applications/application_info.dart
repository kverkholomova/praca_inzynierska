import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:wol_pro_1/screens/menu/refugee/all_applications/edit_application.dart';
import 'package:wol_pro_1/screens/menu/refugee/all_applications/volunteer_info_ref.dart';
import 'package:wol_pro_1/screens/menu/refugee/main_screen_ref.dart';
import 'package:wol_pro_1/widgets/loading.dart';
import '../accepted_applications/application_info_accepted.dart';
import 'rating.dart';
import '../../../../constants.dart';
import '../../../../models/categories.dart';
import '../home_page/home_ref.dart';
import 'all_app_ref.dart';

double ratingSum = 0;
int numberRating = 0;
String editCategory = '';
String cTitle = '';
String cCurrentCategory = '';
String cComment = '';
String idVolunteerOfApplication = '';
String iiIdApplicationVolInfo = '';

class PageOfApplicationRef extends StatefulWidget {
  const PageOfApplicationRef({Key? key}) : super(key: key);

  @override
  State<PageOfApplicationRef> createState() => _PageOfApplicationRefState();
}

class _PageOfApplicationRefState extends State<PageOfApplicationRef> {
  late AndroidNotificationChannel channel;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  String? token = " ";

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
                  'The application was deleted by refugee, so your help is not necessary anymore.',
              'title': 'Refugee deleted an application'
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
      badge: true,
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

  late StreamSubscription<User?> user;

  void setRate() {
    user = FirebaseAuth.instance.authStateChanges().listen((user) async {
      DocumentSnapshot variable = await FirebaseFirestore.instance
          .collection('users')
          .doc(iiiIDVolOfApplication)
          .get();

      ratingSum = variable['ranking'];
      numberRating = variable['num_ranking'];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setRate();
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
            MaterialPageRoute(builder: (context) => MainScreenRefugee()));
        return true;
      },
      child: Scaffold(
        backgroundColor: backgroundRefugee,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 30,
              color: redColor,
            ),
            onPressed: () {
              setState(() {
                controllerTabBottomRef =
                    PersistentTabController(initialIndex: 4);
              });
              Navigator.of(context, rootNavigator: true).pushReplacement(
                  MaterialPageRoute(builder: (context) => MainScreenRefugee()));
            },
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Align(
            alignment: Alignment.topLeft,
            child: Text(
              "Application details",
              style: GoogleFonts.raleway(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.9,
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('applications')
                      .where('Id', isEqualTo: applicationIDRef)
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
                                        height: streamSnapshot.data?.docs[index]
                                                    ['status'] ==
                                                "done"
                                            ? MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.83
                                            : MediaQuery.of(context)
                                                    .size
                                                    .height *
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
                                                child: streamSnapshot.data
                                                                ?.docs[index]
                                                            ['status'] ==
                                                        "done"
                                                    ? Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(15.0),
                                                            child: Icon(
                                                              Icons
                                                                  .check_circle,
                                                              size: 45,
                                                              color: redColor,
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    : streamSnapshot.data
                                                                ?.docs[index][
                                                            'application_accepted']
                                                        ? Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        15.0),
                                                                child:
                                                                    IconButton(
                                                                  icon: Icon(
                                                                    Icons
                                                                        .info_outline_rounded,
                                                                    size: 30,
                                                                    color:
                                                                        redColor,
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    setState(
                                                                        () {
                                                                      isAcceptedApplicationRefugee =
                                                                          false;
                                                                      idVolunteerOfApplication = streamSnapshot
                                                                          .data
                                                                          ?.docs[index]['volunteerID'];
                                                                      idAppDeleteVol = streamSnapshot
                                                                          .data
                                                                          ?.docs[
                                                                              index]
                                                                          .id;
                                                                    });
                                                                    Navigator.of(
                                                                            context,
                                                                            rootNavigator:
                                                                                true)
                                                                        .pushReplacement(MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                const InfoVolforRef()));
                                                                  },
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        15.0),
                                                                child:
                                                                    IconButton(
                                                                  icon: Icon(
                                                                    Icons
                                                                        .delete_forever,
                                                                    size: 30,
                                                                    color:
                                                                        redColor,
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    dialogBuilderDeleteApplication(
                                                                        context);
                                                                  },
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                        : Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        15.0),
                                                                child:
                                                                    IconButton(
                                                                  icon: Icon(
                                                                    Icons
                                                                        .delete_forever,
                                                                    size: 30,
                                                                    color:
                                                                        redColor,
                                                                  ),
                                                                  onPressed:
                                                                      () {
                                                                    dialogBuilderDeleteApplication(
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
                                                0.03,
                                      ),
                                      streamSnapshot.data?.docs[index]
                                                  ['status'] ==
                                              "done"
                                          ? Container()
                                          : streamSnapshot.data?.docs[index]
                                                  ['application_accepted']
                                              ? Align(
                                                  alignment:
                                                      Alignment.topCenter,
                                                  child: Center(
                                                    child: Container(
                                                      width: double.infinity,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
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
                                                              Navigator.of(
                                                                      context,
                                                                      rootNavigator:
                                                                          true)
                                                                  .pushReplacement(
                                                                      MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              const Rating()));
                                                            });
                                                          }),
                                                    ),
                                                  ),
                                                )
                                              : Align(
                                                  alignment:
                                                      Alignment.topCenter,
                                                  child: Center(
                                                    child: Container(
                                                      width: double.infinity,
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.085,
                                                      decoration:
                                                          buttonActiveDecorationRefugee,
                                                      child: TextButton(
                                                          child: Text(
                                                            "Edit application",
                                                            style:
                                                                textActiveButtonStyleRefugee,
                                                          ),
                                                          onPressed: () async {
                                                            setState(() {
                                                              editCategory =
                                                                  streamSnapshot
                                                                          .data
                                                                          ?.docs[index]
                                                                      [
                                                                      'category'];
                                                              cTitle = streamSnapshot
                                                                          .data
                                                                          ?.docs[
                                                                      index]
                                                                  ['title'];
                                                              cComment = streamSnapshot
                                                                          .data
                                                                          ?.docs[
                                                                      index]
                                                                  ['comment'];
                                                            });
                                                            Navigator.of(
                                                                    context,
                                                                    rootNavigator:
                                                                        true)
                                                                .pushReplacement(
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                EditApplication()));
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
    );
  }

  Future<void> dialogBuilderDeleteApplication(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: backgroundRefugee,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text('Delete application?'),
          titleTextStyle: GoogleFonts.raleway(
            fontSize: 16,
            color: redColor,
          ),
          content: const Text(
              "You are about to delete this application. Are you sure you want to do it?"),
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
                          'Keep application',
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
                          "Delete application",
                          style: textInactiveButtonStyleRefugee,
                        ),
                        onPressed: () async {
                          setState(() {
                            sendPushMessage();
                            FirebaseFirestore.instance
                                .collection('applications')
                                .doc(applicationIDRef)
                                .delete();
                            iiIdApplicationVolInfo != ""
                                ? FirebaseFirestore.instance
                                    .collection('USERS_COLLECTION')
                                    .doc(iiIdApplicationVolInfo)
                                    .delete()
                                : null;

                            controllerTabBottomRef =
                                PersistentTabController(initialIndex: 4);
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
