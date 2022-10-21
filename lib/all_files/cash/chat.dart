//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// String? ID = FirebaseAuth.instance.currentUser?.uid;
//
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//       options: FirebaseOptions(
//         apiKey: "",
//         appId: "",
//         messagingSenderId: '',
//         projectId: "",
//       ));
//   runApp(MyApp());
// }
//
// class MyApp extends StatefulWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//   @override
//   _MyAppState createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Chat',
//       theme: ThemeData(
//         primaryColor: Colors.orange,
//       ),
//       // home: Home(),
//
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }
// // import 'package:cloud_firestore/cloud_firestore.dart';
// //
// // class ChatMessages {
// //   String idFrom;
// //   String idTo;
// //   String timestamp;
// //   String content;
// //   int type;
// //
// //   ChatMessages(
// //       {required this.idFrom,
// //         required this.idTo,
// //         required this.timestamp,
// //         required this.content,
// //         required this.type});
// //
// //   Map<String, dynamic> toJson() {
// //     return {
// //       idFrom: idFrom,
// //       idTo: idTo,
// //       timestamp: timestamp,
// //       content: content,
// //       // type: type,
// //     };
// //   }
// //
// //   factory ChatMessages.fromDocument(DocumentSnapshot documentSnapshot) {
// //     String idFrom = documentSnapshot.get("idFrom");
// //     String idTo = documentSnapshot.get("idTo");
// //     String timestamp = documentSnapshot.get("timestamp");
// //     String content = documentSnapshot.get("content");
// //     int type = documentSnapshot.get("type");
// //
// //     return ChatMessages(
// //         idFrom: idFrom,
// //         idTo: idTo,
// //         timestamp: timestamp,
// //         content: content,
// //         type: type);
// //   }
// // }
//
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:flutter/material.dart';
// // import 'package:wol_pro_1/screens/option.dart';
// //
// // class HomeChat extends StatefulWidget {
// //   const HomeChat({Key? key}) : super(key: key);
// //
// //   @override
// //   State<HomeChat> createState() => _HomeChatState();
// // }
// //
// // class _HomeChatState extends State<HomeChat> {
//
//   // Future<void> updateFirestoreData(
//   //     String collectionPath, String path, Map<String, dynamic> updateData) {
//   //   return FirebaseFirestore.instance
//   //       .collection("users")
//   //       .doc(FirebaseAuth.instance.currentUser!.uid)
//   //       .update(updateData);
//   // }
//   //
//   // Stream<QuerySnapshot> getFirestoreData(
//   //     String collectionPath, int limit, String? textSearch) {
//   //   if (textSearch?.isNotEmpty == true) {
//   //     return FirebaseFirestore.instance
//   //         .collection(collectionPath)
//   //         .limit(limit)
//   //         .where(displayName, isEqualTo: textSearch)
//   //         .snapshots();
//   //   } else {
//   //     return FirebaseFirestore.instance
//   //         .collection(collectionPath)
//   //         .limit(limit)
//   //         .snapshots();
//   //   }
//   // }
//   //
//   // Widget buildSearchBar() {
//   //   return Container(
//   //     margin:  EdgeInsets.all(10),
//   //     height: 50,
//   //     child: Row(
//   //       crossAxisAlignment: CrossAxisAlignment.center,
//   //       children: [
//   //         const SizedBox(
//   //           width: 10,
//   //         ),
//   //         const Icon(
//   //           Icons.person_search,
//   //           color: Colors.white,
//   //           size: 24,
//   //         ),
//   //         const SizedBox(
//   //           width: 5,
//   //         ),
//   //         Expanded(
//   //           child: TextFormField(
//   //             textInputAction: TextInputAction.search,
//   //             // controller: searchTextEditingController,
//   //             // onChanged: (value) {
//   //             //   if (value.isNotEmpty) {
//   //             //     buttonClearController.add(true);
//   //             //     setState(() {
//   //             //       _textSearch = value;
//   //             //     });
//   //             //   } else {
//   //             //     buttonClearController.add(false);
//   //             //     setState(() {
//   //             //       _textSearch = "";
//   //             //     });
//   //             //   }
//   //             // },
//   //             decoration: const InputDecoration.collapsed(
//   //               hintText: 'Search here...',
//   //               hintStyle: TextStyle(color: Colors.white),
//   //             ),
//   //           ),
//   //         ),
//   //         StreamBuilder(
//   //             // stream: buttonClearController.stream,
//   //             builder: (context, snapshot) {
//   //               return snapshot.data == true
//   //                   ? GestureDetector(
//   //                 onTap: () {
//   //                   // searchTextEditingController.clear();
//   //                   // buttonClearController.add(false);
//   //                   // setState(() {
//   //                   //   _textSearch = '';
//   //                   // });
//   //                 },
//   //                 child: const Icon(
//   //                   Icons.clear_rounded,
//   //                   color: Colors.grey,
//   //                   size: 20,
//   //                 ),
//   //               )
//   //                   : const SizedBox.shrink();
//   //             })
//   //       ],
//   //     ),
//   //     decoration: BoxDecoration(
//   //       borderRadius: BorderRadius.circular(30),
//   //       color: Colors.blueGrey,
//   //     ),
//   //   );
//   // }
//
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //           centerTitle: true,
// //           title: const Text('Smart Talk'),
// //           actions: [
// //
// //             IconButton(
// //                 onPressed: () {
// //                   Navigator.push(
// //                       context,
// //                       MaterialPageRoute(
// //                           builder: (context) => OptionChoose()));
// //                 },
// //                 icon: const Icon(Icons.person)),
// //           ]),);
// //   }
// // }
