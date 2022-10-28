import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';

import '../../../../../constants.dart';

firebase_storage.FirebaseStorage storage =
    firebase_storage.FirebaseStorage.instance;

class ImageUploads extends StatefulWidget {
  ImageUploads({Key? key}) : super(key: key);

  @override
  _ImageUploadsState createState() => _ImageUploadsState();
}

class _ImageUploadsState extends State<ImageUploads> {

  PlatformFile? pickedFile;
  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if(result!=null) {
      void setState() {
        pickedFile = result.files.first;
      }
    }
  }

  Future uploadFile() async {
    final path = 'files/${pickedFile!.name}';
    final file = File(pickedFile!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    ref.putFile(file);
  }



  // firebase_storage.FirebaseStorage storage =
  //     firebase_storage.FirebaseStorage.instance;
  //
  // File? _photo;
  // final ImagePicker _picker = ImagePicker();
  //
  // Future imgFromGallery() async {
  //   final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
  //
  //   setState(() {
  //     if (pickedFile != null) {
  //       _photo = File(pickedFile.path);
  //       uploadFile();
  //     } else {
  //       print('No image selected.');
  //     }
  //   });
  // }
  //
  // Future imgFromCamera() async {
  //   final pickedFile = await _picker.pickImage(source: ImageSource.camera);
  //
  //   setState(() {
  //     if (pickedFile != null) {
  //       _photo = File(pickedFile.path);
  //       uploadFile();
  //     } else {
  //       print('No image selected.');
  //     }
  //   });
  // }
  //
  // Future uploadFile() async {
  //   if (_photo == null) return;
  //   final fileName = basename(_photo!.path);
  //   final destination = 'files/$fileName';
  //
  //   try {
  //     final ref = firebase_storage.FirebaseStorage.instance
  //         .ref(destination)
  //         .child('file/');
  //     await ref.putFile(_photo!);
  //   } catch (e) {
  //     print('error occured');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
        children: [
          pickedFile!= null?
            Expanded(
                child: Container(
              color: background,
              child:
              // Text(pickedFile!.path!)
              Image.file(
                File(pickedFile!.path!),
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ))
          :Expanded(
              child: Container(
                  color: background,
                  child: Text("Null image")
                // Image.file(
                //   File(pickedFile!.path!),
                //   width: double.infinity,
                //   fit: BoxFit.cover,
                // ),
              )),
        ElevatedButton(onPressed: selectFile, child: Text("Select file")),
    ElevatedButton(onPressed: uploadFile, child: Text("Upload file")),
    ],
    ),
    ),);

      // Column(
      //   children: <Widget>[
      //     SizedBox(
      //       height: 32,
      //     ),
      //     Center(
      //       child: GestureDetector(
      //         onTap: () {
      //           _showPicker(context);
      //         },
      //         child: CircleAvatar(
      //           radius: 55,
      //           backgroundColor: Color(0xffFDCF09),
      //           child: _photo != null
      //               ? ClipRRect(
      //             borderRadius: BorderRadius.circular(50),
      //             child: Image.file(
      //               _photo!,
      //               width: 100,
      //               height: 100,
      //               fit: BoxFit.fitHeight,
      //             ),
      //           )
      //               : Container(
      //             decoration: BoxDecoration(
      //                 color: Colors.grey[200],
      //                 borderRadius: BorderRadius.circular(50)),
      //             width: 100,
      //             height: 100,
      //             child: Icon(
      //               Icons.camera_alt,
      //               color: Colors.grey[800],
      //             ),
      //           ),
      //         ),
      //       ),
      //     )
      //   ],
      // ),

  }

  void showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Scaffold(
              body: Column(
                children: [
                  ElevatedButton(onPressed: selectFile, child: Text("Select file")),
                  ElevatedButton(onPressed: uploadFile, child: Text("Select file")),
                ],
              ),
            ),

            // Container(
            //   child: new Wrap(
            //     children: <Widget>[
            //       new ListTile(
            //           leading: new Icon(Icons.photo_library),
            //           title: new Text('Gallery'),
            //           onTap: () {
            //             imgFromGallery();
            //             Navigator.of(context).pop();
            //           }),
            //       new ListTile(
            //         leading: new Icon(Icons.photo_camera),
            //         title: new Text('Camera'),
            //         onTap: () {
            //           imgFromCamera();
            //           Navigator.of(context).pop();
            //         },
            //       ),
            //     ],
            //   ),
            // ),
          );
        });
  }
}