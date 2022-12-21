import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wol_pro_1/to_delete/messages_ref.dart';
import 'package:wol_pro_1/to_delete/pageWithChats.dart';
import 'package:wol_pro_1/screens/menu/refugee/all_applications/rating.dart';
import 'package:wol_pro_1/to_delete/info_volunteer_accepted_application.dart';

import '../../../../constants.dart';
import '../accepted_applications/accepted_applications.dart';
import 'all_app_ref.dart';
import 'application_info.dart';

String IDVolOfApplication = '';
// String? token;
final FirebaseFirestore _db = FirebaseFirestore.instance;
final FirebaseMessaging _fcm = FirebaseMessaging.instance;

class Rating extends StatefulWidget {
  const Rating({Key? key}) : super(key: key);

  @override
  State<Rating> createState() => _RatingState();
}

class _RatingState extends State<Rating> {
  late final _ratingController;
  late double _rating;

  double _userRating = 3.0;
  int _ratingBarMode = 1;
  double _initialRating = 5.0;
  bool _isRTLMode = false;
  bool _isVertical = false;

  IconData? _selectedIcon;

  late AndroidNotificationChannel channel;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  String? token = " ";

  @override
  void initState() {
    _ratingController = TextEditingController(text: '3.0');
    _rating = _initialRating;
    super.initState();
  }

