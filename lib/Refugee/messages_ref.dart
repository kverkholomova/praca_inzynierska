import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';
import 'package:wol_pro_1/Refugee/pageWithChats.dart';

import 'SettingRefugee.dart';
final ScrollController _scrollControllerRef = ScrollController();
// bool _needsScroll = false;
class messagesRef extends StatefulWidget {
  //
  String? name;
  messagesRef({ required this.name});
  @override
  _messagesRefState createState() => _messagesRefState(name: name);
}

double myMessageLeftRef(String name_receiver){
  if (name_receiver == current_name_Ref){
    return 40;
  }
  else{
    return 5;
  }
}

double myMessageRightRef(String name_receiver){
  if (name_receiver == current_name_Ref){
    return 5;
  }
  else{
    return 40;
  }
}
class _messagesRefState extends State<messagesRef> {

  //
  // _scrollToEnd() async {
  //   _scrollController.animateTo(
  //       _scrollController.position.maxScrollExtent,  duration: Duration(milliseconds: 200),
  //       curve: Curves.easeInOut);
  // }
  String? name;
  _messagesRefState({ required this.name});
  //
  // Stream<QuerySnapshot> _messageStream = FirebaseFirestore.instance
  //     .collection('Messages')
  //     // .where("id_of_adressee", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
  //     .orderBy('time')
  //     .snapshots();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      child: StreamBuilder(
        stream: FirebaseFirestore.instance.collection("USERS_COLLECTION").doc(IdOfChatroomRef).collection("CHATROOMS_COLLECTION")
            .orderBy('time')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          print("SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSs");
          print(FirebaseAuth.instance.currentUser?.uid);

          if (snapshot.hasError) {
            return Text("Something is wrong");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return Padding(
            padding: const EdgeInsets.only(bottom: 0),
            child: ListView.builder(
              controller: _scrollControllerRef,
              itemCount: snapshot.data!.docs.length,
              // physics: ScrollPhysics(),
              shrinkWrap: true,
              // reverse: true,
              // primary: true,
              itemBuilder: (_, index) {

                QueryDocumentSnapshot qs = snapshot.data!.docs[index];
                Timestamp t = qs['time'];
                DateTime d = t.toDate();

                print(d.toString());

                final dataKeyRef = GlobalKey();
                // if (_needsScroll) {
                //   _scrollToEnd();
                //   _needsScroll = false;
                // }
                return Padding(
                  padding: EdgeInsets.only(top: 8, bottom: 8, left: myMessageLeftRef(snapshot.data?.docs[index]["name"]), right: myMessageRightRef(snapshot.data?.docs[index]["name"])),
                  child: Column(
                    // crossAxisAlignment: name == qs['name']
                    //     ? CrossAxisAlignment.end
                    //     : CrossAxisAlignment.start,
                    children: [
                      Container(

                        decoration: new BoxDecoration(
                            color: snapshot.data?.docs[index]["name"] == current_name_Ref ? Colors.purple[100]:Colors.blue[100],
                            borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                        child: ListTile(
                          key: dataKeyRef,
                          // shape: RoundedRectangleBorder(
                          //   side: BorderSide(
                          //     color: snapshot.data?.docs[index]["name"] == current_name_Ref ? Colors.purple:Colors.blue,
                          //   ),
                          //   borderRadius: BorderRadius.circular(10),
                          // ),
                          title: Text(
                            qs['name'],
                            style: TextStyle(
                              fontSize: 15,
                            ),
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 200,
                                child: Text(
                                  qs['message'],
                                  softWrap: true,
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                              Text(
                                d.hour.toString() + ":" + d.minute.toString(),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class SelectedChatroom_Ref extends StatefulWidget {
  const SelectedChatroom_Ref({Key? key}) : super(key: key);

  @override
  State<SelectedChatroom_Ref> createState() => _SelectedChatroom_RefState();
}
// String id_users_col = FirebaseFirestore.instance.collection("USERS_COLLECTION").doc().id;
class _SelectedChatroom_RefState extends State<SelectedChatroom_Ref> {

  // String id_users_col = FirebaseFirestore.instance.collection("USERS_COLLECTION").doc().id;

  writeMessages(){
    FirebaseFirestore.instance.collection("USERS_COLLECTION").doc(IdOfChatroomRef).collection("CHATROOMS_COLLECTION").doc().set(
        {
          'message': message_ref.text.trim(),
          'time': DateTime.now(),
          'name': current_name_Ref,
          'id_message': "null"
        }
    );
  }

  final TextEditingController message_ref = new TextEditingController();



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {

          _scrollControllerRef.jumpTo(
              _scrollControllerRef.positions.last.maxScrollExtent);
          // duration: Duration(milliseconds: 400),
          // curve: Curves.fastOutSlowIn);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ListofChatroomsRef()),
        );
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(

                height: MediaQuery.of(context).size.height * 0.91,
                child: messagesRef(
                  name: current_name_Ref,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 0),
                child: Container(
                  color: Colors.white,
                  height: 60,
                  child: Align(
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: TextFormField(
                              controller: message_ref,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'Message',
                                enabled: true,
                                contentPadding: const EdgeInsets.only(
                                    left: 14.0, bottom: 8.0, top: 8.0),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: new BorderSide(color: Colors.purple),
                                  borderRadius: new BorderRadius.circular(10),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: new BorderSide(color: Colors.purple),
                                  borderRadius: new BorderRadius.circular(10),
                                ),
                              ),
                              validator: (value) {

                              },
                              onSaved: (value) {
                                message_ref.text = value!;
                              },
                            ),
                          ),
                        ),
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.purple[500],
                          child: IconButton(
                            onPressed: () async {
                              // messagesRef(name: current_name_Ref,);

                              // _scrollController.position.maxScrollExtent;
                              // _scrollController.animateTo(
                              //   0.0,
                              //   curve: Curves.easeOut,
                              //   duration: const Duration(milliseconds: 300),
                              // );
                              // _scrollController;
                              if (message_ref.text.isNotEmpty) {
                                writeMessages();
                                // Timer(Duration(milliseconds: 500), () {
                                //   _scrollControllerRef.jumpTo(_scrollControllerRef.position.maxScrollExtent);
                                // });
                                await Future.delayed(Duration(milliseconds: 500));
                                SchedulerBinding.instance?.addPostFrameCallback((_) {
                                  print("works");
                                  _scrollControllerRef.jumpTo(
                                      _scrollControllerRef.positions.last.maxScrollExtent);
                                      // duration: Duration(milliseconds: 400),
                                      // curve: Curves.fastOutSlowIn);
                                });


                                // FirebaseFirestore.instance.collection('').doc().set({
                                //   'message': message.text.trim(),
                                //   'time': DateTime.now(),
                                //   // 'name': current_name,
                                // });
                                message_ref.clear();
                              }
                            },
                            icon: Icon(Icons.send_sharp, color: Colors.white,),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
