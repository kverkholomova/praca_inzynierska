import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wol_pro_1/volunteer/chat/message.dart';

import 'package:wol_pro_1/volunteer/chat/messagesVol.dart';
import 'package:wol_pro_1/volunteer/home/settings_home_vol.dart';

import '../../Refugee/SettingRefugee.dart';




class ListofChatroomsVol extends StatefulWidget {
  const ListofChatroomsVol({Key? key}) : super(key: key);

  @override
  State<ListofChatroomsVol> createState() => _ListofChatroomsVolState();
}
String? IdOfChatroomVol = '';
List<String?> listOfRefugeesVol_ = [];
class _ListofChatroomsVolState extends State<ListofChatroomsVol> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SettingsHomeVol()),
        );
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Chats'),
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
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('USERS_COLLECTION')
              .where('IdVolunteer', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot?> streamSnapshot) {
            return Container(

              height: double.infinity,
              child: ListView.builder(

                shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: !streamSnapshot.hasData? 1:streamSnapshot.data?.docs.length,
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
                        mainAxisSize: MainAxisSize.max,
                    children: [
                      MaterialButton(
                        onPressed: () {
                          setState(() {
                            listOfRefugeesVol_.add(streamSnapshot.data?.docs[index]["IdRefugee"]);
                            IdOfChatroomVol = streamSnapshot.data?.docs[index]["chatId"];

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      SelectedChatroomVol()),
                            );
                            // print("print ${streamSnapshot.data?.docs[index][id]}");
                          });
                        },
                        child: SizedBox(
                          width: 300,
                          child: Card(

                            child: Padding(
                              padding: const EdgeInsets.only(top: 8,bottom: 8),
                              child: Stack(
                                children: [
                                  //streamSnapshot.data?.docs[index]['title']==null ?

                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: CircleAvatar(
                                        radius: 25,
                                        backgroundColor: Colors.lightBlue,
                                      ),
                                    ),
                                  ),

                                  Align(
                                    alignment: Alignment.centerLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 23, left: 70,bottom: 8,),
                                        child: Text(streamSnapshot.data?.docs[index]['Refugee_Name'], style: TextStyle(fontSize: 18),),
                                      )),

                                  // StreamBuilder(
                                  //   stream: FirebaseFirestore.instance
                                  //       .collection('USERS_COLLECTION')
                                  //       .doc()
                                  //       .collection("CHATROOMS_COLLECTION")
                                  //       // .where(field)
                                  //
                                  //       .where('chatId', isEqualTo: IdOfChatroomVol)
                                  //       .where('time', isGreaterThan: FirebaseFirestore.instance
                                  //       .collection('USERS_COLLECTION')
                                  //       .doc()
                                  //       .collection("CHATROOMS_COLLECTION")
                                  //       .where('chatId', isEqualTo: IdOfChatroomVol))
                                  //       .snapshots(),
                                  //   builder: (context, AsyncSnapshot<QuerySnapshot?> streamSnapshot) {
                                  //     return Container(
                                  //
                                  //       height: double.infinity,
                                  //       child: ListView.builder(
                                  //
                                  //           shrinkWrap: true,
                                  //           scrollDirection: Axis.vertical,
                                  //           itemCount: streamSnapshot.data?.docs.length,
                                  //           itemBuilder: (ctx, index) =>
                                  //               Column(
                                  //                 mainAxisSize: MainAxisSize.max,
                                  //                 children: [
                                  //                   Padding(
                                  //                     padding: const EdgeInsets.all(8.0),
                                  //                     child: Align(
                                  //                       alignment: Alignment.topLeft,
                                  //                       child: Text(streamSnapshot.data?.docs[index]['message'], style: TextStyle(fontSize: 16),
                                  //                       ),
                                  //                     ),
                                  //                   ),
                                  //
                                  //                 ],
                                  //               )),
                                  //     );
                                  //   },
                                  // ),

                                  // Align(
                                  //     alignment: Alignment.centerLeft,
                                  //     child: Padding(
                                  //       padding: const EdgeInsets.only(top: 8, left: 70,bottom: 8,),
                                  //       child: Text(last_message!, style: TextStyle(fontSize: 16),),
                                  //     )
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        ),
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
                }),
            );
          },
        ),
      ),
    );
  }
}