  final CollectionReference applications =
      FirebaseFirestore.instance.collection('applications');

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context,
            rootNavigator:
            true)
            .pushReplacement(
            MaterialPageRoute(
                builder:
                    (context) =>
                    PageOfApplicationRef()));
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => PageOfApplicationRef()),
        // );
        return true;
      },
      child: Scaffold(
        backgroundColor: background,
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
              color: blueColor,
            ),
            onPressed: () async {
              Navigator.of(context,
                  rootNavigator:
                  true)
                  .pushReplacement(
                  MaterialPageRoute(
                      builder:
                          (context) =>
                          PageOfApplicationRef()));
              // await _auth.signOut();
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => PageOfApplicationRef()),
              // );
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
                      glowColor: blueColor,
                      unratedColor: blueColor.withOpacity(0.2),
                      initialRating: _initialRating,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      // unratedColor: Colors.amber.withAlpha(50),
                      itemCount: 5,
                      itemSize: 40.0,

                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => Icon(
                        _selectedIcon ?? Icons.star,
                        color: blueColor,
                      ),
                      onRatingUpdate: (rating) {
                        setState(() {
                          _rating = rating;
                        });
                      },
                      updateOnDrag: true,
                    ),
                    Text(
                      'Rating: $_rating',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.39,
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('applications')
                            .where('Id', isEqualTo: applicationIDRef)
                            // .where('category', isEqualTo: card_category_ref)
                            // .where('comment', isEqualTo: card_comment_ref)
                            .snapshots(),
                        builder: (context,
                            AsyncSnapshot<QuerySnapshot> streamSnapshot) {
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
                                          child: CircularProgressIndicator(
                                            color: background,
                                          ),
                                        ),
                                      ]);
                                    case ConnectionState.active:
                                      return Column(
                                        children: [
                                          Align(
                                            alignment: Alignment.topCenter,
                                            child: Center(
                                              child: Container(
                                                width: double.infinity,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.085,
                                                decoration:
                                                    buttonInactiveDecoration,
                                                child: TextButton(
                                                    child: Text(
                                                      "Mark application as done",
                                                      style:
                                                          textInactiveButtonStyle,
                                                    ),
                                                    onPressed: () async {
                                                      setState(() {
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'applications')
                                                            .doc(streamSnapshot
                                                                .data
                                                                ?.docs[index]
                                                                .id)
                                                            .update({
                                                          "voluneer_rating":
                                                              _rating
                                                        });
                                                        // sendPushMessage();
                                                        //
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'applications')
                                                            .doc(streamSnapshot
                                                                .data
                                                                ?.docs[index]
                                                                .id)
                                                            .update({
                                                          "status": "done"
                                                        });
                                                      });

                                                      Future.delayed(
                                                          const Duration(
                                                              milliseconds:
                                                                  500), () {
                                                        Navigator.of(context,
                                                                rootNavigator:
                                                                    true)
                                                            .pushReplacement(
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            PageOfApplicationRef()));
                                                      });
                                                      // Navigator.push(
                                                      //   context,
                                                      //   MaterialPageRoute(
                                                      //       builder: (context) =>
                                                      //           CategoriesRef()),
                                                      // );
                                                      //
                                                      //   context,
                                                      //   MaterialPageRoute(
                                                      //       builder: (context) =>
                                                      //           Rating_Page()),
                                                      // );

                                                      // sendPushMessage();
                                                      // FirebaseFirestore.instance
                                                      //     .collection(
                                                      //         'applications')
                                                      //     .doc(streamSnapshot.data
                                                      //         ?.docs[index].id)
                                                      //     .delete();
                                                      // setState(() {
                                                      //   controllerTabBottomRef =
                                                      //       PersistentTabController(
                                                      //           initialIndex: 4);
                                                      // });
                                                      // Navigator.of(context,
                                                      //         rootNavigator: true)
                                                      //     .pushReplacement(
                                                      //         MaterialPageRoute(
                                                      //             builder:
                                                      //                 (context) =>
                                                      //                     MainScreenRefugee()));
                                                    }),
                                              ),
                                            ),
                                          ),
                                          // SizedBox(
                                          //   height: MediaQuery.of(context).size.height * 0.015,
                                          // ),
                                          // Align(
                                          //   alignment: Alignment.topCenter,
                                          //   child: Center(
                                          //     child: Container(
                                          //       width: double.infinity,
                                          //       height:
                                          //       MediaQuery.of(context).size.height *
                                          //           0.085,
                                          //       decoration: buttonInactiveDecoration,
                                          //       child: TextButton(
                                          //           child: Text(
                                          //             "Delete",
                                          //             style: textInactiveButtonStyle,
                                          //           ),
                                          //           onPressed: () async {
                                          //             sendPushMessage();
                                          //             FirebaseFirestore.instance
                                          //                                               .collection('applications')
                                          //                                               .doc(streamSnapshot.data?.docs[index].id).delete();
                                          //             setState(() {
                                          //               controllerTabBottomRef = PersistentTabController(initialIndex: 4);
                                          //             });
                                          //             Navigator.of(context, rootNavigator: true).pushReplacement(
                                          //                 MaterialPageRoute(builder: (context) => MainScreenRefugee()));
                                          //           }),
                                          //     ),
                                          //   ),
                                          // ),

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
                // SizedBox(
                //   height: MediaQuery.of(context).size.height * 0.1,
                //   child: StreamBuilder(
                //     stream: FirebaseFirestore.instance
                //         .collection('applications')
                //         .where('Id', isEqualTo: applicationIDRef)
                //
                //         .snapshots(),
                //     builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                //       return ListView.builder(
                //           // physics: NeverScrollableScrollPhysics(),
                //           shrinkWrap: true,
                //           itemCount: streamSnapshot.data?.docs.length,
                //           itemBuilder: (ctx, index) {
                //             // User? user = FirebaseAuth.instance.currentUser;
                //             // final docId = streamSnapshot.data!.docs[index]["volunteerID"];
                //
                //             switch (streamSnapshot.connectionState) {
                //               case ConnectionState.waiting:
                //                 return Container();
                //
                //               case ConnectionState.active:
                //                 return Align(
                //                   alignment: Alignment.topCenter,
                //                   child: Center(
                //                     child: Container(
                //                       width: double.infinity,
                //                       height: MediaQuery
                //                           .of(context)
                //                           .size
                //                           .height *
                //                           0.085,
                //                       decoration:
                //                       buttonActiveDecoration,
                //                       child: TextButton(
                //                           child: Text(
                //                               "Submit",
                //                               style: textActiveButtonStyle),
                //
                //
                //                           onPressed: () {
                //                             FirebaseFirestore.instance
                //                                 .collection('applications')
                //                                 .doc(
                //                                 streamSnapshot.data?.docs[index]
                //                                     .id)
                //                                 .update(
                //                                 {"voluneer_rating": _rating});
                //                             // sendPushMessage();
                //                             //
                //                             FirebaseFirestore.instance
                //                                 .collection('applications')
                //                                 .doc(
                //                                 streamSnapshot.data?.docs[index]
                //                                     .id)
                //                                 .update({"status": "done"});
                //
                //                             // Navigator.push(
                //                             //   context,
                //                             //   MaterialPageRoute(
                //                             //       builder: (context) =>
                //                             //           CategoriesRef()),
                //                             // );
                //
                //                           }),
                //                     ),
                //                   ),
                //                 );
                //             }
                //             return Container();
                //           });
                //     },
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _ratingBar() {
    // switch (mode) {
    //   case 1:
    return RatingBar.builder(
      glowColor: blueColor,
      unratedColor: blueColor.withOpacity(0.2),
      initialRating: _initialRating,
      minRating: 1,
      direction: _isVertical ? Axis.vertical : Axis.horizontal,
      allowHalfRating: true,
      // unratedColor: Colors.amber.withAlpha(50),
      itemCount: 5,
      itemSize: 40.0,

      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => Icon(
        _selectedIcon ?? Icons.star,
        color: blueColor,
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
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 16.0,
            ),
          ),
          SizedBox(
            height: 20.0,
          ),
        ],
      );
}

