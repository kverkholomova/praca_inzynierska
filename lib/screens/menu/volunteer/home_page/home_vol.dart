import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:wol_pro_1/screens/intro_screen/option.dart';
import 'package:wol_pro_1/widgets/loading.dart';

import '../../../../constants.dart';
import '../../../../models/categories.dart';
import '../../../../widgets/wrapper.dart';

import 'categories/update_categories.dart';
import 'settings/settings_vol_info.dart';

bool isLoggedIn = true;
String tokenRefNotification = '';
String? currentNameVol = '';
List categoriesUserRegister = [];
String? tokenVol;

class HomeVol extends StatefulWidget {
  const HomeVol({Key? key}) : super(key: key);

  @override
  State<HomeVol> createState() => _HomeVolState();
}

class _HomeVolState extends State<HomeVol> {
  ScrollController scrollController = ScrollController();

  loadImage() async {
    DocumentSnapshot variable = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    //a list of images names (i need only one)
    var img_url = variable['image'];
    //select the image url
    Reference ref =
        FirebaseStorage.instance.ref().child("user_pictures/").child(img_url);

    //get image url from firebase storage
    var url = await ref.getDownloadURL();

    // put the URL in the state, so that the UI gets rerendered
    setState(() {
      url_image = url;
    });
  }

  storeNotificationToken() async {
    String? token_v = await FirebaseMessaging.instance.getToken();

    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({'token_vol': token_v}, SetOptions(merge: true));
  }

  bool scrolled = false;

  late StreamSubscription<User?> user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // print("TTTTTime");
    // print(DateTime.now().toString());
    loadImage();
    // scrollControllerVol.jumpTo(scrollControllerVol.positions.last.maxScrollExtent);
    scrollController.addListener(scrollListener);
    FirebaseMessaging.instance.getInitialMessage();
    storeNotificationToken();

