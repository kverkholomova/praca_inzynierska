import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:wol_pro_1/constants.dart';
import 'package:wol_pro_1/screens/intro_screen/option.dart';
import 'package:wol_pro_1/screens/menu/volunteer/home_page/settings/upload_photo.dart';
import 'package:wol_pro_1/screens/menu/volunteer/main_screen.dart';
import 'package:wol_pro_1/widgets/datepicker.dart';
import '../../../../../../service/local_push_notifications.dart';

import '../../../../../services/auth.dart';
import 'application_info.dart';


final FirebaseFirestore db = FirebaseFirestore.instance;
final FirebaseMessaging fcm = FirebaseMessaging.instance;

class InfoVolforRef extends StatefulWidget {
  const InfoVolforRef({Key? key}) : super(key: key);

  @override
  State<InfoVolforRef> createState() => _InfoVolforRefState();
}

class _InfoVolforRefState extends State<InfoVolforRef> {


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context, rootNavigator: true).pushReplacement(
            MaterialPageRoute(
                builder: (context) => new PageOfApplicationRef()));
        return true;
      },
      child: Scaffold(
        backgroundColor: background,
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        floatingActionButton: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 30,
            color: background,
          ),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pushReplacement(
                MaterialPageRoute(
                    builder: (context) => new PageOfApplicationRef()));
            // Navigator.push(context,
            //     MaterialPageRoute(builder: (context) => const HomeVol()));
          },
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
                    0.69,
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .where('id_vol',
                      isEqualTo: IDVolInfo)
                      .snapshots(),
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                    return ListView.builder(
                        itemCount: streamSnapshot.data?.docs.length,
                        itemBuilder: (ctx, index) {
                          // categories_user = streamSnapshot.data?.docs[index]['category'];
                          // token_vol = streamSnapshot.data?.docs[index]['token'];
                          // current_name_Vol = streamSnapshot.data?.docs[index]['user_name'];
                          return SingleChildScrollView(
                            child: Padding(
                              padding: padding,
                              child: Column(
                                children: [

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
                                        style: textLabelSeparated,
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
                                      Alignment.topCenter,
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment
                                            .center,
                                        children: [
                                          streamSnapshot.data?.docs[
                                          index]
                                          [
                                          'ranking'] >=
                                              1
                                              ? Icon(
                                            Icons.star,
                                            color: Colors
                                                .white,
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
                                            color: Colors
                                                .white,
                                            size: MediaQuery.of(context)
                                                .size
                                                .width *
                                                0.06,
                                          )
                                              : Icon(
                                            Icons
                                                .star_border,
                                            color: Colors
                                                .white,
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
                                            color: Colors
                                                .white,
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
                                            color: Colors
                                                .white,
                                            size: MediaQuery.of(context)
                                                .size
                                                .width *
                                                0.06,
                                          )
                                              : Icon(
                                            Icons
                                                .star_border,
                                            color: Colors
                                                .white,
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
                                            color: Colors
                                                .white,
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
                                            color: Colors
                                                .white,
                                            size: MediaQuery.of(context)
                                                .size
                                                .width *
                                                0.06,
                                          )
                                              : Icon(
                                            Icons
                                                .star_border,
                                            color: Colors
                                                .white,
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
                                            color: Colors
                                                .white,
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
                                            color: Colors
                                                .white,
                                            size: MediaQuery.of(context)
                                                .size
                                                .width *
                                                0.06,
                                          )
                                              : Icon(
                                            Icons
                                                .star_border,
                                            color: Colors
                                                .white,
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
                                            color: Colors
                                                .white,
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
                                            color: Colors
                                                .white,
                                            size: MediaQuery.of(context)
                                                .size
                                                .width *
                                                0.06,
                                          )
                                              : Icon(
                                            Icons
                                                .star_border,
                                            color: Colors
                                                .white,
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
                                        style: textLabelSeparated,
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
                                        .height * 0.015,
                                  ),
                                  SizedBox(
                                      height: MediaQuery
                                          .of(context)
                                          .size
                                          .height *
                                          0.01),

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
                                              "Save changes",
                                              style: textActiveButtonStyle,
                                            ),
                                            onPressed: () async {

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

}