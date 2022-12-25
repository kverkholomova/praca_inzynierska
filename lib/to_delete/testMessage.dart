// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:wol_pro_1/shared/loading.dart';
// import 'package:wol_pro_1/volunteer/chat/pageWithChatsVol.dart';
// import 'package:wol_pro_1/volunteer/chat/select_chatroom.dart';
// import 'package:wol_pro_1/volunteer/applications/screen_with_applications.dart';
// import 'package:wol_pro_1/volunteer/applications/settings_of_application.dart';
// import 'package:wol_pro_1/volunteer/home/home_vol.dart';
//
//
//
// final ScrollController _scrollControllerVOL = ScrollController();
// class messages extends StatefulWidget {
//   //
//   String? name;
//   messages({ required this.name});
//   @override
//   _messagesState createState() => _messagesState(name: name);
// }
// bool loading = true;
// class _messagesState extends State<messages> {
//
//   String? name;
//   _messagesState({ required this.name});
//
//   @override
//   Widget build(BuildContext context) {
//     // return isLoading() ? Loading() :StreamBuilder(
//     return Container(
//       height: 250,
//       child: StreamBuilder(
//         stream: FirebaseFirestore.instance.collection("USERS_COLLECTION").doc(IdOfChatroom).collection("CHATROOMS_COLLECTION")
//             .orderBy('time')
//             .snapshots(),
//         builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           print("SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSs");
//           print(FirebaseAuth.instance.currentUser?.uid);
//           if (!snapshot.hasData){
//             return Loading();
//           }
//           if (snapshot.hasError) {
//             return Text("Something is wrong");
//           }
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//
//           return Padding(
//             padding: const EdgeInsets.only(bottom: 0),
//             child: ListView.builder(
//               itemCount: snapshot.data!.docs.length,
//               controller: _scrollControllerVOL,
//               // physics: ScrollPhysics(),
//               shrinkWrap: true,
//               // primary: true,
//               itemBuilder: (_, index) {
//                 QueryDocumentSnapshot qs = snapshot.data!.docs[index];
//                 Timestamp t = qs['time'];
//                 DateTime d = t.toDate();
//
//                 print(d.toString());
//                 final dataKey = GlobalKey();
//                 return Padding(
//                   padding: const EdgeInsets.only(top: 8, bottom: 8),
//                   child: Column(
//                     // crossAxisAlignment: name == qs['name']
//                     //     ? CrossAxisAlignment.end
//                     //     : CrossAxisAlignment.start,
//                     children: [
//                       Container(
//                         color: snapshot.data?.docs[index]["name"] == current_name_Vol ? Colors.blue[100]:Colors.purple[100],
//                         child: ListTile(
//                           key: dataKey,
//                           shape: RoundedRectangleBorder(
//                             side: BorderSide(
//                               color: snapshot.data?.docs[index]["name"] == current_name_Vol ? Colors.blue:Colors.purple,
//                             ),
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                           title: Text(
//                             qs['name'],
//                             style: TextStyle(
//                               fontSize: 15,
//                             ),
//                           ),
//                           subtitle: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Container(
//                                 width: 200,
//                                 child: Text(
//                                   qs['message'],
//                                   softWrap: true,
//                                   style: TextStyle(
//                                     fontSize: 15,
//                                   ),
//                                 ),
//                               ),
//                               Text(
//                                 d.hour.toString() + ":" + d.minute.toString(),
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
//
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
//   writeMessages(){
//     FirebaseFirestore.instance.collection("USERS_COLLECTION").doc(IdOfChatroom).collection("CHATROOMS_COLLECTION").doc().set(
//         {
//           'message': message.text.trim(),
//           'time': DateTime.now(),
//           'name': current_name_Vol,
//         }
//     );
//   }
//
//   final TextEditingController message = new TextEditingController();
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       body: SingleChildScrollView(
//         child: Column(
//
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Container(
//               height: MediaQuery.of(context).size.height * 0.91,
//               child: messages(
//                 name: current_name_Vol,
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.only( bottom: 0),
//               child: Container(
//                 color: Colors.white,
//                 height: 60,
//                 child: Align(
//                   alignment: Alignment.center,
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: TextFormField(
//                           controller: message,
//                           decoration: InputDecoration(
//                             filled: true,
//                             fillColor: Colors.lightBlue,
//                             hintText: 'message',
//                             enabled: true,
//                             // contentPadding: const EdgeInsets.only(
//                             //     left: 14.0, bottom: 8.0, top: 8.0),
//                             focusedBorder: OutlineInputBorder(
//                               borderSide: new BorderSide(color: Colors.indigoAccent),
//                               borderRadius: new BorderRadius.circular(10),
//                             ),
//                             enabledBorder: UnderlineInputBorder(
//                               borderSide: new BorderSide(color: Colors.purple),
//                               borderRadius: new BorderRadius.circular(10),
//                             ),
//                           ),
//                           validator: (value) {
//
//                           },
//                           onSaved: (value) {
//                             message.text = value!;
//                           },
//                         ),
//                       ),
//                       IconButton(
//                         onPressed: () async {
//                           messages(name: current_name_Vol,);
//                           loading = false;
//                           await Future.delayed(const Duration(milliseconds: 500));
//                           SchedulerBinding.instance?.addPostFrameCallback((_) {
//                             _scrollControllerVOL.animateTo(
//                                 _scrollControllerVOL.position.maxScrollExtent,
//                                 // _scrollControllerVOL.position.maxScrollExtent,
//                                 duration: Duration(milliseconds: 400),
//                                 curve: Curves.fastOutSlowIn);
//                           });
//                           if (message.text.isNotEmpty) {
//                             writeMessages();
//                             // FirebaseFirestore.instance.collection('').doc().set({
//                             //   'message': message.text.trim(),
//                             //   'time': DateTime.now(),
//                             //   // 'name': current_name,
//                             // });
//                             message.clear();
//                           }
//                         },
//                         icon: Icon(Icons.send_sharp),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }