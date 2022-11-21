import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wol_pro_1/constants.dart';
import 'package:wol_pro_1/screens/menu/volunteer/messages/volunteer/messagesVol.dart';

import '../../home_page/home_vol.dart';
import '../../home_page/settings/upload_photo.dart';
import '../../main_screen.dart';





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
          MaterialPageRoute(builder: (context) => HomeVol()),
        );
        return true;
      },
      child: Scaffold(
        backgroundColor: background,
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
                    color: blueColor,
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
                                "Contact with refugees",
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
                      .where('IdVolunteer', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
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
                          children: [
                            Padding(
                              padding: padding,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    listOfRefugeesVol_.add(streamSnapshot.data?.docs[index]["IdRefugee"]);
                                    IdOfChatroomVol = streamSnapshot.data?.docs[index]["chatId"];
                                    isVisibleTabBar = false;
                                    print("KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKLLLLLLLLLLLLLLL");
                                    print(isVisibleTabBar);
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //       builder: (context) =>
                                    //           MainScreen()),
                                    // );
                                    // print("print ${streamSnapshot.data?.docs[index][id]}");
                                  });
                                  Navigator.of(context, rootNavigator: true).pushReplacement(
                                      MaterialPageRoute(builder: (context) => new SelectedChatroomVol()));
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
                                          24)),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 15,),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                            radius: 25.0,
                                            backgroundImage: NetworkImage(url_image.toString())),
                                        Align(
                                          alignment: Alignment.center,
                                          child: SizedBox(
                                            width: MediaQuery.of(context).size.width *
                                                0.5,
                                            height: MediaQuery.of(context).size.height *
                                                0.1,
                                            child:Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 15),
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: ListTile(
                                                  // mainAxisAlignment: MainAxisAlignment.start,
                                                  // contentPadding:
                                                  // EdgeInsets.symmetric(
                                                  //     vertical: 10),
                                                  title: Text(
                                                      streamSnapshot.data?.docs[index]['Refugee_Name']
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
                      });
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}