//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:wol_pro_1/Refugee/applications/application_info_accepted.dart';
//
//
//
// class Rating_Page extends StatefulWidget {
//   @override
//   _Rating_PageState createState() => _Rating_PageState();
// }
//
// class _Rating_PageState extends State<Rating_Page> {
//   late final _ratingController;
//   late double _rating;
//
//   double _userRating = 3.0;
//   int _ratingBarMode = 1;
//   double _initialRating = 2.0;
//   bool _isRTLMode = false;
//   bool _isVertical = false;
//
//   IconData? _selectedIcon;
//
//   @override
//   void initState() {
//     super.initState();
//     _ratingController = TextEditingController(text: '3.0');
//     _rating = _initialRating;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//         onWillPop: () async {
//
//       Navigator.push(
//         context,
//         MaterialPageRoute(builder: (context) => PageOfApplicationRef()),
//       );
//       return true;
//     },
//     child: MaterialApp(
//       debugShowCheckedModeBanner: false,
//       // theme: ThemeData(
//       //   primarySwatch: Colors.amber,
//       //   appBarTheme: AppBarTheme(
//       //     titleTextStyle: Theme.of(context)
//       //         .textTheme
//       //         .headline6
//       //         ?.copyWith(color: Colors.white),
//       //   ),
//       // ),
//       home: Builder(
//         builder: (context) => Scaffold(
//           appBar: AppBar(
//             backgroundColor: Color.fromRGBO(49, 72, 103, 0.8),
//             title: Text('Application is done'),
//             leading: IconButton(
//               icon: const Icon(Icons.arrow_back,color: Colors.white,),
//               onPressed: () async {
//                 // await _auth.signOut();
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => PageOfApplicationRef()),
//                 );
//               },
//             ),
//             // actions: [
//             //   IconButton(
//             //     icon: Icon(Icons.settings),
//             //     color: Colors.white,
//             //     onPressed: () async {
//             //       _selectedIcon = await showDialog<IconData>(
//             //         context: context,
//             //         builder: (context) => IconAlert(),
//             //       );
//             //       _ratingBarMode = 1;
//             //       setState(() {});
//             //     },
//             //   ),
//             // ],
//           ),
//           body: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisSize: MainAxisSize.min,
//               children: <Widget>[
//                 SizedBox(
//                   height: 40.0,
//                 ),
//                 Align(
//                   alignment: Alignment.bottomLeft,
//                   child: Padding(
//                     padding: const EdgeInsets.all(10.0),
//                     child: Text("Your application is done now!", style: TextStyle(fontSize: 18),textAlign: TextAlign.left,),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(10.0),
//                   child: Text("We are happy that our app helped you to find an assistance.", style: TextStyle(fontSize: 16),),
//                 ),
//                 SizedBox(
//                   height: 200.0,
//                 ),
//                 _heading('Rate volunteer assistance'),
//                 _ratingBar(_ratingBarMode),
//                 SizedBox(height: 20.0),
//                 Text(
//                   'Rating: $_rating',
//                   style: TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(top: 20),
//                   child: SizedBox(
//                     height: 50,
//                     width: 300,
//                     child: MaterialButton(
//                         child: Text(
//                           "Submit",
//                           style: TextStyle(color: Colors.white),
//                         ),
//                         color: Color.fromRGBO(18, 56, 79, 0.8),
//                         onPressed: () {
//
//
//                           // sendPushMessage();
//                           //
//                           // FirebaseFirestore.instance
//                           //     .collection('applications')
//                           //     .doc(streamSnapshot.data?.docs[index].id)
//                           //     .update({"status": "deleted"});
//
//
//                         }),
//                   ),
//                 ),
//                 // SizedBox(height: 40.0),
//                 // _heading('Rating Indicator'),
//                 // RatingBarIndicator(
//                 //   rating: _userRating,
//                 //   itemBuilder: (context, index) => Icon(
//                 //     _selectedIcon ?? Icons.star,
//                 //     color: Colors.amber,
//                 //   ),
//                 //   itemCount: 5,
//                 //   itemSize: 50.0,
//                 //   unratedColor: Colors.amber.withAlpha(50),
//                 //   direction: _isVertical ? Axis.vertical : Axis.horizontal,
//                 // ),
//                 // SizedBox(height: 20.0),
//                 // Padding(
//                 //   padding: EdgeInsets.symmetric(horizontal: 16.0),
//                 //   child: TextFormField(
//                 //     controller: _ratingController,
//                 //     keyboardType: TextInputType.number,
//                 //     decoration: InputDecoration(
//                 //       border: OutlineInputBorder(),
//                 //       hintText: 'Enter rating',
//                 //       labelText: 'Enter rating',
//                 //       suffixIcon: MaterialButton(
//                 //         onPressed: () {
//                 //           _userRating =
//                 //               double.parse(_ratingController.text ?? '0.0');
//                 //           setState(() {});
//                 //         },
//                 //         child: Text('Rate'),
//                 //       ),
//                 //     ),
//                 //   ),
//                 // ),
//                 // SizedBox(height: 40.0),
//                 // _heading('Scrollable Rating Indicator'),
//                 // RatingBarIndicator(
//                 //   rating: 8.2,
//                 //   itemCount: 20,
//                 //   itemSize: 30.0,
//                 //   physics: BouncingScrollPhysics(),
//                 //   itemBuilder: (context, _) => Icon(
//                 //     Icons.star,
//                 //     color: Colors.amber,
//                 //   ),
//                 // ),
//                 // SizedBox(height: 20.0),
//                 // Text(
//                 //   'Rating Bar Modes',
//                 //   style: TextStyle(fontWeight: FontWeight.w300),
//                 // ),
//                 // Row(
//                 //   children: [
//                 //     _radio(1),
//                 //     _radio(2),
//                 //     _radio(3),
//                 //   ],
//                 // ),
//                 // Row(
//                 //   mainAxisAlignment: MainAxisAlignment.center,
//                 //   children: <Widget>[
//                 //     Text(
//                 //       'Switch to Vertical Bar',
//                 //       style: TextStyle(fontWeight: FontWeight.w300),
//                 //     ),
//                 //     Switch(
//                 //       value: _isVertical,
//                 //       onChanged: (value) {
//                 //         setState(() {
//                 //           _isVertical = value;
//                 //         });
//                 //       },
//                 //       activeColor: Colors.amber,
//                 //     ),
//                 //   ],
//                 // ),
//                 // Row(
//                 //   mainAxisAlignment: MainAxisAlignment.center,
//                 //   children: <Widget>[
//                 //     Text(
//                 //       'Switch to RTL Mode',
//                 //       style: TextStyle(fontWeight: FontWeight.w300),
//                 //     ),
//                 //     Switch(
//                 //       value: _isRTLMode,
//                 //       onChanged: (value) {
//                 //         setState(() {
//                 //           _isRTLMode = value;
//                 //         });
//                 //       },
//                 //       activeColor: Colors.amber,
//                 //     ),
//                 //   ],
//                 // ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     )
//     );
//   }
//
//   // Widget _radio(int value) {
//   //   return Expanded(
//   //     child: RadioListTile<int>(
//   //       value: value,
//   //       groupValue: _ratingBarMode,
//   //       dense: true,
//   //       title: Text(
//   //         'Mode $value',
//   //         style: TextStyle(
//   //           fontWeight: FontWeight.w300,
//   //           fontSize: 12.0,
//   //         ),
//   //       ),
//   //       onChanged: (value) {
//   //         setState(() {
//   //           _ratingBarMode = value!;
//   //         });
//   //       },
//   //     ),
//   //   );
//   // }
//
//   Widget _ratingBar(int mode) {
//     // switch (mode) {
//     //   case 1:
//         return RatingBar.builder(
//           initialRating: _initialRating,
//           minRating: 1,
//           direction: _isVertical ? Axis.vertical : Axis.horizontal,
//           allowHalfRating: true,
//           unratedColor: Colors.amber.withAlpha(50),
//           itemCount: 5,
//           itemSize: 40.0,
//           itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
//           itemBuilder: (context, _) => Icon(
//             _selectedIcon ?? Icons.star,
//             color: Colors.amber,
//           ),
//           onRatingUpdate: (rating) {
//             setState(() {
//               _rating = rating;
//             });
//           },
//           updateOnDrag: true,
//         );
//       // case 2:
//       //   return RatingBar(
//       //     initialRating: _initialRating,
//       //     direction: _isVertical ? Axis.vertical : Axis.horizontal,
//       //     allowHalfRating: true,
//       //     itemCount: 5,
//       //     ratingWidget: RatingWidget(
//       //       full: _image('assets/heart.png'),
//       //       half: _image('assets/heart_half.png'),
//       //       empty: _image('assets/heart_border.png'),
//       //     ),
//       //     itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
//       //     onRatingUpdate: (rating) {
//       //       setState(() {
//       //         _rating = rating;
//       //       });
//       //     },
//       //     updateOnDrag: true,
//       //   );
//       // case 3:
//       //   return RatingBar.builder(
//       //     initialRating: _initialRating,
//       //     direction: _isVertical ? Axis.vertical : Axis.horizontal,
//       //     itemCount: 5,
//       //     itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
//       //     itemBuilder: (context, index) {
//       //       switch (index) {
//       //         case 0:
//       //           return Icon(
//       //             Icons.sentiment_very_dissatisfied,
//       //             color: Colors.red,
//       //           );
//       //         case 1:
//       //           return Icon(
//       //             Icons.sentiment_dissatisfied,
//       //             color: Colors.redAccent,
//       //           );
//       //         case 2:
//       //           return Icon(
//       //             Icons.sentiment_neutral,
//       //             color: Colors.amber,
//       //           );
//       //         case 3:
//       //           return Icon(
//       //             Icons.sentiment_satisfied,
//       //             color: Colors.lightGreen,
//       //           );
//       //         case 4:
//       //           return Icon(
//       //             Icons.sentiment_very_satisfied,
//       //             color: Colors.green,
//       //           );
//       //         default:
//       //           return Container();
//       //       }
//       //     },
//       //     onRatingUpdate: (rating) {
//       //       setState(() {
//       //         _rating = rating;
//       //       });
//       //     },
//       //     updateOnDrag: true,
//       //   );
//       // default:
//       //   return Container();
//     // }
//   }
//
//   // Widget _image(String asset) {
//   //   return Image.asset(
//   //     asset,
//   //     height: 30.0,
//   //     width: 30.0,
//   //     color: Colors.amber,
//   //   );
//   // }
//
//   Widget _heading(String text) => Column(
//     children: [
//       Text(
//         text,
//         style: TextStyle(
//           fontWeight: FontWeight.w300,
//           fontSize: 16.0,
//         ),
//       ),
//       SizedBox(
//         height: 20.0,
//       ),
//     ],
//   );
// }

