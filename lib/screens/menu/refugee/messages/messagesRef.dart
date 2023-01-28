import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:wol_pro_1/app.dart';
import 'package:wol_pro_1/constants.dart';
import 'package:wol_pro_1/screens/menu/refugee/home_page/home_ref.dart';
import 'package:wol_pro_1/screens/menu/refugee/main_screen_ref.dart';
import 'package:wol_pro_1/screens/menu/refugee/messages/pageWithChatsRef.dart';

bool stop = false;
double indexMessage = 0;
double ind = 0;
bool toMe = false;
String currentLastMsg = '';
String lastMessage = '';
bool firstChat = true;
String color = "red";
bool changeContainerHeightRefugee = false;

class MessagesRef extends StatefulWidget {
  //
  String? name;

  MessagesRef({Key? key, required this.name}) : super(key: key);

  @override
  _MessagesRefState createState() => _MessagesRefState(name: name);
}

bool loading = true;

double myMessageLeftVol(String idReceiver) {
  if (idReceiver != FirebaseAuth.instance.currentUser?.uid) {
    return 5;
  } else {
    return 40;
  }
}

double myMessageRightVol(String idReceiver) {
  if (idReceiver == FirebaseAuth.instance.currentUser?.uid) {
    return 5;
  } else {
    return 40;
  }
}

class _MessagesRefState extends State<MessagesRef> {
  String? name;

