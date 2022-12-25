// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:wol_pro_1/volunteer/applications/settings_of_application.dart';
// import 'package:wol_pro_1/volunteer/home/applications_vol.dart';
// import 'package:wol_pro_1/volunteer/home/home_vol.dart';
//
// import '../../chat_3/models/chatMessageModel.dart';
// import 'message.dart';
// class SelectedChatroom extends StatefulWidget {
//   const SelectedChatroom({Key? key}) : super(key: key);
//
//   @override
//   State<SelectedChatroom> createState() => _SelectedChatroomState();
// }
// // String id_users_col = FirebaseFirestore.instance.collection("USERS_COLLECTION").doc().id;
// class _SelectedChatroomState extends State<SelectedChatroom> {
//
//   // String id_users_col = FirebaseFirestore.instance.collection("USERS_COLLECTION").doc().id;
//
// writeMessages(){
//   FirebaseFirestore.instance.collection("USERS_COLLECTION").doc(IdOfChatroom).collection("CHATROOMS_COLLECTION").doc().set(
//     {
//       'message': message.text.trim(),
//       'time': DateTime.now(),
//       'name': current_name_Vol,
//     }
//   );
// }
//
//   final TextEditingController message = new TextEditingController();
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Container(
//               height: MediaQuery.of(context).size.height * 0.91,
//               child: messages(
//                 name: current_name_Vol,
//               ),
//             ),
//             Container(
//               width: double.infinity,
//               color: Colors.purple[200],
//               child: Row(
//                 children: [
//                   TextFormField(
//                     controller: message,
//                     decoration: InputDecoration(
//                       filled: true,
//                       fillColor: Colors.purple[100],
//                       hintText: 'message',
//                       enabled: true,
//                       contentPadding: const EdgeInsets.only(
//                           left: 14.0, bottom: 8.0, top: 8.0),
//                       focusedBorder: OutlineInputBorder(
//                         borderSide: new BorderSide(color: Colors.purple),
//                         borderRadius: new BorderRadius.circular(10),
//                       ),
//                       enabledBorder: UnderlineInputBorder(
//                         borderSide: new BorderSide(color: Colors.purple),
//                         borderRadius: new BorderRadius.circular(10),
//                       ),
//                     ),
//                     validator: (value) {
//
//                     },
//                     onSaved: (value) {
//                       message.text = value!;
//                     },
//                   ),
//                   IconButton(
//                     onPressed: () {
//                       if (message.text.isNotEmpty) {
//                         writeMessages();
//                         // FirebaseFirestore.instance.collection('').doc().set({
//                         //   'message': message.text.trim(),
//                         //   'time': DateTime.now(),
//                         //   // 'name': current_name,
//                         // });
//                         message.clear();
//                       }
//                     },
//                     icon: Icon(Icons.send_sharp),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
