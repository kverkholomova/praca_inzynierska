import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:wol_pro_1/Refugee/SettingRefugee.dart';
import 'package:wol_pro_1/Refugee/applications/all_applications.dart';
import 'package:wol_pro_1/Refugee/home/home_ref.dart';
import 'package:wol_pro_1/services/auth.dart';
import 'constants.dart';



var count = 0;

String status = "Sent to volunteer";
String volID = "";

class Application extends StatefulWidget {
  @override
  State<Application> createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  var id;
  var ID;
  final List<String> categories = [
    'Choose category',
    'Accomodation',
    'Transfer',
    'Assistance with animals',
    "Clothes",
    "Assistance with children",
    "Free lawyer",
    "Medical assistance",
    "Other"
  ];
  String title = '';
  String currentCategory = '';
  String comment = '';

  final height = 100;
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeRef()),
        );
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Home'),
          backgroundColor: Color.fromRGBO(49, 72, 103, 0.8),
          elevation: 0.0,
          actions: <Widget>[
            TextButton.icon(
              icon: const Icon(
                Icons.person,
                color: Colors.white,
              ),
              label: const Text(
                'logout',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                await _auth.signOut();
              },
            )
          ],
        ),
        body: Container(
            color: Color.fromRGBO(234, 191, 213, 0.8),
            child: Column(
              children: [
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextFormField(
                    decoration: textInputDecoration.copyWith(hintText: 'Title'),
                    validator: (val) => val!.isEmpty ? 'Enter the title' : null,
                    onChanged: (val) {
                      setState(() => title = val);
                    },
                  ),
                ),

                //dropdown
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: DropdownButtonFormField(
                    value: categories[0],
                    items: categories.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (val) {
                      setState(() {
                        currentCategory = val.toString();
                      });
                    },
                  ),
                ),

                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: TextFormField(
                    maxLines: height ~/ 20,
                    decoration: textInputDecoration.copyWith(hintText: 'Comment'),
                    validator: (val) => val!.isEmpty ? 'Enter the comment' : null,
                    onChanged: (val) {
                      setState(() => comment = val);
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Center(
                    child: Container(
                      width: 300,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20)
                      ),
                      child: MaterialButton(
                        color: const Color.fromRGBO(137, 102, 120, 0.8),
                        child: const Text('Add new application', style: (TextStyle(color: Colors.white, fontSize: 15)),),
                        onPressed: () async{
                          ID = FirebaseAuth.instance.currentUser?.uid;
                          await FirebaseFirestore.instance
                              .collection('applications')
                              .add({
                            'title': (title == Null)?("Title"):(title),
                            'category': (currentCategory=='')?("Category"):(currentCategory),
                            'comment': (comment==Null)?("Comment"):(comment),
                            'status': status,
                            'userID': ID,
                            'volunteerID': volID,
                            'date': "null",
                            'token_vol': "null",
                            'token_ref': token_ref,
                            'chatId_vol': "null",
                            'mess_button_visibility_vol': true,
                            'mess_button_visibility_ref': false,
                            'refugee_name': current_name_Ref,
                            'volunteer_name': 'null',
                            'Id': 'null',
                            'voluneer_rating': 5,
                            "application_accepted": false,
                            //'volunteer_pref': currentCategory,

                            // 'userId': FirebaseFirestore.instance.collection('applications').doc().id,
                          });
                          currentCategory='';
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => HomeRef()),
                          );
                        },
                      ),
                    ),
                  ),
                ),
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
            )),
      ),
    );
  }
}
