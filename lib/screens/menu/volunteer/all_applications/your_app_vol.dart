import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:wol_pro_1/constants.dart';
import 'package:wol_pro_1/screens/intro_screen/option.dart';

import '../../../../models/categories.dart';
import '../main_screen.dart';
import 'chosen_category_applications.dart';
import 'new_screen_with_applications.dart';
import '../home_page/home_vol.dart';
import 'page_of_application_vol.dart';

bool myCategories = true;
String cardTitle = '';
String cardCategory = '';
String cardComment = '';
String userID_vol = '';

List<String> chosen_category_settings = [];

class YourCategories extends StatefulWidget {
  const YourCategories({Key? key}) : super(key: key);

  @override
  State createState() => YourCategoriesState();
}

class YourCategoriesState extends State<YourCategories> {
  FirebaseFirestore db = FirebaseFirestore.instance;

  bool loading = false;
  final CollectionReference applications =
      FirebaseFirestore.instance.collection("applications");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        setState(() {
          controllerTabBottomVol = PersistentTabController(initialIndex: 4);
        });
        Navigator.of(context, rootNavigator: true).pushReplacement(
            MaterialPageRoute(builder: (context) => MainScreen()));
        return true;
      },
      child: Scaffold(
        backgroundColor: background,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 30,
              color: blueColor,
            ),
            onPressed: () {
              setState(() {
                controllerTabBottomVol =
                    PersistentTabController(initialIndex: 4);
              });
              Navigator.of(context, rootNavigator: true).pushReplacement(
                  MaterialPageRoute(builder: (context) => MainScreen()));
            },
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Align(
            alignment: Alignment.topLeft,
            child: Text(
              "Choose an application",
              style: GoogleFonts.raleway(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                  height: MediaQuery.of(context).size.height * 0.85,
                  child: StreamBuilder(
                    stream: applications
                        .where("status", isEqualTo: 'Sent to volunteer')
                        .where("category", whereIn: categoriesVolunteer)
                        .snapshots(),
                    builder: (context,
                        AsyncSnapshot<QuerySnapshot?> streamSnapshot) {
                      return ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: streamSnapshot.data?.docs.length,
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
                                              FirebaseFirestore.instance
                                                  .collection('applications')
                                                  .doc(streamSnapshot
                                                  .data?.docs[index].id)
                                                  .update({
                                                "Id": streamSnapshot
                                                    .data!.docs[index].id,
                                              });
                                              tokenRefNotification =
                                                  streamSnapshot
                                                          .data?.docs[index]
                                                      ['token_ref'];
                                              myCategories = true;
                                              idCurrentApplicationInfo = streamSnapshot
                                                  .data!.docs[index].id;
                                              print("Tatatatatawawawawawa");
                                              print(idCurrentApplicationInfo);
                                              // cardTitleVol = streamSnapshot
                                              //         .data?.docs[index]
                                              //     ['title'] as String;
                                              // cardCategoryVol = streamSnapshot
                                              //         .data?.docs[index]
                                              //     ['category'] as String;
                                              // cardCommentVol = streamSnapshot
                                              //         .data?.docs[index]
                                              //     ['comment'] as String;

                                              // Id_Of_current_application =
                                              //     streamSnapshot
                                              //         .data?.docs[index].id;
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const PageOfApplication()),
                                              );
                                            });
                                          },
                                          child: Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(18)),
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.015),
                                                  child: Icon(
                                                    streamSnapshot.data?.docs[index]
                                                                    ['category']
                                                                as String ==
                                                            categoriesListAll[3]
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
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.75,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.12,
                                                  child: Align(
                                                    alignment:
                                                        Alignment.topCenter,
                                                    child: ListTile(
                                                      // mainAxisAlignment: MainAxisAlignment.start,
                                                      contentPadding:
                                                          const EdgeInsets
                                                                  .symmetric(
                                                              vertical: 4),
                                                      title: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 12),
                                                        child: Text(
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
                                                      ),
                                                      subtitle: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 12),
                                                        child: Text(
                                                          "${"${streamSnapshot.data?.docs[index]['comment']}".substring(0, 22)}...",
                                                          style: GoogleFonts
                                                              .raleway(
                                                            fontSize: 12,
                                                            color: Colors.black
                                                                .withOpacity(
                                                                    0.5),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
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
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
