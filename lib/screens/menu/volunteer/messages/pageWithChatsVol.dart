import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wol_pro_1/constants.dart';
import 'package:wol_pro_1/screens/menu/volunteer/messages/messagesVol.dart';

import '../main_screen.dart';

ScrollController scrollControllerVol = ScrollController();

class ListofChatroomsVol extends StatefulWidget {
  const ListofChatroomsVol({Key? key}) : super(key: key);

  @override
  State<ListofChatroomsVol> createState() => _ListofChatroomsVolState();
}

String? IdOfChatroomVol = '';
List<String?> listOfRefugeesVol_ = [];

class _ListofChatroomsVolState extends State<ListofChatroomsVol> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // foregroundMessage();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();

        return true;
      },
      child: Scaffold(
        backgroundColor: background,
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
                              style: GoogleFonts.raleway(
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
                height: MediaQuery.of(context).size.height * 0.015,
              ),
              SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('USERS_COLLECTION')
                        .where('IdVolunteer',
                            isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                        .snapshots(),
                    builder: (context,
                        AsyncSnapshot<QuerySnapshot?> streamSnapshot) {
                      return ListView.builder(
                          shrinkWrap: true,
                          // scrollDirection: Axis.vertical,
                          itemCount: !streamSnapshot.hasData
                              ? 1
                              : streamSnapshot.data?.docs.length,
                          itemBuilder: (ctx, index) {
                            if (streamSnapshot.hasData) {
                              switch (streamSnapshot.connectionState) {
                                case ConnectionState.waiting:
                                  return Column(children: const [
                                    Padding(
                                      padding: EdgeInsets.only(top: 16),
                                      child: Text(''),
                                    )
                                  ]);

                                case ConnectionState.active:
                                  return Column(
                                    children: [
                                      Padding(
                                        padding: padding,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              changeContainerHeight = false;

                                              listOfRefugeesVol_.add(
                                                  streamSnapshot
                                                          .data?.docs[index]
                                                      ["IdRefugee"]);
                                              IdOfChatroomVol = streamSnapshot
                                                  .data?.docs[index]["chatId"];

                                              lastMessageVol = streamSnapshot
                                                  .data
                                                  ?.docs[index]["last_msg"];
                                              isVisibleTabBar = false;
                                            });
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .pushReplacement(MaterialPageRoute(
                                                    builder: (context) =>
                                                        const SelectedChatroomVol()));
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            child: Padding(
                                                padding: padding,
                                                child: Align(
                                                  alignment: Alignment.topLeft,
                                                  child: SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.9,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.085,
                                                    child: ListTile(
                                                      title: Text(
                                                          streamSnapshot.data
                                                                      ?.docs[index]
                                                                  [
                                                                  'Application_Name']
                                                              as String,
                                                          style: GoogleFonts
                                                              .raleway(
                                                            fontSize: 14,
                                                            color: Colors.black,
                                                          )),
                                                    ),
                                                  ),
                                                )),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.015,
                                      ),
                                    ],
                                  );
                              }
                            }
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 100),
                                child: Column(
                                  children: const [
                                    Align(
                                      alignment: Alignment.center,
                                      child: Text("",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 24,
                                            color: Colors.black,
                                          )),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 20),
                                    )
                                  ],
                                ),
                              ),
                            );
                          });
                    },
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.015,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
