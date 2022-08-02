import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wol_pro_1/Refugee/selectChatroom_Ref.dart';

import 'SettingRefugee.dart';
import 'applications/all_applications.dart';
import 'messages_ref.dart';

class ListofChatroomsRef extends StatefulWidget {
  const ListofChatroomsRef({Key? key}) : super(key: key);

  @override
  State<ListofChatroomsRef> createState() => _ListofChatroomsRefState();
}
String? IdOfChatroomRef = '';
List<String?> listOfVolunteers = [];
class _ListofChatroomsRefState extends State<ListofChatroomsRef> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SettingsHomeRef()),
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
                MaterialPageRoute(builder: (context) => SettingsHomeRef()),
              );
            },
          ),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('USERS_COLLECTION')
              .where('IdRefugee', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot?> streamSnapshot) {
            return Container(
              height: double.infinity,
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: streamSnapshot.data?.docs.length,
                  itemBuilder: (ctx, index) =>
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          MaterialButton(
                            onPressed: () {
                              setState(() {
                                listOfVolunteers.add(streamSnapshot.data?.docs[index]["IdVolunteer"]);
                                IdOfChatroomRef = streamSnapshot.data?.docs[index]["chatId"];
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SelectedChatroom_Ref()),
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
                                          child: Text(streamSnapshot.data?.docs[index]['Volunteer_Name'],style: TextStyle(fontSize: 18),),
                                        ),
                                      )
                                      // StreamBuilder(
                                      //     stream: FirebaseFirestore.instance
                                      //         .collection('users')
                                      //         .where('id_vol',
                                      //             arrayContains: listOfVolunteers)
                                      //         .snapshots(),
                                      //     builder: (context,
                                      //         AsyncSnapshot<QuerySnapshot?>
                                      //             streamSnapshot) {
                                      //       return Container(
                                      //           width: 450,
                                      //           height: 300,
                                      //           child: ListView.builder(
                                      //               scrollDirection: Axis.vertical,
                                      //               itemCount: streamSnapshot
                                      //                   .data?.docs.length,
                                      //               itemBuilder: (ctx, index) =>
                                      //                   Column(children: [])));
                                      //     })
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
      ),
    );
  }
}
