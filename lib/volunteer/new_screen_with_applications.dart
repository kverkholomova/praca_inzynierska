import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wol_pro_1/volunteer/applications/page_of_application_vol.dart';

import 'package:wol_pro_1/services/auth.dart';
import 'package:wol_pro_1/volunteer/home/settings_home_vol.dart';

import 'package:wol_pro_1/volunteer/your_app_vol.dart';

String category_chosen_button ='';
String? card_title_vol='';
String? card_category_vol='';
String? card_comment_vol='';
String userID_vol ='';

List<String> categories_list_all = [
  "Your categories",
  "Accomodation",
  "Transfer",
  "Assistance with animals",
  "Clothes",
  "Assistance with children",
  "Free lawyer",
  "Medical assistance",
  "Other"];

class Categories extends StatefulWidget {
  const Categories({Key? key}) : super(key: key);
  @override
  State createState() => new CategoriesState();
}

class CategoriesState extends State<Categories> {


  FirebaseFirestore db = FirebaseFirestore.instance;

  bool loading = false;
  final AuthService _auth = AuthService();
  final CollectionReference applications = FirebaseFirestore.instance.collection("applications");


  @override

  void initState() {

  }
  Widget build(BuildContext context) {

    print(userID_vol);
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SettingsHomeVol()),
        );
        return true;
      },
      child: DefaultTabController(

        length: categories_list_all.length,
        child: Scaffold(

          appBar: AppBar(
                centerTitle: false,
                title: const Text('Home'),
                  backgroundColor: Color.fromRGBO(49, 72, 103, 0.8),
                  elevation: 0.0,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back,color: Colors.white,),
                    onPressed: () async {
                      // await _auth.signOut();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SettingsHomeVol()),
                      );
                    },
                  ),
                  // actions: <Widget>[
                  //   IconButton(
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
                  //
                  //   IconButton(
                  //     icon: const Icon(Icons.person,color: Colors.white,),
                  //     //label: const Text('logout',style: TextStyle(color: Colors.white),),
                  //     onPressed: () async {
                  //       //await _auth.signOut();
                  //       Navigator.push(
                  //         context,
                  //         MaterialPageRoute(builder: (context) => ApplicationsOfVolunteer()),
                  //       );
                  //     },
                  //   ),
                  //
                  // ],
          ),
                  body: SingleChildScrollView(

                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Center(
                            child: Container(
                              width: 300,
                              height: 60,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20)
                              ),
                              child: MaterialButton(
                                color: const Color.fromRGBO(137, 102, 120, 0.8),
                                child: Text(categories_list_all[0], style: (TextStyle(color: Colors.white, fontSize: 15)),),
                                onPressed: () {

                                  // category_chosen_button = categories_list_all[0];
                                  // print(categories_list_all[7]);
                                  print(categories_list_all.length);
                                  print("PPPPPPPPPPPPPPPPPPPPPPPP____________________WWWWWWWWWWWWWWWWWWWWWWW");
                                  print(categories_user_Register);
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => const YourCategories()));
                                },
                              ),
                            ),
                          ),
                        ),


                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Center(
                      child: Container(
                        width: 300,
                        height: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20)
                        ),
                        child: MaterialButton(
                          color: const Color.fromRGBO(137, 102, 120, 0.8),
                          child: Text(categories_list_all[1], style: (TextStyle(color: Colors.white, fontSize: 15)),),
                          onPressed: () {

                            category_chosen_button = categories_list_all[1];
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const ChosenCategory()));
                          },
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Center(
                      child: Container(
                        width: 300,
                        height: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20)
                        ),
                        child: MaterialButton(
                          color: const Color.fromRGBO(137, 102, 120, 0.8),
                          child: Text(categories_list_all[2], style: (TextStyle(color: Colors.white, fontSize: 15)),),
                          onPressed: () {

                            category_chosen_button = categories_list_all[2];
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const ChosenCategory()));
                          },
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Center(
                      child: Container(
                        width: 300,
                        height: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20)
                        ),
                        child: MaterialButton(
                          color: const Color.fromRGBO(137, 102, 120, 0.8),
                          child: Text(categories_list_all[3], style: (TextStyle(color: Colors.white, fontSize: 15)),),
                          onPressed: () {

                            category_chosen_button = categories_list_all[3];
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const ChosenCategory()));
                          },
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Center(
                      child: Container(
                        width: 300,
                        height: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20)
                        ),
                        child: MaterialButton(
                          color: const Color.fromRGBO(137, 102, 120, 0.8),
                          child: Text(categories_list_all[4], style: (TextStyle(color: Colors.white, fontSize: 15)),),
                          onPressed: () {

                            category_chosen_button = categories_list_all[4];
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const ChosenCategory()));
                          },
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Center(
                      child: Container(
                        width: 300,
                        height: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20)
                        ),
                        child: MaterialButton(
                          color: const Color.fromRGBO(137, 102, 120, 0.8),
                          child: Text(categories_list_all[5], style: (TextStyle(color: Colors.white, fontSize: 15)),),
                          onPressed: () {

                            category_chosen_button = categories_list_all[5];
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const ChosenCategory()));
                          },
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Center(
                      child: Container(
                        width: 300,
                        height: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20)
                        ),
                        child: MaterialButton(
                          color: const Color.fromRGBO(137, 102, 120, 0.8),
                          child: Text(categories_list_all[6], style: (TextStyle(color: Colors.white, fontSize: 15)),),
                          onPressed: () {

                            category_chosen_button = categories_list_all[6];
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const ChosenCategory()));
                          },
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Center(
                      child: Container(
                        width: 300,
                        height: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20)
                        ),
                        child: MaterialButton(
                          color: const Color.fromRGBO(137, 102, 120, 0.8),
                          child: Text(categories_list_all[7], style: (TextStyle(color: Colors.white, fontSize: 15)),),
                          onPressed: () {

                            category_chosen_button = categories_list_all[7];
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const ChosenCategory()));
                          },
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Center(
                      child: Container(
                        width: 300,
                        height: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20)
                        ),
                        child: MaterialButton(
                          color: const Color.fromRGBO(137, 102, 120, 0.8),
                          child: Text(categories_list_all[8], style: (TextStyle(color: Colors.white, fontSize: 15)),),
                          onPressed: () {

                            category_chosen_button = categories_list_all[8];
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const ChosenCategory()));
                          },
                        ),
                      ),
                    ),
                  ),
                      ],
                    ),
                  ),
        ),
      ),
    );
  }
}

