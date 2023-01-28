import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:wol_pro_1/screens/menu/refugee/home_page/settings_ref/settings_ref_info.dart';
import 'package:wol_pro_1/widgets/wrapper.dart';

import '../../../../constants.dart';

import '../../../../widgets/loading.dart';
import 'create_application/create_application.dart';

String? currentNameRef = '';
String? tokenVolApplication;

class HomeRef extends StatefulWidget {
  const HomeRef({Key? key}) : super(key: key);

  @override
  State<HomeRef> createState() => _HomeRefState();
}

class _HomeRefState extends State<HomeRef> {
  loadImageRef() async {
    DocumentSnapshot variable = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    //a list of images names (i need only one)
    var img_urlRef = variable['image'];
    //select the image url
    Reference ref = FirebaseStorage.instance
        .ref()
        .child("user_pictures/")
        .child(img_urlRef);

    //get image url from firebase storage
    var urlRef = await ref.getDownloadURL();

    // put the URL in the state, so that the UI gets rerendered
    setState(() {
      urlImageRefugee = urlRef;
    });
  }

  storeNotificationToken() async {
    String? token_v = await FirebaseMessaging.instance.getToken();

    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({'token_ref': token_v}, SetOptions(merge: true));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // foregroundMessage();
    loadImageRef();
    storeNotificationToken();
    FirebaseMessaging.instance.getInitialMessage();

    FirebaseMessaging.instance.subscribeToTopic('subscription');
  }

  // final AuthService _auth = AuthService();

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
          backgroundColor: backgroundRefugee,
          body: Column(
            mainAxisSize: MainAxisSize.min,
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
                  height: MediaQuery.of(context).size.height * 0.47,
                  child: Center(
                      child: Padding(
                    padding: const EdgeInsets.only(bottom: 50),
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .where('id_vol',
                              isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                          .snapshots(),
                      builder: (context,
                          AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                        return ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: !streamSnapshot.hasData
                                ? 1
                                : streamSnapshot.data?.docs.length,
                            itemBuilder: (ctx, index) {
                              switch (streamSnapshot.connectionState) {
                                case ConnectionState.waiting:
                                  return const LoadingRefugee();

                                case ConnectionState.active:
                                  currentNameRef = streamSnapshot
                                      .data?.docs[index]['user_name'];
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.4,
                                          child: urlImageRefugee == ""
                                              ? const Image(
                                                  image: AssetImage(
                                                      "assets/user.png"))
                                              : CircleAvatar(
                                                  backgroundColor:
                                                      const Color.fromRGBO(
                                                          182, 33, 53, 90),
                                                  radius: 80.0,
                                                  backgroundImage: NetworkImage(
                                                      urlImageRefugee
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
                                                  style: GoogleFonts.raleway(
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
                                                          milliseconds: 300),
                                                      () {
                                                    Navigator.of(context,
                                                            rootNavigator: true)
                                                        .pushReplacement(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        const SettingsRef()));
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
                                                "${streamSnapshot.data?.docs[index]['age'] == 0 ? "Please add your age" : streamSnapshot.data?.docs[index]['age']}",
                                                style: GoogleFonts.raleway(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                )),
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
                              // } else {}
                              return const LoadingRefugee();
                            });
                      },
                    ),
                  )),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .where('id_vol',
                          isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                      .snapshots(),
                  builder:
                      (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                    return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: !streamSnapshot.hasData
                            ? 1
                            : streamSnapshot.data?.docs.length,
                        itemBuilder: (ctx, index) {
                          switch (streamSnapshot.connectionState) {
                            case ConnectionState.waiting:
                              return Column(children: const [
                                Padding(
                                  padding: EdgeInsets.only(top: 16),
                                  child: Text(''),
                                )
                              ]);
                            case ConnectionState.active:
                              return Align(
                                alignment: Alignment.center,
                                child: TextButton.icon(
                                  onPressed: () {
                                    tokenRefApplication = streamSnapshot
                                        .data?.docs[index]['token_ref'];

                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const Application()));
                                  },
                                  icon: const Icon(
                                    Icons.add,
                                    color: Colors.black,
                                    size: 30,
                                  ),
                                  label: Text(
                                    "Add new application",
                                    style: GoogleFonts.raleway(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
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
                                  SpinKitChasingDots(
                                    color: Colors.brown,
                                    size: 50.0,
                                  ),
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
            ],
          ),
        ),
      ),
    );
  }
}
