import 'dart:async';
import 'dart:math';

import 'package:cool_dropdown/cool_dropdown.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:wol_pro_1/to_delete/SettingRefugee.dart';
import 'package:wol_pro_1/constants.dart';
import 'package:wol_pro_1/to_delete/home_ref.dart';
import 'package:wol_pro_1/services/auth.dart';

import '../../../../../models/categories.dart';
import '../../main_screen_ref.dart';
import '../home_ref.dart';



String tokenRefApplication = '';
var count = 0;

String status = "Sent to volunteer";
String volID = "";
int numChart = 0;

class Application extends StatefulWidget {
  @override
  State<Application> createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  var id;
  var ID;
  // final List<String> categories = [
  //   'Choose category',
  //   'Accomodation',
  //   'Transfer',
  //   'Assistance with animals',
  //   "Clothes",
  //   "Assistance with children",
  //   "Free lawyer",
  //   "Medical assistance",
  //   "Other"
  // ];
  String title = '';
  String currentCategory = '';
  String comment = '';

  final height = 100;
  final AuthService _auth = AuthService();

  String valueChosen = dropdownItemList[3]["value"];
  late StreamSubscription<User?> user;
  String? userNameRefugee;


  // void foregroundMessage(){
  //   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  //
  //     print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAALLLLLLLLLLLLLLLLLLLLL");
  //     print(message.sentTime);
  //   });
  //   // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //   //   print('Got a message whilst in the foreground!');
  //   //   print('Message data: ${message.data}');
  //   //
  //   //   if (message.notification != null) {
  //   //     print('Message also contained a notification: ${message.notification}');
  //   //   }
  //   // });
  //
  // }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // foregroundMessage();
    print("Tokeeeen Refugeeeeeee Applicaaatiiiiooon");
    print(tokenRefApplication);
    user = FirebaseAuth.instance.authStateChanges().listen((user) async {
      DocumentSnapshot variable = await FirebaseFirestore.instance.
      collection('users').
      doc(FirebaseAuth.instance.currentUser!.uid).
      get();

      userNameRefugee = variable['user_name'];
    });
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        currentCategory='';
        title = '';
        comment = '';
        numChart = 0;
        controllerTabBottomRef = PersistentTabController(initialIndex: 2);
        Navigator.of(context, rootNavigator: true).pushReplacement(
            MaterialPageRoute(builder: (context) => new MainScreenRefugee()));
        return true;
      },
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        floatingActionButton: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 30,
            color: redColor,
          ),
          onPressed: () {
            currentCategory='';
            title = '';
            comment = '';
            numChart = 0;
            controllerTabBottomRef = PersistentTabController(initialIndex: 2);
            Navigator.of(context, rootNavigator: true).pushReplacement(
                MaterialPageRoute(builder: (context) => new MainScreenRefugee()));
          },
        ),
        backgroundColor: backgroundRefugee,
        resizeToAvoidBottomInset: false,
        // appBar: AppBar(
        //   title: const Text('Home'),
        //   backgroundColor: Color.fromRGBO(49, 72, 103, 0.8),
        //   elevation: 0.0,
        //   actions: <Widget>[
        //     TextButton.icon(
        //       icon: const Icon(
        //         Icons.person,
        //         color: Colors.white,
        //       ),
        //       label: const Text(
        //         'logout',
        //         style: TextStyle(color: Colors.white),
        //       ),
        //       onPressed: () async {
        //         await _auth.signOut();
        //       },
        //     )
        //   ],
        // ),
        body: Padding(
          padding: padding,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.08,
                    top: MediaQuery.of(context).size.height * 0.02
                ),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    "Add new application",
                    style: GoogleFonts.raleway(
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              // SizedBox(
              //   height:
              //   MediaQuery.of(context).size.height *
              //       0.02,
              // ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height *
                        0.005,
                  ),
                  child: Text(
                    "What the title of your application?",
                    style: textLabelSeparated,
                  ),
                ),
              ),
              TextFormField(
                // controller: widget.customHintText == "Name"
                //     ?controllerTextFieldNameVol
                //     : widget.customHintText == "Phone number"
                //     ?controllerTextFieldPhoneNumberVol
                //     : widget.customHintText == "Email"
                //     ?controllerTextFieldEmailVolRegistration
                //     :widget.customHintText == "Password"
                //     ?controllerTextFieldPasswordVolRegistration
                //     :null,
                decoration: InputDecoration(
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: borderRadiusApplication,
                    borderSide: const BorderSide(
                      color: Colors.red,
                      width: 1.5,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: borderRadiusApplication,
                    borderSide: const BorderSide(
                      color: Colors.red,
                      width: 1.5,
                    ),
                  ),
                  errorStyle: const TextStyle(
                      color: Colors.red
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: borderRadiusApplication,
                    borderSide: BorderSide(
                      color: Colors.black.withOpacity(0.7),
                      // color: Color.fromRGBO(2, 62, 99, 20),
                      width: 1.5,
                    ),
                  ),
                  // labelText: widget.customHintText,
                  // labelStyle: GoogleFonts.raleway(
                  //   fontSize: 16,
                  //   color: Colors.black.withOpacity(0.7),
                  // ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: borderRadiusApplication,
                    borderSide: const BorderSide(
                      color: Colors.white,
                      width: 0,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  // hintStyle: GoogleFonts.raleway(
                  //   fontSize: 16,
                  //   color: Colors.black.withOpacity(0.5),
                  // ),
                  // hintText: widget.customHintText,
                  // suffixIcon: widget.customHintText=="Password"?IconButton(
                  //   icon: Icon(
                  //     // Based on passwordVisible state choose the icon
                  //     passwordVisible
                  //         ? Icons.visibility
                  //         : Icons.visibility_off,
                  //     color: const Color.fromRGBO(2, 62, 99, 20),
                  //   ),
                  //   onPressed: () {
                  //     // Update the state i.e. toogle the state of passwordVisible variable
                  //     setState(() {
                  //       widget.hide = passwordVisible;
                  //       passwordVisible = !passwordVisible;
                  //     });
                  //   },
                  // ):null,
                ),
                validator: (val) =>val!.isEmpty ? 'Enter the title' : null,
                onChanged: (val) {

                    setState(() => title = val);


                },
              ),
              SizedBox(
                height:
                MediaQuery.of(context).size.height *
                    0.02,
              ),
              // Padding(
              //   padding: const EdgeInsets.all(15.0),
              //   child: TextFormField(
              //     decoration: textInputDecoration.copyWith(hintText: 'Title'),
              //     validator: (val) => val!.isEmpty ? 'Enter the title' : null,
              //     onChanged: (val) {
              //       setState(() => title = val);
              //     },
              //   ),
              // ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height *
                        0.005,
                  ),
                  child: Text(
                    "Choose category that refers to your application",
                    style: textLabelSeparated,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: CoolDropdown(
                    resultMainAxis:MainAxisAlignment.start,
                  unselectedItemTS: const TextStyle(
                      color: Colors.black, fontSize: 14),
                  dropdownItemPadding:
                  const EdgeInsets.symmetric(horizontal: 20),
                  isTriangle: false,
                  gap: -30,
                    dropdownItemReverse: true,
                    dropdownItemMainAxis:MainAxisAlignment.start,
                  resultHeight: MediaQuery.of(context).size.height * 0.09,
                  resultBD: BoxDecoration(
                      color: backgroundRefugee,
                      borderRadius: borderRadiusApplication,
                      border:
                      Border.all(width: 0.5, color: redColor)),
                  resultTS: TextStyle(
                      color: redColor, fontSize: 14),
                  placeholderTS: TextStyle(
                      color: backgroundRefugee,
                      fontSize: 14),
                  selectedItemTS: TextStyle(
                      color: redColor, fontSize: 14),
                  selectedItemBD: BoxDecoration(
                      color: backgroundRefugee),
                  dropdownBD: BoxDecoration(
                    color: Colors.white,
                    borderRadius: borderRadiusApplication,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  resultWidth: double.infinity,
                  dropdownWidth: MediaQuery.of(context).size.width * 0.8,
                  dropdownList: dropdownItemList,

                  onChange: (newVal) {
                    setState(() {
                      valueChosen = newVal["value"];
                      currentCategory = valueChosen;
                    });
                    // valueIcon = newVal["icon"].toString();
                  },
                  defaultValue: dropdownItemList[3],
                ),
              ),
              SizedBox(
                height:
                MediaQuery.of(context).size.height *
                    0.02,
              ),
              //dropdown
              // Padding(
              //   padding: const EdgeInsets.all(15.0),
              //   child: DropdownButtonFormField(
              //     value: categoriesListAllRefugee[8],
              //     items: categoriesListAllRefugee.map((category) {
              //       return DropdownMenuItem(
              //         value: category,
              //         child: Text(category),
              //       );
              //     }).toList(),
              //     onChanged: (val) {
              //       setState(() {
              //         currentCategory = val.toString();
              //       });
              //     },
              //   ),
              // ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).size.height *
                        0.005,
                  ),
                  child: Text(
                    "Add description to your application \n(min 30 signs) ${numChart}/30",
                    style: textLabelSeparated,
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                // height: MediaQuery.of(context).size.height *
                //     0.2,
                decoration:
                  BoxDecoration(
                      color: Colors.white,
                      borderRadius: borderRadiusApplication
                  ),
                child: TextFormField(

                  maxLines: height ~/ 15,
                  decoration: InputDecoration(
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: borderRadiusApplication,
                      borderSide: const BorderSide(
                        color: Colors.red,
                        width: 1.5,
                      ),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: borderRadiusApplication,
                      borderSide: const BorderSide(
                        color: Colors.red,
                        width: 1.5,
                      ),
                    ),
                    errorStyle: const TextStyle(
                        color: Colors.red
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: borderRadiusApplication,
                      borderSide: BorderSide(
                        color: Colors.black.withOpacity(0.7),
                        // color: Color.fromRGBO(2, 62, 99, 20),
                        width: 1.5,
                      ),
                    ),
                    // labelText: widget.customHintText,
                    // labelStyle: GoogleFonts.raleway(
                    //   fontSize: 16,
                    //   color: Colors.black.withOpacity(0.7),
                    // ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: borderRadiusApplication,
                      borderSide: const BorderSide(
                        color: Colors.white,
                        width: 0,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    // hintStyle: GoogleFonts.raleway(
                    //   fontSize: 16,
                    //   color: Colors.black.withOpacity(0.5),
                    // ),
                    // hintText: widget.customHintText,
                    // suffixIcon: widget.customHintText=="Password"?IconButton(
                    //   icon: Icon(
                    //     // Based on passwordVisible state choose the icon
                    //     passwordVisible
                    //         ? Icons.visibility
                    //         : Icons.visibility_off,
                    //     color: const Color.fromRGBO(2, 62, 99, 20),
                    //   ),
                    //   onPressed: () {
                    //     // Update the state i.e. toogle the state of passwordVisible variable
                    //     setState(() {
                    //       widget.hide = passwordVisible;
                    //       passwordVisible = !passwordVisible;
                    //     });
                    //   },
                    // ):null,
                  ),
                  validator: (val) => val!.isEmpty ? 'Enter the comment' : null,
                  onChanged: (val) {

                    setState(() {
                      numChart = val.length;
                      comment= val;
                    } );
                  },
                ),
              ),
              SizedBox(
                height:
                MediaQuery.of(context).size.height *
                    0.02,
              ),
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
                          "Add new application",
                          style: textActiveButtonStyleRefugee,
                        ),
                        onPressed: () async {
                          if ( (title == '')||(comment == '')){
                            dialogBuilderEmpty(context);
                          }else if ((comment.length<30)){
                            dialogBuilderLength(context);
                          } else{
                            // setState(() {
                              ID = FirebaseAuth.instance.currentUser?.uid;
                              await FirebaseFirestore.instance
                                  .collection('applications')
                                  .add({
                                'title': (title == Null)?("Title"):(title),
                                'category': (currentCategory=='')?(valueChosen):(currentCategory),
                                'comment': (comment==Null)?("Comment"):(comment),
                                'status': status,
                                'userID': ID,
                                'volunteerID': volID,
                                'date': "null",
                                'token_vol': "null",
                                'token_ref': tokenRefApplication,
                                'chatId_vol': "null",
                                'mess_button_visibility_vol': true,
                                'mess_button_visibility_ref': false,
                                'refugee_name': userNameRefugee!,
                                'volunteer_name': 'null',
                                'Id': 'null',
                                'voluneer_rating': 5,
                                "application_accepted": false,
                              });
                              currentCategory='';
                              title = '';
                              comment = '';
                              numChart = 0;
                            // });
                            // Future.delayed(const Duration(milliseconds: 500), ()
                            // {
                              controllerTabBottomRef =
                                  PersistentTabController(initialIndex: 4);
                              Navigator.of(context, rootNavigator: true)
                                  .pushReplacement(
                                  MaterialPageRoute(builder: (
                                      context) => new MainScreenRefugee()));
                            // });
                          }
                        }),
                  ),
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.only(top: 40),
              //   child: Center(
              //     child: Container(
              //       width: 300,
              //       height: 50,
              //       decoration: BoxDecoration(
              //           borderRadius: BorderRadius.circular(20)
              //       ),
              //       child: MaterialButton(
              //         color: const Color.fromRGBO(137, 102, 120, 0.8),
              //         child: const Text('Add new application', style: (TextStyle(color: Colors.white, fontSize: 15)),),
              //         onPressed: () async{
              //           ID = FirebaseAuth.instance.currentUser?.uid;
              //           await FirebaseFirestore.instance
              //               .collection('applications')
              //               .add({
              //             'title': (title == Null)?("Title"):(title),
              //             'category': (currentCategory=='')?("Category"):(currentCategory),
              //             'comment': (comment==Null)?("Comment"):(comment),
              //             'status': status,
              //             'userID': ID,
              //             'volunteerID': volID,
              //             'date': "null",
              //             'token_vol': "null",
              //             'token_ref': token_ref,
              //             'chatId_vol': "null",
              //             'mess_button_visibility_vol': true,
              //             'mess_button_visibility_ref': false,
              //             'refugee_name': current_name_Ref,
              //             'volunteer_name': 'null',
              //             'Id': 'null',
              //             'voluneer_rating': 5,
              //             "application_accepted": false,
              //             //'volunteer_pref': currentCategory,
              //
              //             // 'userId': FirebaseFirestore.instance.collection('applications').doc().id,
              //           });
              //           currentCategory='';
              //           Navigator.push(
              //             context,
              //             MaterialPageRoute(builder: (context) => HomeRef()),
              //           );
              //         },
              //       ),
              //     ),
              //   ),
              // ),
              // RaisedButton.icon(
              //     icon: Icon(Icons.add),
              //     color: Colors.pink[400],
              //     label: Text(
              //       'Add new application',
              //       style: TextStyle(color: Colors.white),
              //     ),
              //     onPressed: () async {
              //       ID = FirebaseAuth.instance.currentUser?.uid;
              //       await FirebaseFirestore.instance
              //           .collection('applications')
              //           .add({
              //         'title': (title == Null)?("Title"):(title),
              //         'category': (currentCategory=='')?("Category"):(currentCategory),
              //         'comment': (comment==Null)?("Comment"):(comment),
              //         'status': status,
              //         'userID': ID,
              //         'volunteerID': volID,
              //         'date': "null",
              //         'token_vol': "null",
              //         'token_ref': token_ref,
              //         'chatId_vol': "null",
              //         'mess_button_visibility_vol': true,
              //         'mess_button_visibility_ref': false,
              //         'refugee_name': current_name_Ref,
              //         'volunteer_name': 'null',
              //         'Id': 'null',
              //         //'volunteer_pref': currentCategory,
              //
              //        // 'userId': FirebaseFirestore.instance.collection('applications').doc().id,
              //       });
              //       currentCategory='';
              //       //FirebaseAuth.instance.currentUser?.uid;
              //     }),
            ],
          ),
        ),
      ),
    );
  }
  Future<void> dialogBuilderEmpty(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: backgroundRefugee,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadiusApplication,
          ),
          title: const Text('Fill the form'),
          titleTextStyle: GoogleFonts.raleway(
            fontSize: 16,
            color: redColor,
          ),
          content: const Text("You haven't filled the form, please supply the data"),
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
                          "Don't need any help",
                          style: GoogleFonts.raleway(
                            fontSize: 16,
                            color: redColor,
                          ),
                        ),
                        onPressed: () async {
                          currentCategory='';
                          title = '';
                          comment = '';
                          numChart = 0;
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
  Future<void> dialogBuilderLength(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: backgroundRefugee,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadiusApplication,
          ),
          title: const Text('Fill the comment form'),
          titleTextStyle: GoogleFonts.raleway(
            fontSize: 16,
            color: redColor,
          ),
          content: const Text("You haven't filled the comment form properly, please supply more characters to detail your application"),
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
