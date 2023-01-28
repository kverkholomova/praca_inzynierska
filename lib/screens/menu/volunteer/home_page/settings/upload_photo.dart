import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:wol_pro_1/screens/menu/volunteer/home_page/settings/settings_vol_info.dart';

import '../../../../../constants.dart';
import '../../../../../widgets/wrapper.dart';
import '../../main_screen.dart';

String image_url_volunteer = '';
firebase_storage.FirebaseStorage storage =
    firebase_storage.FirebaseStorage.instance;

class ImageUploads extends StatefulWidget {
  const ImageUploads({Key? key}) : super(key: key);

  @override
  _ImageUploadsState createState() => _ImageUploadsState();
}

class _ImageUploadsState extends State<ImageUploads> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // foregroundMessage();
  }

  PlatformFile? file;

  // Uint8List? fileBytes;
  Future selectFile() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result != null) {
      setState(() {
        file = result.files.first;
      });

      final path = 'user_pictures/${file!.name}';
      final currentFile = File(file!.path!);

      final ref = FirebaseStorage.instance.ref().child(path);
      ref.putFile(currentFile);

      FirebaseFirestore.instance
          .collection('users')
          .doc(currentStreamSnapshot)
          .update({"image": file!.name});
      image_url_volunteer = file!.name;
    } else {
      // User canceled the picker
    }
  }

  loadImage() async {
    //select the image url
    Reference ref = FirebaseStorage.instance
        .ref()
        .child("user_pictures/")
        .child(image_url_volunteer);

    //get image url from firebase storage
    var url = await ref.getDownloadURL();

    // put the URL in the state, so that the UI gets rerendered
    setState(() {
      url_image = url;
    });
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
      child: SafeArea(
        child: Scaffold(
          floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
          floatingActionButton: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 30,
              color: blueColor,
            ),
            onPressed: () {
              setState(() {
                controllerTabBottomVol =
                    PersistentTabController(initialIndex: 2);
              });
              Navigator.of(context, rootNavigator: true).pushReplacement(
                  MaterialPageRoute(builder: (context) => MainScreen()));
            },
          ),
          backgroundColor: background,
          body: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.width * 0.1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                file != null
                    ? Expanded(
                        child: Image.file(
                        File(file!.path!),
                        // File(pickedFile!.path!),
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ))
                    : Expanded(
                        child: Center(
                        child: Text(
                          "Choose your avatar picture",
                          style: textCategoryStyle,
                        ),
                      )),
                Padding(
                  padding: padding,
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.075,
                    decoration: buttonActiveDecoration,
                    child: TextButton(
                        onPressed: () {
                          selectFile();
                        },
                        child: Text(
                          "Select file",
                          style: textActiveButtonStyle,
                        )),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.012,
                ),
                Padding(
                  padding: padding,
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.075,
                    decoration: buttonActiveDecoration,
                    child: TextButton(
                        onPressed: () {
                          setState(() {
                            loadImage();
                            controllerTabBottomVol =
                                PersistentTabController(initialIndex: 2);
                          });
                          Future.delayed(const Duration(milliseconds: 500), () {
                            Navigator.of(context, rootNavigator: true)
                                .pushReplacement(MaterialPageRoute(
                                    builder: (context) => MainScreen()));
                          });
                        },
                        child: Text(
                          "Done",
                          style: textActiveButtonStyle,
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
