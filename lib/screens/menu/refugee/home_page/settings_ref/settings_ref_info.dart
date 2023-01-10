import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:wol_pro_1/constants.dart';
import 'package:wol_pro_1/screens/intro_screen/option.dart';
import 'package:wol_pro_1/screens/menu/refugee/home_page/settings_ref/upload_picture_refugee.dart';
import 'package:wol_pro_1/screens/menu/refugee/main_screen_ref.dart';
import 'package:wol_pro_1/screens/menu/volunteer/home_page/settings/settings_vol_info.dart';
import 'package:wol_pro_1/screens/menu/volunteer/home_page/settings/upload_photo.dart';
import 'package:wol_pro_1/widgets/datepicker.dart';
import 'package:wol_pro_1/widgets/wrapper.dart';
import '../../../../../../service/local_push_notifications.dart';


import '../../../../../widgets/datepicker_ref.dart';
import '../../../../register_login/volunteer/register/register_volunteer_1.dart';
import '../../../../../services/auth.dart';
bool visErrorName = false;
bool visErrorPhoneNum = false;
bool phoneLengthEnough = false;
var currentStreamSnapshotRef;
String dateOfBirthRefugee =
DateFormat('dd, MMMM yyyy').format(DateTime.now()).toString();
// String? tokenVol;
final FirebaseFirestore db = FirebaseFirestore.instance;
final FirebaseMessaging fcm = FirebaseMessaging.instance;

class SettingsRef extends StatefulWidget {
  const SettingsRef({Key? key}) : super(key: key);

  @override
  State<SettingsRef> createState() => _SettingsRefState();
}

class _SettingsRefState extends State<SettingsRef> {
  storeNotificationToken() async {
    String? token = await FirebaseMessaging.instance.getToken();
    print(
        "------???---------RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR");
    print(token);
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({'token': token}, SetOptions(merge: true));
    print(
        "RRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRRR");
    print(token);
  }



  void foregroundMessage(){
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    foregroundMessage();
    visErrorName = false;
    visErrorPhoneNum = false;
    FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((event) {});
    storeNotificationToken();
    FirebaseMessaging.instance.subscribeToTopic('subscription');
    FirebaseMessaging.onMessage.listen((event) {
      LocalNotificationService.display(event);
    });
  }

  final AuthService _auth = AuthService();

