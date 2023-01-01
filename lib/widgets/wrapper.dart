import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wol_pro_1/screens/menu/welcome_screen.dart';
import 'package:wol_pro_1/screens/register_login/refugee/login/sign_in_refugee.dart';
import 'package:wol_pro_1/screens/register_login/refugee/onboarding_ref.dart';
import 'package:wol_pro_1/screens/register_login/volunteer/onboarding_register_vol.dart';
import 'package:wol_pro_1/to_delete/SettingRefugee.dart';
import 'package:wol_pro_1/screens/register_login/volunteer/login/sign_in_volunteer.dart';
import 'package:wol_pro_1/to_delete/register_refugee.dart';
import 'package:wol_pro_1/screens/menu/refugee/main_screen_ref.dart';
import 'package:wol_pro_1/screens/menu/volunteer/main_screen.dart';
import 'package:wol_pro_1/screens/register_login/volunteer/register/categories_choose.dart';
import 'package:wol_pro_1/screens/register_login/volunteer/register/register_volunteer_1.dart';
import 'package:wol_pro_1/widgets/authenticate.dart';
import 'package:wol_pro_1/screens/intro_screen/option.dart';
import 'package:wol_pro_1/widgets/loading.dart';

import '../models/user.dart';
import '../screens/menu/volunteer/home_page/home_vol.dart';
import '../screens/menu/volunteer/home_page/settings/upload_photo.dart';

String url_image = '';
class Wrapper extends StatefulWidget {
  Wrapper({Key? key}) : super(key: key);

  @override
  State<Wrapper> createState() => _WrapperState();
}
bool _isLoading = true;
class _WrapperState extends State<Wrapper> {

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
  void initState(){
    super.initState();

    // if(justSignedIn){
    //
    // }
    user = FirebaseAuth.instance.authStateChanges().listen((user) async {

      DocumentSnapshot variable = await FirebaseFirestore.instance.
      collection('users').
      doc(FirebaseAuth.instance.currentUser!.uid).
      get();
      var image = variable["image"];
      print("IIIIIIIIIIIImageeeeeeeeeeeeeee");
      print(image);
      if(image!=''){
        print("IIIIIIIIIIIImageeeeeeeeeeeeeee2222222222222");
        print(image);
        loadImage();
      }
      var currentRole = variable['role'];
      print("CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCWraper");
      print(variable["category"]);
      print(FirebaseAuth.instance.currentUser!.uid);
      categoriesVolunteer = [];
      var cList = variable["category"];
      cList.forEach((element) {
        categoriesVolunteer.add(element);
      });
      // categoriesVolunteer
      //     .add(variable["category"][0]);
      print(categoriesVolunteer);
      setState(() {
        if(currentRole=='1'){
          optionRefugee = false;
          print(11111111111111);
          print(currentRole);
          print(optionRefugee);
        } else{
          optionRefugee = true;
          print(22222222222222);
          print(currentRole);
          print(optionRefugee);
        }
      });

    });
    Future.delayed(Duration(seconds: 5), () {
      setState(() {
        _isLoading = false;
      });
    });

  }

  String id = "wrapper";

  @override
  Widget build(BuildContext context) {

    final user=Provider.of<Users?>(context);
    if (user==null){
      return Authenticate();
    } else if(optionRefugee){
      return signInRef?WelcomeScreen():OnBoardingRefugee();
    }else if(!optionRefugee){
      // return SettingsHomeVol();
      return registrationVol?ChooseCategory():!_isLoading?WelcomeScreen():Loading();
      // return registrationVol?ChooseCategory():!_isLoading?MainScreen():Loading();

    }
    else{
      return OptionChoose();
    }
    //return either Home or Return Widget

  }
}
