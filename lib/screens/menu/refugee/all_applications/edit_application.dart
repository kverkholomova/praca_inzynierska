import 'dart:async';
import 'package:cool_dropdown/cool_dropdown.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:wol_pro_1/constants.dart';
import 'package:wol_pro_1/screens/menu/refugee/all_applications/all_app_ref.dart';
import 'package:wol_pro_1/screens/menu/refugee/all_applications/application_info.dart';
import 'package:wol_pro_1/services/auth.dart';
import '../../../../../models/categories.dart';
import '../main_screen_ref.dart';


int numChartEdit = 0;
class EditApplication extends StatefulWidget {
  @override
  State<EditApplication> createState() => _EditApplicationState();
}

class _EditApplicationState extends State<EditApplication> {
  var id;
  var ID;

  String changedTitle = '';
  String changedCurrentCategory = '';
  String changedComment = '';

  final height = 100;
  final AuthService _auth = AuthService();

  String valueChosen = dropdownItemList[3]["value"];
  late StreamSubscription<User?> user;
  String? userNameRefugee;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    foregroundMessage();
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
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // currentCategory='';
        // title = '';
        // comment = '';
        // numChart = 0;
        controllerTabBottomRef = PersistentTabController(initialIndex: 2);
        Navigator.of(context, rootNavigator: true).pushReplacement(
            MaterialPageRoute(builder: (context) => new MainScreenRefugee()));
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Text(
            "Edit your application",
            style: GoogleFonts.raleway(
              fontSize: 18,
              color: Colors.black,
            ),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 30,
              color: redColor,
            ),
            onPressed: () {
              // currentCategory='';
              // title = '';
              // comment = '';
              // numChart = 0;
              controllerTabBottomRef = PersistentTabController(initialIndex: 2);
              Navigator.of(context, rootNavigator: true).pushReplacement(
                  MaterialPageRoute(builder: (context) => new MainScreenRefugee()));
            },
          ),
        ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        // floatingActionButton: ,
        backgroundColor: backgroundRefugee,
        resizeToAvoidBottomInset: false,

        body: SingleChildScrollView(
          child: Column(
            children: [

              SizedBox(
                height: MediaQuery.of(context).size.height *
                    0.99,
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('applications')
                      .where('Id', isEqualTo: applicationIDRef)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                    return ListView.builder(
                        itemCount: streamSnapshot.data?.docs.length,
                        itemBuilder: (ctx, index) {
                          print("EEEEEEEEEEdiiiiiiiiiiiiiiit");
                          print(editCategory == categoriesListAll[6]);
                          print(editCategory);
                          print( categoriesListAll[6]);
                          print(editCategory == categoriesListAll[1]
                              ?dropdownItemList[0]
                              :editCategory == categoriesListAll[2]
                              ?dropdownItemList[1]
                              :editCategory == categoriesListAll[3]
                              ?dropdownItemList[2]
                              :editCategory == categoriesListAll[4]
                              ?dropdownItemList[3]
                              :editCategory == categoriesListAll[5]
                              ?dropdownItemList[4]
                              :editCategory == categoriesListAll[6]
                              ?dropdownItemList[5]
                              :editCategory == categoriesListAll[7]
                              ?dropdownItemList[6]
                              :editCategory == categoriesListAll[8]
                              ?dropdownItemList[7]
                              :dropdownItemList[6]);
                          // categories_user = streamSnapshot.data?.docs[index]['category'];
                          // token_vol = streamSnapshot.data?.docs[index]['token'];
                          // current_name_Vol = streamSnapshot.data?.docs[index]['user_name'];
                          return SingleChildScrollView(
                            child: Padding(
                              padding: padding,
                              child: Column(
                                children: [
                                  SizedBox(
                                    height:
                                    MediaQuery.of(context).size.height * 0.03,
                                  ),
                                  Align(
                                    alignment: Alignment.topLeft,
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        bottom: MediaQuery.of(context).size.height *
                                            0.005,
                                      ),
                                      child: Text(
                                        "Edit the title of your application",
                                        style: textLabelSeparated,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height:
                                    MediaQuery.of(context).size.height * 0.085,
                                    child: TextFormField(
                                      onChanged: (val) {
                                        changedTitle = val;
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
                                        ['title'],
                                        hintStyle: hintStyleText,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height:
                                    MediaQuery.of(context).size.height *
                                        0.015,
                                  ),
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
                                          changedCurrentCategory = valueChosen;
                                        });
                                        // valueIcon = newVal["icon"].toString();
                                      },
                                      defaultValue: editCategory == categoriesListAll[1]
                                          ?dropdownItemList[0]
                                      :editCategory == categoriesListAll[2]
                                      ?dropdownItemList[1]
                                      :editCategory == categoriesListAll[3]
                                      ?dropdownItemList[2]
                                          :editCategory == categoriesListAll[4]
                                          ?dropdownItemList[3]
                                          :editCategory == categoriesListAll[5]
                                          ?dropdownItemList[4]
                                          :editCategory == categoriesListAll[6]
                                          ?dropdownItemList[5]
                                          :editCategory == categoriesListAll[7]
                                          ?dropdownItemList[6]
                                          :editCategory == categoriesListAll[8]
                                          ?dropdownItemList[7]
                                          :dropdownItemList[6],
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
                                        "Edit description to your application \n(min 30 signs) ${numChartEdit}/30",
                                        style: textLabelSeparated,
                                      ),
                                    ),
                                  ),
                                  TextFormField(
                                    maxLines: height ~/ 10,
                                    onChanged: (val) {
                                      setState(() {
                                        numChartEdit = val.length;
                                      });
                                      changedComment = val;
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
                                        ['comment'],
                                        hintStyle: hintStyleText
                                      // labelStyle: GoogleFonts.raleway(
                                      //   fontSize: 14,
                                      //   color: Colors.black.withOpacity(0.7),
                                      // ),
                                    ),
                                  ),
                                  SizedBox(
                                    height:
                                    MediaQuery.of(context).size.height * 0.015,
                                  ),
                                  Divider(color: redColor),
                                  SizedBox(
                                    height:
                                    MediaQuery.of(context).size.height * 0.03,
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
                                              "Save changes",
                                              style: textActiveButtonStyleRefugee,
                                            ),
                                            onPressed: () async {
                                              if(changedTitle==''&&changedComment==''&&changedCurrentCategory == ''){
                                                print("EEEEEEEEEmptyyyyyyyyy");
                                                dialogBuilderEmpty(context);
                                              }else if(changedComment!=""&&numChartEdit< 30){
                                                print("Leeeeeeengthhhhhhh");
                                                dialogBuilderLength(context);
                                              }
                                              else{
                                                print("Saaaaaaaaaveeeeeeeeeee");
                                                print(".${changedTitle}.");
                                                print("object");
                                                print(changedComment);
                                                print("object");
                                                print(changedCurrentCategory);
                                                print("object");
                                                dialogBuilderSaveChanges(context);
                                              }
                                              // setState(() {
                                              //   FirebaseFirestore.instance
                                              //       .collection('users')
                                              //       .doc(streamSnapshot
                                              //       .data?.docs[index].id)
                                              //       .update({
                                              //     "category": changedCategories!=[]?changedCategories:streamSnapshot
                                              //         .data?.docs[index]['category'],
                                              //     "user_name": changedName!=""?changedName:streamSnapshot
                                              //         .data?.docs[index]['user_name'],
                                              //     "age": currentAgeRefugee!=0?currentAgeRefugee:streamSnapshot
                                              //         .data?.docs[index]['age'],
                                              //     "phone_number": changedPhone!=""?changedPhone:streamSnapshot
                                              //         .data?.docs[index]['phone_number']
                                              //   });
                                              // });
                                              // Navigator.of(context, rootNavigator: true).pushReplacement(
                                              //     MaterialPageRoute(builder: (context) => new MainScreenRefugee()));
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
          title: const Text("You haven't provide any changes"),
          titleTextStyle: GoogleFonts.raleway(
            fontSize: 16,
            color: redColor,
          ),
          content: const Text("You haven't provide any changes, please change something if you want to change data"),
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
                          'Change the data',
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
                          changedTitle = '';
                          changedComment = '';
                          numChartEdit = 0;
                          Future.delayed(Duration(milliseconds: 500),
                                      () {

                                    // controllerTabBottomRef = PersistentTabController(initialIndex: 2);
                                    Navigator.of(context, rootNavigator: true).pushReplacement(
                                        MaterialPageRoute(builder: (context) => PageOfApplicationRef()));
                                  });
                          // currentCategory='';
                          // title = '';
                          // comment = '';
                          // numChart = 0;
                          // Future.delayed(Duration(seconds: 1),
                          //         () {
                          //       controllerTabBottomRef = PersistentTabController(initialIndex: 2);
                          //       Navigator.of(context, rootNavigator: true).pushReplacement(
                          //           MaterialPageRoute(builder: (context) => new MainScreenRefugee()));
                          //     });
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
          title: const Text('Fill the comment form properly'),
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
  Future<void> dialogBuilderSaveChanges(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: backgroundRefugee,
          shape: RoundedRectangleBorder(
            borderRadius: borderRadiusApplication,
          ),
          title: const Text("Change your application data?"),
          titleTextStyle: GoogleFonts.raleway(
            fontSize: 16,
            color: redColor,
          ),
          content: const Text("You have provided some changes. Would you like to save these changes?"),
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
                          'Leave previous data',
                          style: GoogleFonts.raleway(
                            fontSize: 16,
                            color: redColor,
                          ),
                        ),
                        onPressed: () async {
                          setState(() {
                            changedTitle = '';
                            changedComment = '';
                            numChartEdit = 0;
                          });
                          Future.delayed(Duration(milliseconds: 500),
                                  () {
                                // controllerTabBottomRef = PersistentTabController(initialIndex: 2);
                                Navigator.of(context, rootNavigator: true).pushReplacement(
                                    MaterialPageRoute(builder: (context) => PageOfApplicationRef()));
                              });
                          // Navigator.of(context).pop();
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
                          "Save changes",
                          style: GoogleFonts.raleway(
                            fontSize: 16,
                            color: redColor,
                          ),
                        ),
                        onPressed: () async {

                          setState(() {
                            FirebaseFirestore.instance
                                .collection('applications')
                                .doc(applicationIDRef)
                                .update({
                              "title": changedTitle!=''?changedTitle:cTitle,
                              "comment": changedComment!=''?changedComment:cComment,
                              "category": changedCurrentCategory!=''?changedCurrentCategory:editCategory
                            });
                          });
                          Future.delayed(Duration(milliseconds: 500),
                                  () {
                                    setState(() {
                                      changedTitle = '';
                                      changedComment = '';
                                      numChartEdit = 0;
                                    });
                                // controllerTabBottomRef = PersistentTabController(initialIndex: 2);
                                Navigator.of(context, rootNavigator: true).pushReplacement(
                                    MaterialPageRoute(builder: (context) => PageOfApplicationRef()));
                              });
                          // currentCategory='';
                          // title = '';
                          // comment = '';
                          // numChart = 0;
                          // Future.delayed(Duration(seconds: 1),
                          //         () {
                          //       controllerTabBottomRef = PersistentTabController(initialIndex: 2);
                          //       Navigator.of(context, rootNavigator: true).pushReplacement(
                          //           MaterialPageRoute(builder: (context) => new MainScreenRefugee()));
                          //     });
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
