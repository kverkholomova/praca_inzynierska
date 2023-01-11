import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:wol_pro_1/constants.dart';

import 'package:wol_pro_1/services/auth.dart';
import 'package:wol_pro_1/widgets/loading.dart';

import '../../../../models/categories.dart';
import '../../volunteer/all_applications/new_screen_with_applications.dart';
import '../home_page/home_ref.dart';
import 'application_info.dart';
import '../main_screen_ref.dart';

String applicationIDRef = '';
String card_title_ref = '';
String card_category_ref = '';
String card_comment_ref = '';
String IdVolInfoAllApp = '';
String userID_ref = '';
// String? token_vol;

class AllApplicationsRef extends StatefulWidget {
  const AllApplicationsRef({Key? key}) : super(key: key);

  @override
  State createState() => new AllApplicationsRefState();
}

class AllApplicationsRefState extends State<AllApplicationsRef> {
  bool loading = false;
  final AuthService _auth = AuthService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // foregroundMessage();
  }

  // void foregroundMessage(){
  //   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  //
  //     print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAALLLLLLLLLLLLLLLLLLLLL");
  //     print(message.sentTime);
  //   });
  //   // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //   //   print('Got a message whilst in the foreground!');
  //   //   print('Message data: ${message.data}');
  //   //
  //   //   if (message.notification != null) {
  //   //     print('Message also contained a notification: ${message.notification}');
  //   //   }
  //   // });
  //
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        // controllerTabBottomRef = PersistentTabController(initialIndex: 3);
        // Navigator.of(context, rootNavigator: true).pushReplacement(
        //     MaterialPageRoute(builder: (context) => new MainScreenRefugee()));
        return true;
      },
      child: Scaffold(
        backgroundColor: backgroundRefugee,
        // appBar: AppBar(
        //   title: Text('All applications',
        //     style: TextStyle(
        //         color: blueColor
        //     ),
        //   ),
        //   backgroundColor: background,
        //   elevation: 0.0,
        //   // leading: IconButton(
        //   //   icon: Icon(Icons.arrow_back,color: blueColor,),
        //   //   onPressed: () async {
        //   //     // await _auth.signOut();
        //   //     controllerTabBottomRef = PersistentTabController(initialIndex: 3);
        //   //     Navigator.of(context, rootNavigator: true).pushReplacement(
        //   //         MaterialPageRoute(builder: (context) => new MainScreenRefugee()));
        //   //   },
        //   // ),
        //
        //   // bottom: TabBar(
        //   //   indicatorColor: blueColor,
        //   //   isScrollable: true,
        //   //   tabs: [
        //   //     Text(categories[0],style: TextStyle(fontSize: 17, color: blueColor),),
        //   //     Text(categories[1],style: TextStyle(fontSize: 17,color: blueColor),),
        //   //   ],
        //   //
        //   // ),
        // ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              ClipPath(
                clipper: OvalBottomBorderClipper(),
                child: Container(
                  decoration: BoxDecoration(
                    color: redColor,
                    boxShadow: const <BoxShadow>[
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  height: MediaQuery.of(context).size.height * 0.15,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Align(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Text(
                              "Applications",
                              style: GoogleFonts.raleway(
                                fontSize: 24,
                                color: Colors.white,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                "Manage your applications",
                                style: GoogleFonts.raleway(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        )),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.015),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('applications')
                        .where('userID',
                            isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                        // .where("volunteerID", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                        // .where("status", isEqualTo: 'Application is accepted')

                        .snapshots(),
                    builder:
                        (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                      return ListView.builder(
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
                                  return Column(
                                    children: [
                                      Padding(
                                        padding: padding,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {

                                              tokenVolApplication =streamSnapshot
                                                  .data
                                                  ?.docs[index]
                                              [
                                              "token_vol"];

                                              IdApplicationVolInfo =
                                              streamSnapshot
                                                  .data
                                                  ?.docs[index]
                                              [
                                              "chatId_vol"];
                                              IdVolInfoAllApp = streamSnapshot
                                                  .data
                                                  ?.docs[index]['volunteerID'];
                                              FirebaseFirestore.instance
                                                  .collection('applications')
                                                  .doc(streamSnapshot
                                                      .data?.docs[index].id)
                                                  .update({
                                                "Id": streamSnapshot
                                                    .data?.docs[index].id
                                              });
                                              print(
                                                  "IIIIIIIIIIIIIIIDDDDDDDDDDDDDDDDDDDDD");
                                              print(streamSnapshot
                                                  .data?.docs[index].id);
                                              applicationIDRef =
                                                  "${streamSnapshot.data?.docs[index].id}";
                                              //
                                              // id_card = streamSnapshot.data?.docs[index].id;
                                              card_title_vol = streamSnapshot
                                                  .data?.docs[index]['title'];
                                              card_category_vol = streamSnapshot
                                                  .data
                                                  ?.docs[index]['category'];
                                              card_comment_vol = streamSnapshot
                                                  .data?.docs[index]['comment'];
                                              // controllerTabBottomRef = PersistentTabController(initialIndex: 3);
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .pushReplacement(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              new PageOfApplicationRef()));
                                              // Navigator.push(
                                              //   context,
                                              //   MaterialPageRoute(
                                              //       builder: (context) =>
                                              //           PageOfApplication()),
                                              // );
                                              // print("print ${streamSnapshot.data?.docs[index][id]}");
                                            });
                                            // Id_Of_current_application= streamSnapshot.data?.docs[index].id;
                                            // print("GGGGGGGGGGGGGGG________________GGGGGGGGGFFFFFFFFFFFFFFF");
                                            // print(Id_Of_current_application);
                                            //
                                            // card_title_accepted=streamSnapshot.data?.docs[index]['title'] as String;
                                            // card_category_accepted=streamSnapshot.data?.docs[index]['category'] as String;
                                            // card_comment_accepted=streamSnapshot.data?.docs[index]['comment'] as String;
                                            //
                                            // // current_name = streamSnapshot.data?.docs[index]['ref_name'];
                                            //
                                            // Navigator.of(context, rootNavigator: true).pushReplacement(
                                            //     MaterialPageRoute(builder: (context) => new SettingsOfApplicationAccepted()));
                                            // // Navigator.push(
                                            // //   context,
                                            // //   MaterialPageRoute(
                                            // //       builder: (context) => SettingsOfApplication()),
                                            // // );
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            // height: MediaQuery.of(context).size.height *
                                            //     0.2,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(18)),
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.015),
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
                                                      color: streamSnapshot.data?.docs[index]['status']=="done"?Colors.black.withOpacity(0.3):Colors.black,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.65,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.12,
                                                    child: Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: ListTile(
                                                        // mainAxisAlignment: MainAxisAlignment.start,
                                                        // contentPadding:
                                                        // EdgeInsets.symmetric(
                                                        //     vertical: 10),
                                                        title: Text(
                                                            streamSnapshot.data
                                                                        ?.docs[index]
                                                                    ['title']
                                                                as String,
                                                            style: GoogleFonts
                                                                .raleway(
                                                              fontSize: 14,
                                                              color:streamSnapshot.data?.docs[index]['status']=="done"?Colors.black.withOpacity(0.3):
                                                                  Colors.black,
                                                            )),
                                                        // Text(
                                                        //     streamSnapshot.data?.docs[index]['category'] as String,
                                                        //     style: TextStyle(color: Colors.grey)),
                                                        subtitle: Text(
                                                          "${streamSnapshot.data?.docs[index]['comment']}"
                                                                  .substring(
                                                                      0, 30) +
                                                              "...",
                                                          style: GoogleFonts
                                                              .raleway(
                                                            fontSize: 13,
                                                            color: streamSnapshot.data?.docs[index]['status']=="done"?Colors.black.withOpacity(0.2):Colors.black
                                                                .withOpacity(
                                                                    0.5),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          // Stack(
                                          //   children: [
                                          //     Align(
                                          //         alignment: Alignment.topRight,
                                          //         child: Container(child: Icon(Icons.zoom_in_rounded, color: Colors.grey[700], size: 20,))),
                                          //     Column(
                                          //       children: [
                                          //         Align(
                                          //           alignment: Alignment.topLeft,
                                          //           child: Text(
                                          //             streamSnapshot.data?.docs[index]['title'] as String,
                                          //             style: TextStyle(
                                          //                 fontWeight: FontWeight.bold),
                                          //           ),
                                          //         ),
                                          //         Align(
                                          //           alignment: Alignment.topLeft,
                                          //           child: Text(
                                          //               streamSnapshot.data?.docs[index]
                                          //               ['category'] as String,
                                          //               style: TextStyle(color: Colors.grey)),
                                          //         ),
                                          //         Align(
                                          //           alignment: Alignment.topLeft,
                                          //           child: Text(streamSnapshot.data?.docs[index]
                                          //           ['comment'] as String),
                                          //         ),
                                          //       ],
                                          //     ),
                                          //   ],
                                          // ),
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.015,
                                      ),
                                    ],
                                  );
                              }
                            }
                            return LoadingRefugee();
                            //   Center(
                            //   child: Padding(
                            //     padding: EdgeInsets.only(top: 100),
                            //     child: Column(
                            //       children: [
                            //         // SpinKitChasingDots(
                            //         //   color: Colors.brown,
                            //         //   size: 50.0,
                            //         // ),
                            //         Align(
                            //           alignment: Alignment.center,
                            //           child: Text("",
                            //               style: TextStyle(
                            //                 fontWeight: FontWeight.bold,
                            //                 fontSize: 24,
                            //                 color: Colors.black,
                            //               )),
                            //         ),
                            //         Padding(
                            //           padding: EdgeInsets.only(top: 20),
                            //         )
                            //       ],
                            //     ),
                            //   ),
                            // );
                          });
                    },
                  ),
                ),
              )
            ],
          ),
        ),
        // Stack(
        //   children: [
        // ClipPath(
        //   clipper: OvalBottomBorderClipper(),
        //   child: Container(
        //     decoration: BoxDecoration(
        //       color: blueColor,
        //       boxShadow: const <BoxShadow>[
        //         BoxShadow(
        //           color: Colors.black,
        //           blurRadius: 5,
        //         ),
        //       ],
        //     ),
        //     height: MediaQuery.of(context).size.height * 0.15,
        //     child: Padding(
        //       padding: const EdgeInsets.symmetric(vertical: 20),
        //       child: Align(
        //           alignment: Alignment.center,
        //           child: Column(
        //             children: [
        //               Text(
        //                 "All applications",
        //                 style: GoogleFonts.raleway(
        //                   fontSize: 24,
        //                   color: Colors.white,
        //                 ),
        //               ),
        //               Padding(
        //                 padding: const EdgeInsets.all(5.0),
        //                 child: Text(
        //                   "Manage your applications",
        //                   style: GoogleFonts.raleway(
        //                     fontSize: 16,
        //                     color: Colors.white,
        //                   ),
        //                 ),
        //               ),
        //             ],
        //           )),
        //     ),
        //   ),
        // ),
        // Column(
        //   children: [
        //     SizedBox(
        //       height: ,
        //       child: StreamBuilder(
        //         stream: FirebaseFirestore.instance
        //         .collection('applications')
        //         .where('userID',
        //             isEqualTo:
        //                 FirebaseAuth.instance.currentUser?.uid)
        //
        //         // .where("category",
        //         // isEqualTo: categoryChosenVolunteer)
        //
        //         //.where("volunteer_pref", arrayContainsAny: volunteer_preferencies)
        //         //.where("category", arrayContainsAny: ['Accomodation', 'Transfer', 'Assistance with animals'])
        //         //     .where("status",
        //         //     isEqualTo: 'Sent to volunteer')
        //
        //         //.where("category", whereIn: ['Accomodation','Transfer','Assistance with animals'])
        //         //.where("category", arrayContainsAny: ['Accomodation','Transfer','Assistance with animals'])
        //         .snapshots(),
        //         builder: (context,
        //         AsyncSnapshot<QuerySnapshot?> streamSnapshot) {
        //           //                           var tom = streamSnapshot.data!.docs;
        //           // if (tom.isEmpty) {
        //           // return Center(
        //           // child: Padding(
        //           // padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1,),
        //           // child: Column(
        //           // children: const [
        //           // Align(
        //           // alignment: Alignment.center,
        //           // child: Text("There is no data...",
        //           // style: TextStyle(
        //           // fontWeight: FontWeight.bold,
        //           // fontSize: 24,
        //           // color: Colors.black,
        //           // )),
        //           // ),
        //           // Padding(
        //           // padding: EdgeInsets.only(top: 20),
        //           // )
        //           // ],
        //           // ),
        //           // ),
        //           // );
        //           // }
        //           // else
        //           //   if (streamSnapshot.data!.docs.isNotEmpty) {
        //
        //           return ListView.builder(
        //           physics: NeverScrollableScrollPhysics(),
        //           shrinkWrap: true,
        //           itemCount: streamSnapshot.data?.docs.length,
        //           itemBuilder: (ctx, index) {
        //             // if (streamSnapshot.hasData) {
        //             switch (streamSnapshot.connectionState) {
        //               case ConnectionState.waiting:
        //                 return Padding(
        //                   padding: EdgeInsets.only(
        //                     top:
        //                         MediaQuery.of(context).size.height *
        //                             0.0,
        //                   ),
        //                   child: Align(
        //                     alignment: Alignment.topCenter,
        //                     child: Text("",
        //                         style: GoogleFonts.raleway(
        //                           fontSize: 25,
        //                           color: Colors.white,
        //                         )),
        //                   ),
        //                 );
        //               case ConnectionState.active:
        //                 return Column(
        //                   children: [
        //                     GestureDetector(
        //                       onTap: () {
        //                         setState(() {
        //                           IdVolInfoAllApp = streamSnapshot
        //                               .data
        //                               ?.docs[index]['volunteerID'];
        //                           FirebaseFirestore.instance
        //                               .collection('applications')
        //                               .doc(streamSnapshot
        //                                   .data?.docs[index].id)
        //                               .update({
        //                             "Id": streamSnapshot
        //                                 .data?.docs[index].id
        //                           });
        //                           print(
        //                               "IIIIIIIIIIIIIIIDDDDDDDDDDDDDDDDDDDDD");
        //                           print(streamSnapshot
        //                               .data?.docs[index].id);
        //                           applicationIDRef =
        //                               "${streamSnapshot.data?.docs[index].id}";
        //                           //
        //                           // id_card = streamSnapshot.data?.docs[index].id;
        //                           card_title_vol = streamSnapshot
        //                               .data?.docs[index]['title'];
        //                           card_category_vol = streamSnapshot
        //                               .data
        //                               ?.docs[index]['category'];
        //                           card_comment_vol = streamSnapshot
        //                               .data?.docs[index]['comment'];
        //                           // controllerTabBottomRef = PersistentTabController(initialIndex: 3);
        //                           Navigator.of(context,
        //                                   rootNavigator: true)
        //                               .pushReplacement(
        //                                   MaterialPageRoute(
        //                                       builder: (context) =>
        //                                           new PageOfApplicationRef()));
        //                           // Navigator.push(
        //                           //   context,
        //                           //   MaterialPageRoute(
        //                           //       builder: (context) =>
        //                           //           PageOfApplication()),
        //                           // );
        //                           // print("print ${streamSnapshot.data?.docs[index][id]}");
        //                         });
        //                       },
        //                       child: Container(
        //                         width: double.infinity,
        //                         // height: MediaQuery.of(context).size.height *
        //                         //     0.2,
        //                         decoration: BoxDecoration(
        //                             color: Colors.white,
        //                             borderRadius:
        //                                 BorderRadius.circular(15)),
        //                         child: Row(
        //                           children: [
        //                             Padding(
        //                               padding: EdgeInsets.only(
        //                                   left:
        //                                       MediaQuery.of(context)
        //                                               .size
        //                                               .height *
        //                                           0.015),
        //                               child: Icon(
        //                                 streamSnapshot.data?.docs[index]
        //                                                 ['category']
        //                                             as String ==
        //                                         categoriesListAll[3]
        //                                     ? Icons.pets_rounded
        //                                     : streamSnapshot.data?.docs[index]
        //                                                     ['category']
        //                                                 as String ==
        //                                             categoriesListAll[
        //                                                 4]
        //                                         ? Icons
        //                                             .local_grocery_store
        //                                         : streamSnapshot.data?.docs[index]
        //                                                         ['category']
        //                                                     as String ==
        //                                                 categoriesListAll[
        //                                                     2]
        //                                             ? Icons
        //                                                 .emoji_transportation_rounded
        //                                             : streamSnapshot
        //                                                         .data
        //                                                         ?.docs[index]['category'] as String ==
        //                                                     categoriesListAll[1]
        //                                                 ? Icons.house
        //                                                 : streamSnapshot.data?.docs[index]['category'] as String == categoriesListAll[6]
        //                                                     ? Icons.sign_language_rounded
        //                                                     : streamSnapshot.data?.docs[index]['category'] as String == categoriesListAll[5]
        //                                                         ? Icons.child_care_outlined
        //                                                         : streamSnapshot.data?.docs[index]['category'] as String == categoriesListAll[7]
        //                                                             ? Icons.menu_book
        //                                                             : streamSnapshot.data?.docs[index]['category'] as String == categoriesListAll[8]
        //                                                                 ? Icons.medical_information_outlined
        //                                                                 : streamSnapshot.data?.docs[index]['category'] as String == categoriesListAll[0]
        //                                                                     ? Icons.check_box
        //                                                                     : Icons.new_label_sharp,
        //                                 size: 30,
        //                                 color: streamSnapshot.data
        //                                                 ?.docs[index]
        //                                             ['status'] ==
        //                                         "done"
        //                                     ? Colors.black
        //                                         .withOpacity(0.3)
        //                                     : Colors.black,
        //                               ),
        //                             ),
        //                             SizedBox(
        //                               width: MediaQuery.of(context)
        //                                       .size
        //                                       .width *
        //                                   0.65,
        //                               height: MediaQuery.of(context)
        //                                       .size
        //                                       .height *
        //                                   0.12,
        //                               child: Align(
        //                                 alignment:
        //                                     Alignment.topCenter,
        //                                 child: ListTile(
        //                                   // mainAxisAlignment: MainAxisAlignment.start,
        //                                   contentPadding:
        //                                       EdgeInsets.symmetric(
        //                                           vertical: 4),
        //                                   title: Padding(
        //                                     padding:
        //                                         const EdgeInsets
        //                                                 .symmetric(
        //                                             horizontal: 12),
        //                                     child: Text(
        //                                         streamSnapshot.data
        //                                                     ?.docs[index]
        //                                                 ['title']
        //                                             as String,
        //                                         style: GoogleFonts
        //                                             .raleway(
        //                                           fontSize: 14,
        //                                           color: streamSnapshot
        //                                                           .data
        //                                                           ?.docs[index]
        //                                                       [
        //                                                       'status'] ==
        //                                                   "done"
        //                                               ? Colors.black
        //                                                   .withOpacity(
        //                                                       0.5)
        //                                               : Colors
        //                                                   .black,
        //                                         )),
        //                                   ),
        //                                   // Text(
        //                                   //     streamSnapshot.data?.docs[index]['category'] as String,
        //                                   //     style: TextStyle(color: Colors.grey)),
        //                                   subtitle: Padding(
        //                                     padding:
        //                                         const EdgeInsets
        //                                                 .symmetric(
        //                                             horizontal: 12),
        //                                     child: Text(
        //                                       "${streamSnapshot.data?.docs[index]['comment']}"
        //                                               .substring(
        //                                                   0, 30) +
        //                                           "...",
        //                                       style: GoogleFonts
        //                                           .raleway(
        //                                         fontSize: 12,
        //                                         color: streamSnapshot
        //                                                         .data
        //                                                         ?.docs[index]
        //                                                     [
        //                                                     'status'] ==
        //                                                 "done"
        //                                             ? Colors.black
        //                                                 .withOpacity(
        //                                                     0.2)
        //                                             : Colors.black
        //                                                 .withOpacity(
        //                                                     0.5),
        //                                       ),
        //                                     ),
        //                                   ),
        //                                 ),
        //                               ),
        //                             ),
        //                           ],
        //                         ),
        //                       ),
        //                     ),
        //                     SizedBox(
        //                       height: MediaQuery.of(context)
        //                               .size
        //                               .height *
        //                           0.012,
        //                     ),
        //                   ],
        //                 );
        //               // case ConnectionState.none:
        //               //
        //               // case ConnectionState.done:
        //               // // TODO: Handle this case.
        //               //   break;
        //             }
        //             // }
        //             return Container();
        //           });
        //           //                           return ListView.builder(
        //           //                               physics: NeverScrollableScrollPhysics(),
        //           //                               shrinkWrap: true,
        //           //                               scrollDirection: Axis.vertical,
        //           //                               itemCount: streamSnapshot.data?.docs.length,
        //           //                               itemBuilder: (ctx, index)
        //           //                               {
        //           //                               if (streamSnapshot.hasData) {
        //           //                               switch (streamSnapshot.connectionState) {
        //           //                               case ConnectionState.waiting:
        //           //                               return Padding(
        //           //                               padding: EdgeInsets.only(
        //           //                               top: MediaQuery.of(context).size.height * 0.0,
        //           //                               ),
        //           //                               child: Align(
        //           //                               alignment: Alignment.topCenter,
        //           //                               child: Text("Waiting for data",
        //           //                               style: GoogleFonts.raleway(
        //           //                               fontSize: 25,
        //           //                               color: Colors.white,
        //           //                               )),
        //           //                               ),
        //           //                               );
        //           //                               case ConnectionState.active:
        //           //                                       return  Column(
        //           //                                           children: [
        //           //                                             GestureDetector(
        //           //                                               onTap: () {
        //           //                                                 setState(() {
        //           //                                                   // FirebaseFirestore.instance
        //           //                                                   //     .collection('applications')
        //           //                                                   //     .doc(streamSnapshot.data?.docs[index].id)
        //           //                                                   //     .update({"Id": streamSnapshot.data?.docs[index].id});
        //           //                                                   //
        //           //                                                   // id_card = streamSnapshot.data?.docs[index].id;
        //           //                                                   card_title_vol =
        //           //                                                       streamSnapshot.data
        //           //                                                               ?.docs[index]
        //           //                                                           ['title'];
        //           //                                                   card_category_vol =
        //           //                                                       streamSnapshot.data
        //           //                                                               ?.docs[index]
        //           //                                                           ['category'];
        //           //                                                   card_comment_vol =
        //           //                                                       streamSnapshot.data
        //           //                                                               ?.docs[index]
        //           //                                                           ['comment'];
        //           //                                                   Navigator.push(
        //           //                                                     context,
        //           //                                                     MaterialPageRoute(
        //           //                                                         builder: (context) =>
        //           //                                                             PageOfApplication()),
        //           //                                                   );
        //           //                                                   // print("print ${streamSnapshot.data?.docs[index][id]}");
        //           //                                                 });
        //           //                                               },
        //           //                                               child: Container(
        //           //                                                 width: double.infinity,
        //           //                                                 // height: MediaQuery.of(context).size.height *
        //           //                                                 //     0.2,
        //           //                                                 decoration: BoxDecoration(
        //           //                                                     color: Colors.white,
        //           //                                                     borderRadius:
        //           //                                                         BorderRadius
        //           //                                                             .circular(24)),
        //           //                                                 child: ListTile(
        //           //                                                   // mainAxisAlignment: MainAxisAlignment.start,
        //           //
        //           //                                                   contentPadding:
        //           //                                                       EdgeInsets.symmetric(
        //           //                                                           vertical: 5),
        //           //                                                   title: Padding(
        //           //                                                     padding:
        //           //                                                         const EdgeInsets
        //           //                                                                 .symmetric(
        //           //                                                             horizontal: 12),
        //           //                                                     child: Text(
        //           //                                                         streamSnapshot.data
        //           //                                                                     ?.docs[index]
        //           //                                                                 ['title']
        //           //                                                             as String,
        //           //                                                         style: GoogleFonts
        //           //                                                             .raleway(
        //           //                                                           fontSize: 16,
        //           //                                                           color:
        //           //                                                               Colors.black,
        //           //                                                         )),
        //           //                                                   ),
        //           //                                                   // Text(
        //           //                                                   //     streamSnapshot.data?.docs[index]['category'] as String,
        //           //                                                   //     style: TextStyle(color: Colors.grey)),
        //           //                                                   subtitle: Padding(
        //           //                                                     padding:
        //           //                                                         const EdgeInsets
        //           //                                                                 .symmetric(
        //           //                                                             horizontal: 12),
        //           //                                                     child: Text(
        //           //                                                       streamSnapshot.data
        //           //                                                                   ?.docs[index]
        //           //                                                               ['comment']
        //           //                                                           as String,
        //           //                                                       style: GoogleFonts
        //           //                                                           .raleway(
        //           //                                                         fontSize: 14,
        //           //                                                         color: Colors.black
        //           //                                                             .withOpacity(
        //           //                                                                 0.5),
        //           //                                                       ),
        //           //                                                     ),
        //           //                                                   ),
        //           //                                                 ),
        //           //                                               ),
        //           //                                             ),
        //           //                                           ],
        //           //                                         );
        //           //                                 // case ConnectionState.none:
        //           //                                 //
        //           //                                 // case ConnectionState.done:
        //           //                                 // // TODO: Handle this case.
        //           //                                 //   break;
        //           //                               }
        //           //                               }
        //           //                               return Container();
        //           //
        //           //                                       });
        //           // }
        //           // return Container();
        //         },
        //       ),
        //     ),
        //   ],
        // ),
        //   ],
        // )
        // TabBarView(
        //   children: [

        // StreamBuilder(
        //   stream: FirebaseFirestore.instance
        //
        //       .collection('applications')
        //       .where('userID', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        //
        //
        //
        //   //.where("volunteer_pref", arrayContainsAny: volunteer_preferencies)
        //   //.where("category", arrayContainsAny: ['Accomodation', 'Transfer', 'Assistance with animals'])
        //
        //   //     .where("status", isEqualTo: 'Application is accepted')
        //
        //
        //
        //   //.where("category", whereIn: ['Accomodation','Transfer','Assistance with animals'])
        //   //.where("category", arrayContainsAny: ['Accomodation','Transfer','Assistance with animals'])
        //       .snapshots(),
        //   builder: (context, AsyncSnapshot<QuerySnapshot?> streamSnapshot) {
        //     return ListView.builder(
        //         scrollDirection: Axis.vertical,
        //         itemCount: streamSnapshot.data?.docs.length,
        //         itemBuilder: (ctx, index) => Column(
        //           children: [
        //             SizedBox(
        //               height: MediaQuery.of(context).size.height * 0.015,
        //             ),
        //             Padding(
        //               padding: padding,
        //               child: GestureDetector(
        //                   onTap: () {
        //                     setState(() {
        //                       card_title_ref=streamSnapshot.data?.docs[index]['title'] as String;
        //                       card_category_ref=streamSnapshot.data?.docs[index]['category'] as String;
        //                       card_comment_ref=streamSnapshot.data?.docs[index]['comment'] as String;
        //                       application_ID = streamSnapshot.data?.docs[index].id as String;
        //                       token_vol=streamSnapshot.data?.docs[index]["token_vol"]as String;
        //                       print(card_title_ref);
        //                       print(card_category_ref);
        //                       print(card_comment_ref);
        //                       Navigator.push(
        //                         context,
        //                         MaterialPageRoute(
        //                             builder: (context) => PageOfApplicationRef()),
        //                       );
        //                       // print("print ${streamSnapshot.data?.docs[index][id]}");
        //                     });
        //
        //                   },
        //                   child: Container(
        //                     width: double.infinity,
        //                     // height: MediaQuery.of(context).size.height *
        //                     //     0.2,
        //                     decoration: BoxDecoration(
        //                         color: Colors.white,
        //                         borderRadius:
        //                         BorderRadius.circular(
        //                             18)),
        //                     child: Align(
        //                       alignment: Alignment.center,
        //                       child: Row(
        //                         mainAxisAlignment: MainAxisAlignment.spaceAround,
        //                         children: [
        //                           Padding(
        //                             padding: EdgeInsets.only(left: MediaQuery.of(context).size.height *
        //                                 0.015,),
        //                             child: Icon(
        //                               streamSnapshot.data?.docs[index]['category'] ==categoriesListAll[3]
        //                                   ?Icons.pets_rounded
        //                                   :streamSnapshot.data?.docs[index]['category'] ==categoriesListAll[4]
        //                                   ?Icons.local_grocery_store
        //                                   :streamSnapshot.data?.docs[index]['category'] ==categoriesListAll[2]
        //                                   ?Icons.emoji_transportation_rounded
        //                                   :streamSnapshot.data?.docs[index]['category'] ==categoriesListAll[1]
        //                                   ?Icons.house
        //                                   :streamSnapshot.data?.docs[index]['category'] ==categoriesListAll[6]
        //                                   ?Icons.sign_language_rounded
        //                                   :streamSnapshot.data?.docs[index]['category'] ==categoriesListAll[5]
        //                                   ?Icons.child_care_outlined
        //                                   :streamSnapshot.data?.docs[index]['category'] ==categoriesListAll[7]
        //                                   ?Icons.menu_book
        //                                   :streamSnapshot.data?.docs[index]['category'] ==categoriesListAll[8]
        //                                   ?Icons.medical_information_outlined
        //                                   :streamSnapshot.data?.docs[index]['category'] ==categoriesListAll[0]
        //                                   ?Icons.check_box
        //                                   :Icons.new_label_sharp,
        //                               size: 30,
        //                               color: Colors.black,
        //                             ),
        //                           ),
        //                           SizedBox(
        //                             width: MediaQuery.of(context).size.width *
        //                                 0.65,
        //                             height: MediaQuery.of(context).size.height *
        //                                 0.12,
        //                             child: Align(
        //                               alignment: Alignment.center,
        //                               child: ListTile(
        //                                 title: Text(
        //                                   streamSnapshot.data?.docs[index]['title'],
        //                                   style: GoogleFonts
        //                                       .raleway(
        //                                     fontSize: 14,
        //                                     color: Colors.black,
        //                                   ),
        //                                 ),
        //                                 subtitle: Text("${streamSnapshot.data
        //                                     ?.docs[index]
        //                                 ['comment']}".substring(0,31)+"...",
        //                                   style: GoogleFonts.raleway(
        //                                     fontSize: 13,
        //                                     color: Colors.black
        //                                         .withOpacity(0.5),
        //                                   ),
        //                                 ),
        //                               ),
        //                             ),
        //                           ),
        //                         ],
        //                       ),
        //                     ),
        //                   )
        //
        //               ),
        //             ),
        //           ],
        //         ));
        //   },
        // ),
        // StreamBuilder(
        //   stream:   FirebaseFirestore.instance
        //       .collection('applications')
        //       .where('userID', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        //
        //   //.where("volunteer_pref", arrayContainsAny: volunteer_preferencies)
        //   //.where("category", arrayContainsAny: ['Accomodation', 'Transfer', 'Assistance with animals'])
        //       .where("status", isEqualTo: 'Sent to volunteer')
        //
        //   //.where("category", whereIn: ['Accomodation','Transfer','Assistance with animals'])
        //   //.where("category", arrayContainsAny: ['Accomodation','Transfer','Assistance with animals'])
        //       .snapshots(),
        //   builder: (context, AsyncSnapshot<QuerySnapshot?> streamSnapshot) {
        //     return Container(
        //       width: 450,
        //       height: 300,
        //       child: ListView.builder(
        //           scrollDirection: Axis.vertical,
        //           itemCount: streamSnapshot.data?.docs.length,
        //           itemBuilder: (ctx, index) => Column(
        //             children: [
        //               MaterialButton(
        //                 onPressed: () {
        //
        //                   setState(() {
        //                     card_title_ref=streamSnapshot.data?.docs[index]['title'] as String;
        //                     card_category_ref=streamSnapshot.data?.docs[index]['category'] as String;
        //                     card_comment_ref=streamSnapshot.data?.docs[index]['comment'] as String;
        //                     Navigator.push(
        //                       context,
        //                       MaterialPageRoute(
        //                           builder: (context) => PageOfApplicationRef()),
        //                     );
        //                     // print("print ${streamSnapshot.data?.docs[index][id]}");
        //                   });
        //
        //                 },
        //                 child: Card(
        //                   child: Center(
        //                     child: Padding(
        //                       padding: const EdgeInsets.all(8.0),
        //                       child: Padding(
        //                         padding: const EdgeInsets.all(8.0),
        //                         child: Column(
        //                           children: [
        //                             Align(
        //                               alignment: Alignment.topLeft,
        //                               child: Text(
        //                                 streamSnapshot.data?.docs[index]['title'] as String,
        //                                 style: TextStyle(
        //                                     fontWeight: FontWeight.bold),
        //                               ),
        //                             ),
        //                             Align(
        //                               alignment: Alignment.topLeft,
        //                               child: Text(
        //                                   streamSnapshot.data?.docs[index]
        //                                   ['category'] as String,
        //                                   style: TextStyle(color: Colors.grey)),
        //                             ),
        //                             Align(
        //                               alignment: Alignment.topLeft,
        //                               child: Text(streamSnapshot.data?.docs[index]
        //                               ['comment'] as String),
        //                             ),
        //                           ],
        //                         ),
        //                       ),
        //                     ),
        //                   ),
        //                 ),
        //               ),
        //             ],
        //           )),
        //     );
        //   },
        // ),

        //   ],
        // ),
      ),
    );
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
// import 'package:wol_pro_1/constants.dart';
//
// import 'package:wol_pro_1/services/auth.dart';
//
// import '../../../../models/categories.dart';
// import '../../../../widgets/loading.dart';
// import '../home_page/home_ref.dart';
//
// import '../../../../Refugee/applications/application_info_accepted.dart';
// import '../main_screen_ref.dart';
//
// String application_ID = '';
// String card_title_ref = '';
// String card_category_ref = '';
// String card_comment_ref = '';
//
// String userID_ref = '';
// // String? token_vol;
//
// class AllCategoriesRef extends StatefulWidget {
//   const AllCategoriesRef({Key? key}) : super(key: key);
//
//   @override
//   State createState() => new AllCategoriesRefState();
// }
//
// class AllCategoriesRefState extends State<AllCategoriesRef> {
//   bool loading = false;
//   final AuthService _auth = AuthService();
//
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         controllerTabBottomRef = PersistentTabController(initialIndex: 1);
//         Navigator.of(context, rootNavigator: true).pushReplacement(
//             MaterialPageRoute(builder: (context) => new MainScreenRefugee()));
//         return true;
//       },
//       child: Scaffold(
//         backgroundColor: background,
//         appBar: AppBar(
//           title: Text(
//             'Your applications',
//             style: TextStyle(color: blueColor),
//           ),
//           backgroundColor: background,
//           elevation: 0.0,
//           leading: IconButton(
//             icon: Icon(
//               Icons.arrow_back,
//               color: blueColor,
//             ),
//             onPressed: () async {
//               // await _auth.signOut();
//               controllerTabBottomRef =
//                   PersistentTabController(initialIndex: 1);
//               Navigator.of(context, rootNavigator: true).pushReplacement(
//                   MaterialPageRoute(
//                       builder: (context) => new MainScreenRefugee()));
//             },
//           ),
//
//           // bottom: TabBar(
//           //   indicatorColor: blueColor,
//           //   isScrollable: true,
//           //   tabs: [
//           //     Text(categories[0],style: TextStyle(fontSize: 17, color: blueColor),),
//           //     Text(categories[1],style: TextStyle(fontSize: 17,color: blueColor),),
//           //   ],
//           //
//           // ),
//         ),
//         body:
//             // TabBarView(
//             //   children: [
//
//             StreamBuilder(
//           stream: FirebaseFirestore.instance
//               .collection('applications')
//               .where('userID',
//                   isEqualTo: FirebaseAuth.instance.currentUser?.uid)
//               .snapshots(),
//           builder: (context, AsyncSnapshot<QuerySnapshot?> streamSnapshot) {
//             return ListView.builder(
//                 scrollDirection: Axis.vertical,
//                 itemCount: streamSnapshot.data?.docs.length,
//                 itemBuilder: (ctx, index) {
//                   if (streamSnapshot.hasData) {
//                     switch (streamSnapshot.connectionState) {
//                       case ConnectionState.waiting:
//                         return const SizedBox(
//                           width: 60,
//                           height: 60,
//                           child: Loading(),
//                         );
//
//                       case ConnectionState.active:
//                         return Column(
//                           children: [
//                             SizedBox(
//                               height:
//                                   MediaQuery.of(context).size.height * 0.015,
//                             ),
//                             Padding(
//                               padding: padding,
//                               child: GestureDetector(
//                                   onTap: () {
//                                     setState(() {
//                                       card_title_ref = streamSnapshot.data
//                                           ?.docs[index]['title'] as String;
//                                       card_category_ref = streamSnapshot.data
//                                           ?.docs[index]['category'] as String;
//                                       card_comment_ref = streamSnapshot.data
//                                           ?.docs[index]['comment'] as String;
//                                       application_ID = streamSnapshot
//                                           .data?.docs[index].id as String;
//                                       token_vol =
//                                           streamSnapshot.data?.docs[index]
//                                               ["token_vol"] as String;
//                                       print(card_title_ref);
//                                       print(card_category_ref);
//                                       print(card_comment_ref);
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                             builder: (context) =>
//                                                 PageOfApplicationRef()),
//                                       );
//                                       // print("print ${streamSnapshot.data?.docs[index][id]}");
//                                     });
//                                   },
//                                   child: Container(
//                                     width: double.infinity,
//                                     // height: MediaQuery.of(context).size.height *
//                                     //     0.2,
//                                     decoration: BoxDecoration(
//                                         color: Colors.white,
//                                         borderRadius:
//                                             BorderRadius.circular(18)),
//                                     child: Align(
//                                       alignment: Alignment.center,
//                                       child: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceAround,
//                                         children: [
//                                           Padding(
//                                             padding: EdgeInsets.only(
//                                               left: MediaQuery.of(context)
//                                                       .size
//                                                       .height *
//                                                   0.015,
//                                             ),
//                                             child: Icon(
//                                               " ${streamSnapshot.data?.docs[index]['category']}" ==
//                                                       categoriesListAll[3]
//                                                   ? Icons.pets_rounded
//                                                   : " ${streamSnapshot.data?.docs[index]['category']}" ==
//                                                           categoriesListAll[4]
//                                                       ? Icons
//                                                           .local_grocery_store
//                                                       : " ${streamSnapshot.data?.docs[index]['category']}" ==
//                                                               categoriesListAll[
//                                                                   2]
//                                                           ? Icons
//                                                               .emoji_transportation_rounded
//                                                           : " ${streamSnapshot.data?.docs[index]['category']}" ==
//                                                                   categoriesListAll[
//                                                                       1]
//                                                               ? Icons.house
//                                                               : " ${streamSnapshot.data?.docs[index]['category']}" ==
//                                                                       categoriesListAll[
//                                                                           6]
//                                                                   ? Icons
//                                                                       .sign_language_rounded
//                                                                   : " ${streamSnapshot.data?.docs[index]['category']}" ==
//                                                                           categoriesListAll[
//                                                                               5]
//                                                                       ? Icons
//                                                                           .child_care_outlined
//                                                                       : " ${streamSnapshot.data?.docs[index]['category']}" ==
//                                                                               categoriesListAll[7]
//                                                                           ? Icons.menu_book
//                                                                           : " ${streamSnapshot.data?.docs[index]['category']}" == categoriesListAll[8]
//                                                                               ? Icons.medical_information_outlined
//                                                                               : " ${streamSnapshot.data?.docs[index]['category']}" == categoriesListAll[0]
//                                                                                   ? Icons.check_box
//                                                                                   : Icons.new_label_sharp,
//                                               size: 30,
//                                               color: Colors.black,
//                                             ),
//                                           ),
//                                           SizedBox(
//                                             width: MediaQuery.of(context)
//                                                     .size
//                                                     .width *
//                                                 0.65,
//                                             height: MediaQuery.of(context)
//                                                     .size
//                                                     .height *
//                                                 0.12,
//                                             child: Align(
//                                               alignment: Alignment.center,
//                                               child: ListTile(
//                                                 title: Text(
//                                                   streamSnapshot.data
//                                                       ?.docs[index]['title'],
//                                                   style: GoogleFonts.raleway(
//                                                     fontSize: 14,
//                                                     color: Colors.black,
//                                                   ),
//                                                 ),
//                                                 subtitle: Text(
//                                                   "${streamSnapshot.data?.docs[index]['comment']}"
//                                                           .substring(0, 31) +
//                                                       "...",
//                                                   style: GoogleFonts.raleway(
//                                                     fontSize: 13,
//                                                     color: Colors.black
//                                                         .withOpacity(0.5),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   )),
//                             ),
//                           ],
//                         );
//                     }
//                   }
//                   return Container();
//                 });
//           },
//         ),
//         // StreamBuilder(
//         //   stream:   FirebaseFirestore.instance
//         //       .collection('applications')
//         //       .where('userID', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
//         //
//         //   //.where("volunteer_pref", arrayContainsAny: volunteer_preferencies)
//         //   //.where("category", arrayContainsAny: ['Accomodation', 'Transfer', 'Assistance with animals'])
//         //       .where("status", isEqualTo: 'Sent to volunteer')
//         //
//         //   //.where("category", whereIn: ['Accomodation','Transfer','Assistance with animals'])
//         //   //.where("category", arrayContainsAny: ['Accomodation','Transfer','Assistance with animals'])
//         //       .snapshots(),
//         //   builder: (context, AsyncSnapshot<QuerySnapshot?> streamSnapshot) {
//         //     return Container(
//         //       width: 450,
//         //       height: 300,
//         //       child: ListView.builder(
//         //           scrollDirection: Axis.vertical,
//         //           itemCount: streamSnapshot.data?.docs.length,
//         //           itemBuilder: (ctx, index) => Column(
//         //             children: [
//         //               MaterialButton(
//         //                 onPressed: () {
//         //
//         //                   setState(() {
//         //                     card_title_ref=streamSnapshot.data?.docs[index]['title'] as String;
//         //                     card_category_ref=streamSnapshot.data?.docs[index]['category'] as String;
//         //                     card_comment_ref=streamSnapshot.data?.docs[index]['comment'] as String;
//         //                     Navigator.push(
//         //                       context,
//         //                       MaterialPageRoute(
//         //                           builder: (context) => PageOfApplicationRef()),
//         //                     );
//         //                     // print("print ${streamSnapshot.data?.docs[index][id]}");
//         //                   });
//         //
//         //                 },
//         //                 child: Card(
//         //                   child: Center(
//         //                     child: Padding(
//         //                       padding: const EdgeInsets.all(8.0),
//         //                       child: Padding(
//         //                         padding: const EdgeInsets.all(8.0),
//         //                         child: Column(
//         //                           children: [
//         //                             Align(
//         //                               alignment: Alignment.topLeft,
//         //                               child: Text(
//         //                                 streamSnapshot.data?.docs[index]['title'] as String,
//         //                                 style: TextStyle(
//         //                                     fontWeight: FontWeight.bold),
//         //                               ),
//         //                             ),
//         //                             Align(
//         //                               alignment: Alignment.topLeft,
//         //                               child: Text(
//         //                                   streamSnapshot.data?.docs[index]
//         //                                   ['category'] as String,
//         //                                   style: TextStyle(color: Colors.grey)),
//         //                             ),
//         //                             Align(
//         //                               alignment: Alignment.topLeft,
//         //                               child: Text(streamSnapshot.data?.docs[index]
//         //                               ['comment'] as String),
//         //                             ),
//         //                           ],
//         //                         ),
//         //                       ),
//         //                     ),
//         //                   ),
//         //                 ),
//         //               ),
//         //             ],
//         //           )),
//         //     );
//         //   },
//         // ),
//
//         //   ],
//         // ),
//       ),
//     );
//   }
// }
