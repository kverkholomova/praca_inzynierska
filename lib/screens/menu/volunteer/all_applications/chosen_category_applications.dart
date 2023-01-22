import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:wol_pro_1/constants.dart';
import 'package:wol_pro_1/screens/menu/volunteer/all_applications/your_app_vol.dart';

import '../../../../models/categories.dart';
import '../home_page/home_vol.dart';
import '../main_screen.dart';
import 'page_of_application_vol.dart';
import 'new_screen_with_applications.dart';

// String? id_card = '';

class ChosenCategory extends StatefulWidget {
  const ChosenCategory({Key? key}) : super(key: key);

  @override
  State createState() => ChosenCategoryState();
}

class ChosenCategoryState extends State<ChosenCategory> {
  ScrollController scrollController = ScrollController();
  // final AuthService _auth_ = AuthService();

  // @override
  // void initState() {}

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
          setState(() {
            controllerTabBottomVol = PersistentTabController(initialIndex: 4);
          });
          Navigator.of(context, rootNavigator: true).pushReplacement(
              MaterialPageRoute(builder: (context) => MainScreen()));
          return true;
        },
        child: SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: background,
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 30,
                  color: blueColor,
                ),
                onPressed: () {
                  setState(() {
                    controllerTabBottomVol =
                        PersistentTabController(initialIndex: 4);
                  });
                  Navigator.of(context, rootNavigator: true).pushReplacement(
                      MaterialPageRoute(builder: (context) => MainScreen()));
                },
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Choose an application",
                  style: GoogleFonts.raleway(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
            ),

            // appBar: AppBar(
            //   centerTitle: false,
            //   title: const Text('Home'),
            //   backgroundColor: Color.fromRGBO(49, 72, 103, 0.8),
            //   elevation: 0.0,
            //   leading: IconButton(
            //     icon: const Icon(Icons.arrow_back,color: Colors.white,),
            //     onPressed: () {
            //       // await _auth_.signOut();
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(builder: (context) => Categories()),
            //       );
            //     },
            //   ),
            //   // actions: <Widget>[
            //   //   IconButton(
            //   //     icon: const Icon(Icons.settings,color: Colors.white,),
            //   //     //label: const Text('logout',style: TextStyle(color: Colors.white),),
            //   //     onPressed: () async {
            //   //       //await _auth.signOut();
            //   //       // chosen_category_settings = [];
            //   //       Navigator.push(
            //   //         context,
            //   //         MaterialPageRoute(builder: (context) => SettingsVol()),
            //   //       );
            //   //     },
            //   //   ),
            //   //
            //   //   IconButton(
            //   //     icon: const Icon(Icons.person,color: Colors.white,),
            //   //     //label: const Text('logout',style: TextStyle(color: Colors.white),),
            //   //     onPressed: () async {
            //   //       //await _auth.signOut();
            //   //       Navigator.push(
            //   //         context,
            //   //         MaterialPageRoute(builder: (context) => ApplicationsOfVolunteer()),
            //   //       );
            //   //     },
            //   //   ),
            //   //
            //   // ],
            // ),
            body: SizedBox(
              height: MediaQuery.of(context).size.height *
                  0.85,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('applications')
                    .where("category",
                        isEqualTo: chosenCategoryVolApp)

                    //.where("volunteer_pref", arrayContainsAny: volunteer_preferencies)
                    //.where("category", arrayContainsAny: ['Accomodation', 'Transfer', 'Assistance with animals'])
                    .where("status", isEqualTo: 'Sent to volunteer')

                    //.where("category", whereIn: ['Accomodation','Transfer','Assistance with animals'])
                    //.where("category", arrayContainsAny: ['Accomodation','Transfer','Assistance with animals'])
                    .snapshots(),
                builder: (context,
                    AsyncSnapshot<QuerySnapshot?>
                        streamSnapshot) {


                  //                           var tom = streamSnapshot.data!.docs;
                  // if (tom.isEmpty) {
                  // return Center(
                  // child: Padding(
                  // padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1,),
                  // child: Column(
                  // children: const [
                  // Align(
                  // alignment: Alignment.center,
                  // child: Text("There is no data...",
                  // style: TextStyle(
                  // fontWeight: FontWeight.bold,
                  // fontSize: 24,
                  // color: Colors.black,
                  // )),
                  // ),
                  // Padding(
                  // padding: EdgeInsets.only(top: 20),
                  // )
                  // ],
                  // ),
                  // ),
                  // );
                  // }
                  // else
                  //   if (streamSnapshot.data!.docs.isNotEmpty) {
                  // if (streamSnapshot.hasData){
                  //   return Text(
                  //           "There aren't any applications in this category"
                  //       );
                  // }
                  print("Jungaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");
                  print(streamSnapshot.hasData);
                  print(streamSnapshot.hasError);
                  print(streamSnapshot);
                  return ListView.builder(
                      // physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: streamSnapshot.data?.docs.length,
                      itemBuilder: (ctx, index) {

                        // if(!streamSnapshot.hasData){
                        //   return Text(
                        //       "There aren't any applications in this category"
                        //   );
                        // }
                        // if (streamSnapshot.hasData) {
                        switch (streamSnapshot.connectionState) {
                          case ConnectionState.waiting:
                            return Padding(
                              padding: EdgeInsets.only(
                                top: MediaQuery.of(context)
                                        .size
                                        .height *
                                    0.0,
                              ),
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: Text("",
                                    style: GoogleFonts.raleway(
                                      fontSize: 25,
                                      color: Colors.white,
                                    )),
                              ),
                            );
                          case ConnectionState.active:
                            return Column(
                              children: [
                                Padding(
                                  padding: padding,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        myCategories = false;
                                        // FirebaseFirestore.instance
                                        //     .collection('applications')
                                        //     .doc(streamSnapshot.data?.docs[index].id)
                                        //     .update({"Id": streamSnapshot.data?.docs[index].id});
                                        //
                                        // id_card = streamSnapshot.data?.docs[index].id;
                                        tokenRefNotification = streamSnapshot.data?.docs[index]
                                        ['token_ref'];
                                        print("TTooooooookenReeef Chosen applications");
                                        card_title_vol =
                                            streamSnapshot.data
                                                    ?.docs[index]
                                                ['title'];
                                        card_category_vol =
                                            streamSnapshot.data
                                                    ?.docs[index]
                                                ['category'];
                                        card_comment_vol =
                                            streamSnapshot.data
                                                    ?.docs[index]
                                                ['comment'];
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const PageOfApplication()),
                                        );
                                        // print("print ${streamSnapshot.data?.docs[index][id]}");
                                      });
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      // height: MediaQuery.of(context).size.height *
                                      //     0.2,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(
                                                  18)),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: MediaQuery.of(
                                                            context)
                                                        .size
                                                        .height *
                                                    0.015),
                                            child: Icon(
                                              streamSnapshot.data?.docs[
                                                                  index]
                                                              ['category']
                                                          as String ==
                                                      categoriesListAll[
                                                          3]
                                                  ? Icons
                                                      .pets_rounded
                                                  : streamSnapshot.data
                                                                  ?.docs[index]['category']
                                                              as String ==
                                                          categoriesListAll[
                                                              4]
                                                      ? Icons
                                                          .local_grocery_store
                                                      : streamSnapshot.data?.docs[index]['category']
                                                                  as String ==
                                                              categoriesListAll[
                                                                  2]
                                                          ? Icons
                                                              .emoji_transportation_rounded
                                                          : streamSnapshot.data?.docs[index]['category'] as String ==
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
                                            width: MediaQuery.of(
                                                        context)
                                                    .size
                                                    .width *
                                                0.65,
                                            height: MediaQuery.of(
                                                        context)
                                                    .size
                                                    .height *
                                                0.12,
                                            child: Align(
                                              alignment:
                                                  Alignment.topCenter,
                                              child: ListTile(
                                                // mainAxisAlignment: MainAxisAlignment.start,
                                                contentPadding:
                                                    const EdgeInsets
                                                        .symmetric(
                                                            vertical:
                                                    4),
                                                title: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal:
                                                          12),
                                                  child: Text(
                                                      streamSnapshot
                                                              .data
                                                              ?.docs[index]['title']
                                                          as String,
                                                      style: GoogleFonts
                                                          .raleway(
                                                        fontSize:
                                                            14,
                                                        color: Colors
                                                            .black,
                                                      )),
                                                ),
                                                // Text(
                                                //     streamSnapshot.data?.docs[index]['category'] as String,
                                                //     style: TextStyle(color: Colors.grey)),
                                                subtitle: Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal:
                                                          12),
                                                  child: Text(
                                                    "${streamSnapshot.data?.docs[index]['comment']}"
                                                            .substring(
                                                                0,
                                                                30) +
                                                        "...",
                                                    style:
                                                        GoogleFonts
                                                            .raleway(
                                                      fontSize: 12,
                                                      color: Colors
                                                          .black
                                                          .withOpacity(
                                                              0.5),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: MediaQuery.of(context)
                                          .size
                                          .height *
                                      0.012,
                                ),
                              ],
                            );
                          // case ConnectionState.none:
                          //
                          // case ConnectionState.done:
                          // // TODO: Handle this case.
                          //   break;
                          case ConnectionState.none:

                            break;
                          case ConnectionState.done:
                            // return Text(
                            //     "There aren't any applications in this category"
                            // );
                            break;
                        }
                        // }
                        return Container();
                      });

                  //                           return ListView.builder(
                  //                               physics: NeverScrollableScrollPhysics(),
                  //                               shrinkWrap: true,
                  //                               scrollDirection: Axis.vertical,
                  //                               itemCount: streamSnapshot.data?.docs.length,
                  //                               itemBuilder: (ctx, index)
                  //                               {
                  //                               if (streamSnapshot.hasData) {
                  //                               switch (streamSnapshot.connectionState) {
                  //                               case ConnectionState.waiting:
                  //                               return Padding(
                  //                               padding: EdgeInsets.only(
                  //                               top: MediaQuery.of(context).size.height * 0.0,
                  //                               ),
                  //                               child: Align(
                  //                               alignment: Alignment.topCenter,
                  //                               child: Text("Waiting for data",
                  //                               style: GoogleFonts.raleway(
                  //                               fontSize: 25,
                  //                               color: Colors.white,
                  //                               )),
                  //                               ),
                  //                               );
                  //                               case ConnectionState.active:
                  //                                       return  Column(
                  //                                           children: [
                  //                                             GestureDetector(
                  //                                               onTap: () {
                  //                                                 setState(() {
                  //                                                   // FirebaseFirestore.instance
                  //                                                   //     .collection('applications')
                  //                                                   //     .doc(streamSnapshot.data?.docs[index].id)
                  //                                                   //     .update({"Id": streamSnapshot.data?.docs[index].id});
                  //                                                   //
                  //                                                   // id_card = streamSnapshot.data?.docs[index].id;
                  //                                                   card_title_vol =
                  //                                                       streamSnapshot.data
                  //                                                               ?.docs[index]
                  //                                                           ['title'];
                  //                                                   card_category_vol =
                  //                                                       streamSnapshot.data
                  //                                                               ?.docs[index]
                  //                                                           ['category'];
                  //                                                   card_comment_vol =
                  //                                                       streamSnapshot.data
                  //                                                               ?.docs[index]
                  //                                                           ['comment'];
                  //                                                   Navigator.push(
                  //                                                     context,
                  //                                                     MaterialPageRoute(
                  //                                                         builder: (context) =>
                  //                                                             PageOfApplication()),
                  //                                                   );
                  //                                                   // print("print ${streamSnapshot.data?.docs[index][id]}");
                  //                                                 });
                  //                                               },
                  //                                               child: Container(
                  //                                                 width: double.infinity,
                  //                                                 // height: MediaQuery.of(context).size.height *
                  //                                                 //     0.2,
                  //                                                 decoration: BoxDecoration(
                  //                                                     color: Colors.white,
                  //                                                     borderRadius:
                  //                                                         BorderRadius
                  //                                                             .circular(24)),
                  //                                                 child: ListTile(
                  //                                                   // mainAxisAlignment: MainAxisAlignment.start,
                  //
                  //                                                   contentPadding:
                  //                                                       EdgeInsets.symmetric(
                  //                                                           vertical: 5),
                  //                                                   title: Padding(
                  //                                                     padding:
                  //                                                         const EdgeInsets
                  //                                                                 .symmetric(
                  //                                                             horizontal: 12),
                  //                                                     child: Text(
                  //                                                         streamSnapshot.data
                  //                                                                     ?.docs[index]
                  //                                                                 ['title']
                  //                                                             as String,
                  //                                                         style: GoogleFonts
                  //                                                             .raleway(
                  //                                                           fontSize: 16,
                  //                                                           color:
                  //                                                               Colors.black,
                  //                                                         )),
                  //                                                   ),
                  //                                                   // Text(
                  //                                                   //     streamSnapshot.data?.docs[index]['category'] as String,
                  //                                                   //     style: TextStyle(color: Colors.grey)),
                  //                                                   subtitle: Padding(
                  //                                                     padding:
                  //                                                         const EdgeInsets
                  //                                                                 .symmetric(
                  //                                                             horizontal: 12),
                  //                                                     child: Text(
                  //                                                       streamSnapshot.data
                  //                                                                   ?.docs[index]
                  //                                                               ['comment']
                  //                                                           as String,
                  //                                                       style: GoogleFonts
                  //                                                           .raleway(
                  //                                                         fontSize: 14,
                  //                                                         color: Colors.black
                  //                                                             .withOpacity(
                  //                                                                 0.5),
                  //                                                       ),
                  //                                                     ),
                  //                                                   ),
                  //                                                 ),
                  //                                               ),
                  //                                             ),
                  //                                           ],
                  //                                         );
                  //                                 // case ConnectionState.none:
                  //                                 //
                  //                                 // case ConnectionState.done:
                  //                                 // // TODO: Handle this case.
                  //                                 //   break;
                  //                               }
                  //                               }
                  //                               return Container();
                  //
                  //                                       });
                  // }
                  // return Container();
                },
              ),
            ),
          ),
        ));
  }
}
