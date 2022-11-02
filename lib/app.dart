import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wol_pro_1/screens/intro_screen/option.dart';
import 'package:wol_pro_1/screens/menu/volunteer/home_page/settings/upload_photo.dart';
import 'package:wol_pro_1/screens/menu/volunteer/main_screen.dart';
import 'package:wol_pro_1/services/auth.dart';
import 'package:wol_pro_1/widgets/loading.dart';
import 'package:wol_pro_1/widgets/wrapper.dart';

import 'models/user.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool _isLoading = true;
  loadImage() async{

    DocumentSnapshot variable = await FirebaseFirestore.instance.
    collection('users').
    doc(FirebaseAuth.instance.currentUser!.uid).
    get();

    //a list of images names (i need only one)
    var img_url = variable['image'];
    //select the image url
    Reference  ref = FirebaseStorage.instance.ref().child("user_pictures/").child(img_url);

    //get image url from firebase storage
    var url = await ref.getDownloadURL();

    print("GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG");
    print(url);
    // put the URL in the state, so that the UI gets rerendered
    setState(() {
      url_image = url;
    });
  }
  late StreamSubscription<User?> user;

  void initState() {
    super.initState();
    user = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
        loadImage();

        Future.delayed(Duration(seconds: 2), () {
          setState(() {
            _isLoading = false;
            print("FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF");
            print(url_image);
          });
        });
      }
    });
  }

  @override
  void dispose() {
    user.cancel();
    super.dispose();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<Users?>.value(
      value: AuthService().user,
      initialData: null,
      child: MaterialApp(
        home: OptionChoose(),
        debugShowCheckedModeBanner: false,
        initialRoute: FirebaseAuth.instance.currentUser == null ? "OptionChoose()" : MainScreen().id,
        routes: {
          MainScreen().id: (context) => _isLoading?Loading():MainScreen(),
          "OptionChoose()": (context) => OptionChoose(),
        },
      ),
    );
  }
}

