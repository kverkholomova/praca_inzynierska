import 'package:file_picker/file_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:wol_pro_1/screens/menu/refugee/home_page/settings_ref/settings_ref_info.dart';

import 'package:wol_pro_1/screens/menu/volunteer/home_page/settings/settings_vol_info.dart';

import '../../../../../constants.dart';
import '../../main_screen_ref.dart';

String? url_image_ref;
String image_url_volunteer = '';
firebase_storage.FirebaseStorage storage =
    firebase_storage.FirebaseStorage.instance;

class ImageUploadsRef extends StatefulWidget {
  ImageUploadsRef({Key? key}) : super(key: key);

  @override
  _ImageUploadsRefState createState() => _ImageUploadsRefState();
}

class _ImageUploadsRefState extends State<ImageUploadsRef> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    foregroundMessage();
  }

  void foregroundMessage(){
    FirebaseMessaging.instance.getInitialMessage().then((_message){
      if(_message!=null)
      {
        // print("Background Notification");
        // final route=_message.data["route"];
        // navigateTo(route);
      } else{
        print("HHHHHHHHHHHHHHHHHHHEEEEEEEEEEEEELP");
        print(_message);
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          // if(message.notification!=null)
          // {
          //   // print("Foreground Notification :${message.notification!.title}");
          //   // FCM.init(message);
          // }
        });
      }
    });

  }

  PlatformFile? file;

  // Uint8List? fileBytes;
  Future selectFile() async {
    FilePickerResult? result =
    await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result != null) {
      setState(() {
        file = result.files.first;
        // fileBytes = file!.bytes;
        // await FirebaseStorage.instance.ref('uploads/${file!.name}').putData(fileBytes!);
      });

      print(file);
      print(file!.name);
      print(file!.readStream);
      print(file!.size);
      print(file!.extension);
      print(file!.path);

      final path = 'user_pictures/${file!.name}';
      final currentFile = File(file!.path!);

      final ref = FirebaseStorage.instance.ref().child(path);
      ref.putFile(currentFile);

      FirebaseFirestore.instance
          .collection('users')
          .doc(currentStreamSnapshotRef)
          .update({"image": file!.name});
      image_url_volunteer = file!.name;
    } else {
      // User canceled the picker
    }

  }


  loadImageRef() async {
    //select the image url
    Reference ref = FirebaseStorage.instance
        .ref()
        .child("user_pictures/")
        .child(image_url_volunteer);

    //get image url from firebase storage
    var url = await ref.getDownloadURL();

    print("GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG");
    print(url);
    // put the URL in the state, so that the UI gets rerendered
    setState(() {
      url_image_ref = url;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context, rootNavigator: true).pushReplacement(
            MaterialPageRoute(builder: (context) => SettingsRef()));
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
          floatingActionButton: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 30,
              color: redColor,
            ),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const SettingsRef()));
            },
          ),
          backgroundColor: backgroundRefugee,
          body: Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context)
                .size
                .width *
                0.1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                file != null
                    ? Expanded(
                    child: Container(
                      child:
                      // Text(pickedFile!.path!)
                      Image.file(
                        File(file!.path!),
                        // File(pickedFile!.path!),
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ))
                    : Expanded(
                    child: Container(
                      child: Center(
                        child: Text("Choose your avatar picture",
                          style: textCategoryStyle,
                        ),
                      ),
                    )),
                Padding(
                  padding: padding,
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.075,
                    decoration: buttonActiveDecorationRefugee,
                    child: TextButton(
                        onPressed: () {
                          selectFile();
                        },
                        child: Text(
                          "Select file",
                          style: textActiveButtonStyleRefugee,
                        )),
                  ),
                ),
                SizedBox(
                  height:
                  MediaQuery.of(context).size.height *
                      0.012,
                ),
                Padding(
                  padding: padding,
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.075,
                    decoration: buttonActiveDecorationRefugee,
                    child: TextButton(
                        onPressed: () {

                          setState(() {
                            loadImageRef();
                            controllerTabBottomRef = PersistentTabController(initialIndex: 2);
                          });

                          Future.delayed(const Duration(milliseconds: 500), () {
                            Navigator.of(context, rootNavigator: true).pushReplacement(
                                MaterialPageRoute(builder: (context) => new MainScreenRefugee()));
                          });
                        },
                        child: Text(
                          "Done",
                          style: textActiveButtonStyleRefugee,
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}