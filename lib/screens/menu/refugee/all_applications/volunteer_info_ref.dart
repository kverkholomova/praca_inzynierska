import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:wol_pro_1/constants.dart';
import 'package:wol_pro_1/screens/menu/refugee/accepted_applications/application_info_accepted.dart';
import 'package:wol_pro_1/widgets/loading.dart';

import '../home_page/home_ref.dart';
import 'all_app_ref.dart';
import 'application_info.dart';


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

  void sendPushMessageDeclinedVolunteer() async {
    print(
        "Send Notification that app is done");
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
              'title': 'Refugee marked an applicationas done'
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            "to": "$tokenVolApplication",
          },
        ),
      );
    } catch (e) {
      print("error push notification");
    }
  }

  // deleteVolunteer(){
  //   user = FirebaseAuth.instance.authStateChanges().listen((user) async {
  //
  //     DocumentSnapshot variable = await FirebaseFirestore.instance.
  //     collection('applications').
  //     doc(applicationIDRef).
  //     get();
  //
  //     idAppDeleteVol = variable.id;
  //
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if(isAcceptedApplicationRefugee==true){
          Navigator.of(context, rootNavigator: true).pushReplacement(
              MaterialPageRoute(
                  builder: (context) => const AcceptedPageOfApplicationRef()));
        } else{
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
              if(isAcceptedApplicationRefugee==true){
                Navigator.of(context, rootNavigator: true).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) => const AcceptedPageOfApplicationRef()));
              } else{
                Navigator.of(context, rootNavigator: true).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) => const PageOfApplicationRef()));
              }
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
        body: Column(
          children: [

            SizedBox(
              height: MediaQuery
                  .of(context)
                  .size
                  .height *
                  0.85,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .where('id_vol',
                    isEqualTo: idVolunteerOfApplication)
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

                        // if (streamSnapshot.hasData) {
                          switch (streamSnapshot.connectionState) {
                            case ConnectionState.waiting:
                              return Column(children: const [
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
                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              Padding(
                                padding: padding,
                                child: Container(
                                  // padding: padding,
                                  height: MediaQuery
                                      .of(context)
                                      .size
                                      .height * 0.75,
                                  decoration: BoxDecoration(

                                    color: Colors.white,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(15),
                                    ),
                                  ),
                                  // color: Colors.white,
                                  child: Padding(
                                    padding: padding,
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height:
                                          MediaQuery
                                              .of(context)
                                              .size
                                              .height * 0.05,
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
                                                fontSize: 24,
                                                color:  Colors.black,
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
                                                  color: redColor,
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
                                                  color: redColor,
                                                  size: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                      0.06,
                                                )
                                                    : Icon(
                                                  Icons
                                                      .star_border,
                                                  color: redColor,
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
                                                  color: redColor,
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
                                                  color: redColor,
                                                  size: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                      0.06,
                                                )
                                                    : Icon(
                                                  Icons
                                                      .star_border,
                                                  color: redColor,
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
                                                  color: redColor,
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
                                                  color: redColor,
                                                  size: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                      0.06,
                                                )
                                                    : Icon(
                                                  Icons
                                                      .star_border,
                                                  color: redColor,
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
                                                  color: redColor,
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
                                                  color: redColor,
                                                  size: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                      0.06,
                                                )
                                                    : Icon(
                                                  Icons
                                                      .star_border,
                                                  color: redColor,
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
                                                  color: redColor,
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
                                                  color: redColor,
                                                  size: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                      0.06,
                                                )
                                                    : Icon(
                                                  Icons
                                                      .star_border,
                                                  color: redColor,
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
                                                color:  Colors.black,
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

                                        Divider(color: redColor),
                                        // SizedBox(
                                        //   height:
                                        //   MediaQuery
                                        //       .of(context)
                                        //       .size
                                        //       .height * 0.55,
                                        // ),



                                      ],
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
                                padding: padding,
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Center(
                                    child: Container(
                                      width: double.infinity,
                                      height: MediaQuery
                                          .of(context)
                                          .size
                                          .height *
                                          0.085,
                                      decoration: buttonActiveDecorationRefugee,
                                      child: TextButton(
                                          child: Text(
                                            "Decline this volunteer",
                                            style: textActiveButtonStyleRefugee,
                                          ),
                                          onPressed: () {
                                            dialogBuilderDeclineVolunteer(context);

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
                        return LoadingRefugee();
                        //   Center(
                        //   child: Padding(
                        //     padding: const EdgeInsets.only(top: 100),
                        //     child: Column(
                        //       children: [
                        //         SpinKitChasingDots(
                        //           color: redColor,
                        //           size: 50.0,
                        //         ),
                        //         // Align(
                        //         //   alignment: Alignment.center,
                        //         //   child: Text("Waiting...",
                        //         //       style: TextStyle(
                        //         //         fontWeight: FontWeight.bold,
                        //         //         fontSize: 24,
                        //         //         color: Colors.black,
                        //         //       )),
                        //         // ),
                        //       ],
                        //     ),
                        //   ),
                        // );
                      });
                },
              ),
            ),
          ],
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
          backgroundColor: backgroundRefugee,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text('Decline volunteer?'),
          titleTextStyle: GoogleFonts.raleway(
            fontSize: 16,
            color: redColor,
          ),
          content: const Text("You are about to decline this volunteer. If you are ready to do it, your application would become active for other volunteers and you would have to wait until another volunteer accept your application to help you."),
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
                    height: MediaQuery.of(context).size.height *
                        0.085,
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
                    decoration: buttonInactiveDecorationRefugee,
                    child: TextButton(
                        child: Text(
                          "Decline volunteer",
                          style: textInactiveButtonStyleRefugee,
                        ),
                        onPressed: () async {
                          setState(() {

                            FirebaseFirestore.instance
                                .collection('applications')
                                .doc(idAppDeleteVol).update({
                              "volunteerID": "",
                              "application_accepted": false,
                              "chatId_vol":"",
                              "date":"",
                              "mess_button_visibility_ref": false,
                              "mess_button_visibility_vol": true,
                              "status":"Sent to volunteer",
                              "token_vol": "",
                              "voluneer_rating":5,
                              "volunteerID":"",
                              "volunteer_name":""
                            });
                            FirebaseFirestore.instance.collection('USERS_COLLECTION').doc(IdApplicationVolInfo).delete();
                          });

                          Future.delayed(const Duration(milliseconds: 500), () {

                            if(isAcceptedApplicationRefugee==true){
                              Navigator.of(context, rootNavigator: true).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => const AcceptedPageOfApplicationRef()));
                            } else{
                              Navigator.of(context, rootNavigator: true).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => const PageOfApplicationRef()));
                            }});

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