    setState(() {
      user = FirebaseAuth.instance.authStateChanges().listen((user) async {
        // loadImage();
        DocumentSnapshot variable = await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get();

        var cList = variable["category"];
        cList.forEach((element) {
          if (categoriesUpdated.contains(element)) {
          } else {
            categoriesUpdated.add(element);
          }
        });
      });
    });
  }

  scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      setState(() {
        scrolled = true;
      });
    }
    if (scrollController.offset <= scrollController.position.minScrollExtent &&
        !scrollController.position.outOfRange) {
      setState(() {
        scrolled = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();

        return true;
      },
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: background,
          body: SingleChildScrollView(
            controller: scrollController,
            child: Column(
              children: <Widget>[
                ClipPath(
                  clipper: OvalBottomBorderClipper(),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.43,
                    decoration: BoxDecoration(
                      color: blueColor,
                    ),
                    child: Align(
                        alignment: AlignmentDirectional.center,
                        child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .where('id_vol',
                                  isEqualTo:
                                      FirebaseAuth.instance.currentUser?.uid)
                              .snapshots(),
                          builder: (context,
                              AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                            return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: !streamSnapshot.hasData
                                    ? 1
                                    : streamSnapshot.data?.docs.length,
                                itemBuilder: (ctx, index) {
                                  tokenVol = streamSnapshot.data?.docs[index]
                                      ['token_vol'];
                                  currentNameVol = streamSnapshot
                                      .data?.docs[index]['user_name'];

                                  // if (streamSnapshot.hasData) {
                                  switch (streamSnapshot.connectionState) {
                                    case ConnectionState.waiting:
                                      return const SizedBox(
                                        width: 60,
                                        height: 60,
                                        child: Loading(),
                                      );

                                    case ConnectionState.active:
                                      return Padding(
                                        padding: const EdgeInsets.only(top: 20),
                                        child: Column(
                                          children: [
                                            SizedBox(
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.4,
                                              child: url_image == ""
                                                  ? const Image(
                                                      image: AssetImage(
                                                          "assets/user.png"))
                                                  : CircleAvatar(
                                                      radius: 80.0,
                                                      backgroundImage:
                                                          NetworkImage(url_image
                                                              .toString())),
                                            ),
                                            Align(
                                              alignment: Alignment.topCenter,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                      streamSnapshot
                                                              .data?.docs[index]
                                                          ['user_name'],
                                                      style:
                                                          GoogleFonts.raleway(
                                                        fontSize: 24,
                                                        color: Colors.white,
                                                      )),
                                                  IconButton(
                                                    icon: const Icon(
                                                      Icons.edit,
                                                      color: Colors.white,
                                                    ),
                                                    onPressed: () {
                                                      Future.delayed(
                                                          const Duration(
                                                              milliseconds:
                                                                  500), () {
                                                        Navigator.of(context,
                                                                rootNavigator:
                                                                    true)
                                                            .pushReplacement(
                                                                MaterialPageRoute(
                                                                    builder:
                                                                        (context) =>
                                                                            const SettingsVol()));
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.02),
                                              child: Align(
                                                alignment: Alignment.topCenter,
                                                child: Text(
                                                    "${streamSnapshot.data?.docs[index]['age'] == 0 ? "Your profile isn't completed" : streamSnapshot.data?.docs[index]['age']}",
                                                    style: GoogleFonts.raleway(
                                                      fontSize: 15,
                                                      color: Colors.white,
                                                    )),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.02),
                                              child: Align(
                                                alignment: Alignment.topCenter,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    streamSnapshot.data?.docs[
                                                                        index][
                                                                    'ranking'] /
                                                                streamSnapshot
                                                                        .data
                                                                        ?.docs[index]
                                                                    [
                                                                    'num_ranking'] >=
                                                            1
                                                        ? Icon(
                                                            Icons.star,
                                                            color: Colors.white,
                                                            size: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.06,
                                                          )
                                                        : streamSnapshot.data?.docs[
                                                                            index]
                                                                        [
                                                                        'ranking'] /
                                                                    streamSnapshot
                                                                            .data
                                                                            ?.docs[index]
                                                                        ['num_ranking'] ==
                                                                0.5
                                                            ? Icon(
                                                                Icons.star_half,
                                                                color: Colors
                                                                    .white,
                                                                size: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.06,
                                                              )
                                                            : Icon(
                                                                Icons
                                                                    .star_border,
                                                                color: Colors
                                                                    .white,
                                                                size: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.06,
                                                              ),
                                                    streamSnapshot.data?.docs[
                                                                        index][
                                                                    'ranking'] /
                                                                streamSnapshot
                                                                        .data
                                                                        ?.docs[index]
                                                                    [
                                                                    'num_ranking'] >=
                                                            2
                                                        ? Icon(
                                                            Icons.star_rate,
                                                            color: Colors.white,
                                                            size: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.06,
                                                          )
                                                        : streamSnapshot.data?.docs[
                                                                            index]
                                                                        [
                                                                        'ranking'] /
                                                                    streamSnapshot
                                                                            .data
                                                                            ?.docs[index]
                                                                        ['num_ranking'] ==
                                                                1.5
                                                            ? Icon(
                                                                Icons.star_half,
                                                                color: Colors
                                                                    .white,
                                                                size: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.06,
                                                              )
                                                            : Icon(
                                                                Icons
                                                                    .star_border,
                                                                color: Colors
                                                                    .white,
                                                                size: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.06,
                                                              ),
                                                    streamSnapshot.data?.docs[
                                                                        index][
                                                                    'ranking'] /
                                                                streamSnapshot
                                                                        .data
                                                                        ?.docs[index]
                                                                    [
                                                                    'num_ranking'] >=
                                                            3
                                                        ? Icon(
                                                            Icons.star_rate,
                                                            color: Colors.white,
                                                            size: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.06,
                                                          )
                                                        : streamSnapshot.data?.docs[
                                                                            index]
                                                                        [
                                                                        'ranking'] /
                                                                    streamSnapshot
                                                                            .data
                                                                            ?.docs[index]
                                                                        ['num_ranking'] ==
                                                                2.5
                                                            ? Icon(
                                                                Icons.star_half,
                                                                color: Colors
                                                                    .white,
                                                                size: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.06,
                                                              )
                                                            : Icon(
                                                                Icons
                                                                    .star_border,
                                                                color: Colors
                                                                    .white,
                                                                size: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.06,
                                                              ),
                                                    streamSnapshot.data?.docs[
                                                                        index][
                                                                    'ranking'] /
                                                                streamSnapshot
                                                                        .data
                                                                        ?.docs[index]
                                                                    [
                                                                    'num_ranking'] >=
                                                            4
                                                        ? Icon(
                                                            Icons.star_rate,
                                                            color: Colors.white,
                                                            size: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.06,
                                                          )
                                                        : streamSnapshot.data?.docs[
                                                                            index]
                                                                        [
                                                                        'ranking'] /
                                                                    streamSnapshot
                                                                            .data
                                                                            ?.docs[index]
                                                                        ['num_ranking'] ==
                                                                3.5
                                                            ? Icon(
                                                                Icons.star_half,
                                                                color: Colors
                                                                    .white,
                                                                size: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.06,
                                                              )
                                                            : Icon(
                                                                Icons
                                                                    .star_border,
                                                                color: Colors
                                                                    .white,
                                                                size: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.06,
                                                              ),
                                                    streamSnapshot.data?.docs[
                                                                        index][
                                                                    'ranking'] /
                                                                streamSnapshot
                                                                        .data
                                                                        ?.docs[index]
                                                                    [
                                                                    'num_ranking'] >=
                                                            5
                                                        ? Icon(
                                                            Icons.star_rate,
                                                            color: Colors.white,
                                                            size: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.06,
                                                          )
                                                        : streamSnapshot.data?.docs[
                                                                            index]
                                                                        [
                                                                        'ranking'] /
                                                                    streamSnapshot
                                                                            .data
                                                                            ?.docs[index]
                                                                        ['num_ranking'] ==
                                                                4.5
                                                            ? Icon(
                                                                Icons.star_half,
                                                                color: Colors
                                                                    .white,
                                                                size: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.06,
                                                              )
                                                            : Icon(
                                                                Icons
                                                                    .star_border,
                                                                color: Colors
                                                                    .white,
                                                                size: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    0.06,
                                                              ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 250,
                                            ),
                                          ],
                                        ),
                                      );
                                    case ConnectionState.none:
                                      // TODO: Handle this case.
                                      break;
                                    case ConnectionState.done:
                                      // TODO: Handle this case.
                                      break;
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
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.012,
                ),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: padding,
                    child: Text(
                      "Preferencies",
                      style: GoogleFonts.raleway(
                        fontSize: 18,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                SizedBox(
                  height: categoriesVolunteer.length == 1
                      ? MediaQuery.of(context).size.height * 0.15
                      : categoriesVolunteer.length == 2
                          ? MediaQuery.of(context).size.height * 0.2
                          : categoriesVolunteer.length == 3
                              ? MediaQuery.of(context).size.height * 0.3
                              : categoriesVolunteer.length == 4
                                  ? MediaQuery.of(context).size.height * 0.4
                                  : categoriesVolunteer.length == 5
                                      ? MediaQuery.of(context).size.height * 0.5
                                      : categoriesVolunteer.length == 6
                                          ? MediaQuery.of(context).size.height *
                                              0.6
                                          : categoriesVolunteer.length == 7
                                              ? MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.7
                                              : categoriesVolunteer.length == 8
                                                  ? MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.8
                                                  : MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.1,
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .where('id_vol',
                              isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                          .snapshots(),
                      builder: (context,
                          AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                        if (streamSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Loading();
                        } else if (streamSnapshot.connectionState ==
                            ConnectionState.done) {
                          return const Text('done');
                        } else if (streamSnapshot.hasError) {
                          return const Text('Error!');
                        } else {
                          return ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: categoriesVolunteer.length,
                              itemBuilder: (ctx, index) {
                                return Column(
                                  children: [
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.015,
                                    ),
                                    Padding(
                                      padding: padding,
                                      child: Container(
                                        width: double.infinity,
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.085,
                                        decoration: categoryDecoration,
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                left: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.05,
                                                right: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.04,
                                              ),
                                              child: Icon(
                                                categoriesVolunteer[index] ==
                                                        categoriesListAll[3]
                                                    ? Icons.pets_rounded
                                                    : categoriesVolunteer[
                                                                index] ==
                                                            categoriesListAll[4]
                                                        ? Icons
                                                            .local_grocery_store
                                                        : categoriesVolunteer[
                                                                    index] ==
                                                                categoriesListAll[
                                                                    2]
                                                            ? Icons
                                                                .emoji_transportation_rounded
                                                            : categoriesVolunteer[
                                                                        index] ==
                                                                    categoriesListAll[
                                                                        1]
                                                                ? Icons.house
                                                                : categoriesVolunteer[
                                                                            index] ==
                                                                        categoriesListAll[
                                                                            6]
                                                                    ? Icons
                                                                        .sign_language_rounded
                                                                    : categoriesVolunteer[index] ==
                                                                            categoriesListAll[
                                                                                5]
                                                                        ? Icons
                                                                            .child_care_outlined
                                                                        : categoriesVolunteer[index] ==
                                                                                categoriesListAll[7]
                                                                            ? Icons.menu_book
                                                                            : categoriesVolunteer[index] == categoriesListAll[8]
                                                                                ? Icons.medical_information_outlined
                                                                                : categoriesVolunteer[index] == categoriesListAll[0]
                                                                                    ? Icons.check_box
                                                                                    : Icons.new_label_sharp,
                                                size: 30,
                                                color: Colors.black,
                                              ),
                                            ),
                                            Text(
                                              categoriesVolunteer[index]
                                                  .toString(),
                                              style: textCategoryStyle,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              });
                        }
                      }),
                ),
                Align(
                  alignment: Alignment.center,
                  child: TextButton.icon(
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true)
                          .pushReplacement(MaterialPageRoute(
                              builder: (context) => const ManageCategories()));
                    },
                    icon: const Icon(
                      Icons.manage_accounts_rounded,
                      color: Colors.black,
                      size: 30,
                    ),
                    label: Text(
                      "Manage your preferences",
                      style: GoogleFonts.raleway(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: categoriesVolunteer.length == 1
                      ? MediaQuery.of(context).size.height * 0.012
                      : categoriesVolunteer.length == 2
                          ? MediaQuery.of(context).size.height * 0.012
                          : categoriesVolunteer.length == 3
                              ? MediaQuery.of(context).size.height * 0.012
                              : categoriesVolunteer.length == 4
                                  ? MediaQuery.of(context).size.height * 0.012
                                  : MediaQuery.of(context).size.height * 0.012,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