String? id_card = '';
class ChosenCategory extends StatefulWidget{
  const ChosenCategory({Key? key}) : super(key: key);
  @override
  State createState() => new ChosenCategoryState();
}

class ChosenCategoryState extends State<ChosenCategory> {

  final AuthService _auth_ = AuthService();
  @override

  void initState() {

  }
  Widget build(BuildContext context) {
    print(userID_vol);
    return WillPopScope(
        onWillPop: () async {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Categories()),
          );
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            centerTitle: false,
            title: const Text('Home'),
            backgroundColor: Color.fromRGBO(49, 72, 103, 0.8),
            elevation: 0.0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back,color: Colors.white,),
              onPressed: () {
                // await _auth_.signOut();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Categories()),
                );
              },
            ),
            // actions: <Widget>[
            //   IconButton(
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
            //
            //   IconButton(
            //     icon: const Icon(Icons.person,color: Colors.white,),
            //     //label: const Text('logout',style: TextStyle(color: Colors.white),),
            //     onPressed: () async {
            //       //await _auth.signOut();
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(builder: (context) => ApplicationsOfVolunteer()),
            //       );
            //     },
            //   ),
            //
            // ],
          ),
          body: StreamBuilder(
          stream:   FirebaseFirestore.instance
              .collection('applications')
              .where("category", isEqualTo: category_chosen_button)

          //.where("volunteer_pref", arrayContainsAny: volunteer_preferencies)
          //.where("category", arrayContainsAny: ['Accomodation', 'Transfer', 'Assistance with animals'])
              .where("status", isEqualTo: 'Sent to volunteer')

          //.where("category", whereIn: ['Accomodation','Transfer','Assistance with animals'])
          //.where("category", arrayContainsAny: ['Accomodation','Transfer','Assistance with animals'])
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot?> streamSnapshot) {
            return Container(
              width: 450,
              height: double.infinity,
              child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: streamSnapshot.data?.docs.length,
                  itemBuilder: (ctx, index) => Column(
                    children: [
                      MaterialButton(
                        onPressed: () {

                          setState(() {
                            // FirebaseFirestore.instance
                            //     .collection('applications')
                            //     .doc(streamSnapshot.data?.docs[index].id)
                            //     .update({"Id": streamSnapshot.data?.docs[index].id});
                            //
                            // id_card = streamSnapshot.data?.docs[index].id;
                            card_title_vol=streamSnapshot.data?.docs[index]['title'];
                            card_category_vol=streamSnapshot.data?.docs[index]['category'];
                            card_comment_vol=streamSnapshot.data?.docs[index]['comment'];
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PageOfApplication()),
                            );
                            // print("print ${streamSnapshot.data?.docs[index][id]}");
                          });

                        },
                        child: Card(
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Text(
                                    streamSnapshot.data?.docs[index]['title'] as String,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                      streamSnapshot.data?.docs[index]['category'] as String,
                                      style: TextStyle(color: Colors.grey)),
                                  Text(streamSnapshot.data?.docs[index]['comment'] as String),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            );
          },
        ),
        ));
  }
}