  String changedName = '';
  int changedAge = 0;
  String changedPhone = '';
  List changedCategories = [];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context, rootNavigator: true).pushReplacement(
            MaterialPageRoute(builder: (context) => new MainScreenRefugee()));
        return true;
      },
      child: Scaffold(
        backgroundColor: backgroundRefugee,
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        floatingActionButton: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 30,
            color: backgroundRefugee,
          ),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pushReplacement(
                MaterialPageRoute(builder: (context) => new MainScreenRefugee()));
            // Navigator.push(context,
            //     MaterialPageRoute(builder: (context) => const HomeVol()));
          },
        ),
        // appBar: AppBar(
        //   backgroundColor: Color.fromRGBO(49, 72, 103, 0.8),
        //   elevation: 0.0,
        //   title: Text('Users Info',style: TextStyle(fontSize: 16),),
        //
        // ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height *
                    0.31,
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .where('id_vol',
                      isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                    return ListView.builder(
                        itemCount: streamSnapshot.data?.docs.length,
                        itemBuilder: (ctx, index) {
                          // categories_user = streamSnapshot.data?.docs[index]['category'];
                          // token_vol = streamSnapshot.data?.docs[index]['token'];
                          // current_name_Vol = streamSnapshot.data?.docs[index]['user_name'];
                          return ClipPath(
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
                              height: MediaQuery.of(context).size.height * 0.25,
                              child: Center(
                                child: Padding(
                                  padding:
                                  const EdgeInsets.only(bottom: 30, top: 10),
                                  child: GestureDetector(
                                    onTap: (){
                                      currentStreamSnapshotRef =
                                          streamSnapshot.data?.docs[index].id;
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ImageUploads()));
                                    },
                                    child: SizedBox(
                                        height:
                                        MediaQuery.of(context).size.width * 0.5,
                                        child: urlImageRefugee == ""
                                            ? Stack(
                                            children: [
                                              Image(
                                                  image:
                                                  AssetImage("assets/user.png")),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  top: MediaQuery.of(context).size.height * 0.125,
                                                  left: MediaQuery.of(context).size.width * 0.3,
                                                ),
                                                child: GestureDetector(
                                                    onTap: (){
                                                      currentStreamSnapshotRef =
                                                          streamSnapshot.data?.docs[index].id;
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  ImageUploadsRef()));
                                                    },
                                                    child: Container(
                                                        width: 50,
                                                        height: 50,
                                                        decoration: BoxDecoration(
                                                            shape: BoxShape.circle,
                                                            color: backgroundRefugee
                                                        ),
                                                        child: Center(
                                                            child: Icon(Icons.add_rounded, color: redColor, size: 30,)))),
                                              )
                                            ])
                                            : Stack(
                                            children: [
                                              CircleAvatar(
                                                  radius: 70.0,
                                                  backgroundImage: NetworkImage(
                                                      urlImageRefugee.toString())),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  top: MediaQuery.of(context).size.height * 0.125,
                                                  left: MediaQuery.of(context).size.width * 0.3,
                                                ),
                                                child: GestureDetector(
                                                    onTap: (){
                                                      currentStreamSnapshotRef =
                                                          streamSnapshot.data?.docs[index].id;
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  ImageUploadsRef()));
                                                    },
                                                    child: Container(
                                                      width: 40,
                                                        height: 40,
                                                        decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          color: backgroundRefugee
                                                        ),
                                                        child: Center(
                                                            child: Icon(Icons.add_rounded, color: redColor, size: 35,)))),
                                              ),
                                            ])),
                                  ),
                                ),
                              ),
                            ),
                          );
                        });
                  },
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height *
                    0.69,
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .where('id_vol',
                      isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                    return ListView.builder(
                        itemCount: streamSnapshot.data?.docs.length,
                        itemBuilder: (ctx, index) {
                          // categories_user = streamSnapshot.data?.docs[index]['category'];
                          // token_vol = streamSnapshot.data?.docs[index]['token'];
                          // current_name_Vol = streamSnapshot.data?.docs[index]['user_name'];
                          return SingleChildScrollView(
                            child: Padding(
                              padding: padding,
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context).size.height *
                                            0.005,
                                      ),
                                      child: Text(
                                        "Your name",
                                        style: textLabelSeparated,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height:
                                    MediaQuery.of(context).size.height * 0.085,
                                    child: TextFormField(
                                      // validator: (val){
                                      //   if((val!.contains(RegExp(r'[0-9]')))||(val!.contains(RegExp(r'[#?!@$%^&*-]')))){
                                      //     setState(() {
                                      //       visErrorName=true;
                                      //     });
                                      //   }
                                      // },
                                      onChanged: (val) {
                                        if((val!.contains(RegExp(r'[0-9]')))||(val!.contains(RegExp(r'[#?!@$%^&*-]')))){
                                          setState(() {
                                            visErrorName=true;
                                          });
                                        }
                                        else {
                                          setState(() {
                                            visErrorName=false;
                                          });
                                          changedName = val;
                                        }

                                      },
                                      // controller: TextEditingController(text: streamSnapshot.data?.docs[index]['user_name']),
                                      decoration: InputDecoration(
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(15),
                                          borderSide: const BorderSide(
                                            color: Colors.red,
                                            width: 1.5,
                                          ),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(15),
                                          borderSide: const BorderSide(
                                            color: Colors.red,
                                            width: 1.5,
                                          ),
                                        ),
                                        errorStyle:
                                        const TextStyle(color: Colors.red),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(15),
                                          borderSide: BorderSide(
                                            color: redColor,
                                            // color: Color.fromRGBO(2, 62, 99, 20),
                                            width: 1.5,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(15),
                                          borderSide: const BorderSide(
                                            color: Colors.white,
                                            width: 0,
                                          ),
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                        hintText: streamSnapshot.data?.docs[index]
                                        ['user_name'],
                                        hintStyle: hintStyleText,
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: visErrorName,
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context).size.height *
                                              0.005,
                                        ),
                                        child: Text(
                                          "Your name should contain only letters (A-Z,a-z)",
                                          style: GoogleFonts.raleway(
                                            fontSize: 12,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  // SizedBox(
                                  //   height:
                                  //       MediaQuery.of(context).size.height * 0.012,
                                  // ),
                                  // Row(
                                  //   children: [
                                  //     SizedBox(
                                  //       height: MediaQuery.of(context).size.height *
                                  //           0.075,
                                  //       width: MediaQuery.of(context).size.height *
                                  //           0.13,
                                  //       child: TextFormField(
                                  //         onTap: (){
                                  //           Navigator.push(
                                  //             context,
                                  //             MaterialPageRoute(builder: (context) => DatePicker()),
                                  //           );
                                  //         },
                                  //         // controller: TextEditingController(text: "${streamSnapshot.data?.docs[index]['age']}"),
                                  //         decoration: InputDecoration(
                                  //           focusedErrorBorder: OutlineInputBorder(
                                  //             borderRadius: BorderRadius.circular(24.0),
                                  //             borderSide: const BorderSide(
                                  //               color: Colors.red,
                                  //               width: 1.5,
                                  //             ),
                                  //           ),
                                  //           errorBorder: OutlineInputBorder(
                                  //             borderRadius: BorderRadius.circular(24.0),
                                  //             borderSide: const BorderSide(
                                  //               color: Colors.red,
                                  //               width: 1.5,
                                  //             ),
                                  //           ),
                                  //           errorStyle: const TextStyle(
                                  //               color: Colors.red
                                  //           ),
                                  //           focusedBorder: OutlineInputBorder(
                                  //             borderRadius: BorderRadius.circular(24.0),
                                  //             borderSide: BorderSide(
                                  //               color: blueColor,
                                  //               // color: Color.fromRGBO(2, 62, 99, 20),
                                  //               width: 1.5,
                                  //             ),
                                  //           ),
                                  //
                                  //           enabledBorder: OutlineInputBorder(
                                  //             borderRadius: BorderRadius.circular(24.0),
                                  //             borderSide: const BorderSide(
                                  //               color: Colors.white,
                                  //               width: 0,
                                  //             ),
                                  //           ),
                                  //           filled: true,
                                  //           fillColor: Colors.white,
                                  //           hintText: "${DateTime.now().day}",
                                  //           labelStyle: GoogleFonts.raleway(
                                  //             fontSize: 16,
                                  //             color: Colors.black.withOpacity(0.7),
                                  //           ),
                                  //         ),
                                  //       ),
                                  //     ),
                                  //     Padding(
                                  //       padding: const EdgeInsets.symmetric(horizontal: 5),
                                  //       child: SizedBox(
                                  //         width:MediaQuery.of(context).size.height *
                                  //       0.13,
                                  //         height: MediaQuery.of(context).size.height *
                                  //             0.075,
                                  //
                                  //         child: TextFormField(
                                  //           // controller: TextEditingController(text: "${streamSnapshot.data?.docs[index]['age']}"),
                                  //           decoration: InputDecoration(
                                  //             focusedErrorBorder: OutlineInputBorder(
                                  //               borderRadius: BorderRadius.circular(24.0),
                                  //               borderSide: const BorderSide(
                                  //                 color: Colors.red,
                                  //                 width: 1.5,
                                  //               ),
                                  //             ),
                                  //             errorBorder: OutlineInputBorder(
                                  //               borderRadius: BorderRadius.circular(24.0),
                                  //               borderSide: const BorderSide(
                                  //                 color: Colors.red,
                                  //                 width: 1.5,
                                  //               ),
                                  //             ),
                                  //             errorStyle: const TextStyle(
                                  //                 color: Colors.red
                                  //             ),
                                  //             focusedBorder: OutlineInputBorder(
                                  //               borderRadius: BorderRadius.circular(24.0),
                                  //               borderSide: BorderSide(
                                  //                 color: blueColor,
                                  //                 // color: Color.fromRGBO(2, 62, 99, 20),
                                  //                 width: 1.5,
                                  //               ),
                                  //             ),
                                  //
                                  //             enabledBorder: OutlineInputBorder(
                                  //               borderRadius: BorderRadius.circular(24.0),
                                  //               borderSide: const BorderSide(
                                  //                 color: Colors.white,
                                  //                 width: 0,
                                  //               ),
                                  //             ),
                                  //             filled: true,
                                  //             fillColor: Colors.white,
                                  //             hintText: "${DateTime.now().month}",
                                  //             labelStyle: GoogleFonts.raleway(
                                  //               fontSize: 16,
                                  //               color: Colors.black.withOpacity(0.7),
                                  //             ),
                                  //           ),
                                  //         ),
                                  //       ),
                                  //     ),
                                  //     SizedBox(
                                  //       width:MediaQuery.of(context).size.height *
                                  //           0.15,
                                  //       height: MediaQuery.of(context).size.height *
                                  //           0.075,
                                  //
                                  //       child: TextFormField(
                                  //         // controller: TextEditingController(text: "${streamSnapshot.data?.docs[index]['age']}"),
                                  //         decoration: InputDecoration(
                                  //           focusedErrorBorder: OutlineInputBorder(
                                  //             borderRadius: BorderRadius.circular(24.0),
                                  //             borderSide: const BorderSide(
                                  //               color: Colors.red,
                                  //               width: 1.5,
                                  //             ),
                                  //           ),
                                  //           errorBorder: OutlineInputBorder(
                                  //             borderRadius: BorderRadius.circular(24.0),
                                  //             borderSide: const BorderSide(
                                  //               color: Colors.red,
                                  //               width: 1.5,
                                  //             ),
                                  //           ),
                                  //           errorStyle: const TextStyle(
                                  //               color: Colors.red
                                  //           ),
                                  //           focusedBorder: OutlineInputBorder(
                                  //             borderRadius: BorderRadius.circular(24.0),
                                  //             borderSide: BorderSide(
                                  //               color: blueColor,
                                  //               // color: Color.fromRGBO(2, 62, 99, 20),
                                  //               width: 1.5,
                                  //             ),
                                  //           ),
                                  //
                                  //           enabledBorder: OutlineInputBorder(
                                  //             borderRadius: BorderRadius.circular(24.0),
                                  //             borderSide: const BorderSide(
                                  //               color: Colors.white,
                                  //               width: 0,
                                  //             ),
                                  //           ),
                                  //           filled: true,
                                  //           fillColor: Colors.white,
                                  //           hintText: "${DateTime.now().year}",
                                  //           labelStyle: GoogleFonts.raleway(
                                  //             fontSize: 16,
                                  //             color: Colors.black.withOpacity(0.7),
                                  //           ),
                                  //         ),
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),

                                  SizedBox(
                                    height:
                                    MediaQuery.of(context).size.height * 0.015,
                                  ),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context).size.height *
                                            0.005,
                                      ),
                                      child: Text(
                                        "Your date of birth",
                                        style: textLabelSeparated,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height:
                                    MediaQuery.of(context).size.height * 0.085,
                                    child: TextFormField(
                                      onChanged: (val) {

                                        changedAge = currentAgeVolunteer;
                                      },
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => DatePickerRefugee()),
                                        );
                                      },
                                      // controller: TextEditingController(text: streamSnapshot.data?.docs[index]['phone_number']),
                                      decoration: InputDecoration(
                                        focusedErrorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(15),
                                          borderSide: const BorderSide(
                                            color: Colors.red,
                                            width: 1.5,
                                          ),
                                        ),
                                        errorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(15),
                                          borderSide: const BorderSide(
                                            color: Colors.red,
                                            width: 1.5,
                                          ),
                                        ),
                                        errorStyle:
                                        const TextStyle(color: Colors.red),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(15),
                                          borderSide: BorderSide(
                                            color: redColor,
                                            // color: Color.fromRGBO(2, 62, 99, 20),
                                            width: 1.5,
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(15),
                                          borderSide: const BorderSide(
                                            color: Colors.white,
                                            width: 0,
                                          ),
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                        hintText: dateOfBirthRefugee==DateFormat('dd, MMMM yyyy').format(DateTime.now()).toString()?"Please supply data":dateOfBirthRefugee,
                                        hintStyle: hintStyleText,
                                        // labelStyle: GoogleFonts.raleway(
                                        //   fontSize: 16,
                                        //   color: Colors.black.withOpacity(0.7),
                                        // ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height:
                                    MediaQuery.of(context).size.height * 0.015,
                                  ),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context).size.height *
                                            0.005,
                                      ),
                                      child: Text(
                                        "Your phone number",
                                        style: textLabelSeparated,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height:
                                    MediaQuery.of(context).size.height * 0.085,
                                    child: TextFormField(
                                      onChanged: (val) {
                                        print("Phone");
                                        print(changedPhone);
                                        if(val.contains(RegExp(r'[A-Z]'))||val.contains(RegExp(r'[a-z]'))||val.contains(RegExp(r'[#?!@$%^&()*-]'))){
                                          setState(() {
                                            visErrorPhoneNum=true;
                                          });
                                        }else {
                                          if(val.length>9){
                                            setState(() {
                                              visErrorPhoneNum=true;
                                              phoneLengthEnough = true;
                                            });
                                          } else{
                                            setState(() {
                                              visErrorPhoneNum=false;
                                            });
                                          }
                                        }
                                        // if(!(val.contains(RegExp(r'[0-9]')))){
                                        //   setState(() {
                                        //     visErrorPhoneNum=true;
                                        //   });
                                        // }
                                        // else {
                                        //   if (val.length!=9){
                                        //     setState(() {
                                        //       phoneLengthEnough = true;
                                        //     });
                                        //   } else{
                                        //
                                        //     setState(() {
                                        //       phoneLengthEnough=false;
                                        //       visErrorPhoneNum=false;
                                        //     });
                                        //     changedPhone = val;
                                        //   }
                                        //
                                        // }

                                      },
                                      // controller: TextEditingController(text: streamSnapshot.data?.docs[index]['phone_number']),
                                      decoration: InputDecoration(
                                          focusedErrorBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(15),
                                            borderSide: const BorderSide(
                                              color: Colors.red,
                                              width: 1.5,
                                            ),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(15),
                                            borderSide: const BorderSide(
                                              color: Colors.red,
                                              width: 1.5,
                                            ),
                                          ),
                                          errorStyle:
                                          const TextStyle(color: Colors.red),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(15),
                                            borderSide: BorderSide(
                                              color: redColor,
                                              // color: Color.fromRGBO(2, 62, 99, 20),
                                              width: 1.5,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(15),
                                            borderSide: const BorderSide(
                                              color: Colors.white,
                                              width: 0,
                                            ),
                                          ),
                                          filled: true,
                                          fillColor: Colors.white,
                                          hintText: streamSnapshot.data?.docs[index]
                                          ['phone_number'],
                                          hintStyle: hintStyleText
                                        // labelStyle: GoogleFonts.raleway(
                                        //   fontSize: 14,
                                        //   color: Colors.black.withOpacity(0.7),
                                        // ),
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: visErrorPhoneNum,
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          bottom: MediaQuery.of(context).size.height *
                                              0.005,
                                        ),
                                        child: Text(
                                          phoneLengthEnough
                                              ?"Your phone should contain only 9 numbers"
                                          :"Your phone should contain only numbers (0-9)",
                                          style: GoogleFonts.raleway(
                                            fontSize: 12,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height:
                                    MediaQuery.of(context).size.height * 0.015,
                                  ),
                                  Divider(color: redColor),
                                  SizedBox(
                                    height:
                                    MediaQuery.of(context).size.height * 0.015,
                                  ),
                                  // Padding(
                                  //   padding: EdgeInsets.only(
                                  //     bottom:
                                  //     MediaQuery.of(context).size.height * 0.02,
                                  //   ),
                                  //   child: Text(
                                  //       "Choose categories which are the best suitable for you",
                                  //       style: textLabelSeparated),
                                  // ),
                                  // buildCategorySettings(context, categoriesListAll[3],
                                  //     Icons.pets_rounded),
                                  // SizedBox(
                                  //   height:
                                  //   MediaQuery.of(context).size.height * 0.012,
                                  // ),
                                  // buildCategorySettings(context, categoriesListAll[4],
                                  //     Icons.local_grocery_store),
                                  // SizedBox(
                                  //   height:
                                  //   MediaQuery.of(context).size.height * 0.012,
                                  // ),
                                  // buildCategorySettings(context, categoriesListAll[2],
                                  //     Icons.emoji_transportation_rounded),
                                  // SizedBox(
                                  //   height:
                                  //   MediaQuery.of(context).size.height * 0.012,
                                  // ),
                                  // buildCategorySettings(
                                  //     context, categoriesListAll[1], Icons.house),
                                  // SizedBox(
                                  //   height:
                                  //   MediaQuery.of(context).size.height * 0.012,
                                  // ),
                                  // buildCategorySettings(context, categoriesListAll[6],
                                  //     Icons.sign_language_rounded),
                                  // SizedBox(
                                  //   height:
                                  //   MediaQuery.of(context).size.height * 0.012,
                                  // ),
                                  // buildCategorySettings(context, categoriesListAll[5],
                                  //     Icons.child_care_outlined),
                                  // SizedBox(
                                  //   height:
                                  //   MediaQuery.of(context).size.height * 0.012,
                                  // ),
                                  // buildCategorySettings(context, categoriesListAll[7],
                                  //     Icons.menu_book),
                                  // SizedBox(
                                  //   height:
                                  //   MediaQuery.of(context).size.height * 0.012,
                                  // ),
                                  // buildCategorySettings(context, categoriesListAll[8],
                                  //     Icons.medical_information_outlined),
                                  // Divider(color: blueColor),
                                  // SizedBox(
                                  //     height: MediaQuery.of(context).size.height *
                                  //         0.01),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Center(
                                      child: Container(
                                        width: double.infinity,
                                        height: MediaQuery.of(context).size.height *
                                            0.085,
                                        decoration: buttonActiveDecorationRefugee,
                                        child: TextButton(
                                            child: Text(
                                              "Save changes",
                                              style: textActiveButtonStyleRefugee,
                                            ),
                                            onPressed: () async {
                                              if(visErrorName||visErrorPhoneNum){
                                                dialogBuilderError(context);
                                              } else{
                                                setState(() {
                                                  FirebaseFirestore.instance
                                                      .collection('users')
                                                      .doc(streamSnapshot
                                                      .data?.docs[index].id)
                                                      .update({
                                                    "category": changedCategories!=[]?changedCategories:streamSnapshot
                                                        .data?.docs[index]['category'],
                                                    "user_name": changedName!=""?changedName:streamSnapshot
                                                        .data?.docs[index]['user_name'],
                                                    "age": currentAgeRefugee!=0?currentAgeRefugee:streamSnapshot
                                                        .data?.docs[index]['age'],
                                                    "phone_number": changedPhone!=""?changedPhone:streamSnapshot
                                                        .data?.docs[index]['phone_number']
                                                  });
                                                });
                                                Navigator.of(context, rootNavigator: true).pushReplacement(
                                                    MaterialPageRoute(builder: (context) => new MainScreenRefugee()));
                                              }

                                            }),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height:
                                    MediaQuery.of(context).size.height * 0.015,
                                  ),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Center(
                                      child: Container(
                                        width: double.infinity,
                                        height: MediaQuery.of(context).size.height *
                                            0.085,
                                        decoration: buttonInactiveDecorationRefugee,
                                        child: TextButton(
                                            child: Text(
                                              "Sign Out",
                                              style: textInactiveButtonStyleRefugee,
                                            ),
                                            onPressed: () async {
                                              await _auth.signOut();
                                              Navigator.of(context, rootNavigator: true).pushReplacement(
                                                  MaterialPageRoute(builder: (context) => OptionChoose()));
                                              // Navigator.push(
                                              //     context,
                                              //     MaterialPageRoute(
                                              //         builder: (context) =>
                                              //         const OptionChoose()));
                                            }),
                                      ),
                                    ),
                                  ),

                                  SizedBox(
                                    height:
                                    MediaQuery.of(context).size.height * 0.015,
                                  ),

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

        // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        // floatingActionButton:
        // Padding(
        //   padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.77,),
        //   child: Padding(
        //     padding: padding,
        //     child: Align(
        //       alignment: Alignment.bottomCenter,
        //       child: StreamBuilder(
        //           stream: FirebaseFirestore.instance
        //               .collection('users')
        //               .where('id_vol', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
        //               .snapshots(),
        //           builder:
        //               (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
        //             return ListView.builder(
        //                 itemCount: !streamSnapshot.hasData
        //                     ? 1
        //                     : streamSnapshot.data?.docs.length,
        //                 itemBuilder: (ctx, index) {
        //                   return Center(
        //                     child: Container(
        //                       width: double.infinity,
        //                       height: MediaQuery.of(context).size.height *
        //                           0.075,
        //                       decoration: buttonDecoration,
        //                       child: TextButton(
        //                           child: Text(
        //                             "Done",
        //                             style: textButtonStyle,
        //                           ),
        //                           onPressed: () async {
        //                             FirebaseFirestore.instance
        //                                 .collection('users')
        //                                 .doc(streamSnapshot
        //                                 .data?.docs[index].id)
        //                                 .update({
        //                               "category": chosenCategoryList
        //                             });
        //                             Navigator.push(
        //                                 context,
        //                                 MaterialPageRoute(
        //                                     builder: (context) =>
        //                                     const HomeVol()));
        //                           }),
        //                     ),
        //                   );
        //                 });
        //           }),
        //     ),
        //   ),
        // ),
        // FloatingActionButton(
        //   child: const Text('Done'),
        //   onPressed: () {
        //     FirebaseFirestore.instance
        //         .collection("users")
        //         .doc(FirebaseAuth.instance.currentUser?.uid)
        //         .update({"category": chosen_category_settings});
        //     // print(categories_user);
        //     // categories_user = streamSnapshot.data?.docs[index]['category'];
        //     // print("OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO__________OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO");
        //     // print(categories_user);
        //     // Navigator.push(context, MaterialPageRoute(builder: (context) => Categories()));
        //
        //     showDialog<String>(
        //       context: context,
        //       builder: (BuildContext context) => AlertDialog(
        //         title: const Text('Confirm changes'),
        //         content: const Text(
        //             'Are you sure that you want to change your settings?'),
        //         actions: <Widget>[
        //           TextButton(
        //             onPressed: () {
        //               Navigator.push(context,
        //                   MaterialPageRoute(builder: (context) => HomeVol()));
        //             },
        //             child: const Text('Cancel'),
        //           ),
        //           TextButton(
        //             onPressed: () {
        //               // categories_user= [];
        //               categories_user_Register = chosen_category_settings;
        //               print(
        //                   "OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO__________OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO");
        //               // print(categories_user);
        //               Navigator.push(
        //                   context,
        //                   MaterialPageRoute(
        //                       builder: (context) => YourCategories()));
        //             },
        //             child: const Text('Yes'),
        //           ),
        //         ],
        //       ),
        //     );
        //   },
        // ),
      ),
    );
  }

  GestureDetector buildCategorySettings(
      BuildContext context, String text, IconData icon) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (changedCategories.contains(text)) {
            changedCategories.remove(text);
          } else {
            changedCategories.add(text);
          }
        });
      },
      child: AnimatedContainer(
        height: MediaQuery.of(context).size.height * 0.075,
        duration: const Duration(milliseconds: 500),
        decoration: BoxDecoration(
          color: chosenCategoryListChanges.contains(text) ? redColor : Colors.white,
          borderRadius: const BorderRadius.all(
            Radius.circular(24),
          ),
        ),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.05,
                right: MediaQuery.of(context).size.width * 0.04,
              ),
              child: Icon(
                icon,
                size: 27,
                color: chosenCategoryListChanges.contains(text)
                    ? Colors.white
                    : Colors.black,
              ),
            ),
            Text(
              text,
              style: GoogleFonts.raleway(
                fontSize: 14,
                color: chosenCategoryListChanges.contains(text)
                    ? Colors.white
                    : Colors.black,
              ),
            )
          ],
        ),
      ),
    );
  }


  Future<void> dialogBuilderError(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: backgroundRefugee,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadiusApplication,
          ),
          title: const Text('You provided wrong data'),
          titleTextStyle: GoogleFonts.raleway(
            fontSize: 16,
            color: redColor,
          ),
          content: const Text("You have provided wrong data, so please supply correct data or leave previous data"),
          contentTextStyle: GoogleFonts.raleway(
            fontSize: 14,
            color: redColor,
          ),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Center(
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height *
                        0.085,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                        borderRadiusApplication),
                    child: TextButton(
                        child: Text(
                          'Supply the data',
                          style: GoogleFonts.raleway(
                            fontSize: 16,
                            color: redColor,
                          ),
                        ),
                        onPressed: () async {
                          Navigator.of(context).pop();
                        }),
                  ),
                ),
              ),
            ),
            // TextButton(
            //   style: TextButton.styleFrom(
            //     textStyle: Theme.of(context).textTheme.labelLarge,
            //   ),
            //   child: const Text('Choose category'),
            //   onPressed: () {
            //     Navigator.of(context).pop();
            //   },
            // ),
            SizedBox(
              height:
              MediaQuery.of(context).size.height *
                  0.01,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Center(
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height *
                        0.085,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                        BorderRadius.circular(15)),
                    child: TextButton(
                        child: Text(
                          "Leave previous data",
                          style: GoogleFonts.raleway(
                            fontSize: 16,
                            color: redColor,
                          ),
                        ),
                        onPressed: () async {

                          Future.delayed(Duration(seconds: 1),
                                  () {
                                controllerTabBottomRef = PersistentTabController(initialIndex: 2);
                                Navigator.of(context, rootNavigator: true).pushReplacement(
                                    MaterialPageRoute(builder: (context) => new MainScreenRefugee()));
                              });
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(builder: (context) => MainScreen()),
                          // if(chosenCategoryList==[]){
                          //   dialogBuilder(context);
                          // }
                          // else if(chosenCategoryList!=[]){
                          // FirebaseFirestore.instance
                          //     .collection('users')
                          //     .doc(streamSnapshot
                          //     .data?.docs[index].id)
                          //     .update({
                          //   "category": chosenCategoryList
                          // });
                          // categoriesVolunteer =
                          //     chosenCategoryList;
                          // }
                          // Future.delayed(Duration(seconds: 1),
                          //         () {
                          //   if(chosenCategoryList == []){
                          //     dialogBuilder(context);
                          //     print("IIIIIIIIIIIIII");
                          //   }
                          //   else {
                          //     print("SSSSSSSSSSSSSSS");
                          //     print(chosenCategoryList);
                          //     Navigator.push(
                          //         context,
                          //         MaterialPageRoute(
                          //             builder: (
                          //                 context) =>
                          //             const HomeVol()));
                          //   }
                          //     });
                          // );
                        }),
                  ),
                ),
              ),
            ),
            SizedBox(
              height:
              MediaQuery.of(context).size.height *
                  0.02,
            ),
            // TextButton(
            //   style: TextButton.styleFrom(
            //     textStyle: Theme.of(context).textTheme.labelLarge,
            //   ),
            //   child: const Text('Leave my categories'),
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => const HomeVol()),
            //     );
            //   },
            // ),
          ],
        );
      },
    );
  }

}