// class IconAlert extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text(
//         'Select Icon',
//         style: TextStyle(
//           fontWeight: FontWeight.w300,
//         ),
//       ),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10.0),
//       ),
//       titlePadding: EdgeInsets.all(12.0),
//       contentPadding: EdgeInsets.all(0),
//       content: Wrap(
//         children: [
//           _iconButton(context, Icons.home),
//           _iconButton(context, Icons.airplanemode_active),
//           _iconButton(context, Icons.euro_symbol),
//           _iconButton(context, Icons.beach_access),
//           _iconButton(context, Icons.attach_money),
//           _iconButton(context, Icons.music_note),
//           _iconButton(context, Icons.android),
//           _iconButton(context, Icons.toys),
//           _iconButton(context, Icons.language),
//           _iconButton(context, Icons.landscape),
//           _iconButton(context, Icons.ac_unit),
//           _iconButton(context, Icons.star),
//         ],
//       ),
//     );
//   }
//
//   Widget _iconButton(BuildContext context, IconData icon) => IconButton(
//     icon: Icon(icon),
//     onPressed: () => Navigator.pop(context, icon),
//     splashColor: Colors.amberAccent,
//     color: Colors.amber,
//   );
// }

// import 'package:cloud_firestore/cloud_firestore.dart';
// import "package:flutter/material.dart";
//
// import 'applications/application_info_accepted.dart';
//
// var icon_chosen = Icons.star_border;
// var icon_chosen1 = Icons.star_border;
//
// class Rating_Page extends StatefulWidget {
//   const Rating_Page({Key? key}) : super(key: key);
//
//   @override
//   State<Rating_Page> createState() => _Rating_PageState();
// }
//
// class _Rating_PageState extends State<Rating_Page> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Color.fromRGBO(49, 72, 103, 0.8),
//         elevation: 0.0,
//         title: Text('Application Info',style: TextStyle(fontSize: 16),),
//
//       ),
//       body: Container(
//         color: Color.fromRGBO(234, 191, 213, 0.8),
//         child: StreamBuilder(
//           stream: FirebaseFirestore.instance
//               .collection('users')
//               .where('id_vol', isEqualTo: IDVolOfApplication)
//               .snapshots(),
//
//           builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
//             return ListView.builder(
//                 itemCount: streamSnapshot.data?.docs.length,
//                 itemBuilder: (ctx, index) =>
//                     Column(
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.only(top: 30),
//                           child: Text(
//                             streamSnapshot.data?.docs[index]['user_name'],
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,fontSize: 16,color: Colors.black,),textAlign: TextAlign.center,
//                           ),
//
//                         ),
//
//                         Text(
//                           streamSnapshot.data?.docs[index]['phone_number'],
//                           style: TextStyle(color: Colors.grey,fontSize: 14),textAlign: TextAlign.center,),
//
//                         // Text(
//                         //   streamSnapshot.data?.docs[index]['date'],
//                         //   style: TextStyle(color: Colors.grey,fontSize: 14),textAlign: TextAlign.center,),
//
//                         Row(
//                           children: [
//                             IconButton(onPressed: (){
//                               icon_chosen = Icons.star;
//                             },
//                               icon: Icon(icon_chosen, color: Colors.grey,),),
//                             IconButton(onPressed: (){
//                               icon_chosen = Icons.star;
//                               icon_chosen1 = Icons.star;
//                             },
//                               icon: Icon(icon_chosen1, color: Colors.grey,),)
//                           ],
//                         )
//                       ],
//                     ));
//           },
//         ),
//       ),
//
//     );
//
//   }
// }
