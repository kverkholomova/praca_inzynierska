import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:wol_pro_1/screens/intro_screen/option.dart';
import 'package:wol_pro_1/screens/menu/volunteer/home_page/settings/upload_photo.dart';
import 'package:wol_pro_1/screens/register_login/volunteer/register/categories_choose.dart';
import 'package:wol_pro_1/widgets/loading.dart';

import '../../../../constants.dart';
import '../../../../models/categories.dart';
import '../../../../service/local_push_notifications.dart';
import '../../../register_login/volunteer/register/register_volunteer_1.dart';
import 'categories/update_categories.dart';
import 'settings/settings_vol_info.dart';

bool isLoggedIn = true;

// String? currentId_set = '';
String? currentNameVol = '';
List categoriesUserRegister = [];
String? tokenVol;
// final FirebaseFirestore _db = FirebaseFirestore.instance;
// final FirebaseMessaging _fcm = FirebaseMessaging.instance;

class HomeVol extends StatefulWidget {
  const HomeVol({Key? key}) : super(key: key);

  @override
  State<HomeVol> createState() => _HomeVolState();
}

class _HomeVolState extends State<HomeVol> {
  ScrollController scrollController = ScrollController();

  // final Stream<int> _bids = (() {
  //   late final StreamController<int> controller;
  //   controller = StreamController<int>(
  //     onListen: () async {
  //       await Future<void>.delayed(const Duration(seconds: 1));
  //       controller.add(1);
  //       await Future<void>.delayed(const Duration(seconds: 1));
  //       await controller.close();
  //     },
  //   );
  //   return controller.stream;
  // })();
  /// Get the token, save it to the database for current user
  // _saveDeviceToken() async {
  //   // Get the current user
  //   // String uid = FirebaseAuth.instance.currentUser!.uid;
  //   // FirebaseUser user = await _auth.currentUser();
  //
  //   // Get the token for this device
  //   String? fcmToken = await _fcm.getToken();
  //
  //   // // Save it to Firestore
  //   // if (fcmToken != null) {
  //   //   var tokens = _db
  //   //       .collection('users')
  //   //       .doc(uid)
  //   //       .collection('tokens')
  //   //       .doc(fcmToken);
  //   //
  //   //   await tokens.set({
  //   //     'token': fcmToken,
  //   //     'createdAt': FieldValue.serverTimestamp(), // optional
  //   //
  //   //   });
  //   // }
  // }

  // String token = '';
  //

  loadImage(String image_url) async {
    //select the image url
    Reference ref =
        FirebaseStorage.instance.ref().child("user_pictures/").child(image_url);

    //get image url from firebase storage
    var url = await ref.getDownloadURL();
    // put the URL in the state, so that the UI gets rerendered
    setState(() {
      url_image = url;
    });
  }

  storeNotificationToken() async {
    String? token_v = await FirebaseMessaging.instance.getToken();
    print(
        "------???---------Token");
    print(token_v);
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({'token_vol': token_v}, SetOptions(merge: true));
    print(
        "Token");
    print(token_v);
  }

