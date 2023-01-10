import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wol_pro_1/constants.dart';
import 'package:wol_pro_1/screens/menu/volunteer/messages/messagesVol.dart';
import 'package:wol_pro_1/widgets/loading.dart';

import '../home_page/home_ref.dart';
import 'messagesRef.dart';

ScrollController scrollControllerRef = ScrollController();

class ListofChatroomsRef extends StatefulWidget {
  const ListofChatroomsRef({Key? key}) : super(key: key);

  @override
  State<ListofChatroomsRef> createState() => _ListofChatroomsRefState();
}
String? IdOfChatroomRef = '';
List<String?> listOfRefugeesVol_ = [];
class _ListofChatroomsRefState extends State<ListofChatroomsRef> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    foregroundMessage();
  }

  void foregroundMessage(){
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => const OptionChoose()),
        // );
        return true;
      },
      child: Scaffold(
        backgroundColor: backgroundRefugee,
        // appBar: AppBar(
        //   title: const Text('Chats'),
        //   backgroundColor: Color.fromRGBO(49, 72, 103, 0.8),
        //   elevation: 0.0,
        //   leading: IconButton(
        //     icon: const Icon(Icons.arrow_back,color: Colors.white,),
        //     onPressed: () async {
        //       // await _auth.signOut();
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(builder: (context) => SettingsHomeVol()),
        //       );
        //     },
        //   ),
        // ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              ClipPath(
                clipper: OvalBottomBorderClipper(),
                child: Container(
                  decoration: BoxDecoration(
                    color: redColor,
                    boxShadow: const <BoxShadow>[
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  height: MediaQuery.of(context).size.height * 0.15,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Align(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Text(
                              "Messages",
                              style:  GoogleFonts.raleway(
                                fontSize: 24,
                                color: Colors.white,
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                "Contact with volunteers",
                                style: GoogleFonts.raleway(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        )),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context)
                    .size
                    .height *
                    0.015,
              ),
              SizedBox(
                height: MediaQuery.of(context)
                    .size
                    .height *
                    0.9,
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('USERS_COLLECTION')
                      .where('IdRefugee', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot?> streamSnapshot) {
                    return ListView.builder(
                        shrinkWrap: true,
                        // scrollDirection: Axis.vertical,
                        itemCount: !streamSnapshot.hasData? 1:streamSnapshot.data?.docs.length,
                        itemBuilder: (ctx, index) {
                          if (streamSnapshot.hasData){
                            switch (streamSnapshot.connectionState){
                              case ConnectionState.waiting:
                                return  LoadingRefugee();
                                //   Column(
                                //     children: [
                                //       SizedBox(
                                //         width: 60,
                                //         height: 60,
                                //         child: CircularProgressIndicator(),
                                //       ),
                                //       // Padding(
                                //       //   padding: EdgeInsets.only(top: 16),
                                //       //   child: Text('Awaiting data...'),
                                //       // )
                                //     ]
                                //
                                // );

                              case ConnectionState.active:
                                return Column(
                                  children: [
                                    Padding(
                                      padding: padding,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {

                                            listOfRefugeesVol_.add(streamSnapshot.data?.docs[index]["IdRefugee"]);
                                            IdOfChatroomRef = streamSnapshot.data?.docs[index]["chatId"];
                                            last_message = streamSnapshot.data?.docs[index]["last_msg"];
                                            // isVisibleTabBar = false;
                                            // print("KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKLLLLLLLLLLLLLLL");
                                            // print(isVisibleTabBar);
                                            // Navigator.push(
                                            //   context,
                                            //   MaterialPageRoute(
                                            //       builder: (context) =>
                                            //           MainScreen()),
                                            // );
                                            // print("print ${streamSnapshot.data?.docs[index][id]}");
                                          });
                                          Navigator.of(context, rootNavigator: true).pushReplacement(
                                              MaterialPageRoute(builder: (context) => new SelectedChatroomRef()));
                                          // Navigator.push(
                                          //   context,
                                          //   MaterialPageRoute(
                                          //       builder: (context) =>
                                          //           SelectedChatroomVol()),
                                          // );
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                              BorderRadius.circular(
                                                  15)),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 15,),
                                            child: Row(
                                              children: [
                                                // CircleAvatar(
                                                //     radius: 25.0,
                                                //     backgroundImage: NetworkImage(url_image.toString())),
                                                Align(
                                                  alignment: Alignment.center,
                                                  child: SizedBox(
                                                    width: MediaQuery.of(context).size.width *
                                                        0.7,
                                                    height: MediaQuery.of(context).size.height *
                                                        0.1,
                                                    child:Align(
                                                      alignment: Alignment.center,
                                                      child: ListTile(
                                                        // mainAxisAlignment: MainAxisAlignment.start,
                                                        // contentPadding:
                                                        // EdgeInsets.symmetric(
                                                        //     vertical: 10),
                                                        title: Text(
                                                            streamSnapshot.data?.docs[index]['Application_Name']
                                                            as String,
                                                            style: GoogleFonts
                                                                .raleway(
                                                              fontSize: 14,
                                                              color: Colors.black,
                                                            )),
                                                        // Text(
                                                        //     streamSnapshot.data?.docs[index]['category'] as String,
                                                        //     style: TextStyle(color: Colors.grey)),
                                                        // subtitle: Text(
                                                        //   streamSnapshot.data
                                                        //       ?.docs[index]
                                                        //   ['comment']
                                                        //   as String,
                                                        //   style:
                                                        //   GoogleFonts.raleway(
                                                        //     fontSize: 12,
                                                        //     color: Colors.black
                                                        //         .withOpacity(0.5),
                                                        //   ),
                                                        // ),
                                                      ),
                                                    ),),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        // Stack(
                                        //   children: [
                                        //     //streamSnapshot.data?.docs[index]['title']==null ?
                                        //
                                        //     const Padding(
                                        //       padding: EdgeInsets.all(8.0),
                                        //       child: Align(
                                        //         alignment: Alignment.topLeft,
                                        //         child: CircleAvatar(
                                        //           radius: 25,
                                        //           backgroundColor: Colors.lightBlue,
                                        //         ),
                                        //       ),
                                        //     ),

                                        // Align(
                                        //   alignment: Alignment.centerLeft,
                                        //     child: Padding(
                                        //       padding: const EdgeInsets.only(top: 23, left: 70,bottom: 8,),
                                        //       child: Text(streamSnapshot.data?.docs[index]['Refugee_Name'], style: TextStyle(fontSize: 18),),
                                        //     )),

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
                                        //   ],
                                        // ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: MediaQuery.of(context)
                                          .size
                                          .height *
                                          0.015,
                                    ),
                                  ],
                                );}}
                          return LoadingRefugee();
                          //   Center(
                          //   child: Padding(padding: EdgeInsets.only(top: 100),
                          //     child: Column(
                          //       children: [
                          //         SpinKitChasingDots(
                          //           color: Colors.brown,
                          //           size: 50.0,
                          //         ),
                          //         Align(
                          //           alignment: Alignment.center,
                          //           child: Text(
                          //               "Waiting...",
                          //               style: TextStyle(
                          //                 fontWeight: FontWeight.bold,fontSize: 24,color: Colors.black,)
                          //           ),
                          //         ),
                          //         Padding(padding: EdgeInsets.only(top: 20),)
                          //       ],
                          //     ),
                          //   ),
                          // );
                        });
                  },
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context)
                    .size
                    .height *
                    0.015,
              ),
            ],
          ),
        ),
      ),
    );
  }
}