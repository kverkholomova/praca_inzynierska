import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:wol_pro_1/constants.dart';

import 'package:wol_pro_1/services/auth.dart';

import '../../../../models/categories.dart';
import '../home_page/home_ref.dart';
import '../../../../Refugee/SettingRefugee.dart';
import '../../../../to_delete/home_ref.dart';
import '../../../../Refugee/applications/application_info.dart';
import '../main_screen_ref.dart';

String application_ID = '';
String card_title_ref='';
String card_category_ref='';
String card_comment_ref='';

String userID_ref = '';
// String? token_vol;

class CategoriesRef extends StatefulWidget {
  const CategoriesRef({Key? key}) : super(key: key);
  @override
  State createState() => new CategoriesRefState();
}

class CategoriesRefState extends State<CategoriesRef> {

  bool loading = false;
  final AuthService _auth = AuthService();


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        controllerTabBottomRef = PersistentTabController(initialIndex: 3);
        Navigator.of(context, rootNavigator: true).pushReplacement(
            MaterialPageRoute(builder: (context) => new MainScreenRefugee()));
        return true;
      },
      child: Scaffold(
        backgroundColor: background,
        appBar: AppBar(
          title: Text('Your applications',
          style: TextStyle(
              color: blueColor
          ),
          ),
          backgroundColor: background,
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back,color: blueColor,),
            onPressed: () async {
              // await _auth.signOut();
              controllerTabBottomRef = PersistentTabController(initialIndex: 3);
              Navigator.of(context, rootNavigator: true).pushReplacement(
                  MaterialPageRoute(builder: (context) => new MainScreenRefugee()));
            },
          ),

          // bottom: TabBar(
          //   indicatorColor: blueColor,
          //   isScrollable: true,
          //   tabs: [
          //     Text(categories[0],style: TextStyle(fontSize: 17, color: blueColor),),
          //     Text(categories[1],style: TextStyle(fontSize: 17,color: blueColor),),
          //   ],
          //
          // ),
        ),
        body:
        // TabBarView(
        //   children: [

            StreamBuilder(
              stream: FirebaseFirestore.instance

                  .collection('applications')
                  .where('userID', isEqualTo: FirebaseAuth.instance.currentUser?.uid)



              //.where("volunteer_pref", arrayContainsAny: volunteer_preferencies)
              //.where("category", arrayContainsAny: ['Accomodation', 'Transfer', 'Assistance with animals'])
                  .where("status", isEqualTo: 'Application is accepted')



              //.where("category", whereIn: ['Accomodation','Transfer','Assistance with animals'])
              //.where("category", arrayContainsAny: ['Accomodation','Transfer','Assistance with animals'])
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot?> streamSnapshot) {
                return ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: streamSnapshot.data?.docs.length,
                    itemBuilder: (ctx, index) => Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.015,
                        ),
                        Padding(
                          padding: padding,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                card_title_ref=streamSnapshot.data?.docs[index]['title'] as String;
                                card_category_ref=streamSnapshot.data?.docs[index]['category'] as String;
                                card_comment_ref=streamSnapshot.data?.docs[index]['comment'] as String;
                                application_ID = streamSnapshot.data?.docs[index].id as String;
                                token_vol=streamSnapshot.data?.docs[index]["token_vol"]as String;
                                print(card_title_ref);
                                print(card_category_ref);
                                print(card_comment_ref);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PageOfApplicationRef()),
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
                              child: Align(
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: MediaQuery.of(context).size.height *
                                    0.015,),
                                      child: Icon(
                                        streamSnapshot.data?.docs[index]['category'] as String==categoriesListAll[3]
                                            ?Icons.pets_rounded
                                            :streamSnapshot.data?.docs[index]['category'] as String==categoriesListAll[4]
                                            ?Icons.local_grocery_store
                                            :streamSnapshot.data?.docs[index]['category'] as String==categoriesListAll[2]
                                            ?Icons.emoji_transportation_rounded
                                            :streamSnapshot.data?.docs[index]['category'] as String==categoriesListAll[1]
                                            ?Icons.house
                                            :streamSnapshot.data?.docs[index]['category'] as String==categoriesListAll[6]
                                            ?Icons.sign_language_rounded
                                            :streamSnapshot.data?.docs[index]['category'] as String==categoriesListAll[5]
                                            ?Icons.child_care_outlined
                                            :streamSnapshot.data?.docs[index]['category'] as String==categoriesListAll[7]
                                            ?Icons.menu_book
                                            :streamSnapshot.data?.docs[index]['category'] as String==categoriesListAll[8]
                                            ?Icons.medical_information_outlined
                                            :streamSnapshot.data?.docs[index]['category'] as String==categoriesListAll[0]
                                            ?Icons.check_box
                                            :Icons.new_label_sharp,
                                        size: 30,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                        0.65,
                  height: MediaQuery.of(context).size.height *
                      0.12,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: ListTile(
                                              title: Text(
                                                streamSnapshot.data?.docs[index]['title'],
                                                style: GoogleFonts
                                                    .raleway(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              subtitle: Text("${streamSnapshot.data
                                                  ?.docs[index]
                                              ['comment']}".substring(0,31)+"...",
                                              style: GoogleFonts.raleway(
                                                fontSize: 13,
                                                color: Colors.black
                                                    .withOpacity(0.5),
                                              ),
                                              ),
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )

                          ),
                        ),
                      ],
                    ));
              },
            ),
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