  bool scrolled = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollController.addListener(scrollListener);
    FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((event) {});
    storeNotificationToken();
    FirebaseMessaging.instance.subscribeToTopic('subscription');
    FirebaseMessaging.onMessage.listen((event) {
      LocalNotificationService.display(event);
    });
  }

  scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      setState(() {
        scrolled = true;
      });
    }
    if (scrollController.offset <= scrollController.position.minScrollExtent &&
        !scrollController.position.outOfRange) {
      setState(() {
        scrolled = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print("Volunteer");
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => const OptionChoose()),
        // );
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: background,
          // appBar: AppBar(
          //   title: Padding(
          //     padding: EdgeInsets.only(left: MediaQuery.of(context).size.height * 0.1),
          //     child: Text(
          //       "Volunteer",
          //       style: GoogleFonts.sairaStencilOne(
          //         fontSize: 25,
          //         color: Colors.black.withOpacity(0.7),
          //
          //       ),
          //       textAlign: TextAlign.center,
          //     ),
          //   ),
          //   elevation: 0,
          //   backgroundColor: Colors.transparent,
          //   leading: IconButton(
          //       onPressed: (){
          //         Navigator.push(
          //           context,
          //           MaterialPageRoute(builder: (context) => const OptionChoose()),
          //         );
          //       },
          //       icon: Icon(Icons.arrow_back_ios_new_rounded, color: blueColor,)),
          // ),
          // appBar: AppBar(
          //   backgroundColor: Color.fromRGBO(49, 72, 103, 0.8),
          //   elevation: 0.0,
          //   title: Text('Users Info',style: TextStyle(fontSize: 16),),
          //   leading: IconButton(onPressed: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => OptionChoose()),
          //     );
          //   }, icon: Icon(Icons.arrow_back),
          //
          //   ),
          //
          //   actions: <Widget>[
          //
          // IconButton(
          //     icon: const Icon(Icons.settings,color: Colors.white,),
          //     //label: const Text('logout',style: TextStyle(color: Colors.white),),
          //     onPressed: () async {
          //       //await _auth.signOut();
          //       // chosen_category_settings = [];
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(builder: (context) => SettingsVol()),
          //       );
          //     },
          //   ),
          //     Padding(
          //       padding: const EdgeInsets.all(8.0),
          //       child: TextButton.icon(
          //         icon: const Icon(Icons.person,color: Colors.white,),
          //         label: const Text('Logout',style: TextStyle(color: Colors.white),),
          //         onPressed: () async {
          //           await _auth.signOut();
          //           Navigator.push(
          //             context,
          //             MaterialPageRoute(builder: (context) => OptionChoose()),
          //           );
          //         },
          //       ),
          //     ),
          //     /**TextButton.icon(
          //         onPressed: (){
          //         showSettingsPanel();
          //         },
          //         label: Text("Settings",style: TextStyle(color: Colors.white),),
          //         icon: Icon(Icons.settings,color: Colors.white,),)**/
          //   ],
          // ),
          body: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: <Widget>[
                // IconButton(
                //   icon: const Icon(Icons.edit, color: Colors.white,),
                //   onPressed: (){
                //     print("K");
                //   },),
                // StreamBuilder(
                //   stream: FirebaseFirestore.instance
                //       .collection('users')
                //       .where('id_vol', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                //       .snapshots(),
                //
                //   builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                //     return ListView.builder(
                //         itemCount: !streamSnapshot.hasData? 1: streamSnapshot.data?.docs.length,
                //         itemBuilder: (ctx, index) {
                //           token_vol = streamSnapshot.data?.docs[index]['token_vol'];
                //           current_name_Vol = streamSnapshot.data?.docs[index]['user_name'];
                //           if (streamSnapshot.hasData){
                //           switch (streamSnapshot.connectionState){
                //             case ConnectionState.waiting:
                //               return  Column(
                //                 children: [
                //                   const SizedBox(
                //                     width: 60,
                //                     height: 60,
                //                     child: CircularProgressIndicator(),
                //                   ),
                //                   const Padding(
                //                     padding: EdgeInsets.only(top: 16),
                //                     child: Text('Awaiting data...'),
                //                   )
                //                 ]
                //
                //               );
                //
                //             case ConnectionState.active:
                //           return Padding(
                //             padding: const EdgeInsets.only(top: 120),
                //             child: Column(
                //                 children: [
                //
                //                   // Padding(
                //                   //   padding: const EdgeInsets.only(left: 15),
                //                   //   child: Align(
                //                   //     alignment: Alignment.topLeft,
                //                   //     child: Text(
                //                   //       streamSnapshot.data?.docs[index]['user_name'] ,
                //                   //       style: TextStyle(
                //                   //         fontWeight: FontWeight.bold,fontSize: 24,color: Colors.black,)
                //                   //     ),
                //                   //   ),
                //                   // ),
                //                   //
                //                   // Padding(
                //                   //   padding: const EdgeInsets.only(top: 15),
                //                   //   child: Row(
                //                   //     children: [
                //                   //       IconButton(onPressed: () {
                //                   //         print("Phone");
                //                   //       }, icon: Icon(Icons.phone)),
                //                   //       Align(
                //                   //         alignment: Alignment.topLeft,
                //                   //         child: Text(
                //                   //           streamSnapshot.data?.docs[index]['phone_number'],
                //                   //           style: TextStyle(color: Colors.grey[700],fontSize: 16),textAlign: TextAlign.left,),
                //                   //       ),
                //                   //     ],
                //                   //   ),
                //                   // ),
                //
                //
                //
                //                   // Text(
                //                   //   streamSnapshot.data?.docs[index]['date'],
                //                   //   style: TextStyle(color: Colors.grey,fontSize: 14),textAlign: TextAlign.center,),
                //
                //                   const SizedBox(height: 250,),
                //                   Padding(
                //                     padding: const EdgeInsets.only(top: 40),
                //                     child: Center(
                //                       child: Container(
                //                         width: 300,
                //                         height: 50,
                //                         decoration: BoxDecoration(
                //                             borderRadius: BorderRadius.circular(20)
                //                         ),
                //                         child: MaterialButton(
                //                           color: const Color.fromRGBO(137, 102, 120, 0.8),
                //                           child: const Text('All applications', style: (TextStyle(color: Colors.white, fontSize: 15)),),
                //                           onPressed: () {
                //
                //                             categories_user_Register = streamSnapshot.data?.docs[index]['category'];
                //                             print("OOOOOOOOOOOOOOOO___________________TTTTTTTTTTTTTTTTTTTt");
                //                             print(categories_user_Register);
                //                             currentId_set = streamSnapshot.data?.docs[index].id;
                //                             current_name_Vol = streamSnapshot.data?.docs[index]['user_name'];
                //                             Navigator.push(context, MaterialPageRoute(builder: (context) => const Categories()));
                //                           },
                //                         ),
                //                       ),
                //                     ),
                //                   ),
                //
                //                   Padding(
                //                     padding: const EdgeInsets.only(top: 10),
                //                     child: Center(
                //                       child: Container(
                //                         width: 300,
                //                         height: 50,
                //                         decoration: BoxDecoration(
                //                             borderRadius: BorderRadius.circular(20)
                //                         ),
                //                         child: MaterialButton(
                //                           color: const Color.fromRGBO(137, 102, 120, 0.8),
                //                           child: const Text('My applications', style: (TextStyle(color: Colors.white, fontSize: 15)),),
                //                           onPressed: () {
                //
                //                             currentId_set = streamSnapshot.data?.docs[index].id;
                //                             current_name_Vol = streamSnapshot.data?.docs[index]['user_name'];
                //                             Navigator.push(context, MaterialPageRoute(builder: (context) => const ApplicationsOfVolunteer()));
                //                           },
                //                         ),
                //                       ),
                //                     ),
                //                   ),
                //
                //                   Padding(
                //                     padding: const EdgeInsets.only(top: 10),
                //                     child: Center(
                //                       child: Container(
                //                         width: 300,
                //                         height: 50,
                //                         decoration: BoxDecoration(
                //                             borderRadius: BorderRadius.circular(20)
                //                         ),
                //                         child: MaterialButton(
                //                           color: const Color.fromRGBO(137, 102, 120, 0.8),
                //                           child: const Text('Messages', style: (TextStyle(color: Colors.white, fontSize: 15)),),
                //                           onPressed: () {
                //                             Navigator.push(
                //                                     context,
                //                                     MaterialPageRoute(
                //                                         builder: (context) =>
                //                                             const ListofChatroomsVol()),
                //                                   );
                //                             // Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage_3()));
                //                             // Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(name: current_name,)));
                //                             // Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(name: current_name)));
                //                             // Navigator.push(context, MaterialPageRoute(builder: (context) => Chat(chatRoomId: '',)));
                //                           },
                //                         ),
                //                       ),
                //                     ),
                //                   ),
                //                 ],
                //               ),
                //           );}}
                //           else{
                //
                //           }
                //           return Center(
                //             child: Padding(padding: const EdgeInsets.only(top: 100),
                //               child: Column(
                //                 children: [
                //                   const SpinKitChasingDots(
                //                     color: Colors.brown,
                //                     size: 50.0,
                //                   ),
                //                   const Align(
                //                     alignment: Alignment.center,
                //                     child: Text(
                //                         "Waiting...",
                //                         style: TextStyle(
                //                           fontWeight: FontWeight.bold,fontSize: 24,color: Colors.black,)
                //                     ),
                //                   ),
                //               const Padding(padding: EdgeInsets.only(top: 20),)
                //                 ],
                //               ),
                //             ),
                //           );
                //         });
                //   },
                // ),
                ClipPath(
                  clipper: OvalBottomBorderClipper(),
                  child: AnimatedContainer(
                    height: scrolled
                        ? MediaQuery.of(context).size.height * 0.3
                        : MediaQuery.of(context).size.height * 0.43,
                    duration: const Duration(milliseconds: 10000000),
                    decoration: BoxDecoration(
                      color: blueColor,
                    ),

                    // Container(
                    //   decoration: BoxDecoration(
                    //     color: blueColor,
                    //     boxShadow: const <BoxShadow>[
                    //       BoxShadow(
                    //         color: Colors.black,
                    //         blurRadius: 5,
                    //       ),
                    //     ],
                    //   ),
                    //   height: MediaQuery.of(context).size.height * 0.47,
                    child:
                        // scrolled
                        //     ?
                        // Align(
                        //   alignment: Alignment.topLeft,
                        //     child: StreamBuilder(
                        //       stream: FirebaseFirestore.instance
                        //           .collection('users')
                        //           .where('id_vol',
                        //           isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                        //           .snapshots(),
                        //       builder: (context,
                        //           AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                        //         return SizedBox(
                        //           height: 200,
                        //           width: 200,
                        //           child: ListView.builder(
                        //               physics: NeverScrollableScrollPhysics(),
                        //               shrinkWrap: true,
                        //               itemCount: !streamSnapshot.hasData
                        //                   ? 1
                        //                   : streamSnapshot.data?.docs.length,
                        //               itemBuilder: (ctx, index) {
                        //                 token_vol =
                        //                 streamSnapshot.data?.docs[index]['token_vol'];
                        //                 currentNameVol =
                        //                 streamSnapshot.data?.docs[index]['user_name'];
                        //                 if (streamSnapshot.hasData) {
                        //                   switch (streamSnapshot.connectionState) {
                        //                     case ConnectionState.waiting:
                        //                       return SizedBox(
                        //                               width: 60,
                        //                               height: 60,
                        //                               child: CircularProgressIndicator(),
                        //                             );
                        //
                        //                     case ConnectionState.active:
                        //                       categoriesVolunteer.add(streamSnapshot
                        //                           .data?.docs[index]['category']);
                        //                       return Row(
                        //
                        //                         children: [
                        //                           Container(
                        //                             height: MediaQuery.of(context)
                        //                                 .size
                        //                                 .width *
                        //                                 0.04,
                        //                             child: url_image==null?Image(
                        //                                 image:AssetImage("assets/user.png")
                        //                             ): CircleAvatar(
                        //                                 radius: 30.0,
                        //                                 backgroundImage: NetworkImage(url_image.toString())),
                        //                           ),
                        //                           ListTile(
                        //                             title: Text(
                        //                                   streamSnapshot
                        //                                       .data?.docs[index]
                        //                                   ['user_name'],
                        //                                   style: GoogleFonts.raleway(
                        //                                     fontSize: 24,
                        //                                     color: Colors.white,
                        //                                   )),
                        //                             subtitle: Text(
                        //                                 "${streamSnapshot.data?.docs[index]['age'] == 0 ? "Please add your age" : streamSnapshot.data?.docs[index]['age']}",
                        //                                 style: GoogleFonts.raleway(
                        //                                   fontSize: 16,
                        //                                   color: Colors.white,
                        //                                 )),
                        //                           ),
                        //
                        //                           // Padding(
                        //                           //   padding: const EdgeInsets.only(top: 15),
                        //                           //   child: Row(
                        //                           //     children: [
                        //                           //       IconButton(onPressed: () {
                        //                           //         print("Phone");
                        //                           //       }, icon: Icon(Icons.phone)),
                        //                           //       Align(
                        //                           //         alignment: Alignment.topLeft,
                        //                           //         child: Text(
                        //                           //           streamSnapshot.data?.docs[index]['phone_number'],
                        //                           //           style: TextStyle(color: Colors.grey[700],fontSize: 16),textAlign: TextAlign.left,),
                        //                           //       ),
                        //                           //     ],
                        //                           //   ),
                        //                           // ),
                        //
                        //                           // Text(
                        //                           //   streamSnapshot.data?.docs[index]['date'],
                        //                           //   style: TextStyle(color: Colors.grey,fontSize: 14),textAlign: TextAlign.center,),
                        //
                        //                         ],
                        //                       );
                        //                   }
                        //                 } else {}
                        //                 return Center(
                        //                   child: SpinKitChasingDots(
                        //                     color: Colors.brown,
                        //                     size: 50.0,
                        //                   ),
                        //                 );
                        //               }),
                        //         );
                        //       },
                        //     ))
                        //
                        // :

                        Center(
                            child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .where('id_vol',
                                isEqualTo:
                                    FirebaseAuth.instance.currentUser?.uid)
                            .snapshots(),
                        builder: (context,
                            AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                          return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: !streamSnapshot.hasData
                                  ? 1
                                  : streamSnapshot.data?.docs.length,
                              itemBuilder: (ctx, index) {
                                tokenVol = streamSnapshot.data?.docs[index]
                                    ['token_vol'];
                                currentNameVol = streamSnapshot
                                    .data?.docs[index]['user_name'];
                                if (streamSnapshot.hasData) {
                                  switch (streamSnapshot.connectionState) {
                                    case ConnectionState.waiting:
                                      return const SizedBox(
                                        width: 60,
                                        height: 60,
                                        child: Loading(),
                                      );

                                    case ConnectionState.active:
                                      // categoriesVolunteer.add(streamSnapshot
                                      //     .data?.docs[index]['category']);
                                      // print(
                                      //     "LLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL");
                                      // print(categoriesVolunteer.length);
                                      return scrolled
                                          ? Padding(
                                              padding: EdgeInsets.only(
                                                top: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.2,
                                              ),
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.3,
                                                    child: url_image == null
                                                        ? const Image(
                                                            image: AssetImage(
                                                                "assets/user.png"))
                                                        : CircleAvatar(
                                                            radius: 60.0,
                                                            backgroundImage:
                                                                NetworkImage(
                                                                    url_image
                                                                        .toString())),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                            streamSnapshot.data
                                                                    ?.docs[index]
                                                                ['user_name'],
                                                            style: GoogleFonts
                                                                .raleway(
                                                              fontSize: 24,
                                                              color:
                                                                  Colors.white,
                                                            )),
                                                        Align(
                                                          alignment:
                                                              Alignment.topLeft,
                                                          child: Text(
                                                              "${streamSnapshot.data?.docs[index]['age'] == 0 ? "Please add your age" : streamSnapshot.data?.docs[index]['age']}",
                                                              style: GoogleFonts
                                                                  .raleway(
                                                                fontSize: 18,
                                                                color: Colors
                                                                    .white,
                                                              )),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 20),
                                              child: Column(
                                                children: [
                                                  SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.4,
                                                    child: url_image == null
                                                        ? const Image(
                                                            image: AssetImage(
                                                                "assets/user.png"))
                                                        : CircleAvatar(
                                                            radius: 80.0,
                                                            backgroundImage:
                                                                NetworkImage(
                                                                    url_image
                                                                        .toString())),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.topCenter,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                            streamSnapshot.data
                                                                    ?.docs[index]
                                                                ['user_name'],
                                                            style: GoogleFonts
                                                                .raleway(
                                                              fontSize: 24,
                                                              color:
                                                                  Colors.white,
                                                            )),
                                                        IconButton(
                                                          icon: const Icon(
                                                            Icons.edit,
                                                            color: Colors.white,
                                                          ),
                                                          onPressed: () {
                                                            loadImage(
                                                                streamSnapshot
                                                                            .data
                                                                            ?.docs[
                                                                        index]
                                                                    ['image']);
                                                            Future.delayed(
                                                                const Duration(
                                                                    milliseconds:
                                                                        500),
                                                                () {
                                                              Navigator.of(
                                                                      context,
                                                                      rootNavigator:
                                                                          true)
                                                                  .pushReplacement(
                                                                      MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              new SettingsVol()));
                                                              // Navigator.push(
                                                              //     context,
                                                              //     MaterialPageRoute(
                                                              //         builder: (
                                                              //             context) =>
                                                              //             SettingsVol()));
                                                            });
                                                          },
                                                        ),
                                                      ],
                                                    ),
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
                                                      child: Text(
                                                          "${streamSnapshot.data?.docs[index]['age'] == 0 ? "Your profile isn't completed" : streamSnapshot.data?.docs[index]['age']}",
                                                          style: GoogleFonts
                                                              .raleway(
                                                            fontSize: 16,
                                                            color: Colors.white,
                                                          )),
                                                    ),
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

                                                  // Padding(
                                                  //   padding: const EdgeInsets.only(top: 15),
                                                  //   child: Row(
                                                  //     children: [
                                                  //       IconButton(onPressed: () {
                                                  //         print("Phone");
                                                  //       }, icon: Icon(Icons.phone)),
                                                  //       Align(
                                                  //         alignment: Alignment.topLeft,
                                                  //         child: Text(
                                                  //           streamSnapshot.data?.docs[index]['phone_number'],
                                                  //           style: TextStyle(color: Colors.grey[700],fontSize: 16),textAlign: TextAlign.left,),
                                                  //       ),
                                                  //     ],
                                                  //   ),
                                                  // ),

                                                  // Text(
                                                  //   streamSnapshot.data?.docs[index]['date'],
                                                  //   style: TextStyle(color: Colors.grey,fontSize: 14),textAlign: TextAlign.center,),

                                                  const SizedBox(
                                                    height: 250,
                                                  ),
                                                ],
                                              ),
                                            );
                                  }
                                } else {}
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
                                        Padding(
                                          padding: EdgeInsets.only(top: 20),
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              });
                        },
                      ),
                    )),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.012,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: padding,
                    child: Text(
                      "Preferencies",
                      style: GoogleFonts.raleway(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),

                SizedBox(
                  height: categoriesVolunteer.length == 1
                      ? 100
                      : categoriesVolunteer.length == 2
                          ? 170
                          : categoriesVolunteer.length == 3
                              ? 210
                              : categoriesVolunteer.length == 4
                                  ? 300
                                  : categoriesVolunteer.length == 5
                                      ? 350
                                      : categoriesVolunteer.length == 6
                                          ? 400
                                          : categoriesVolunteer.length == 7
                                              ? 500
                                              : categoriesVolunteer.length == 8
                                                  ? 600
                                                  : 140,
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .where('id_vol',
                              isEqualTo:
                                  FirebaseAuth.instance.currentUser?.uid)
                          .snapshots(),
                      builder: (context,
                          AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                        if (streamSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Loading();
                        } else if (streamSnapshot.connectionState ==
                            ConnectionState.done) {
                          return const Text('done');
                        } else if (streamSnapshot.hasError) {
                          return const Text('Error!');
                        } else {
                          return ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: categoriesVolunteer.length,
                              itemBuilder: (ctx, index) {

                                return Column(
                                  children: [
                                    SizedBox(
                                      height: MediaQuery.of(context)
                                              .size
                                              .height *
                                          0.015,
                                    ),
                                    Padding(
                                      padding: padding,
                                      child: Container(
                                        width: double.infinity,
                                        height: MediaQuery.of(context)
                                                .size
                                                .height *
                                            0.085,
                                        decoration: categoryDecoration,
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                left:
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.05,
                                                right:
                                                    MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.04,
                                              ),
                                              child: Icon(
                                                categoriesVolunteer[
                                                            index] ==
                                                        categoriesListAll[
                                                            3]
                                                    ? Icons.pets_rounded
                                                    : categoriesVolunteer[
                                                                index] ==
                                                            categoriesListAll[
                                                                4]
                                                        ? Icons
                                                            .local_grocery_store
                                                        : categoriesVolunteer[
                                                                    index] ==
                                                                categoriesListAll[
                                                                    2]
                                                            ? Icons
                                                                .emoji_transportation_rounded
                                                            : categoriesVolunteer[
                                                                        index] ==
                                                                    categoriesListAll[
                                                                        1]
                                                                ? Icons
                                                                    .house
                                                                : categoriesVolunteer[index] ==
                                                                        categoriesListAll[6]
                                                                    ? Icons.sign_language_rounded
                                                                    : categoriesVolunteer[index] == categoriesListAll[5]
                                                                        ? Icons.child_care_outlined
                                                                        : categoriesVolunteer[index] == categoriesListAll[7]
                                                                            ? Icons.menu_book
                                                                            : categoriesVolunteer[index] == categoriesListAll[8]
                                                                                ? Icons.medical_information_outlined
                                                                                : categoriesVolunteer[index] == categoriesListAll[0]
                                                                                    ? Icons.check_box
                                                                                    : Icons.new_label_sharp,
                                                size: 30,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Text(
                                              categoriesVolunteer[index]
                                                  .toString(),
                                              // streamSnapshot.data?.docs[index]
                                              //     ["category"][index],
                                              style: textCategoryStyle,
                                            ),
                                            // SizedBox(
                                            //   height:
                                            //   MediaQuery.of(context).size.height *
                                            //       0.05,
                                            // ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                                // }
                                // );
                                // return CircularProgressIndicator();
                              });
                        }
                      }),
                ),

                Align(
                  alignment: Alignment.center,
                  child: TextButton.icon(
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true)
                          .pushReplacement(MaterialPageRoute(
                              builder: (context) => ManageCategories(categoriesUpdated: [],)));
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => ChooseCategory()));
                      // categoriesUpdated = categoriesVolunteer;
                      // print("Updateeeeeed");
                      // print(categoriesUpdated);

                    },
                    icon: const Icon(
                      Icons.manage_accounts_rounded,
                      color: Colors.black,
                      size: 30,
                    ),
                    label: Text(
                      "Manage your preferences",
                      style: GoogleFonts.raleway(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  height: categoriesVolunteer.length == 1
                      ? MediaQuery.of(context).size.height * 0.012
                      : categoriesVolunteer.length == 2
                          ? MediaQuery.of(context).size.height * 0.012
                          : categoriesVolunteer.length == 3
                              ? MediaQuery.of(context).size.height * 0.2
                              : categoriesVolunteer.length == 4
                                  ? MediaQuery.of(context).size.height * 0.025
                                  : MediaQuery.of(context).size.height * 0.05,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
