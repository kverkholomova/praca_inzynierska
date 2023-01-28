import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:wol_pro_1/screens/menu/volunteer/main_screen.dart';

import '../../../../../constants.dart';
import '../../../../../models/categories.dart';
import '../../../../../widgets/loading.dart';
import '../../../../intro_screen/option.dart';

List categoriesUpdated = [];

class ManageCategories extends StatefulWidget {
  const ManageCategories({
    Key? key,
  }) : super(key: key);

  @override
  _ManageCategoriesState createState() => _ManageCategoriesState();
}

class _ManageCategoriesState extends State<ManageCategories> {
  // final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;
  bool chosen = false;

  // text field state
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
        setState(() {
          controllerTabBottomVol = PersistentTabController(initialIndex: 2);
        });

        Navigator.of(context, rootNavigator: true).pushReplacement(
            MaterialPageRoute(builder: (context) => MainScreen()));

        return true;
      },
      child: loading
          ? const Loading()
          : SafeArea(
              child: Scaffold(
                resizeToAvoidBottomInset: true,
                backgroundColor: background,
                appBar: AppBar(
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  leading: IconButton(
                      onPressed: () {
                        setState(() {
                          controllerTabBottomVol =
                              PersistentTabController(initialIndex: 2);
                        });

                        Navigator.of(context, rootNavigator: true)
                            .pushReplacement(MaterialPageRoute(
                                builder: (context) => MainScreen()));
                      },
                      icon: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: blueColor,
                      )),
                ),
                body: SingleChildScrollView(
                  dragStartBehavior: DragStartBehavior.down,
                  scrollDirection: Axis.vertical,
                  child: Padding(
                    padding: padding,
                    child: Column(
                      children: [
                        Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 45),
                                child: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        "Your preferencies",
                                        style: GoogleFonts.raleway(
                                          fontSize: 25,
                                          color: Colors.black,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 7),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          "Choose at least one category,",
                                          style: GoogleFonts.raleway(
                                            fontSize: 14,
                                            color: Colors.black,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        "where you would help.",
                                        style: GoogleFonts.raleway(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                        textAlign: TextAlign.left,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  buildCategory(context, categoriesListAll[1],
                                      Icons.house),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.012,
                                  ),
                                  buildCategory(
                                    context,
                                    categoriesListAll[2],
                                    Icons.emoji_transportation_rounded,
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.012,
                                  ),
                                  buildCategory(context, categoriesListAll[3],
                                      Icons.pets_rounded),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.012,
                                  ),
                                  buildCategory(
                                    context,
                                    categoriesListAll[4],
                                    Icons.local_grocery_store_rounded,
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.012,
                                  ),
                                  buildCategory(context, categoriesListAll[5],
                                      Icons.child_care_rounded),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.012,
                                  ),
                                  buildCategory(context, categoriesListAll[6],
                                      Icons.sign_language_rounded),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.012,
                                  ),
                                  buildCategory(context, categoriesListAll[7],
                                      Icons.menu_book),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.012,
                                  ),
                                  buildCategory(context, categoriesListAll[8],
                                      Icons.medical_information_outlined),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.02,
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.09,
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: StreamBuilder(
                                          stream: FirebaseFirestore.instance
                                              .collection('users')
                                              .where('id_vol',
                                                  isEqualTo: FirebaseAuth
                                                      .instance
                                                      .currentUser
                                                      ?.uid)
                                              .snapshots(),
                                          builder: (context,
                                              AsyncSnapshot<QuerySnapshot>
                                                  streamSnapshot) {
                                            return ListView.builder(
                                                itemCount:
                                                    !streamSnapshot.hasData
                                                        ? 1
                                                        : streamSnapshot
                                                            .data?.docs.length,
                                                itemBuilder: (ctx, index) {
                                                  return Container(
                                                    width: double.infinity,
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.085,
                                                    decoration:
                                                        buttonActiveDecoration,
                                                    child: TextButton(
                                                        child: Text(
                                                          "Done",
                                                          style:
                                                              textActiveButtonStyle,
                                                        ),
                                                        onPressed: () {
                                                          if (categoriesUpdated
                                                              .isEmpty) {
                                                            dialogBuilderEmpty(
                                                                context);
                                                          } else {
                                                            dialogBuilder(
                                                                context);
                                                          }
                                                        }),
                                                  );
                                                });
                                          }),
                                    ),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.015,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  String listTileBuilder() {
    String listTile = '';
    for (int i = 0; i < categoriesUpdated.length; i++) {
      if (categoriesUpdated.length == 1) {
        listTile += categoriesUpdated[i];
      } else {
        if (categoriesUpdated.length - 1 == i) {
          listTile += categoriesUpdated[i];
        } else {
          listTile += "${categoriesUpdated[i]}\n";
        }
      }
    }
    return listTile;
  }

  Future<void> dialogBuilderEmpty(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text('Choose your categories'),
          titleTextStyle: GoogleFonts.raleway(
            fontSize: 16,
            color: blueColor,
          ),
          content: const Text(
              "You haven't chosen any category, please supply any category"
              ' or leave your previous preferences'),
          contentTextStyle: GoogleFonts.raleway(
            fontSize: 14,
            color: blueColor,
          ),
          actions: <Widget>[
            SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.085,
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .where('id_vol',
                          isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                      .snapshots(),
                  builder:
                      (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                    return ListView.builder(
                        itemCount: !streamSnapshot.hasData
                            ? 1
                            : streamSnapshot.data?.docs.length,
                        itemBuilder: (ctx, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: SizedBox(
                              width: double.infinity,
                              height:
                                  MediaQuery.of(context).size.height * 0.085,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: blueColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                ),
                                child: Text(
                                  'Choose category',
                                  style: textActiveButtonStyle,
                                ),
                              ),
                            ),
                          );
                        });
                  }),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.085,
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .where('id_vol',
                          isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                      .snapshots(),
                  builder:
                      (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                    return ListView.builder(
                        itemCount: !streamSnapshot.hasData
                            ? 1
                            : streamSnapshot.data?.docs.length,
                        itemBuilder: (ctx, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: SizedBox(
                              width: double.infinity,
                              height:
                                  MediaQuery.of(context).size.height * 0.085,
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    controllerTabBottomVol =
                                        PersistentTabController(
                                            initialIndex: 2);
                                  });

                                  Future.delayed(
                                      const Duration(milliseconds: 500), () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MainScreen()));
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: blueColor,
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    side:
                                        BorderSide(width: 1, color: blueColor),
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                ),
                                child: Text(
                                  'Leave previous',
                                  style: textInactiveButtonStyle,
                                ),
                              ),
                            ),
                          );
                        });
                  }),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
          ],
        );
      },
    );
  }

  Future<String?> dialogBuilder(BuildContext context) {
    return showDialog<String?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text('Verify your choice'),
          titleTextStyle: GoogleFonts.raleway(
            fontSize: 16,
            color: blueColor,
          ),
          content: Text(
              "You chose categories that refer to:\n\n${listTileBuilder()}\n"),
          contentTextStyle: GoogleFonts.raleway(
            fontSize: 14,
            color: blueColor,
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.085,
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .where('id_vol',
                          isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                      .snapshots(),
                  builder:
                      (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                    return ListView.builder(
                        itemCount: !streamSnapshot.hasData
                            ? 1
                            : streamSnapshot.data?.docs.length,
                        itemBuilder: (ctx, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: SizedBox(
                              width: double.infinity,
                              height:
                                  MediaQuery.of(context).size.height * 0.085,
                              child: ElevatedButton(
                                onPressed: () {
                                  FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(streamSnapshot.data?.docs[index].id)
                                      .update({"category": categoriesUpdated});
                                  categoriesVolunteer = categoriesUpdated;

                                  categoriesUpdated = [];

                                  Future.delayed(const Duration(seconds: 1),
                                      () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MainScreen()));
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: blueColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                ),
                                child: Text(
                                  'Save my changes',
                                  style: textActiveButtonStyle,
                                ),
                              ),
                            ),
                          );
                        });
                  }),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.085,
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .where('id_vol',
                          isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                      .snapshots(),
                  builder:
                      (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                    return ListView.builder(
                        itemCount: !streamSnapshot.hasData
                            ? 1
                            : streamSnapshot.data?.docs.length,
                        itemBuilder: (ctx, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: SizedBox(
                              width: double.infinity,
                              height:
                                  MediaQuery.of(context).size.height * 0.085,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: blueColor,
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    side:
                                        BorderSide(width: 1, color: blueColor),
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                ),
                                child: Text(
                                  'Change my choice',
                                  style: textInactiveButtonStyle,
                                ),
                              ),
                            ),
                          );
                        });
                  }),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
          ],
        );
      },
    );
  }

  GestureDetector buildCategory(
      BuildContext context, String text, IconData icon) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (categoriesUpdated.contains(text)) {
            categoriesUpdated.remove(text);
          } else {
            categoriesUpdated.add(text);
          }
        });
      },
      child: AnimatedContainer(
        height: MediaQuery.of(context).size.height * 0.085,
        duration: const Duration(milliseconds: 500),
        decoration: BoxDecoration(
          border: Border.all(
            color: categoriesUpdated.contains(text) ? blueColor : Colors.white,
            width: 2,
          ),
          // color: categoriesVolunteer.contains(text) ? blueColor : Colors.white,
          borderRadius: const BorderRadius.all(
            Radius.circular(18),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.05,
                    right: MediaQuery.of(context).size.width * 0.04,
                  ),
                  child: Icon(
                    icon,
                    size: 30,
                    color: Colors.black,
                  ),
                ),
                Text(
                  text,
                  style: GoogleFonts.raleway(
                    fontSize: 15,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            categoriesUpdated.contains(text)
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child:
                        Icon(Icons.check_rounded, size: 30, color: blueColor),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