  _MessagesRefState({required this.name});

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // return isLoading() ? Loading() :StreamBuilder(
    return WillPopScope(
      onWillPop: () async {
        setState(() {
          scrollControllerRef
              .jumpTo(scrollControllerRef.positions.last.maxScrollExtent);

          controllerTabBottomRef = PersistentTabController(initialIndex: 0);
        });
        Navigator.of(context, rootNavigator: true).pushReplacement(
            MaterialPageRoute(builder: (context) => MainScreenRefugee()));
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 30,
                color: redColor,
              ),
              onPressed: () {
                setState(() {
                  scrollControllerRef.jumpTo(
                      scrollControllerRef.positions.last.maxScrollExtent);

                  controllerTabBottomRef =
                      PersistentTabController(initialIndex: 0);
                });
                Navigator.of(context, rootNavigator: true).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) => MainScreenRefugee()));
              },
            ),
            title: Align(
              alignment: Alignment.topLeft,
              child: Text(
                ("Messages"),
                style: GoogleFonts.raleway(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          // resizeToAvoidBottomInset: false,

          backgroundColor: backgroundRefugee,
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: changeContainerHeightRefugee
                      ? MediaQuery.of(context).size.height * 0.4
                      : MediaQuery.of(context).size.height * 0.75,
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("USERS_COLLECTION")
                        .doc(iIdOfChatroomRef)
                        .collection("CHATROOMS_COLLECTION")
                        .orderBy('time')
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center();
                      }

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 0),
                        child: ListView.builder(
                          controller: scrollControllerRef,
                          itemCount: snapshot.data!.docs.length,
                          shrinkWrap: true,
                          itemBuilder: (_, index) {
                            indexMessage = snapshot.data!.docs.length - 1;

                            snapshot.data!.docs[snapshot.data!.docs.length - 1]
                                        ["id_user"] !=
                                    FirebaseAuth.instance.currentUser!.uid
                                ? toMe = true
                                : toMe = false;
                            currentLastMsg = snapshot
                                    .data!.docs[snapshot.data!.docs.length - 1]
                                ["message"];

                            QueryDocumentSnapshot qs =
                                snapshot.data!.docs[index];
                            Timestamp t = qs['time'];
                            DateTime d = t.toDate();
                            final dataKey = GlobalKey();
                            return Padding(
                              padding: EdgeInsets.only(
                                  top: 8,
                                  bottom: 8,
                                  left:
                                      // 40,
                                      myMessageLeftVol(snapshot
                                          .data?.docs[index]["id_user"]),
                                  right: myMessageRightVol(
                                      snapshot.data?.docs[index]["id_user"])),
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: snapshot.data?.docs[index]
                                                    ["id_user"] ==
                                                FirebaseAuth
                                                    .instance.currentUser?.uid
                                            ? Colors.white
                                            : redColor.withOpacity(0.2),
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10))),
                                    // width: 300,

                                    child: ListTile(
                                      key: dataKey,
                                      title: Text(
                                        qs['name'],
                                        style: const TextStyle(
                                          fontSize: 15,
                                        ),
                                      ),
                                      subtitle: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            width: 200,
                                            child: Text(
                                              qs['message'],
                                              softWrap: true,
                                              style: const TextStyle(
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            DateTime.now()
                                                .toString()
                                                .substring(10, 16),
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SelectedChatroomRef extends StatefulWidget {
  const SelectedChatroomRef({Key? key}) : super(key: key);

  @override
  State<SelectedChatroomRef> createState() => _SelectedChatroomRefState();
}

bool? messagesNull;

// String id_users_col = FirebaseFirestore.instance.collection("USERS_COLLECTION").doc().id;
class _SelectedChatroomRefState extends State<SelectedChatroomRef> {
  Position? currentPosition;

  void getCurrentLocation() {
    Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    ).then((Position position) {
      setState(() {
        currentPosition = position;
      });
    }).catchError((e) {
      print(e);
    });
  }

  writeMessages() {
    lastMessage = message.text.trim();
    FirebaseFirestore.instance
        .collection("USERS_COLLECTION")
        .doc(iIdOfChatroomRef)
        .collection("CHATROOMS_COLLECTION")
        .doc()
        .set({
      'message': message.text.trim(),
      'time': DateTime.now(),
      'name': currentNameRef,
      'id_message': "null",
      "id_user": FirebaseAuth.instance.currentUser?.uid,

      // "user_message": true
    });
    FirebaseFirestore.instance
        .collection("USERS_COLLECTION")
        .doc(iIdOfChatroomRef)
        .update({
      'last_msg': message.text.trim(),
      // "user_message": true
    });
  }

  late StreamSubscription<User?> user;

  void scrollToMe() {
    if (currentLastMsg != FirebaseAuth.instance.currentUser!.uid) {
      Future.delayed(const Duration(milliseconds: 200), () {
        scrollControllerRef
            .jumpTo(scrollControllerRef.positions.last.maxScrollExtent);

        lastMessage = currentLastMsg;
      });
    } else {}
  }

  void scrollToLastMessageSmall() {
    setState(() {
      changeContainerHeightRefugee = true;
    });
    Future.delayed(const Duration(milliseconds: 200), () {
      scrollControllerRef
          .jumpTo(scrollControllerRef.positions.last.maxScrollExtent);
    });
  }

  void scrollToLastMessageBig() {
    setState(() {
      changeContainerHeightRefugee = false;
    });
    Future.delayed(const Duration(milliseconds: 200), () {
      scrollControllerRef
          .jumpTo(scrollControllerRef.positions.last.maxScrollExtent);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Timer.periodic(
      const Duration(milliseconds: 200),
      (timer) {
        if (lastMessage != currentLastMsg) {
          scrollToMe();
        }
      },
    );
    Future.delayed(const Duration(milliseconds: 200), () {
      scrollControllerRef
          .jumpTo(scrollControllerRef.positions.last.maxScrollExtent);
    });
  }

  final TextEditingController message = TextEditingController();

  @override
  Widget build(BuildContext context) {
    MediaQuery.of(context).viewInsets.bottom > 0
        ? scrollToLastMessageSmall()
        : scrollToLastMessageBig();
    MediaQuery.of(context).viewInsets.bottom == 0
        ? print("No keyboard ${MediaQuery.of(context).viewInsets.bottom}")
        : print(MediaQuery.of(context).viewInsets.bottom);
    return WillPopScope(
      onWillPop: () async {
        setState(() {
          controllerTabBottomRef = PersistentTabController(initialIndex: 0);
        });
        Navigator.of(context, rootNavigator: true).pushReplacement(
            MaterialPageRoute(builder: (context) => MainScreenRefugee()));
        return true;
      },
      child: GestureDetector(
        onTap: () {
          changeContainerHeightRefugee = false;
          FocusManager.instance.primaryFocus?.unfocus();
          Future.delayed(const Duration(milliseconds: 200), () {
            scrollControllerRef
                .jumpTo(scrollControllerRef.positions.last.maxScrollExtent);
          });
        },
        child: Scaffold(
          backgroundColor: backgroundRefugee,
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).viewInsets.bottom > 0
                      ? MediaQuery.of(context).size.height * 0.54
                      : MediaQuery.of(context).size.height * 0.9,
                  child: MessagesRef(
                    name: currentName,
                  ),
                ),
                SizedBox(
                  // color: background,
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: padding,
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: TextFormField(
                                controller: message,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: 'Message',
                                  enabled: true,
                                  contentPadding: const EdgeInsets.only(
                                      left: 14.0, bottom: 8.0, top: 8.0),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: redColor),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: redColor),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                // validator: (value) {},
                                onSaved: (value) {
                                  message.text = value!;
                                },
                              ),
                            ),
                          ),
                          CircleAvatar(
                            radius: 25,
                            backgroundColor: redColor,
                            child: IconButton(
                              onPressed: () async {
                                if (message.text.isNotEmpty) {
                                  setState(() {
                                    writeMessages();
                                  });

                                  await Future.delayed(
                                      const Duration(milliseconds: 200), () {
                                    messagesNull = false;
                                    SchedulerBinding.instance
                                        .addPostFrameCallback((_) {
                                      scrollControllerRef.jumpTo(
                                          scrollControllerRef
                                              .positions.last.maxScrollExtent);
                                    });
                                    message.clear();
                                  });
                                }
                              },
                              icon: Icon(
                                Icons.send_sharp,
                                color: backgroundRefugee,
                              ),
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
      ),
    );
  }
}
