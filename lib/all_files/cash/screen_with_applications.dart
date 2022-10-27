// import 'package:cloud_firestore/cloud_firestore.dart';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart';
// import 'package:wol_pro_1/volunteer/applications/page_of_application_vol.dart';
//
// import 'package:wol_pro_1/volunteer/home/applications_vol.dart';
// import 'package:wol_pro_1/screens/option.dart';
//
// import 'package:wol_pro_1/services/auth.dart';
//
// import 'dart:async';
//
// import 'package:wol_pro_1/volunteer/home/home_vol.dart';
// import 'package:wol_pro_1/volunteer/settings_vol_info.dart';
//
//
// String card_title='';
// String card_category='';
// String card_comment='';
// String userID_vol ='';
//
// List<String> chosen_category_settings = [];
// class Categories extends StatefulWidget {
//   const Categories({Key? key}) : super(key: key);
//   @override
//   State createState() => new CategoriesState();
// }
//
// class CategoriesState extends State<Categories> {
//
//
//   FirebaseFirestore db = FirebaseFirestore.instance;
//
//   bool loading = false;
//   final AuthService _auth = AuthService();
//   final CollectionReference applications = FirebaseFirestore.instance.collection("applications");
//
//   List<String> cat = [];
//
//   List<String> categories = ["Your categories", "Accomodation", "Transfer", "Assistance with animals"];
//
//
// //   Future<List> Widg() async {
// //   List _message = [];
// //   _fetchData(List mess) async{
// //     db.collection("users").doc(userID_vol).get().then((value) {
// //       setState(() {
// //         mess.add(value.get("category"));
// //         print(mess);
// //       });
// //
// //     });
// //   }
// //   return await _fetchData(_message);
// // }
//
//   // Future<List> _fetchData() async{
//   //   List mess = [];
//   //   db.collection("users").doc(userID_vol).get().then((value) {
//   //     setState(() {
//   //       mess.add(value.get("category"));
//   //       print(mess);
//   //     });
//   //   });
//   //   return mess;
//   // }
//   //
//   // @override
//   // void initState() {
//   //   super.initState();
//   //   // this should not be done in build method.
//   //   _fetchData();
//   // }
//   List list_cat = [];
//
//   List getList() {
//       DocumentReference docRef = FirebaseFirestore.instance.collection("users").doc(userID_vol);
//       docRef.set("category").toString();
//       List data = [];
//       data.add(docRef.set("category").toString());
//       // docRef.get().then((datasnapshot){
//       //     data.add(datasnapshot.get("category"));
//       // });
//       return data as List;
//     }
//
//     @override
//     void main() async{
//
//       list_cat = await getList() as List;
//     }
//
//   @override
//
//   void initState() {
//
//   }
//   Widget build(BuildContext context) {
//
//     print(userID_vol);
//     return WillPopScope(
//       onWillPop: () async {
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => OptionChoose()),
//         );
//         return true;
//       },
//       child: DefaultTabController(
//
//         length: categories.length,
//         child: Scaffold(
//           appBar:
//
//           AppBar(
//             title: const Text('Home'),
//             backgroundColor: Color.fromRGBO(49, 72, 103, 0.8),
//             elevation: 0.0,
//             leading: IconButton(
//               icon: const Icon(Icons.exit_to_app,color: Colors.white,),
//               onPressed: () async {
//                 await _auth.signOut();
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => OptionChoose()),
//                 );
//               },
//             ),
//             actions: <Widget>[
//               IconButton(
//                 icon: const Icon(Icons.settings,color: Colors.white,),
//                 //label: const Text('logout',style: TextStyle(color: Colors.white),),
//                 onPressed: () async {
//                   //await _auth.signOut();
//                   chosen_category_settings = [];
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => SettingsVol()),
//                   );
//                 },
//               ),
//
//               IconButton(
//                 icon: const Icon(Icons.person,color: Colors.white,),
//                 //label: const Text('logout',style: TextStyle(color: Colors.white),),
//                 onPressed: () async {
//                   //await _auth.signOut();
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(builder: (context) => ApplicationsOfVolunteer()),
//                   );
//                 },
//               ),
//
//             ],
//             bottom: TabBar(
//               indicatorColor: Color.fromRGBO(85, 146, 169, 0.8),
//               isScrollable: true,
//               tabs: [
//                 Text(categories[0],style: TextStyle(fontSize: 17),),
//                 Text(categories[1],style: TextStyle(fontSize: 17),),
//                 Text(categories[2],style: TextStyle(fontSize: 17),),
//                 Text(categories[3],style: TextStyle(fontSize: 17),),
//               ],
//
//             ),
//           ),
//         body: TabBarView(
//           children: [
//
//             StreamBuilder(
//               stream:  applications
//                   .where("status", isEqualTo: 'Sent to volunteer')
//                   .where("category", whereIn: categories_user)
//
//                   .snapshots(),
//               builder: (context, AsyncSnapshot<QuerySnapshot?> streamSnapshot) {
//                 return Container(
//                   width: 450,
//                   height: 300,
//                   child: ListView.builder(
//                       scrollDirection: Axis.vertical,
//                       itemCount: streamSnapshot.data?.docs.length,
//                       itemBuilder: (ctx, index) => Column(
//                         children: [
//                           MaterialButton(
//                             onPressed: () {
//                               setState(() {
//                                 card_title=streamSnapshot.data?.docs[index]['title'] as String;
//                                 card_category=streamSnapshot.data?.docs[index]['category'] as String;
//                                 card_comment=streamSnapshot.data?.docs[index]['comment'] as String;
//
//                                 print(card_title);
//                                 print(card_category);
//                                 print(card_comment);
//                                 Id_Of_current_application = streamSnapshot.data?.docs[index].id;
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) => PageOfApplication()),
//                                 );
//                                 // print("print ${streamSnapshot.data?.docs[index][id]}");
//                               });
//
//                             },
//                             child: Card(
//                               child: Center(
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Column(
//                                     children: [
//                                       //streamSnapshot.data?.docs[index]['title']==null ?
//
//                                       Text(
//                                         streamSnapshot.data?.docs[index]['title'],
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.bold, ),
//                                         textAlign: TextAlign.left,
//                                       ),
//                                       Text(
//                                           streamSnapshot.data?.docs[index]
//                                           ['category'] as String,
//                                           style: TextStyle(color: Colors.grey)),
//                                       Text(streamSnapshot.data?.docs[index]
//                                       ['comment'] as String),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       )),
//                 );
//               },
//             ),
//             StreamBuilder(
//                   stream:   FirebaseFirestore.instance
//                       .collection('applications')
//                       .where("category", isEqualTo: "Accomodation")
//
//                   //.where("volunteer_pref", arrayContainsAny: volunteer_preferencies)
//                   //.where("category", arrayContainsAny: ['Accomodation', 'Transfer', 'Assistance with animals'])
//                       .where("status", isEqualTo: 'Sent to volunteer')
//
//                   //.where("category", whereIn: ['Accomodation','Transfer','Assistance with animals'])
//                   //.where("category", arrayContainsAny: ['Accomodation','Transfer','Assistance with animals'])
//                       .snapshots(),
//                   builder: (context, AsyncSnapshot<QuerySnapshot?> streamSnapshot) {
//                     return Container(
//                       width: 450,
//                       height: 300,
//                       child: ListView.builder(
//                           scrollDirection: Axis.vertical,
//                           itemCount: streamSnapshot.data?.docs.length,
//                           itemBuilder: (ctx, index) => Column(
//                             children: [
//                               MaterialButton(
//                                 onPressed: () {
//
//                                   setState(() {
//                                     card_title=streamSnapshot.data?.docs[index]['title'] as String;
//                                     card_category=streamSnapshot.data?.docs[index]['category'] as String;
//                                     card_comment=streamSnapshot.data?.docs[index]['comment'] as String;
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (context) => PageOfApplication()),
//                                     );
//                                     // print("print ${streamSnapshot.data?.docs[index][id]}");
//                                   });
//
//                                 },
//                                 child: Card(
//                                   child: Center(
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(8.0),
//                                       child: Column(
//                                         children: [
//                                           Text(
//                                             streamSnapshot.data?.docs[index]['title'] as String,
//                                             style: TextStyle(
//                                                 fontWeight: FontWeight.bold),
//                                           ),
//                                           Text(
//                                               streamSnapshot.data?.docs[index]
//                                               ['category'] as String,
//                                               style: TextStyle(color: Colors.grey)),
//                                           Text(streamSnapshot.data?.docs[index]
//                                           ['comment'] as String),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           )),
//                     );
//                   },
//                 ),
//             StreamBuilder(
//               stream: FirebaseFirestore.instance
//                   .collection('applications')
//                   .where("category", isEqualTo: "Transfer")
//
//               //.where("volunteer_pref", arrayContainsAny: volunteer_preferencies)
//               //.where("category", arrayContainsAny: ['Accomodation', 'Transfer', 'Assistance with animals'])
//                   .where("status", isEqualTo: 'Sent to volunteer')
//
//               //.where("category", whereIn: ['Accomodation','Transfer','Assistance with animals'])
//               //.where("category", arrayContainsAny: ['Accomodation','Transfer','Assistance with animals'])
//                   .snapshots(),
//               builder: (context, AsyncSnapshot<QuerySnapshot?> streamSnapshot) {
//                 return Container(
//                   width: 450,
//                   height: 300,
//                   child: ListView.builder(
//                       scrollDirection: Axis.vertical,
//                       itemCount: streamSnapshot.data?.docs.length,
//                       itemBuilder: (ctx, index) => Column(
//                         children: [
//                           MaterialButton(
//                             onPressed: () {
//                               card_title=streamSnapshot.data?.docs[index]['title'] as String;
//                               card_category=streamSnapshot.data?.docs[index]['category'] as String;
//                               card_comment=streamSnapshot.data?.docs[index]['comment'] as String;
//                               setState(() {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) => PageOfApplication()),
//                                 );
//                                 // print("print ${streamSnapshot.data?.docs[index][id]}");
//                               });
//
//                             },
//                             child: Card(
//                               child: Center(
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Column(
//                                     children: [
//                                       Text(
//                                         streamSnapshot.data?.docs[index]['title'] as String,
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                       Text(
//                                           streamSnapshot.data?.docs[index]
//                                           ['category'] as String,
//                                           style: TextStyle(color: Colors.grey)),
//                                       Text(streamSnapshot.data?.docs[index]
//                                       ['comment'] as String),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       )),
//                 );
//               },
//             ),
//             StreamBuilder(
//               stream: FirebaseFirestore.instance
//                   .collection('applications')
//                   .where("category", isEqualTo: "Assistance with animals")
//
//               //.where("volunteer_pref", arrayContainsAny: volunteer_preferencies)
//               //.where("category", arrayContainsAny: ['Accomodation', 'Transfer', 'Assistance with animals'])
//                   .where("status", isEqualTo: 'Sent to volunteer')
//
//               //.where("category", whereIn: ['Accomodation','Transfer','Assistance with animals'])
//               //.where("category", arrayContainsAny: ['Accomodation','Transfer','Assistance with animals'])
//                   .snapshots(),
//               builder: (context, AsyncSnapshot<QuerySnapshot?> streamSnapshot) {
//                 return Container(
//                   width: 450,
//                   height: 300,
//                   child: ListView.builder(
//                       scrollDirection: Axis.vertical,
//                       itemCount: streamSnapshot.data?.docs.length,
//                       itemBuilder: (ctx, index) => Column(
//                         children: [
//                           MaterialButton(
//                             onPressed: () {
//                               card_title=streamSnapshot.data?.docs[index]['title'] as String;
//                               card_category=streamSnapshot.data?.docs[index]['category'] as String;
//                               card_comment=streamSnapshot.data?.docs[index]['comment'] as String;
//                               setState(() {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                       builder: (context) => PageOfApplication()),
//                                 );
//                                 // print("print ${streamSnapshot.data?.docs[index][id]}");
//                               });
//
//                             },
//                             child: Card(
//                               child: Center(
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Column(
//                                     children: [
//                                       Text(
//                                         streamSnapshot.data?.docs[index]['title'] as String,
//                                         style: TextStyle(
//                                             fontWeight: FontWeight.bold),
//                                       ),
//                                       Text(
//                                           streamSnapshot.data?.docs[index]
//                                           ['category'] as String,
//                                           style: TextStyle(color: Colors.grey)),
//                                       Text(streamSnapshot.data?.docs[index]
//                                       ['comment'] as String),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       )),
//                 );
//               },
//             ),
//           ],
//         ),
//         ),
//       ),
//     );
//   }
// }