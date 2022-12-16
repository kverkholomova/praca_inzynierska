import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:wol_pro_1/constants.dart';

import 'all_app_ref.dart';
import 'application_info.dart';


final FirebaseFirestore db = FirebaseFirestore.instance;
final FirebaseMessaging fcm = FirebaseMessaging.instance;

class InfoVolforRef extends StatefulWidget {
  const InfoVolforRef({Key? key}) : super(key: key);

  @override
  State<InfoVolforRef> createState() => _InfoVolforRefState();
}

class _InfoVolforRefState extends State<InfoVolforRef> {
  late StreamSubscription<User?> user;
  String idAppDeleteVol = '';
  deleteVolunteer(){
    user = FirebaseAuth.instance.authStateChanges().listen((user) async {

      DocumentSnapshot variable = await FirebaseFirestore.instance.
      collection('applications').
      doc(applicationIDRef).
      get();

      idAppDeleteVol = variable.id;

    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context, rootNavigator: true).pushReplacement(
            MaterialPageRoute(
                builder: (context) => const PageOfApplicationRef()));
        return true;
      },
      child: Scaffold(
        backgroundColor: background,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text(
            "Volunteer Info",
            style: GoogleFonts.raleway(
              fontSize: 20,
              color: blueColor,
            ),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 30,
              color: blueColor,
            ),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pushReplacement(
                  MaterialPageRoute(
                      builder: (context) => const PageOfApplicationRef()));
              // Navigator.push(context,
              //     MaterialPageRoute(builder: (context) => const HomeVol()));
            },
          ),
        ),

        // appBar: AppBar(
        //   backgroundColor: Color.fromRGBO(49, 72, 103, 0.8),
        //   elevation: 0.0,
        //   title: Text('Users Info',style: TextStyle(fontSize: 16),),
        //
        // ),
        body: SingleChildScrollView(
          child: Column(
            children: [

              SizedBox(
                height: MediaQuery
                    .of(context)
                    .size
                    .height *
                    0.9,
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .where('id_vol',
                      isEqualTo: IDVolInfo)
                      .snapshots(),
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                    return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: streamSnapshot.data?.docs.length,
                        itemBuilder: (ctx, index) {
                          // categories_user = streamSnapshot.data?.docs[index]['category'];
                          // token_vol = streamSnapshot.data?.docs[index]['token'];
                          // current_name_Vol = streamSnapshot.data?.docs[index]['user_name'];

                          if (streamSnapshot.hasData) {
                            switch (streamSnapshot.connectionState) {
                              case ConnectionState.waiting:
                                return Column(children: const [
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
                          return SingleChildScrollView(
                            child: Padding(
                              padding: padding,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height:
                                    MediaQuery
                                        .of(context)
                                        .size
                                        .height * 0.015,
                                  ),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        bottom: MediaQuery
                                            .of(context)
                                            .size
                                            .height *
                                            0.005,
                                      ),
                                      child: Text(
                                        streamSnapshot.data?.docs[index]
                                        ['user_name'],
                                        style: GoogleFonts.raleway(
                                          fontSize: 20,
                                          color:  blueColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height:
                                    MediaQuery
                                        .of(context)
                                        .size
                                        .height * 0.015,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: MediaQuery.of(
                                            context)
                                            .size
                                            .width *
                                            0.02),
                                    child: Align(
                                      alignment:
                                      Alignment.topLeft,
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        children: [
                                          streamSnapshot.data?.docs[
                                          index]
                                          [
                                          'ranking'] >=
                                              1
                                              ? Icon(
                                            Icons.star,
                                            color: blueColor,
                                            size: MediaQuery.of(
                                                context)
                                                .size
                                                .width *
                                                0.06,
                                          )
                                              : streamSnapshot
                                              .data
                                              ?.docs[index]['ranking'] ==
                                              0.5
                                              ? Icon(
                                            Icons
                                                .star_half,
                                            color: blueColor,
                                            size: MediaQuery.of(context)
                                                .size
                                                .width *
                                                0.06,
                                          )
                                              : Icon(
                                            Icons
                                                .star_border,
                                            color: blueColor,
                                            size: MediaQuery.of(context)
                                                .size
                                                .width *
                                                0.06,
                                          ),
                                          streamSnapshot.data?.docs[
                                          index]
                                          [
                                          'ranking'] >=
                                              2
                                              ? Icon(
                                            Icons
                                                .star_rate,
                                            color: blueColor,
                                            size: MediaQuery.of(
                                                context)
                                                .size
                                                .width *
                                                0.06,
                                          )
                                              : streamSnapshot
                                              .data
                                              ?.docs[index]['ranking'] ==
                                              1.5
                                              ? Icon(
                                            Icons
                                                .star_half,
                                            color: blueColor,
                                            size: MediaQuery.of(context)
                                                .size
                                                .width *
                                                0.06,
                                          )
                                              : Icon(
                                            Icons
                                                .star_border,
                                            color: blueColor,
                                            size: MediaQuery.of(context)
                                                .size
                                                .width *
                                                0.06,
                                          ),
                                          streamSnapshot.data?.docs[
                                          index]
                                          [
                                          'ranking'] >=
                                              3
                                              ? Icon(
                                            Icons
                                                .star_rate,
                                            color: blueColor,
                                            size: MediaQuery.of(
                                                context)
                                                .size
                                                .width *
                                                0.06,
                                          )
                                              : streamSnapshot
                                              .data
                                              ?.docs[index]['ranking'] ==
                                              2.5
                                              ? Icon(
                                            Icons
                                                .star_half,
                                            color: blueColor,
                                            size: MediaQuery.of(context)
                                                .size
                                                .width *
                                                0.06,
                                          )
                                              : Icon(
                                            Icons
                                                .star_border,
                                            color: blueColor,
                                            size: MediaQuery.of(context)
                                                .size
                                                .width *
                                                0.06,
                                          ),
                                          streamSnapshot.data?.docs[
                                          index]
                                          [
                                          'ranking'] >=
                                              4
                                              ? Icon(
                                            Icons
                                                .star_rate,
                                            color: blueColor,
                                            size: MediaQuery.of(
                                                context)
                                                .size
                                                .width *
                                                0.06,
                                          )
                                              : streamSnapshot
                                              .data
                                              ?.docs[index]['ranking'] ==
                                              3.5
                                              ? Icon(
                                            Icons
                                                .star_half,
                                            color: blueColor,
                                            size: MediaQuery.of(context)
                                                .size
                                                .width *
                                                0.06,
                                          )
                                              : Icon(
                                            Icons
                                                .star_border,
                                            color: blueColor,
                                            size: MediaQuery.of(context)
                                                .size
                                                .width *
                                                0.06,
                                          ),
                                          streamSnapshot.data?.docs[
                                          index]
                                          [
                                          'ranking'] >=
                                              5
                                              ? Icon(
                                            Icons
                                                .star_rate,
                                            color: blueColor,
                                            size: MediaQuery.of(
                                                context)
                                                .size
                                                .width *
                                                0.06,
                                          )
                                              : streamSnapshot
                                              .data
                                              ?.docs[index]['ranking'] ==
                                              4.5
                                              ? Icon(
                                            Icons
                                                .star_half,
                                            color: blueColor,
                                            size: MediaQuery.of(context)
                                                .size
                                                .width *
                                                0.06,
                                          )
                                              : Icon(
                                            Icons
                                                .star_border,
                                            color: blueColor,
                                            size: MediaQuery.of(context)
                                                .size
                                                .width *
                                                0.06,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height:
                                    MediaQuery
                                        .of(context)
                                        .size
                                        .height * 0.015,
                                  ),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        bottom: MediaQuery
                                            .of(context)
                                            .size
                                            .height *
                                            0.005,
                                      ),
                                      child: Text(
                                        streamSnapshot.data?.docs[index]
                                        ['phone_number'],
                                        style: GoogleFonts.raleway(
                                          fontSize: 14,
                                          color:  blueColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height:
                                    MediaQuery
                                        .of(context)
                                        .size
                                        .height * 0.015,
                                  ),

                                  Divider(color: blueColor),
                                  SizedBox(
                                    height:
                                    MediaQuery
                                        .of(context)
                                        .size
                                        .height * 0.55,
                                  ),

                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Center(
                                      child: Container(
                                        width: double.infinity,
                                        height: MediaQuery
                                            .of(context)
                                            .size
                                            .height *
                                            0.085,
                                        decoration: buttonActiveDecoration,
                                        child: TextButton(
                                            child: Text(
                                              "Decline this volunteer",
                                              style: textActiveButtonStyle,
                                            ),
                                            onPressed: () {
                                              dialogBuilderDeclineVolunteer(context);

                                            }),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height:
                                    MediaQuery
                                        .of(context)
                                        .size
                                        .height * 0.015,
                                  ),

                                ],
                              ),
                            ),

                          );
                              case ConnectionState.none:
                              // TODO: Handle this case.
                                break;
                              case ConnectionState.done:
                              // TODO: Handle this case.
                                break;
                            }}
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 100),
                              child: Column(
                                children: const [
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
            ],
          ),
        ),

        // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        // floatingActionButton:
        // Padding(
        //   padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.77,),
        //   child: Padding(
        //     padding: padding,
        //     child: Align(
        //       alignment: Alignment.bottomCenter,
        //       child: StreamBuilder(
        //           stream: FirebaseFirestore.instance
        //               .collection('users')
        //               .where('id_vol', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        //               .snapshots(),
        //           builder:
        //               (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
        //             return ListView.builder(
        //                 itemCount: !streamSnapshot.hasData
        //                     ? 1
        //                     : streamSnapshot.data?.docs.length,
        //                 itemBuilder: (ctx, index) {
        //                   return Center(
        //                     child: Container(
        //                       width: double.infinity,
        //                       height: MediaQuery.of(context).size.height *
        //                           0.075,
        //                       decoration: buttonDecoration,
        //                       child: TextButton(
        //                           child: Text(
        //                             "Done",
        //                             style: textButtonStyle,
        //                           ),
        //                           onPressed: () async {
        //                             FirebaseFirestore.instance
        //                                 .collection('users')
        //                                 .doc(streamSnapshot
        //                                 .data?.docs[index].id)
        //                                 .update({
        //                               "category": chosenCategoryList
        //                             });
        //                             Navigator.push(
        //                                 context,
        //                                 MaterialPageRoute(
        //                                     builder: (context) =>
        //                                     const HomeVol()));
        //                           }),
        //                     ),
        //                   );
        //                 });
        //           }),
        //     ),
        //   ),
        // ),
        // FloatingActionButton(
        //   child: const Text('Done'),
        //   onPressed: () {
        //     FirebaseFirestore.instance
        //         .collection("users")
        //         .doc(FirebaseAuth.instance.currentUser?.uid)
        //         .update({"category": chosen_category_settings});
        //     // print(categories_user);
        //     // categories_user = streamSnapshot.data?.docs[index]['category'];
        //     // print("OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO__________OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO");
        //     // print(categories_user);
        //     // Navigator.push(context, MaterialPageRoute(builder: (context) => Categories()));
        //
        //     showDialog<String>(
        //       context: context,
        //       builder: (BuildContext context) => AlertDialog(
        //         title: const Text('Confirm changes'),
        //         content: const Text(
        //             'Are you sure that you want to change your settings?'),
        //         actions: <Widget>[
        //           TextButton(
        //             onPressed: () {
        //               Navigator.push(context,
        //                   MaterialPageRoute(builder: (context) => HomeVol()));
        //             },
        //             child: const Text('Cancel'),
        //           ),
        //           TextButton(
        //             onPressed: () {
        //               // categories_user= [];
        //               categories_user_Register = chosen_category_settings;
        //               print(
        //                   "OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO__________OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO");
        //               // print(categories_user);
        //               Navigator.push(
        //                   context,
        //                   MaterialPageRoute(
        //                       builder: (context) => YourCategories()));
        //             },
        //             child: const Text('Yes'),
        //           ),
        //         ],
        //       ),
        //     );
        //   },
        // ),
      ),
    );
  }
  Future<void> dialogBuilderDeclineVolunteer(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text('Decline volunteer?'),
          titleTextStyle: GoogleFonts.raleway(
            fontSize: 16,
            color: blueColor,
          ),
          content: const Text("You are about to decline this volunteer. If you are ready to do it, your application would become active for other volunteers and you would have to wait until another volunteer accept your application to help you."),
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
                    height: MediaQuery.of(context).size.height *
                        0.085,
                    decoration: buttonActiveDecoration,
                    child: TextButton(
                        child: Text(
                          'Keep volunteer',
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
              height:
              MediaQuery.of(context).size.height *
                  0.01,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Center(
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height *
                        0.085,
                    decoration: buttonInactiveDecoration,
                    child: TextButton(
                        child: Text(
                          "Decline volunteer",
                          style: textInactiveButtonStyle,
                        ),
                        onPressed: () async {
                          setState(() {
                            FirebaseFirestore.instance
                                .collection('applications')
                                .doc(idAppDeleteVol).update({"volunteerID": "",
                              "application_accepted": false,
                              "chatId_vol":"",
                              "date":"",
                              "mess_button_visibility_ref": false,
                              "mess_button_visibility_vol": true,
                              "status":"Sent to volunteer",
                              "token_vol": "",
                              "voluneer_rating":0,
                              "volunteerID":"",
                              "volunteer_name":""
                            });
                            FirebaseFirestore.instance.collection('USERS_COLLECTION').doc(IdApplicationVolInfo).delete();
                          });

                          Future.delayed(const Duration(milliseconds: 500), () {

                            Navigator.of(context, rootNavigator: true).pushReplacement(
                                MaterialPageRoute(builder: (context) => new PageOfApplicationRef()));});

                        }),
                  ),
                ),
              ),
            ),
            SizedBox(
              height:
              MediaQuery.of(context).size.height *
                  0.02,
            ),

          ],
        );
      },
    );
  }
}