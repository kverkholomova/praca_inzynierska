// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:wol_pro_1/select_chatroom.dart';
// import 'package:wol_pro_1/volunteer/applications/settings_of_application.dart';
//
// class ChatRoom extends StatefulWidget {
//   const ChatRoom({Key? key}) : super(key: key);
//
//   @override
//   State<ChatRoom> createState() => _ChatRoomState();
// }
//
// class _ChatRoomState extends State<ChatRoom> {
//
//   Future<SelectedChatroom> startChatroomForUsers(List<User> users) async {
//     DocumentReference userRef = FirebaseFirestore.instance
//         .collection("USERS_COLLECTION")
//         .doc(users_chat[1]);
//     QuerySnapshot queryResults = await FirebaseFirestore.instance
//         .collection("CHATROOMS_COLLECTION")
//         .where("participants", arrayContains: userRef)
//         .get();
//     DocumentReference otherUserRef = FirebaseFirestore.instance
//         .collection("USERS_COLLECTION")
//         .doc(users_chat[0]);
//     DocumentSnapshot roomSnapshot = queryResults.docs.firstWhere((room) {
//       return room.get("participants").contains(otherUserRef);
//     });
//     if (roomSnapshot != null) {
//       return SelectedChatroom(roomSnapshot.id, users[0].displayName);
//     } else {
//       Map<String, dynamic> chatroomMap = Map<String, dynamic>();
//       chatroomMap["messages"] = List<String>(0);
//       List<DocumentReference> participants = List<DocumentReference>(2);
//       participants[0] = otherUserRef;
//       participants[1] = userRef;
//       chatroomMap["participants"] = participants;
//       DocumentReference reference = await FirebaseFirestore.instance
//           .collection("CHATROOMS_COLLECTION")
//           .add(chatroomMap);
//       DocumentSnapshot chatroomSnapshot = await reference.get();
//       return SelectedChatroom(chatroomSnapshot.id, users[0].displayName);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }
