import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wol_pro_1/constants.dart';
import 'package:wol_pro_1/screens/menu/volunteer/all_applications/page_of_application_vol.dart';
import 'package:wol_pro_1/screens/menu/volunteer/my_applications/settings_of_application.dart';

import '../../../../models/categories.dart';
import '../home_page/home_vol.dart';

String cardTitleAccepted = '';
String cardCategoryAccepted = '';
String cardCommentAccepted = '';
String chatIdDialog = '';

class ApplicationsOfVolunteer extends StatefulWidget {
  const ApplicationsOfVolunteer({Key? key}) : super(key: key);

  @override
  State<ApplicationsOfVolunteer> createState() =>
      _ApplicationsOfVolunteerState();
}

class _ApplicationsOfVolunteerState extends State<ApplicationsOfVolunteer> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomeVol()),
        );
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
                              "Applications",
                              style: GoogleFonts.raleway(
                                fontSize: 24,
                                color: Colors.white,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                "Manage your applications",
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
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.015),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('applications')
                        .where("volunteerID",
                            isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                        .where("status", isEqualTo: 'Application is accepted')
                        .snapshots(),
                    builder:
                        (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                      return ListView.builder(
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
                                            tokenRefNotification =
                                                streamSnapshot.data?.docs[index]
                                                    ['token_ref'];
                                            Id_Of_current_application =
                                                streamSnapshot
                                                    .data?.docs[index].id;

                                            chatIdDialog = streamSnapshot.data
                                                ?.docs[index]["chatId_vol"];
                                            cardTitleAccepted =
                                                streamSnapshot.data?.docs[index]
                                                    ['title'] as String;
                                            cardCategoryAccepted =
                                                streamSnapshot.data?.docs[index]
                                                    ['category'] as String;
                                            cardCommentAccepted =
                                                streamSnapshot.data?.docs[index]
                                                    ['comment'] as String;

                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .pushReplacement(MaterialPageRoute(
                                                    builder: (context) =>
                                                        const SettingsOfApplicationAccepted()));
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(18)),
                                            child: Align(
                                              alignment: Alignment.center,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .height *
                                                            0.015),
                                                    child: Icon(
                                                      streamSnapshot.data?.docs[index]
                                                                      ['category']
                                                                  as String ==
                                                              categoriesListAll[
                                                                  3]
                                                          ? Icons.pets_rounded
                                                          : streamSnapshot.data?.docs[index]
                                                                          ['category']
                                                                      as String ==
                                                                  categoriesListAll[
                                                                      4]
                                                              ? Icons
                                                                  .local_grocery_store
                                                              : streamSnapshot.data?.docs[index]
                                                                              ['category']
                                                                          as String ==
                                                                      categoriesListAll[
                                                                          2]
                                                                  ? Icons
                                                                      .emoji_transportation_rounded
                                                                  : streamSnapshot
                                                                              .data
                                                                              ?.docs[index]['category'] as String ==
                                                                          categoriesListAll[1]
                                                                      ? Icons.house
                                                                      : streamSnapshot.data?.docs[index]['category'] as String == categoriesListAll[6]
                                                                          ? Icons.sign_language_rounded
                                                                          : streamSnapshot.data?.docs[index]['category'] as String == categoriesListAll[5]
                                                                              ? Icons.child_care_outlined
                                                                              : streamSnapshot.data?.docs[index]['category'] as String == categoriesListAll[7]
                                                                                  ? Icons.menu_book
                                                                                  : streamSnapshot.data?.docs[index]['category'] as String == categoriesListAll[8]
                                                                                      ? Icons.medical_information_outlined
                                                                                      : streamSnapshot.data?.docs[index]['category'] as String == categoriesListAll[0]
                                                                                          ? Icons.check_box
                                                                                          : Icons.new_label_sharp,
                                                      size: 30,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.65,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.12,
                                                    child: Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: ListTile(
                                                        title: Text(
                                                            streamSnapshot.data
                                                                        ?.docs[index]
                                                                    ['title']
                                                                as String,
                                                            style: GoogleFonts
                                                                .raleway(
                                                              fontSize: 14,
                                                              color:
                                                                  Colors.black,
                                                            )),
                                                        subtitle: Text(
                                                          "${"${streamSnapshot.data?.docs[index]['comment']}".substring(0, 30)}...",
                                                          style: GoogleFonts
                                                              .raleway(
                                                            fontSize: 13,
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.5),
                                                          ),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
