import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wol_pro_1/constants.dart';
import 'package:wol_pro_1/services/auth.dart';

import '../../../../volunteer/applications/page_of_application_vol.dart';
import 'new_screen_with_applications.dart';


String? id_card = '';
class ChosenCategory extends StatefulWidget{
  const ChosenCategory({Key? key}) : super(key: key);
  @override
  State createState() => new ChosenCategoryState();
}

class ChosenCategoryState extends State<ChosenCategory> {

  ScrollController scrollController = ScrollController();
  final AuthService _auth_ = AuthService();
  @override

  void initState() {

  }
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Categories()),
          );
          return true;
        },
        child: SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: background,
            floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
            floatingActionButton: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 30,
                color: blueColor,
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Categories()));
              },
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
            body: SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: padding,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[

                    Padding(
                      padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.08,
                          top: MediaQuery.of(context).size.height * 0.02
                      ),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          "Choose application",
                          style: GoogleFonts.raleway(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 550,
                      child: Column(
                        children: [
                          Expanded(
                            child:StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('applications')
                                .where("category", isEqualTo: categoryChosenVolunteer)

                            //.where("volunteer_pref", arrayContainsAny: volunteer_preferencies)
                            //.where("category", arrayContainsAny: ['Accomodation', 'Transfer', 'Assistance with animals'])
                                .where("status", isEqualTo: 'Sent to volunteer')

                            //.where("category", whereIn: ['Accomodation','Transfer','Assistance with animals'])
                            //.where("category", arrayContainsAny: ['Accomodation','Transfer','Assistance with animals'])
                                .snapshots(),
                            builder: (context, AsyncSnapshot<QuerySnapshot?> streamSnapshot) {
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


                              return ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: streamSnapshot.data?.docs.length,
                                  itemBuilder: (ctx, index)
                                  {
                                    // if (streamSnapshot.hasData) {
                                      switch (streamSnapshot.connectionState) {
                                        case ConnectionState.waiting:
                                          return Padding(
                                            padding: EdgeInsets.only(
                                              top: MediaQuery.of(context).size.height * 0.0,
                                            ),
                                            child: Align(
                                              alignment: Alignment.topCenter,
                                              child: Text("Waiting for data",
                                                  style: GoogleFonts.raleway(
                                                    fontSize: 25,
                                                    color: Colors.white,
                                                  )),
                                            ),
                                          );
                                        case ConnectionState.active:
                                          return  Column(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    // FirebaseFirestore.instance
                                                    //     .collection('applications')
                                                    //     .doc(streamSnapshot.data?.docs[index].id)
                                                    //     .update({"Id": streamSnapshot.data?.docs[index].id});
                                                    //
                                                    // id_card = streamSnapshot.data?.docs[index].id;
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
                                                              PageOfApplication()),
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
                                                      BorderRadius
                                                          .circular(24)),
                                                  child: ListTile(
                                                    // mainAxisAlignment: MainAxisAlignment.start,

                                                    contentPadding:
                                                    EdgeInsets.symmetric(
                                                        vertical: 10),
                                                    title: Padding(
                                                      padding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 12),
                                                      child: Text(
                                                          streamSnapshot.data
                                                              ?.docs[index]
                                                          ['title']
                                                          as String,
                                                          style: GoogleFonts
                                                              .raleway(
                                                            fontSize: 14,
                                                            color:
                                                            Colors.black,
                                                          )),
                                                    ),
                                                    // Text(
                                                    //     streamSnapshot.data?.docs[index]['category'] as String,
                                                    //     style: TextStyle(color: Colors.grey)),
                                                    subtitle: Padding(
                                                      padding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 12),
                                                      child: Text(
                                                        streamSnapshot.data
                                                            ?.docs[index]
                                                        ['comment']
                                                        as String,
                                                        style: GoogleFonts
                                                            .raleway(
                                                          fontSize: 12,
                                                          color: Colors.black
                                                              .withOpacity(
                                                              0.5),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height:
                                                MediaQuery.of(context).size.height *
                                                    0.012,
                                              ),
                                            ],
                                          );
                                      // case ConnectionState.none:
                                      //
                                      // case ConnectionState.done:
                                      // // TODO: Handle this case.
                                      //   break;
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
                          ),),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}