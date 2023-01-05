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
import 'package:wol_pro_1/screens/menu/volunteer/my_applications/settings_of_application.dart';

import '../../volunteer/messages/pageWithChatsVol.dart';

bool stop = false;
 double index_message = 0;
 double ind =0;
bool toMe = false;
String currentLastMsg = '';
String last_message='';
bool firstChat = true;
String color = "red";
bool changeContainerHeightRefugee = false;
class MessagesRef extends StatefulWidget {
  //
  String? name;

  MessagesRef({required this.name});

  @override
  _MessagesRefState createState() => _MessagesRefState(name: name);
}

bool loading = true;

double myMessageLeftVol(String id_receiver) {
  if (id_receiver != FirebaseAuth.instance.currentUser?.uid) {
    print("id_receiver != FirebaseAuth.instance.currentUser?.uid");
    print(id_receiver);
    print(FirebaseAuth.instance.currentUser?.uid);
    return 5;
  } else {
    print("id_receiver != FirebaseAuth.instance.currentUser?.uid");
    print(id_receiver != FirebaseAuth.instance.currentUser?.uid);
    print(id_receiver);
    print(FirebaseAuth.instance.currentUser?.uid);
    return 40;
  }
}

double myMessageRightVol(String id_receiver) {
  if (id_receiver == FirebaseAuth.instance.currentUser?.uid) {
    print("id_receiver == FirebaseAuth.instance.currentUser?.uid");
    print(id_receiver);
    print(FirebaseAuth.instance.currentUser?.uid);
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
    // Timer.periodic(Duration(seconds: 5), (timer) {
    //
    //
    //   // SchedulerBinding.instance
    //   //     ?.addPostFrameCallback((_) {
    //   //   print("AAAAAAAAAAA__________________works");
    //   //   scrollControllerRef.jumpTo(scrollControllerRef.positions.last.maxScrollExtent);
    //   //   // duration: Duration(milliseconds: 400),
    //   //   // curve: Curves.fastOutSlowIn);
    //   // });
    // });

  }
  //
  // Stream<QuerySnapshot> _messageStream = FirebaseFirestore.instance
  //     .collection('Messages')
  //     // .where("id_of_adressee", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
  //     .orderBy('time')
  //     .snapshots();
  @override
  Widget build(BuildContext context) {
    // return isLoading() ? Loading() :StreamBuilder(
    return WillPopScope(
      onWillPop: () async {
        setState(() {
          scrollControllerRef.jumpTo(scrollControllerRef.positions.last.maxScrollExtent);


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

                  scrollControllerRef.jumpTo(scrollControllerRef.positions.last.maxScrollExtent);

                  controllerTabBottomRef = PersistentTabController(initialIndex: 0);
                });
                Navigator.of(context, rootNavigator: true).pushReplacement(
                    MaterialPageRoute(builder: (context) => MainScreenRefugee()));
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
                  height: changeContainerHeightRefugee?MediaQuery.of(context).size.height * 0.4: MediaQuery.of(context).size.height * 0.75,
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("USERS_COLLECTION")
                        .doc(IdOfChatroomRef)
                        .collection("CHATROOMS_COLLECTION")

                        .orderBy('time')
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {

                      // print(
                      //     "SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSs");
                      // print(FirebaseAuth.instance.currentUser?.uid);
                      //
                      // if (snapshot.hasError) {
                      //   return Text("Something is wrong");
                      // }
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 0),
                        child: ListView.builder(
                          controller: scrollControllerRef,
                          itemCount: snapshot.data!.docs.length,
                          // physics: NeverScrollableScrollPhysics(),

                          // physics: ScrollPhysics(),
                          shrinkWrap: true,
                          // primary: true,
                          itemBuilder: (_, index) {
                            index_message =  snapshot.data!.docs.length-1;

                            snapshot.data!.docs[snapshot.data!.docs.length-1]["id_user"]!=FirebaseAuth.instance.currentUser!.uid?toMe=true:toMe=false;
                            // currentLastMsg = snapshot.data!.docs[snapshot.data!.docs.length-1]["message"];
                            currentLastMsg = snapshot.data!.docs[snapshot.data!.docs.length-1]["id_user"];
                            print("Message laaaaaaaaaaaast");

                            print(currentLastMsg);
                            print(toMe);
                            print(index_message);

                            QueryDocumentSnapshot qs =
                            snapshot.data!.docs[index];
                            Timestamp t = qs['time'];
                            DateTime d = t.toDate();
                            print(d.toString());
                            final dataKey = GlobalKey();
                            return Padding(
                              padding: EdgeInsets.only(
                                  top: 8,
                                  bottom: 8,
                                  left:
                                  // 40,
                                  myMessageLeftVol(
                                      snapshot.data?.docs[index]["id_user"]),
                                  right: myMessageRightVol(snapshot
                                      .data?.docs[index]["id_user"])),
                              child: Column(
                                // crossAxisAlignment: name == qs['name']
                                //     ? CrossAxisAlignment.end
                                //     : CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: new BoxDecoration(
                                        color: snapshot.data?.docs[index]
                                        ["id_user"] ==
                                            FirebaseAuth.instance.currentUser?.uid
                                            ? Colors.white
                                            : redColor.withOpacity(0.2),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    // width: 300,

                                    child: ListTile(
                                      key: dataKey,
                                      // shape: RoundedRectangleBorder(
                                      //   side: BorderSide(
                                      //     color: snapshot.data?.docs[index]["name"] == current_name_Vol ? Colors.blue:Colors.purple,
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
                                        mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
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
                                            DateTime.now().toString().substring(10,16),
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
  // String id_users_col = FirebaseFirestore.instance.collection("USERS_COLLECTION").doc().id;

  Position? currentPosition;
  void getCurrentLocation() {
    Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best,
    ).then((Position position) {
      setState(() {
        currentPosition = position;
        print("Current positioooooooon");
        print(currentPosition);
      });
    }).catchError((e) {
      print(e);
    });
  }

  //  void share(){
  //   Share.share('https://www.google.com/maps/search/?api=1&query=${currentPosition?.latitude},${currentPosition?.longitude}');
  // }
  // void checkCurrentPosition() {
  //   if (_currentPosition != null) {
  //     markers.add(Marker(
  //         markerId: const MarkerId('Home'),
  //         icon: BitmapDescriptor.defaultMarkerWithHue(
  //           BitmapDescriptor.hueAzure,
  //         ),
  //         position: LatLng(_currentPosition?.latitude ?? 0.0,
  //             _currentPosition?.longitude ?? 0.0)));
  //     mapController
  //         ?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
  //       target: LatLng(_currentPosition?.latitude ?? 0.0,
  //           _currentPosition?.longitude ?? 0.0),
  //       zoom: 15.0,
  //     )));
  //   }
  // }

  writeMessages() {
    last_message= message.text.trim();
    FirebaseFirestore.instance
        .collection("USERS_COLLECTION")
        .doc(IdOfChatroomRef)
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
        .doc(IdOfChatroomRef)
        .update({
      'last_msg': message.text.trim(),
      // "user_message": true
    });
  }

  late StreamSubscription<User?> user;

  void scrollToMe (){
    if(currentLastMsg!=FirebaseAuth.instance.currentUser!.uid){
      print("tomeeeeeeee");
      Future.delayed(const Duration(milliseconds: 200), () {
        print("tomeeeeeeee scrooooll");
        scrollControllerRef.jumpTo(scrollControllerRef.positions.last.maxScrollExtent);

        // print("indddddddeeeeeeeeeeeex");
        // print(index_message);
        // print(ind = index_message+1);

        // setState(() {
        //   toMe = false;
        // });
        // currentLastMsg = 'null';
      });
      // setState(() {
      //   toMe = false;
      // });
      // setState(() {
      //   stop= true;
      // });
    }else{
      print("fromm meeeeeeeeee");

    }
  }

  void scrollToLastMessageSmall(){
    setState(() {
      changeContainerHeightRefugee = true;
    });
    Future.delayed(const Duration(milliseconds: 200), () {
      print(DateTime.now());
      // SchedulerBinding.instance
      //     ?.addPostFrameCallback((_) {
      //   print("AAAAAAAAAAA__________________works");
      scrollControllerRef.jumpTo(scrollControllerRef.positions.last.maxScrollExtent);
      // duration: Duration(milliseconds: 400),
      // curve: Curves.fastOutSlowIn);
      // });
    });
  }

  void scrollToLastMessageBig(){
    setState(() {
      changeContainerHeightRefugee = false;
    });
    Future.delayed(const Duration(milliseconds: 200), () {
      print(DateTime.now());
      // SchedulerBinding.instance
      //     ?.addPostFrameCallback((_) {
      //   print("AAAAAAAAAAA__________________works");
      scrollControllerRef.jumpTo(scrollControllerRef.positions.last.maxScrollExtent);
      // duration: Duration(milliseconds: 400),
      // curve: Curves.fastOutSlowIn);
      // });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Timer.periodic(
      const Duration(milliseconds: 500),
          (timer) {
        scrollToMe();
        // if(index_message){
        //   scrollToMe();
        // } else{
        //   print("do not move");
        // }

        print("scroolled");

        // Update user about remaining time
      },
    );
    Future.delayed(const Duration(milliseconds: 200), () {
      print(DateTime.now());
      // SchedulerBinding.instance
      //     ?.addPostFrameCallback((_) {
      //   print("AAAAAAAAAAA__________________works");
      scrollControllerRef.jumpTo(scrollControllerRef.positions.last.maxScrollExtent);
      // duration: Duration(milliseconds: 400),
      // curve: Curves.fastOutSlowIn);
      // });
    });

    // user = FirebaseAuth.instance.authStateChanges().listen((user) async {
    //   DocumentSnapshot variable = await FirebaseFirestore.instance.
    //   collection("USERS_COLLECTION")
    //       .doc(IdOfChatroomVol)
    //       .collection("CHATROOMS_COLLECTION")
    //       .doc().
    //   get();
    //
    //   print("OOOOOOOOOOOOOOHHHHHHHHHELP");
    //   print(variable == null);
    //
    // });
  }
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //
  //   SchedulerBinding.instance
  //       .addPostFrameCallback((_) {
  //     print("AAAAAAAAAAA__________________works");
  //     scrollControllerVol.jumpTo(scrollControllerVol.positions.last.maxScrollExtent);
  // });
  // }
  final TextEditingController message = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    // scrollToMe();
      // scrollControllerRef.jumpTo(scrollControllerVol.positions.last.maxScrollExtent);

   // print("Messageeeeeeeeees teeeeeeeest ");
   // print(last_message);
   // print(currentLastMsg);
   // print(toMe);
   // last_message!=currentLastMsg?scrollToMe():null;
   // scrollToMe();
   //  setState(() {
   //    scrollToMe();
   //  });
    MediaQuery.of(context).viewInsets.bottom>0?scrollToLastMessageSmall():scrollToLastMessageBig();
    MediaQuery.of(context).viewInsets.bottom==0?print("No keyboard ${MediaQuery.of(context).viewInsets.bottom}"):
    print(MediaQuery.of(context).viewInsets.bottom);
    print("keyboard");
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
            print(DateTime.now());

            scrollControllerRef.jumpTo(scrollControllerRef.positions.last.maxScrollExtent);

          });
        },
        child: Scaffold(
          backgroundColor: backgroundRefugee,
          // resizeToAvoidBottomInset: true,
          // floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
          // floatingActionButton: IconButton(
          //   icon: Icon(
          //     Icons.arrow_back_ios_new_rounded,
          //     size: 30,
          //     color: blueColor,
          //   ),
          //   onPressed: () {
          //     setState(() {
          //       controllerTabBottomVol = PersistentTabController(initialIndex: 0);
          //     });
          //     Navigator.of(context, rootNavigator: true).pushReplacement(
          //         MaterialPageRoute(builder: (context) => MainScreen()));
          //   },
          // ),
          // floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
          // floatingActionButton: IconButton(
          //   icon: Icon(
          //     Icons.arrow_back_ios_new_rounded,
          //     size: 30,
          //     color: blueColor,
          //   ),
          //   onPressed: () {
          //     setState(() {
          //       controllerTabBottom = PersistentTabController(initialIndex: 1);
          //     });
          //     Navigator.of(context, rootNavigator: true).pushReplacement(
          //         MaterialPageRoute(builder: (context) => MainScreen()));
          //
          //   },
          // ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                //     firstMessage?
                // Container(
                //       height: MediaQuery.of(context).size.height * 0.91,)
                //     :
                // messagesNull?
                // SizedBox(
                //   height: MediaQuery.of(context).size.height * 0.9,
                //   child: Container(
                //       height: MediaQuery.of(context).size.height * 0.5,
                //     width: MediaQuery.of(context).size.height * 0.6,
                //     color: blueColor.withOpacity(0.2),
                //     child: Text(
                //       "No messages here yet",
                //       style: GoogleFonts.raleway(
                //         fontSize: 12,
                //         color: Colors.black,
                //       ),
                //     ),
                //   ),
                // )
                // :
                SizedBox(
                  height: MediaQuery.of(context).viewInsets.bottom>0?MediaQuery.of(context).size.height * 0.54:MediaQuery.of(context).size.height * 0.9,
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

                                  // suffixIcon: IconButton(onPressed: (){
                                  //   getCurrentLocation();
                                  //
                                  // }, icon: Icon(Icons.attach_file_rounded)),
                                  // suffixIconColor: blueColor,
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintText: 'Message',
                                  enabled: true,
                                  contentPadding: const EdgeInsets.only(
                                      left: 14.0, bottom: 8.0, top: 8.0),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide:
                                    new BorderSide(color: redColor),
                                    borderRadius: new BorderRadius.circular(15),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide:
                                    new BorderSide(color: redColor),
                                    borderRadius: new BorderRadius.circular(15),
                                  ),
                                ),
                                // validator: (value) {},
                                onSaved: (value) {
                                  message.text = value!;
                                },
                                // onTap: (){
                                //   setState(() {
                                //     changeContainerHeight = true;
                                //
                                //   });
                                //   Future.delayed(const Duration(milliseconds: 200), () {
                                //     print(DateTime.now());
                                //     // SchedulerBinding.instance
                                //     //     ?.addPostFrameCallback((_) {
                                //     //   print("AAAAAAAAAAA__________________works");
                                //     scrollControllerRef.jumpTo(scrollControllerRef.positions.last.maxScrollExtent);
                                //     // duration: Duration(milliseconds: 400),
                                //     // curve: Curves.fastOutSlowIn);
                                //     // });
                                //   });
                                //
                                //   // duration: Duration(milliseconds: 400),
                                //   // curve: Curves.fastOutSlowIn);
                                //
                                // },
                              ),
                            ),
                          ),
                          CircleAvatar(
                            radius: 25,
                            backgroundColor: redColor,
                            child: IconButton(
                              onPressed: () async {
                                // /messages_Vol(name: current_name_Vol,);
                                // setState(() {
                                //   // firstMessage = false;
                                //   // Navigator.of(context, rootNavigator: true).pushReplacement(
                                //   //     MaterialPageRoute(builder: (context) => new MessagesVol(name: currentName)));
                                // });
                                if (message.text.isNotEmpty) {

                                  setState(() {
                                    writeMessages();
                                  });

                                  await Future.delayed(
                                      Duration(milliseconds: 200), (){
                                    messagesNull = false;
                                    SchedulerBinding.instance
                                        ?.addPostFrameCallback((_) {
                                      print("AAAAAAAAAAA__________________works");
                                      // scrollControllerVol.jumpTo(scrollControllerVol.positions.last.maxScrollExtent);
                                      scrollControllerRef.jumpTo(scrollControllerRef.positions.last.maxScrollExtent);
                                      // duration: Duration(milliseconds: 400),
                                      // curve: Curves.fastOutSlowIn);
                                    });
                                    message.clear();
                                  });

                                  // setState(() {
                                  //   scrollControllerVol.jumpTo(scrollControllerVol.positions.last.maxScrollExtent);
                                  //
                                  // });
                                  // await Future.delayed(
                                  //     Duration(milliseconds: 200), (){
                                  //   messagesNull = false;
                                  //   SchedulerBinding.instance
                                  //       ?.addPostFrameCallback((_) {
                                  //     print("AAAAAAAAAAA__________________works");
                                  //     scrollControllerVol.jumpTo(scrollControllerVol.positions.last.maxScrollExtent);
                                  //     // scrollControllerRef.jumpTo(scrollControllerRef.positions.last.maxScrollExtent);
                                  //     // duration: Duration(milliseconds: 400),
                                  //     // curve: Curves.fastOutSlowIn);
                                  //   });
                                  //   message.clear();
                                  // });

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




// import 'dart:async';
//
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
// import 'package:wol_pro_1/app.dart';
// import 'package:wol_pro_1/constants.dart';
// import 'package:wol_pro_1/screens/menu/refugee/messages/pageWithChatsRef.dart';
// import 'package:wol_pro_1/screens/menu/volunteer/my_applications/settings_of_application.dart';
//
// import '../../volunteer/messages/pageWithChatsVol.dart';
// import '../home_page/home_ref.dart';
// import '../main_screen_ref.dart';
//
//
//
//
// bool firstChat = true;
// String color = "blue";
//
// class MessagesRef extends StatefulWidget {
//   //
//   String? name;
//
//   MessagesRef({required this.name});
//
//   @override
//   _MessagesRefState createState() => _MessagesRefState(name: name);
// }
//
// bool loading = true;
//
// double myMessageLeftVol(String id_receiver) {
//   if (id_receiver != FirebaseAuth.instance.currentUser?.uid) {
//     print("id_receiver != FirebaseAuth.instance.currentUser?.uid");
//     print(id_receiver);
//     print(FirebaseAuth.instance.currentUser?.uid);
//     return 5;
//   } else {
//     print("id_receiver != FirebaseAuth.instance.currentUser?.uid");
//     print(id_receiver != FirebaseAuth.instance.currentUser?.uid);
//     print(id_receiver);
//     print(FirebaseAuth.instance.currentUser?.uid);
//     return 40;
//   }
// }
//
// double myMessageRightVol(String id_receiver) {
//   if (id_receiver == FirebaseAuth.instance.currentUser?.uid) {
//     print("id_receiver == FirebaseAuth.instance.currentUser?.uid");
//     print(id_receiver);
//     print(FirebaseAuth.instance.currentUser?.uid);
//     return 5;
//   } else {
//     return 40;
//   }
// }
//
// class _MessagesRefState extends State<MessagesRef> {
//   String? name;
//
//   _MessagesRefState({required this.name});
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     // Timer.periodic(Duration(seconds: 5), (timer) {
//     //   SchedulerBinding.instance
//     //       ?.addPostFrameCallback((_) {
//     //     print("AAAAAAAAAAA__________________works");
//     //     scrollControllerVol.jumpTo(scrollControllerVol.positions.last.maxScrollExtent);
//     //     // duration: Duration(milliseconds: 400),
//     //     // curve: Curves.fastOutSlowIn);
//     //   });
//     // });
//
//   }
//   //
//   // Stream<QuerySnapshot> _messageStream = FirebaseFirestore.instance
//   //     .collection('Messages')
//   //     // .where("id_of_adressee", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
//   //     .orderBy('time')
//   //     .snapshots();
//   @override
//   Widget build(BuildContext context) {
//     // return isLoading() ? Loading() :StreamBuilder(
//     return WillPopScope(
//       onWillPop: () async {
//         setState(() {
//           scrollControllerRef.jumpTo(scrollControllerRef.positions.last.maxScrollExtent);
//
//
//           controllerTabBottomRef = PersistentTabController(initialIndex: 0);
//         });
//         Navigator.of(context, rootNavigator: true).pushReplacement(
//             MaterialPageRoute(builder: (context) => MainScreenRefugee()));
//         return true;
//       },
//       child: SafeArea(
//         child: Scaffold(
//           appBar: AppBar(
//             backgroundColor: Colors.transparent,
//             elevation: 0,
//             leading: IconButton(
//               icon: Icon(
//                 Icons.arrow_back_ios_new_rounded,
//                 size: 30,
//                 color: blueColor,
//               ),
//               onPressed: () {
//                 setState(() {
//
//                   scrollControllerRef.jumpTo(scrollControllerRef.positions.last.maxScrollExtent);
//
//                   controllerTabBottomRef = PersistentTabController(initialIndex: 0);
//                 });
//                 Navigator.of(context, rootNavigator: true).pushReplacement(
//                     MaterialPageRoute(builder: (context) => MainScreenRefugee()));
//               },
//             ),
//             title: Align(
//               alignment: Alignment.topLeft,
//               child: Text(
//                 ("Messages"),
//                 style: GoogleFonts.raleway(
//                   fontSize: 18,
//                   color: Colors.black,
//                 ),
//               ),
//             ),
//
//           ),
//           // resizeToAvoidBottomInset: false,
//
//           backgroundColor: background,
//           body: SingleChildScrollView(
//             child: Column(
//               children: [
//                 SizedBox(
//                   height: MediaQuery.of(context).size.height * 0.75,
//                   child: StreamBuilder(
//                     stream: FirebaseFirestore.instance
//                         .collection("USERS_COLLECTION")
//                         .doc(IdOfChatroomRef)
//                         .collection("CHATROOMS_COLLECTION")
//
//                         .orderBy('time')
//                         .snapshots(),
//                     builder: (BuildContext context,
//                         AsyncSnapshot<QuerySnapshot> snapshot) {
//                       // print(
//                       //     "SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSs");
//                       // print(FirebaseAuth.instance.currentUser?.uid);
//                       //
//                       // if (snapshot.hasError) {
//                       //   return Text("Something is wrong");
//                       // }
//                       if (snapshot.connectionState ==
//                           ConnectionState.waiting) {
//                         return Center(
//                           child: CircularProgressIndicator(),
//                         );
//                       }
//
//                       return Padding(
//                         padding: const EdgeInsets.only(bottom: 0),
//                         child: ListView.builder(
//                           controller: scrollControllerRef,
//                           itemCount: snapshot.data!.docs.length,
//                           // physics: NeverScrollableScrollPhysics(),
//
//                           // physics: ScrollPhysics(),
//                           shrinkWrap: true,
//                           // primary: true,
//                           itemBuilder: (_, index) {
//                             QueryDocumentSnapshot qs =
//                             snapshot.data!.docs[index];
//                             Timestamp t = qs['time'];
//                             DateTime d = t.toDate();
//                             print(d.toString());
//                             final dataKey = GlobalKey();
//                             return Padding(
//                               padding: EdgeInsets.only(
//                                   top: 8,
//                                   bottom: 8,
//                                   left:
//                                   // 40,
//                                   myMessageLeftVol(
//                                       snapshot.data?.docs[index]["id_user"]),
//                                   right: myMessageRightVol(snapshot
//                                       .data?.docs[index]["id_user"])),
//                               child: Column(
//                                 // crossAxisAlignment: name == qs['name']
//                                 //     ? CrossAxisAlignment.end
//                                 //     : CrossAxisAlignment.start,
//                                 children: [
//                                   Container(
//                                     decoration: new BoxDecoration(
//                                         color: snapshot.data?.docs[index]
//                                         ["id_user"] ==
//                                             FirebaseAuth.instance.currentUser?.uid
//                                             ? Colors.white
//                                             : blueColor.withOpacity(0.2),
//                                         borderRadius: BorderRadius.all(
//                                             Radius.circular(10))),
//                                     // width: 300,
//
//                                     child: ListTile(
//                                       key: dataKey,
//                                       // shape: RoundedRectangleBorder(
//                                       //   side: BorderSide(
//                                       //     color: snapshot.data?.docs[index]["name"] == current_name_Vol ? Colors.blue:Colors.purple,
//                                       //   ),
//                                       //   borderRadius: BorderRadius.circular(10),
//                                       // ),
//                                       title: Text(
//                                         qs['name'],
//                                         style: TextStyle(
//                                           fontSize: 15,
//                                         ),
//                                       ),
//                                       subtitle: Row(
//                                         mainAxisAlignment:
//                                         MainAxisAlignment
//                                             .spaceBetween,
//                                         children: [
//                                           Container(
//                                             width: 200,
//                                             child: Text(
//                                               qs['message'],
//                                               softWrap: true,
//                                               style: TextStyle(
//                                                 fontSize: 15,
//                                               ),
//                                             ),
//                                           ),
//                                           Text(
//                                             d.hour.toString() +
//                                                 ":" +
//                                                 d.minute.toString(),
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             );
//                           },
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class SelectedChatroomRef extends StatefulWidget {
//   const SelectedChatroomRef({Key? key}) : super(key: key);
//
//   @override
//   State<SelectedChatroomRef> createState() => _SelectedChatroomRefState();
// }
// bool? messagesNull;
// // String id_users_col = FirebaseFirestore.instance.collection("USERS_COLLECTION").doc().id;
// class _SelectedChatroomRefState extends State<SelectedChatroomRef> {
//   // String id_users_col = FirebaseFirestore.instance.collection("USERS_COLLECTION").doc().id;
//
//   writeMessages() {
//     FirebaseFirestore.instance
//         .collection("USERS_COLLECTION")
//         .doc(IdOfChatroomRef)
//         .collection("CHATROOMS_COLLECTION")
//         .doc()
//         .set({
//       'message': message.text.trim(),
//       'time': DateTime.now(),
//       'name': currentNameRef,
//       'id_message': "null",
//       "id_user": FirebaseAuth.instance.currentUser?.uid,
//       // "user_message": true
//     });
//
//   }
//
//   late StreamSubscription<User?> user;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     // print("Null message test ................");
//     // print(messagesNull);
//     // if (messagesNull==true){
//     //   FirebaseFirestore.instance
//     //       .collection("USERS_COLLECTION")
//     //       .doc(IdOfChatroomRef)
//     //       .collection("CHATROOMS_COLLECTION")
//     //       .doc()
//     //       .set({
//     //     'message': "Hello👋",
//     //     'time': DateTime.now(),
//     //     'name': currentNameRef,
//     //     'id_message': "null",
//     //     "id_user": FirebaseAuth.instance.currentUser?.uid,
//     //     // "user_message": false
//     //   });
//     // }
//     Future.delayed(const Duration(milliseconds: 200), () {
//       print(DateTime.now());
//       // SchedulerBinding.instance
//       //     ?.addPostFrameCallback((_) {
//       //   print("AAAAAAAAAAA__________________works");
//       scrollControllerRef.jumpTo(scrollControllerRef.positions.last.maxScrollExtent);
//       // duration: Duration(milliseconds: 400),
//       // curve: Curves.fastOutSlowIn);
//       // });
//     });
//
//     // user = FirebaseAuth.instance.authStateChanges().listen((user) async {
//     //   DocumentSnapshot variable = await FirebaseFirestore.instance.
//     //   collection("USERS_COLLECTION")
//     //       .doc(IdOfChatroomVol)
//     //       .collection("CHATROOMS_COLLECTION")
//     //       .doc().
//     //   get();
//     //
//     //   print("OOOOOOOOOOOOOOHHHHHHHHHELP");
//     //   print(variable == null);
//     //
//     // });
//   }
//   // @override
//   // void initState() {
//   //   // TODO: implement initState
//   //   super.initState();
//   //
//   //   SchedulerBinding.instance
//   //       .addPostFrameCallback((_) {
//   //     print("AAAAAAAAAAA__________________works");
//   //     scrollControllerVol.jumpTo(scrollControllerVol.positions.last.maxScrollExtent);
//   // });
//   // }
//   final TextEditingController message = new TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     print("HHHHHHHHHJJJJJJJJJJJJJKKKKKKKKKKKKSSSSSSSSSSSK");
//     print(firstMessage);
//     return WillPopScope(
//       onWillPop: () async {
//         setState(() {
//           controllerTabBottomRef= PersistentTabController(initialIndex: 0);
//         });
//         Navigator.of(context, rootNavigator: true).pushReplacement(
//             MaterialPageRoute(builder: (context) => MainScreenRefugee()));
//         return true;
//       },
//       child: Scaffold(
//         backgroundColor: background,
//         // resizeToAvoidBottomInset: true,
//         // floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
//         // floatingActionButton: IconButton(
//         //   icon: Icon(
//         //     Icons.arrow_back_ios_new_rounded,
//         //     size: 30,
//         //     color: blueColor,
//         //   ),
//         //   onPressed: () {
//         //     setState(() {
//         //       controllerTabBottomVol = PersistentTabController(initialIndex: 0);
//         //     });
//         //     Navigator.of(context, rootNavigator: true).pushReplacement(
//         //         MaterialPageRoute(builder: (context) => MainScreen()));
//         //   },
//         // ),
//         // floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
//         // floatingActionButton: IconButton(
//         //   icon: Icon(
//         //     Icons.arrow_back_ios_new_rounded,
//         //     size: 30,
//         //     color: blueColor,
//         //   ),
//         //   onPressed: () {
//         //     setState(() {
//         //       controllerTabBottom = PersistentTabController(initialIndex: 1);
//         //     });
//         //     Navigator.of(context, rootNavigator: true).pushReplacement(
//         //         MaterialPageRoute(builder: (context) => MainScreen()));
//         //
//         //   },
//         // ),
//         body: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               //     firstMessage?
//               // Container(
//               //       height: MediaQuery.of(context).size.height * 0.91,)
//               //     :
//               // messagesNull?
//               // SizedBox(
//               //   height: MediaQuery.of(context).size.height * 0.9,
//               //   child: Container(
//               //       height: MediaQuery.of(context).size.height * 0.5,
//               //     width: MediaQuery.of(context).size.height * 0.6,
//               //     color: blueColor.withOpacity(0.2),
//               //     child: Text(
//               //       "No messages here yet",
//               //       style: GoogleFonts.raleway(
//               //         fontSize: 12,
//               //         color: Colors.black,
//               //       ),
//               //     ),
//               //   ),
//               // )
//               // :
//               SizedBox(
//                 height: MediaQuery.of(context).size.height * 0.9,
//                 child: MessagesRef(
//                   name: currentName,
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(bottom: 0),
//                 child: SizedBox(
//                   // color: background,
//                   height: MediaQuery.of(context).size.height * 0.1,
//                   child: Align(
//                     alignment: Alignment.center,
//                     child: Padding(
//                       padding: padding,
//                       child: Row(
//                         children: [
//                           Expanded(
//                             child: Padding(
//                               padding: const EdgeInsets.only(right: 5),
//                               child: TextFormField(
//                                 controller: message,
//                                 decoration: InputDecoration(
//                                   filled: true,
//                                   fillColor: Colors.white,
//                                   hintText: 'Message',
//                                   enabled: true,
//                                   contentPadding: const EdgeInsets.only(
//                                       left: 14.0, bottom: 8.0, top: 8.0),
//                                   focusedBorder: OutlineInputBorder(
//                                     borderSide:
//                                     new BorderSide(color: blueColor),
//                                     borderRadius: new BorderRadius.circular(15),
//                                   ),
//                                   enabledBorder: UnderlineInputBorder(
//                                     borderSide:
//                                     new BorderSide(color: blueColor),
//                                     borderRadius: new BorderRadius.circular(15),
//                                   ),
//                                 ),
//                                 validator: (value) {},
//                                 onSaved: (value) {
//                                   message.text = value!;
//                                 },
//                               ),
//                             ),
//                           ),
//                           CircleAvatar(
//                             radius: 25,
//                             backgroundColor: blueColor,
//                             child: IconButton(
//                               onPressed: () async {
//                                 // /messages_Vol(name: current_name_Vol,);
//                                 // setState(() {
//                                 //   // firstMessage = false;
//                                 //   // Navigator.of(context, rootNavigator: true).pushReplacement(
//                                 //   //     MaterialPageRoute(builder: (context) => new MessagesVol(name: currentName)));
//                                 // });
//                                 if (message.text.isNotEmpty) {
//
//                                   setState(() {
//                                     writeMessages();
//                                   });
//
//                                   await Future.delayed(
//                                       Duration(milliseconds: 500), (){
//                                     messagesNull = false;
//                                     SchedulerBinding.instance
//                                         ?.addPostFrameCallback((_) {
//                                       print("AAAAAAAAAAA__________________works");
//                                       scrollControllerRef.jumpTo(scrollControllerRef.positions.last.maxScrollExtent);
//                                       scrollControllerVol.jumpTo(scrollControllerVol.positions.last.maxScrollExtent);
//                                       // duration: Duration(milliseconds: 400),
//                                       // curve: Curves.fastOutSlowIn);
//                                     });
//                                     message.clear();
//                                   });
//
//                                 }
//                               },
//                               icon: Icon(
//                                 Icons.send_sharp,
//                                 color: background,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
// import 'package:wol_pro_1/app.dart';
// import 'package:wol_pro_1/constants.dart';
// import 'package:wol_pro_1/screens/menu/refugee/main_screen_ref.dart';
// import 'package:wol_pro_1/screens/menu/refugee/messages/pageWithChatsRef.dart';
// import 'package:wol_pro_1/screens/menu/volunteer/my_applications/settings_of_application.dart';
//
// import '../home_page/home_ref.dart';
//
// ScrollController _scrollControllerVol_ = ScrollController();
//
// String color = "blue";
//
// class MessagesRef extends StatefulWidget {
//   //
//   String? name;
//
//   MessagesRef({required this.name});
//
//   @override
//   _MessagesRefState createState() => _MessagesRefState(name: name);
// }
//
// bool loading = true;
//
// double myMessageLeftVol(String name_receiver) {
//   if (name_receiver == currentNameRef) {
//     return 40;
//   } else {
//     return 5;
//   }
// }
//
// double myMessageRightVol(String name_receiver) {
//   if (name_receiver == currentNameRef) {
//     return 5;
//   } else {
//     return 40;
//   }
// }
//
// class _MessagesRefState extends State<MessagesRef> {
//   String? name;
//
//   _MessagesRefState({required this.name});
//
//   //
//   // Stream<QuerySnapshot> _messageStream = FirebaseFirestore.instance
//   //     .collection('Messages')
//   //     // .where("id_of_adressee", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
//   //     .orderBy('time')
//   //     .snapshots();
//   @override
//   Widget build(BuildContext context) {
//     // return isLoading() ? Loading() :StreamBuilder(
//     return WillPopScope(
//       onWillPop: () async {
//         setState(() {
//           controllerTabBottomRef = PersistentTabController(initialIndex: 0);
//         });
//         Navigator.of(context, rootNavigator: true).pushReplacement(
//             MaterialPageRoute(builder: (context) => MainScreenRefugee()));
//         return true;
//       },
//       child: SafeArea(
//         child: Scaffold(
//           floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
//           floatingActionButton: IconButton(
//             icon: Icon(
//               Icons.arrow_back_ios_new_rounded,
//               size: 30,
//               color: blueColor,
//             ),
//             onPressed: () {
//               setState(() {
//                 controllerTabBottomRef = PersistentTabController(initialIndex: 0);
//               });
//               Navigator.of(context, rootNavigator: true).pushReplacement(
//                   MaterialPageRoute(builder: (context) => MainScreenRefugee()));
//             },
//           ),
//           backgroundColor: background,
//           body: Column(
//             children: [
//               Padding(
//                 padding: EdgeInsets.only(
//                     top: MediaQuery.of(context).size.height * 0.02),
//                 child: Align(
//                   alignment: Alignment.topCenter,
//                   child: Text(
//                     ("Messages"),
//                     style: GoogleFonts.raleway(
//                       fontSize: 18,
//                       color: Colors.black,
//                     ),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.only(
//                     top: MediaQuery.of(context).size.height * 0.05),
//                 child: SizedBox(
//                   height: MediaQuery.of(context).size.height * 0.75,
//                   child: StreamBuilder(
//                     stream: FirebaseFirestore.instance
//                         .collection("USERS_COLLECTION")
//                         .doc(IdOfChatroomRef)
//                         .collection("CHATROOMS_COLLECTION")
//                         .orderBy('time')
//                         .snapshots(),
//                     builder: (BuildContext context,
//                         AsyncSnapshot<QuerySnapshot> snapshot) {
//                       print(
//                           "SSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSs");
//                       print(FirebaseAuth.instance.currentUser?.uid);
//
//                       if (snapshot.hasError) {
//                         return Text("Something is wrong");
//                       }
//                       if (snapshot.connectionState ==
//                           ConnectionState.waiting) {
//                         return Center(
//                           child: CircularProgressIndicator(),
//                         );
//                       }
//
//                       return Padding(
//                         padding: const EdgeInsets.only(bottom: 0),
//                         child: ListView.builder(
//                           controller: _scrollControllerVol_,
//                           itemCount: snapshot.data!.docs.length,
//                           // physics: NeverScrollableScrollPhysics(),
//
//                           // physics: ScrollPhysics(),
//                           shrinkWrap: true,
//                           // primary: true,
//                           itemBuilder: (_, index) {
//                             QueryDocumentSnapshot qs =
//                             snapshot.data!.docs[index];
//                             Timestamp t = qs['time'];
//                             DateTime d = t.toDate();
//                             print(d.toString());
//                             final dataKey = GlobalKey();
//                             return Padding(
//                               padding: EdgeInsets.only(
//                                   top: 8,
//                                   bottom: 8,
//                                   left: myMessageLeftVol(
//                                       snapshot.data?.docs[index]["name"]),
//                                   right: myMessageRightVol(snapshot
//                                       .data?.docs[index]["name"])),
//                               child: Column(
//                                 // crossAxisAlignment: name == qs['name']
//                                 //     ? CrossAxisAlignment.end
//                                 //     : CrossAxisAlignment.start,
//                                 children: [
//                                   Container(
//                                     decoration: new BoxDecoration(
//                                         color: snapshot.data?.docs[index]
//                                         ["name"] ==
//                                             currentNameRef
//                                             ? Colors.white
//                                             : blueColor.withOpacity(0.2),
//                                         borderRadius: BorderRadius.all(
//                                             Radius.circular(10))),
//                                     // width: 300,
//
//                                     child: ListTile(
//                                       key: dataKey,
//                                       // shape: RoundedRectangleBorder(
//                                       //   side: BorderSide(
//                                       //     color: snapshot.data?.docs[index]["name"] == current_name_Vol ? Colors.blue:Colors.purple,
//                                       //   ),
//                                       //   borderRadius: BorderRadius.circular(10),
//                                       // ),
//                                       title: Text(
//                                         qs['name'],
//                                         style: TextStyle(
//                                           fontSize: 15,
//                                         ),
//                                       ),
//                                       subtitle: Row(
//                                         mainAxisAlignment:
//                                         MainAxisAlignment
//                                             .spaceBetween,
//                                         children: [
//                                           Container(
//                                             width: 200,
//                                             child: Text(
//                                               qs['message'],
//                                               softWrap: true,
//                                               style: TextStyle(
//                                                 fontSize: 15,
//                                               ),
//                                             ),
//                                           ),
//                                           Text(
//                                             d.hour.toString() +
//                                                 ":" +
//                                                 d.minute.toString(),
//                                           )
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             );
//                           },
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class SelectedChatroomRef extends StatefulWidget {
//   const SelectedChatroomRef({Key? key}) : super(key: key);
//
//   @override
//   State<SelectedChatroomRef> createState() => _SelectedChatroomRefState();
// }
//
// // String id_users_col = FirebaseFirestore.instance.collection("USERS_COLLECTION").doc().id;
// class _SelectedChatroomRefState extends State<SelectedChatroomRef> {
//   // String id_users_col = FirebaseFirestore.instance.collection("USERS_COLLECTION").doc().id;
//
//   writeMessages() {
//     FirebaseFirestore.instance
//         .collection("USERS_COLLECTION")
//         .doc(IdOfChatroomRef)
//         .collection("CHATROOMS_COLLECTION")
//         .doc()
//         .set({
//       'message': message.text.trim(),
//       'time': DateTime.now(),
//       'name': currentNameRef,
//       'id_message': "null"
//     });
//   }
//
//   final TextEditingController message = new TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     print("HHHHHHHHHJJJJJJJJJJJJJKKKKKKKKKKKKSSSSSSSSSSSK");
//     print(firstMessage);
//     return WillPopScope(
//       onWillPop: () async {
//         setState(() {
//           controllerTabBottomRef = PersistentTabController(initialIndex: 0);
//         });
//         Navigator.of(context, rootNavigator: true).pushReplacement(
//             MaterialPageRoute(builder: (context) => MainScreenRefugee()));
//         return true;
//       },
//       child: Scaffold(
//         backgroundColor: background,
//         resizeToAvoidBottomInset: true,
//         floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
//         floatingActionButton: IconButton(
//           icon: Icon(
//             Icons.arrow_back_ios_new_rounded,
//             size: 30,
//             color: blueColor,
//           ),
//           onPressed: () {
//             setState(() {
//               controllerTabBottomRef = PersistentTabController(initialIndex: 0);
//             });
//             Navigator.of(context, rootNavigator: true).pushReplacement(
//                 MaterialPageRoute(builder: (context) => MainScreenRefugee()));
//           },
//         ),
//         body: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Container(
//                 height: MediaQuery.of(context).size.height * 0.91,
//                 child: MessagesRef(
//                   name: currentName,
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(bottom: 0),
//                 child: Container(
//                   // color: background,
//                   height: 60,
//                   child: Align(
//                     alignment: Alignment.center,
//                     child: Padding(
//                       padding: padding,
//                       child: Row(
//                         children: [
//                           Expanded(
//                             child: Padding(
//                               padding: const EdgeInsets.only(right: 5),
//                               child: TextFormField(
//                                 controller: message,
//                                 decoration: InputDecoration(
//                                   filled: true,
//                                   fillColor: Colors.white,
//                                   hintText: 'Message',
//                                   enabled: true,
//                                   contentPadding: const EdgeInsets.only(
//                                       left: 14.0, bottom: 8.0, top: 8.0),
//                                   focusedBorder: OutlineInputBorder(
//                                     borderSide:
//                                     new BorderSide(color: blueColor),
//                                     borderRadius: new BorderRadius.circular(24),
//                                   ),
//                                   enabledBorder: UnderlineInputBorder(
//                                     borderSide:
//                                     new BorderSide(color: blueColor),
//                                     borderRadius: new BorderRadius.circular(24),
//                                   ),
//                                 ),
//                                 validator: (value) {},
//                                 onSaved: (value) {
//                                   message.text = value!;
//                                 },
//                               ),
//                             ),
//                           ),
//                           CircleAvatar(
//                             radius: 25,
//                             backgroundColor: blueColor,
//                             child: IconButton(
//                               onPressed: () async {
//                                 // /messages_Vol(name: current_name_Vol,);
//                                 setState(() {
//                                   firstMessage = false;
//                                   // Navigator.of(context, rootNavigator: true).pushReplacement(
//                                   //     MaterialPageRoute(builder: (context) => new MessagesVol(name: currentName)));
//                                 });
//                                 if (message.text.isNotEmpty) {
//
//                                   writeMessages();
//
//                                   await Future.delayed(
//                                       Duration(milliseconds: 500), (){
//                                     SchedulerBinding.instance
//                                         ?.addPostFrameCallback((_) {
//                                       print("AAAAAAAAAAA__________________works");
//                                       _scrollControllerVol_.jumpTo(
//                                           _scrollControllerVol_
//                                               .positions.last.maxScrollExtent);
//                                       // duration: Duration(milliseconds: 400),
//                                       // curve: Curves.fastOutSlowIn);
//                                     });
//                                     message.clear();
//                                   });
//
//                                 }
//                               },
//                               icon: Icon(
//                                 Icons.send_sharp,
//                                 color: background,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }