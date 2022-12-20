import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:wol_pro_1/constants.dart';
import 'package:wol_pro_1/screens/intro_screen/option.dart';

import 'package:wol_pro_1/services/auth.dart';
import 'package:wol_pro_1/screens/menu/volunteer/home_page/settings/settings_vol_info.dart';

import '../../../../models/categories.dart';
import '../main_screen.dart';
import 'new_screen_with_applications.dart';
import '../home_page/home_vol.dart';
import 'page_of_application_vol.dart';

bool myCategories = true;
String card_title='';
String card_category='';
String card_comment='';
String userID_vol ='';

List<String> chosen_category_settings = [];
class YourCategories extends StatefulWidget {
  const YourCategories({Key? key}) : super(key: key);
  @override
  State createState() => new YourCategoriesState();
}

class YourCategoriesState extends State<YourCategories> {


  FirebaseFirestore db = FirebaseFirestore.instance;

  bool loading = false;
  final AuthService _auth_Vol_your = AuthService();
  final CollectionReference applications = FirebaseFirestore.instance.collection("applications");

  // List<String> cat = [];

  // List<String> categories = ["Your categories", "Accomodation", "Transfer", "Assistance with animals"];

  // List list_cat = [];
  //
  // List getList() {
  //     DocumentReference docRef = FirebaseFirestore.instance.collection("users").doc(userID_vol);
  //     docRef.set("category").toString();
  //     List data = [];
  //     data.add(docRef.set("category").toString());
  //     // docRef.get().then((datasnapshot){
  //     //     data.add(datasnapshot.get("category"));
  //     // });
  //     return data as List;
  //   }

    // @override
    // void main() async{
    //
    //   list_cat = await getList() as List;
    // }

  @override
  void initState() {
    print("UUUUUUUUUUUpadaaaaaaaaateeeeed22222222222233333333333");

    print(categoriesVolunteer);
  }
  Widget build(BuildContext context) {

    print(userID_vol);
    return WillPopScope(
      onWillPop: () async {
        setState(() {
          controllerTabBottomVol = PersistentTabController(initialIndex: 4);
        });
        Navigator.of(context, rootNavigator: true).pushReplacement(
            MaterialPageRoute(builder: (context) => MainScreen()));
        return true;
      },
      child:
      // DefaultTabController(
      //
      //   length: categories.length,
        Scaffold(
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
          // appBar:
          //
          // AppBar(
          //   title: const Text('Home'),
          //   backgroundColor: Color.fromRGBO(49, 72, 103, 0.8),
          //   elevation: 0.0,
          //   leading: IconButton(
          //     icon: const Icon(Icons.arrow_back,color: Colors.white,),
          //     onPressed: () async {
          //       // await _auth_Vol_your.signOut();
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
          //   //       chosen_category_settings = [];
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
          //   // bottom: TabBar(
          //   //   indicatorColor: Color.fromRGBO(85, 146, 169, 0.8),
          //   //   isScrollable: true,
          //   //   tabs: [
          //   //     Text(categories[0],style: TextStyle(fontSize: 17),),
          //   //     Text(categories[1],style: TextStyle(fontSize: 17),),
          //   //     Text(categories[2],style: TextStyle(fontSize: 17),),
          //   //     Text(categories[3],style: TextStyle(fontSize: 17),),
          //   //   ],
          //   //
          //   // ),
          // ),
        body:
    // TabBarView(
    //       children: [

        SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                  height: MediaQuery.of(context).size.height * 0.99,
                    child: StreamBuilder(
                      stream:  applications
                          .where("status", isEqualTo: 'Sent to volunteer')
                          .where("category", whereIn: categoriesVolunteer)

                          .snapshots(),
                      builder: (context, AsyncSnapshot<QuerySnapshot?> streamSnapshot) {
                        return ListView.builder(
                            scrollDirection: Axis.vertical,
                            itemCount: streamSnapshot.data?.docs.length,
                            itemBuilder: (ctx, index) {

                        if (streamSnapshot.hasData){
                        switch (streamSnapshot.connectionState){
                          case ConnectionState.waiting:
                            return  Column(
                                children: [
                                  SizedBox(
                                    width: 60,
                                    height: 60,
                                    child: CircularProgressIndicator(),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 16),
                                    child: Text('Awaiting data...'),
                                  )
                                ]

                            );
                          case ConnectionState.active:
                            return Column(
                              children: [
                                Padding(
                                  padding: padding,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        myCategories = true;
                                        card_title_vol=streamSnapshot.data?.docs[index]['title'] as String;
                                        card_category_vol=streamSnapshot.data?.docs[index]['category'] as String;
                                        card_comment_vol=streamSnapshot.data?.docs[index]['comment'] as String;

                                        print(card_title);
                                        print(card_category);
                                        print(card_comment);
                                        Id_Of_current_application = streamSnapshot.data?.docs[index].id;
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => PageOfApplication()),
                                        );
                                        // print("print ${streamSnapshot.data?.docs[index][id]}");
                                      });

                                    },
                                    child:
                                    Container(
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
                                                EdgeInsets
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
                                                        22) +
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
                                    // Card(
                                    //   child: Center(
                                    //     child: Padding(
                                    //       padding: const EdgeInsets.all(8.0),
                                    //       child: Column(
                                    //         children: [
                                    //           //streamSnapshot.data?.docs[index]['title']==null ?
                                    //
                                    //           Align(
                                    //             alignment: Alignment.topLeft,
                                    //             child: Text(
                                    //               streamSnapshot.data?.docs[index]['title'],
                                    //               style: TextStyle(
                                    //                   fontWeight: FontWeight.bold, ),
                                    //               textAlign: TextAlign.left,
                                    //             ),
                                    //           ),
                                    //           Align(
                                    //             alignment: Alignment.topLeft,
                                    //             child: Text(
                                    //                 streamSnapshot.data?.docs[index]
                                    //                 ['category'] as String,
                                    //                 style: TextStyle(color: Colors.grey)),
                                    //           ),
                                    //           Align(
                                    //             alignment: Alignment.topLeft,
                                    //             child: Text(streamSnapshot.data?.docs[index]
                                    //             ['comment'] as String),
                                    //           ),
                                    //         ],
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
                                  ),
                                ),
                                SizedBox(
                                  height:
                                  MediaQuery.of(context).size.height *
                                      0.015,
                                ),
                              ],
                            );}}
                        return Center(
                          child: Padding(padding: EdgeInsets.only(top: 100),
                            child: Column(
                              children: [
                                SpinKitChasingDots(
                                  color: Colors.brown,
                                  size: 50.0,
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                      "Waiting...",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,fontSize: 24,color: Colors.black,)
                                  ),
                                ),
                                Padding(padding: EdgeInsets.only(top: 20),)
                              ],
                            ),
                          ),
                        );
                            });
                      },
                    )
                  ),
                ],
              ),
            ),


          // ],
        // ),
        ),
      // ),
    );
  }
}