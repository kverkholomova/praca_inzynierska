import 'dart:math';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:wol_pro_1/screens/menu/volunteer/home_page/settings/settings_vol_info.dart';

import '../../../../../constants.dart';
import '../../main_screen.dart';

String? url_image;
String image_url_volunteer = '';
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
          .doc(currentStreamSnapshot)
          .update({"image": file!.name});
      image_url_volunteer = file!.name;
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

// PlatformFile? pickedFile;
//   Future uploadFile() async {
//     // FilePickerResult? result = await FilePicker.platform.pickFiles();
//     //
//     // if (result != null) {
//     //   Uint8List? fileBytes = result.files.first.bytes;
//     //   String fileName = result.files.first.name;
//     //
//     //   // Upload file/
//     //   await FirebaseStorage.instance.ref('uploads/$fileName').putData(result.files.single.bytes!);
//     // }
//
//     final path = 'user_pictures/${file!.name}';
//     final currentFile = File(file!.path!);
//
//     final ref = FirebaseStorage.instance.ref().child(path);
//     ref.putFile(currentFile);
//
//     FirebaseFirestore.instance
//         .collection('users')
//         .doc(currentStreamSnapshot)
//         .update({"image": file!.name});
//     image_url_volunteer = file!.name;
//
//     // FilePickerResult? result = await FilePicker.platform.pickFiles();
//     //
//     // if (result != null) {
//     //   Uint8List? fileBytes = result.files.first.bytes;
//     //   String fileName = result.files.first.name;
//     //
//     //   // Upload file
//     //   await FirebaseStorage.instance.ref('uploads/$fileName').putData(fileBytes!);
//     // }
//     // final path = 'files/${file!.name}';
//     // final file = File(file!.path!);
//     //
//     // final ref = FirebaseStorage.instance.ref().child(path);
//     // ref.putFile(file);
//   }

  loadImage() async {
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
      url_image = url;
    });
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
    return WillPopScope(
      onWillPop: () async {
        setState(() {
          controllerTabBottomVol = PersistentTabController(initialIndex: 2);
        });
        Navigator.of(context, rootNavigator: true).pushReplacement(
            MaterialPageRoute(builder: (context) => new MainScreen()));
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
                controllerTabBottomVol = PersistentTabController(initialIndex: 2);
              });
              Navigator.of(context, rootNavigator: true).pushReplacement(
                  MaterialPageRoute(builder: (context) => new MainScreen()));
            },
          ),
          backgroundColor: background,
          // floatingActionButton: StreamBuilder(
          //   stream: FirebaseFirestore.instance
          //       .collection('users')
          //       .where('id_vol',
          //       isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          //       .snapshots(),
          //   builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          //     return ListView.builder(
          //         itemCount: streamSnapshot.data?.docs.length,
          //         itemBuilder: (ctx, index) {
          //           // categories_user = streamSnapshot.data?.docs[index]['category'];
          //           // token_vol = streamSnapshot.data?.docs[index]['token'];
          //           // current_name_Vol = streamSnapshot.data?.docs[index]['user_name'];
          //           return ElevatedButton(onPressed: () async {
          //             image_url_volunteer = file!.name;
          //             Reference  ref = FirebaseStorage.instance.ref().child("user_pictures/${FirebaseAuth.instance.currentUser!.uid}").child(image_url_volunteer);
          //             var urlCurrent = await ref.getDownloadURL();
          //             setState(() {
          //               url = urlCurrent;
          //             });
          //             FirebaseFirestore.instance
          //                 .collection('users')
          //                 .doc(streamSnapshot
          //                 .data?.docs[index].id)
          //                 .update({
          //               "image": file!.name
          //             });
          //           }, child: Text("Done"));
          //         });
          //   },
          // ),
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
                  height:
                  MediaQuery.of(context).size.height *
                      0.012,
                ),
                // Padding(
                //   padding: padding,
                //   child: Container(
                //       width: double.infinity,
                //       height: MediaQuery.of(context).size.height * 0.075,
                //       decoration: buttonDecoration,
                //       child: TextButton(
                //           onPressed: uploadFile,
                //           child: Text(
                //             "Upload file",
                //             style: textButtonStyle,
                //           ))),
                // ),
                // SizedBox(
                //   height:
                //   MediaQuery.of(context).size.height *
                //       0.012,
                // ),
                Padding(
                  padding: padding,
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.075,
                    decoration: buttonActiveDecoration,
                    child: TextButton(
                        onPressed: () {
                          loadImage();
                          Future.delayed(const Duration(milliseconds: 500), () {
                            print(
                                "GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG2222222222222222222");
                            print(url_image);
                            setState(() {
                              controllerTabBottomVol = PersistentTabController(initialIndex: 2);
                            });
                            Navigator.of(context, rootNavigator: true).pushReplacement(
                                MaterialPageRoute(builder: (context) => new MainScreen()));
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

// void showPicker(context) {
//   showModalBottomSheet(
//       context: context,
//       builder: (BuildContext bc) {
//         return SafeArea(
//           child: Scaffold(
//             body: Column(
//               children: [
//                 ElevatedButton(onPressed: selectFile, child: Text("Select file")),
//                 ElevatedButton(onPressed: uploadFile, child: Text("Select file")),
//               ],
//             ),
//           ),
//
//           // Container(
//           //   child: new Wrap(
//           //     children: <Widget>[
//           //       new ListTile(
//           //           leading: new Icon(Icons.photo_library),
//           //           title: new Text('Gallery'),
//           //           onTap: () {
//           //             imgFromGallery();
//           //             Navigator.of(context).pop();
//           //           }),
//           //       new ListTile(
//           //         leading: new Icon(Icons.photo_camera),
//           //         title: new Text('Camera'),
//           //         onTap: () {
//           //           imgFromCamera();
//           //           Navigator.of(context).pop();
//           //         },
//           //       ),
//           //     ],
//           //   ),
//           // ),
//         );
//       });
// }
}
