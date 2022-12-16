//
//
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:wol_pro_1/screens/menu/refugee/all_applications/application_info_accepted.dart';
//
//
//
// class PageOfVolunteerRef extends StatefulWidget {
//   const PageOfVolunteerRef({Key? key}) : super(key: key);
//
//   @override
//   State<PageOfVolunteerRef> createState() => _PageOfVolunteerRefState();
// }
//
//
// class _PageOfVolunteerRefState extends State<PageOfVolunteerRef> {
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Color.fromRGBO(49, 72, 103, 0.8),
//         elevation: 0.0,
//         title: Text('Application Info',style: TextStyle(fontSize: 16),),
//
//       ),
//       body: Container(
//         color: Color.fromRGBO(234, 191, 213, 0.8),
//         child: StreamBuilder(
//           stream: FirebaseFirestore.instance
//               .collection('users')
//               .where('id_vol', isEqualTo: IDVolOfApplication)
//               .snapshots(),
//
//           builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
//             return ListView.builder(
//                 itemCount: streamSnapshot.data?.docs.length,
//                 itemBuilder: (ctx, index) =>
//                     Column(
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.only(top: 30),
//                           child: Text(
//                             streamSnapshot.data?.docs[index]['user_name'],
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,fontSize: 16,color: Colors.black,),textAlign: TextAlign.center,
//                           ),
//
//                         ),
//
//                         Text(
//                           streamSnapshot.data?.docs[index]['phone_number'],
//                           style: TextStyle(color: Colors.grey,fontSize: 14),textAlign: TextAlign.center,),
//
//                         // Text(
//                         //   streamSnapshot.data?.docs[index]['date'],
//                         //   style: TextStyle(color: Colors.grey,fontSize: 14),textAlign: TextAlign.center,),
//
//                       ],
//                     ));
//           },
//         ),
//       ),
//
//     );
//   }
// }