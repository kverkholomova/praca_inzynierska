import 'dart:typed_data';

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectFile();
  }

  PlatformFile? file;
  // Uint8List? fileBytes;
  Future selectFile() async {

    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() async {
        file = result.files.first;
        // fileBytes = file!.bytes;
        // await FirebaseStorage.instance.ref('uploads/${file!.name}').putData(fileBytes!);
      });

      print(file);
      print(file!.name);
      print(file!.bytes);
      print(file!.size);
      print(file!.extension);
      print(file!.path);
    } else {
      // User canceled the picker
    }
    // final result = await FilePicker.platform.pickFiles(
    //     withReadStream: true,
    // );
    // if(result!=null) return;
    //  setState() {
    //     pickedFile = result!.files.first;
    //   }
    //   print("BBBBBBBBBBBBBBBBBBBBBBBBBBB");
    //  print(pickedFile);
    }


  Future uploadFile() async {

    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      Uint8List? fileBytes = result.files.first.bytes;
      String fileName = result.files.first.name;

      // Upload file
      await FirebaseStorage.instance.ref('uploads/$fileName').putData(fileBytes!);
    }
    // final path = 'files/${file!.name}';
    // final file = File(file!.path!);
    //
    // final ref = FirebaseStorage.instance.ref().child(path);
    // ref.putFile(file);
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
          file!= null?
            Expanded(
                child: Container(
              color: background,
              child:
              // Text(pickedFile!.path!)
              Image.file(
                File(file!.path!),
                // File(pickedFile!.path!),
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ))
          :Expanded(
              child: Container(
                  color: background,
                  child: Text("Null image")
              )),
        ElevatedButton(onPressed: () {
          selectFile();
        }, child: Text("Select file")),
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