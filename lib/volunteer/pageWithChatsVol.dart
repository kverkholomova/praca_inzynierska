import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wol_pro_1/Refugee/selectChatroom_Ref.dart';
import 'package:wol_pro_1/volunteer/chat/message.dart';
import 'package:wol_pro_1/volunteer/chat/select_chatroom.dart';


class ListofChatrooms extends StatefulWidget {
  const ListofChatrooms({Key? key}) : super(key: key);

  @override
  State<ListofChatrooms> createState() => _ListofChatroomsState();
}
String? IdOfChatroom = '';
List<String?> listOfRefugees = [];
class _ListofChatroomsState extends State<ListofChatrooms> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('USERS_COLLECTION')
            .where('IdVolunteer', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot?> streamSnapshot) {
          return Container(
            width: 450,
            height: 300,
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: streamSnapshot.data?.docs.length,
                itemBuilder: (ctx, index) => Column(
                  children: [
                    MaterialButton(
                      onPressed: () {
                        setState(() {
                          listOfRefugees.add(streamSnapshot.data?.docs[index]["IdRefugee"]);
                          IdOfChatroom = streamSnapshot.data?.docs[index].id;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    SelectedChatroom()),
                          );
                          // print("print ${streamSnapshot.data?.docs[index][id]}");
                        });
                      },
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              //streamSnapshot.data?.docs[index]['title']==null ?

                              Text(streamSnapshot.data?.docs[index]['IdRefugee'])

                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
          );
        },
      ),
    );
  }
}
