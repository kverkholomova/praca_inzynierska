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

import '../home_page/home_vol.dart';
import '../main_screen.dart';
import 'pageWithChatsVol.dart';

bool stopVol = false;
bool toMeVol = false;
String currentLastMsgVol = '';
String lastMessageVol = '';
bool firstChat = true;
String color = "blue";
bool changeContainerHeight = false;

class MessagesVol extends StatefulWidget {
  //
  String? name;

  MessagesVol({Key? key, required this.name}) : super(key: key);

  @override
  _MessagesVolState createState() => _MessagesVolState(name: name);
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

class _MessagesVolState extends State<MessagesVol> {
  String? name;

  _MessagesVolState({required this.name});

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
          scrollControllerVol
              .jumpTo(scrollControllerVol.positions.last.maxScrollExtent);

          controllerTabBottomVol = PersistentTabController(initialIndex: 0);
        });
        Navigator.of(context, rootNavigator: true).pushReplacement(
            MaterialPageRoute(builder: (context) => MainScreen()));
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
                color: blueColor,
              ),
              onPressed: () {
                setState(() {
                  scrollControllerVol.jumpTo(
                      scrollControllerVol.positions.last.maxScrollExtent);

                  controllerTabBottomVol =
                      PersistentTabController(initialIndex: 0);
                });
                Navigator.of(context, rootNavigator: true).pushReplacement(
                    MaterialPageRoute(builder: (context) => MainScreen()));
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

          backgroundColor: background,
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: changeContainerHeight
                      ? MediaQuery.of(context).size.height * 0.4
                      : MediaQuery.of(context).size.height * 0.75,
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("USERS_COLLECTION")
                        .doc(IdOfChatroomVol)
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
                          controller: scrollControllerVol,
                          itemCount: snapshot.data!.docs.length,
                          shrinkWrap: true,
                          itemBuilder: (_, index) {
                            snapshot.data!.docs[snapshot.data!.docs.length - 1]
                                        ["id_user"] !=
                                    FirebaseAuth.instance.currentUser!.uid
                                ? toMeVol = true
                                : toMeVol = false;
                            currentLastMsgVol = snapshot
                                    .data!.docs[snapshot.data!.docs.length - 1]
                                ["message"];

                            QueryDocumentSnapshot qs =
                                snapshot.data!.docs[index];
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
                                            : blueColor.withOpacity(0.2),
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

class SelectedChatroomVol extends StatefulWidget {
  const SelectedChatroomVol({Key? key}) : super(key: key);

  @override
  State<SelectedChatroomVol> createState() => _SelectedChatroomVolState();
}

bool? messagesNull;

class _SelectedChatroomVolState extends State<SelectedChatroomVol> {
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

  void scrollToMeVolunteer() {
    if (currentLastMsgVol != FirebaseAuth.instance.currentUser!.uid) {
      Future.delayed(const Duration(milliseconds: 200), () {
        scrollControllerVol
            .jumpTo(scrollControllerVol.positions.last.maxScrollExtent);

        lastMessageVol = currentLastMsgVol;
      });
    } else {}
  }

  void scrollToLastMessageSmall() {
    setState(() {
      changeContainerHeight = true;
    });
    Future.delayed(const Duration(milliseconds: 200), () {
      scrollControllerVol
          .jumpTo(scrollControllerVol.positions.last.maxScrollExtent);
    });
  }

  void scrollToLastMessageBig() {
    setState(() {
      changeContainerHeight = false;
    });
    Future.delayed(const Duration(milliseconds: 200), () {
      scrollControllerVol
          .jumpTo(scrollControllerVol.positions.last.maxScrollExtent);
    });
  }

  writeMessages() {
    FirebaseFirestore.instance
        .collection("USERS_COLLECTION")
        .doc(IdOfChatroomVol)
        .collection("CHATROOMS_COLLECTION")
        .doc()
        .set({
      'message': message.text.trim(),
      'time': DateTime.now(),
      'name': currentNameVol,
      'id_message': "null",
      "id_user": FirebaseAuth.instance.currentUser?.uid,
      // "user_message": true
    });
    FirebaseFirestore.instance
        .collection("USERS_COLLECTION")
        .doc(IdOfChatroomVol)
        .update({
      'last_msg': message.text.trim(),
      // "user_message": true
    });
  }

  late StreamSubscription<User?> user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (messagesNull == true) {
      FirebaseFirestore.instance
          .collection("USERS_COLLECTION")
          .doc(IdOfChatroomVol)
          .collection("CHATROOMS_COLLECTION")
          .doc()
          .set({
        'message': "Hello👋",
        'time': DateTime.now(),
        'name': currentNameVol,
        'id_message': "null",
        "id_user": FirebaseAuth.instance.currentUser?.uid,
        // "user_message": false
      });

      FirebaseFirestore.instance
          .collection("USERS_COLLECTION")
          .doc(IdOfChatroomVol)
          .update({
        'last_msg': "Hello👋",
        // "user_message": true
      });
      setState(() {
        messagesNull = false;
      });
    }
    Timer.periodic(
      const Duration(milliseconds: 200),
      (timer) {
        if (lastMessageVol != currentLastMsgVol) {
          scrollToMeVolunteer();
        }
      },
    );
    Future.delayed(const Duration(milliseconds: 200), () {
      scrollControllerVol
          .jumpTo(scrollControllerVol.positions.last.maxScrollExtent);
    });
  }

  final TextEditingController message = TextEditingController();

  @override
  Widget build(BuildContext context) {
    MediaQuery.of(context).viewInsets.bottom > 0
        ? scrollToLastMessageSmall()
        : scrollToLastMessageBig();

    return WillPopScope(
      onWillPop: () async {
        setState(() {
          controllerTabBottomVol = PersistentTabController(initialIndex: 0);
        });
        Navigator.of(context, rootNavigator: true).pushReplacement(
            MaterialPageRoute(builder: (context) => MainScreen()));
        return true;
      },
      child: GestureDetector(
        onTap: () {
          changeContainerHeight = false;
          FocusManager.instance.primaryFocus?.unfocus();
          Future.delayed(const Duration(milliseconds: 200), () {
            scrollControllerVol
                .jumpTo(scrollControllerVol.positions.last.maxScrollExtent);
          });
        },
        child: Scaffold(
          backgroundColor: background,
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: changeContainerHeight
                      ? MediaQuery.of(context).size.height * 0.54
                      : MediaQuery.of(context).size.height * 0.9,
                  child: MessagesVol(
                    name: currentName,
                  ),
                ),
                SizedBox(
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
                                    borderSide: BorderSide(color: blueColor),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: blueColor),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                validator: (value) {
                                  return null;
                                },
                                onSaved: (value) {
                                  message.text = value!;
                                },
                                onTap: () {
                                  setState(() {
                                    changeContainerHeight = true;
                                  });
                                  Future.delayed(
                                      const Duration(milliseconds: 200), () {
                                    scrollControllerVol.jumpTo(
                                        scrollControllerVol
                                            .positions.last.maxScrollExtent);
                                  });
                                },
                              ),
                            ),
                          ),
                          CircleAvatar(
                            radius: 25,
                            backgroundColor: blueColor,
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
                                      scrollControllerVol.jumpTo(
                                          scrollControllerVol
                                              .positions.last.maxScrollExtent);
                                    });
                                    message.clear();
                                  });
                                }
                              },
                              icon: Icon(
                                Icons.send_sharp,
                                color: background,
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
