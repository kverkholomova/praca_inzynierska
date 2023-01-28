import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wol_pro_1/constants.dart';
import 'package:wol_pro_1/widgets/loading.dart';

import 'messagesRef.dart';

ScrollController scrollControllerRef = ScrollController();

class ListofChatroomsRef extends StatefulWidget {
  const ListofChatroomsRef({Key? key}) : super(key: key);

  @override
  State<ListofChatroomsRef> createState() => _ListofChatroomsRefState();
}

String? iIdOfChatroomRef = '';
List<String?> listOfRefugeesVol_ = [];

class _ListofChatroomsRefState extends State<ListofChatroomsRef> {
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
        backgroundColor: backgroundRefugee,
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
                              style: GoogleFonts.raleway(
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
                height: MediaQuery.of(context).size.height * 0.015,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.9,
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('USERS_COLLECTION')
                      .where('IdRefugee',
                          isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                      .snapshots(),
                  builder:
                      (context, AsyncSnapshot<QuerySnapshot?> streamSnapshot) {
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
                                return const LoadingRefugee();

                              case ConnectionState.active:
                                return Column(
                                  children: [
                                    Padding(
                                      padding: padding,
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            listOfRefugeesVol_.add(
                                                streamSnapshot.data?.docs[index]
                                                    ["IdRefugee"]);
                                            iIdOfChatroomRef = streamSnapshot
                                                .data?.docs[index]["chatId"];
                                            lastMessage = streamSnapshot
                                                .data?.docs[index]["last_msg"];
                                          });
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pushReplacement(MaterialPageRoute(
                                                  builder: (context) =>
                                                      const SelectedChatroomRef()));
                                        },
                                        child: Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 15,
                                            ),
                                            child: Row(
                                              children: [
                                                Align(
                                                  alignment: Alignment.center,
                                                  child: SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.7,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.1,
                                                    child: Align(
                                                      alignment:
                                                          Alignment.center,
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
                                                              color:
                                                                  Colors.black,
                                                            )),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
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
                          return const LoadingRefugee();
                        });
                  },
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