// class YourCategory extends StatefulWidget{
//   const YourCategory({Key? key}) : super(key: key);
//   @override
//   State createState() => new YourCategoryState();
// }
//
// class YourCategoryState extends State<YourCategory> {
//
//   final CollectionReference applications = FirebaseFirestore.instance.collection("applications");
//   final AuthService _auth_your = AuthService();
//   @override
//
//   void initState() {
//
//   }
//   Widget build(BuildContext context) {
//     print(userID_vol);
//     return WillPopScope(
//         onWillPop: () async {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => SettingsHomeVol()),
//           );
//           return true;
//         },
//         child: Scaffold(
//           appBar: AppBar(
//             centerTitle: false,
//             title: const Text('Home'),
//             backgroundColor: Color.fromRGBO(49, 72, 103, 0.8),
//             elevation: 0.0,
//             leading: IconButton(
//               icon: const Icon(Icons.exit_to_app,color: Colors.white,),
//               onPressed: () async {
//                 await _auth_your.signOut();
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => SettingsHomeVol()),
//                 );
//               },
//             ),
//             // actions: <Widget>[
//             //   IconButton(
//             //     icon: const Icon(Icons.settings,color: Colors.white,),
//             //     //label: const Text('logout',style: TextStyle(color: Colors.white),),
//             //     onPressed: () async {
//             //       //await _auth.signOut();
//             //       chosen_category_settings = [];
//             //       Navigator.push(
//             //         context,
//             //         MaterialPageRoute(builder: (context) => SettingsVol()),
//             //       );
//             //     },
//             //   ),
//             //
//             //   IconButton(
//             //     icon: const Icon(Icons.person,color: Colors.white,),
//             //     //label: const Text('logout',style: TextStyle(color: Colors.white),),
//             //     onPressed: () async {
//             //       //await _auth.signOut();
//             //       Navigator.push(
//             //         context,
//             //         MaterialPageRoute(builder: (context) => ApplicationsOfVolunteer()),
//             //       );
//             //     },
//             //   ),
//             //
//             // ],
//           ),
//           body: Container(
//             child: StreamBuilder(
//             stream:  applications
//                 .where("status", isEqualTo: 'Sent to volunteer')
//                 // .where("category", whereIn: categories_user_Register)
//
//                 .where("status", isEqualTo: 'Transfer')
//                 .snapshots(),
//             builder: (context, AsyncSnapshot<QuerySnapshot?> streamSnapshot) {
//               print("PPPPPPPPPPPPPPUUUUUUUUUUUU___________NNNNNNNNNNNNOOOOOOOOOO");
//               print(categories_user_Register);
//               return Container(
//                 width: 450,
//                 height: double.infinity,
//                 child: ListView.builder(
//                     scrollDirection: Axis.vertical,
//                     itemCount: streamSnapshot.data?.docs.length,
//                     itemBuilder: (ctx, index) => Column(
//                       children: [
//                         MaterialButton(
//                           onPressed: () {
//                             setState(() {
//                               card_title=streamSnapshot.data?.docs[index]['title'] as String;
//                               card_category=streamSnapshot.data?.docs[index]['category'] as String;
//                               card_comment=streamSnapshot.data?.docs[index]['comment'] as String;
//
//                               print(card_title);
//                               print(card_category);
//                               print(card_comment);
//                               Id_Of_current_application = streamSnapshot.data?.docs[index].id;
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) => PageOfApplication()),
//                               );
//                               // print("print ${streamSnapshot.data?.docs[index][id]}");
//                             });
//
//                           },
//                           child: Card(
//                             child: Center(
//                               child: Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Column(
//                                   children: [
//                                     //streamSnapshot.data?.docs[index]['title']==null ?
//
//                                     Text(
//                                       streamSnapshot.data?.docs[index]['title'],
//                                       style: TextStyle(
//                                         fontWeight: FontWeight.bold, ),
//                                       textAlign: TextAlign.left,
//                                     ),
//                                     Text(
//                                         streamSnapshot.data?.docs[index]
//                                         ['category'] as String,
//                                         style: TextStyle(color: Colors.grey)),
//                                     Text(streamSnapshot.data?.docs[index]
//                                     ['comment'] as String),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     )),
//               );
//             },
//         ),
//           ),
//         ));
//   }
// }


          // appBar:
          //
          // AppBar(
          //   title: const Text('Home'),
          //   backgroundColor: Color.fromRGBO(49, 72, 103, 0.8),
          //   elevation: 0.0,
          //   leading: IconButton(
          //     icon: const Icon(Icons.exit_to_app,color: Colors.white,),
          //     onPressed: () async {
          //       await _auth.signOut();
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(builder: (context) => OptionChoose()),
          //       );
          //     },
          //   ),
          //   actions: <Widget>[
          //     IconButton(
          //       icon: const Icon(Icons.settings,color: Colors.white,),
          //       //label: const Text('logout',style: TextStyle(color: Colors.white),),
          //       onPressed: () async {
          //         //await _auth.signOut();
          //         chosen_category_settings = [];
          //         Navigator.push(
          //           context,
          //           MaterialPageRoute(builder: (context) => SettingsVol()),
          //         );
          //       },
          //     ),
          //
          //     IconButton(
          //       icon: const Icon(Icons.person,color: Colors.white,),
          //       //label: const Text('logout',style: TextStyle(color: Colors.white),),
          //       onPressed: () async {
          //         //await _auth.signOut();
          //         Navigator.push(
          //           context,
          //           MaterialPageRoute(builder: (context) => ApplicationsOfVolunteer()),
          //         );
          //       },
          //     ),
          //
          //   ],
          //   bottom: TabBar(
          //     indicatorColor: Color.fromRGBO(85, 146, 169, 0.8),
          //     isScrollable: true,
          //     tabs: [
          //       Text(categories[0],style: TextStyle(fontSize: 17),),
          //       Text(categories[1],style: TextStyle(fontSize: 17),),
          //       Text(categories[2],style: TextStyle(fontSize: 17),),
          //       Text(categories[3],style: TextStyle(fontSize: 17),),
          //     ],
          //
          //   ),
          // ),
          // body: TabBarView(
          //   children: [
          //
          //     StreamBuilder(
          //       stream:  applications
          //           .where("status", isEqualTo: 'Sent to volunteer')
          //           .where("category", whereIn: categories_user)
          //
          //           .snapshots(),
          //       builder: (context, AsyncSnapshot<QuerySnapshot?> streamSnapshot) {
          //         return Container(
          //           width: 450,
          //           height: 300,
          //           child: ListView.builder(
          //               scrollDirection: Axis.vertical,
          //               itemCount: streamSnapshot.data?.docs.length,
          //               itemBuilder: (ctx, index) => Column(
          //                 children: [
          //                   MaterialButton(
          //                     onPressed: () {
          //                       setState(() {
          //                         card_title=streamSnapshot.data?.docs[index]['title'] as String;
          //                         card_category=streamSnapshot.data?.docs[index]['category'] as String;
          //                         card_comment=streamSnapshot.data?.docs[index]['comment'] as String;
          //
          //                         print(card_title);
          //                         print(card_category);
          //                         print(card_comment);
          //                         Id_Of_current_application = streamSnapshot.data?.docs[index].id;
          //                         Navigator.push(
          //                           context,
          //                           MaterialPageRoute(
          //                               builder: (context) => PageOfApplication()),
          //                         );
          //                         // print("print ${streamSnapshot.data?.docs[index][id]}");
          //                       });
          //
          //                     },
          //                     child: Card(
          //                       child: Center(
          //                         child: Padding(
          //                           padding: const EdgeInsets.all(8.0),
          //                           child: Column(
          //                             children: [
          //                               //streamSnapshot.data?.docs[index]['title']==null ?
          //
          //                               Text(
          //                                 streamSnapshot.data?.docs[index]['title'],
          //                                 style: TextStyle(
          //                                   fontWeight: FontWeight.bold, ),
          //                                 textAlign: TextAlign.left,
          //                               ),
          //                               Text(
          //                                   streamSnapshot.data?.docs[index]
          //                                   ['category'] as String,
          //                                   style: TextStyle(color: Colors.grey)),
          //                               Text(streamSnapshot.data?.docs[index]
          //                               ['comment'] as String),
          //                             ],
          //                           ),
          //                         ),
          //                       ),
          //                     ),
          //                   ),
          //                 ],
          //               )),
          //         );
          //       },
          //     ),
          //     StreamBuilder(
          //       stream:   FirebaseFirestore.instance
          //           .collection('applications')
          //           .where("category", isEqualTo: "Accomodation")
          //
          //       //.where("volunteer_pref", arrayContainsAny: volunteer_preferencies)
          //       //.where("category", arrayContainsAny: ['Accomodation', 'Transfer', 'Assistance with animals'])
          //           .where("status", isEqualTo: 'Sent to volunteer')
          //
          //       //.where("category", whereIn: ['Accomodation','Transfer','Assistance with animals'])
          //       //.where("category", arrayContainsAny: ['Accomodation','Transfer','Assistance with animals'])
          //           .snapshots(),
          //       builder: (context, AsyncSnapshot<QuerySnapshot?> streamSnapshot) {
          //         return Container(
          //           width: 450,
          //           height: 300,
          //           child: ListView.builder(
          //               scrollDirection: Axis.vertical,
          //               itemCount: streamSnapshot.data?.docs.length,
          //               itemBuilder: (ctx, index) => Column(
          //                 children: [
          //                   MaterialButton(
          //                     onPressed: () {
          //
          //                       setState(() {
          //                         card_title=streamSnapshot.data?.docs[index]['title'] as String;
          //                         card_category=streamSnapshot.data?.docs[index]['category'] as String;
          //                         card_comment=streamSnapshot.data?.docs[index]['comment'] as String;
          //                         Navigator.push(
          //                           context,
          //                           MaterialPageRoute(
          //                               builder: (context) => PageOfApplication()),
          //                         );
          //                         // print("print ${streamSnapshot.data?.docs[index][id]}");
          //                       });
          //
          //                     },
          //                     child: Card(
          //                       child: Center(
          //                         child: Padding(
          //                           padding: const EdgeInsets.all(8.0),
          //                           child: Column(
          //                             children: [
          //                               Text(
          //                                 streamSnapshot.data?.docs[index]['title'] as String,
          //                                 style: TextStyle(
          //                                     fontWeight: FontWeight.bold),
          //                               ),
          //                               Text(
          //                                   streamSnapshot.data?.docs[index]
          //                                   ['category'] as String,
          //                                   style: TextStyle(color: Colors.grey)),
          //                               Text(streamSnapshot.data?.docs[index]
          //                               ['comment'] as String),
          //                             ],
          //                           ),
          //                         ),
          //                       ),
          //                     ),
          //                   ),
          //                 ],
          //               )),
          //         );
          //       },
          //     ),
          //     StreamBuilder(
          //       stream: FirebaseFirestore.instance
          //           .collection('applications')
          //           .where("category", isEqualTo: "Transfer")
          //
          //       //.where("volunteer_pref", arrayContainsAny: volunteer_preferencies)
          //       //.where("category", arrayContainsAny: ['Accomodation', 'Transfer', 'Assistance with animals'])
          //           .where("status", isEqualTo: 'Sent to volunteer')
          //
          //       //.where("category", whereIn: ['Accomodation','Transfer','Assistance with animals'])
          //       //.where("category", arrayContainsAny: ['Accomodation','Transfer','Assistance with animals'])
          //           .snapshots(),
          //       builder: (context, AsyncSnapshot<QuerySnapshot?> streamSnapshot) {
          //         return Container(
          //           width: 450,
          //           height: 300,
          //           child: ListView.builder(
          //               scrollDirection: Axis.vertical,
          //               itemCount: streamSnapshot.data?.docs.length,
          //               itemBuilder: (ctx, index) => Column(
          //                 children: [
          //                   MaterialButton(
          //                     onPressed: () {
          //                       card_title=streamSnapshot.data?.docs[index]['title'] as String;
          //                       card_category=streamSnapshot.data?.docs[index]['category'] as String;
          //                       card_comment=streamSnapshot.data?.docs[index]['comment'] as String;
          //                       setState(() {
          //                         Navigator.push(
          //                           context,
          //                           MaterialPageRoute(
          //                               builder: (context) => PageOfApplication()),
          //                         );
          //                         // print("print ${streamSnapshot.data?.docs[index][id]}");
          //                       });
          //
          //                     },
          //                     child: Card(
          //                       child: Center(
          //                         child: Padding(
          //                           padding: const EdgeInsets.all(8.0),
          //                           child: Column(
          //                             children: [
          //                               Text(
          //                                 streamSnapshot.data?.docs[index]['title'] as String,
          //                                 style: TextStyle(
          //                                     fontWeight: FontWeight.bold),
          //                               ),
          //                               Text(
          //                                   streamSnapshot.data?.docs[index]
          //                                   ['category'] as String,
          //                                   style: TextStyle(color: Colors.grey)),
          //                               Text(streamSnapshot.data?.docs[index]
          //                               ['comment'] as String),
          //                             ],
          //                           ),
          //                         ),
          //                       ),
          //                     ),
          //                   ),
          //                 ],
          //               )),
          //         );
          //       },
          //     ),
          //     StreamBuilder(
          //       stream: FirebaseFirestore.instance
          //           .collection('applications')
          //           .where("category", isEqualTo: "Assistance with animals")
          //
          //       //.where("volunteer_pref", arrayContainsAny: volunteer_preferencies)
          //       //.where("category", arrayContainsAny: ['Accomodation', 'Transfer', 'Assistance with animals'])
          //           .where("status", isEqualTo: 'Sent to volunteer')
          //
          //       //.where("category", whereIn: ['Accomodation','Transfer','Assistance with animals'])
          //       //.where("category", arrayContainsAny: ['Accomodation','Transfer','Assistance with animals'])
          //           .snapshots(),
          //       builder: (context, AsyncSnapshot<QuerySnapshot?> streamSnapshot) {
          //         return Container(
          //           width: 450,
          //           height: 300,
          //           child: ListView.builder(
          //               scrollDirection: Axis.vertical,
          //               itemCount: streamSnapshot.data?.docs.length,
          //               itemBuilder: (ctx, index) => Column(
          //                 children: [
          //                   MaterialButton(
          //                     onPressed: () {
          //                       card_title=streamSnapshot.data?.docs[index]['title'] as String;
          //                       card_category=streamSnapshot.data?.docs[index]['category'] as String;
          //                       card_comment=streamSnapshot.data?.docs[index]['comment'] as String;
          //                       setState(() {
          //                         Navigator.push(
          //                           context,
          //                           MaterialPageRoute(
          //                               builder: (context) => PageOfApplication()),
          //                         );
          //                         // print("print ${streamSnapshot.data?.docs[index][id]}");
          //                       });
          //
          //                     },
          //                     child: Card(
          //                       child: Center(
          //                         child: Padding(
          //                           padding: const EdgeInsets.all(8.0),
          //                           child: Column(
          //                             children: [
          //                               Text(
          //                                 streamSnapshot.data?.docs[index]['title'] as String,
          //                                 style: TextStyle(
          //                                     fontWeight: FontWeight.bold),
          //                               ),
          //                               Text(
          //                                   streamSnapshot.data?.docs[index]
          //                                   ['category'] as String,
          //                                   style: TextStyle(color: Colors.grey)),
          //                               Text(streamSnapshot.data?.docs[index]
          //                               ['comment'] as String),
          //                             ],
          //                           ),
          //                         ),
          //                       ),
          //                     ),
          //                   ),
          //                 ],
          //               )),
          //         );
          //       },
          //     ),
          //   ],
          // ),
