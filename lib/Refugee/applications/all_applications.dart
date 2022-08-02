import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:wol_pro_1/services/auth.dart';

import '../SettingRefugee.dart';
import '../home/home_ref.dart';
import 'application_info.dart';

String application_ID = '';
String card_title_ref='';
String card_category_ref='';
String card_comment_ref='';

String userID_ref = '';
String? token_vol;

class CategoriesRef extends StatefulWidget {
  const CategoriesRef({Key? key}) : super(key: key);
  @override
  State createState() => new CategoriesRefState();
}

class CategoriesRefState extends State<CategoriesRef> {





  bool loading = false;
  final AuthService _auth = AuthService();
  List<String> categories = ["Accepted", "Queue"];

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
      child: DefaultTabController(

        length: categories.length,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Your applications'),
            backgroundColor: Color.fromRGBO(49, 72, 103, 0.8),
            elevation: 0.0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back,color: Colors.white,),
              onPressed: () async {
                // await _auth.signOut();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsHomeRef()),
                );
              },
            ),

            bottom: TabBar(
              indicatorColor: Color.fromRGBO(85, 146, 169, 0.8),
              isScrollable: true,
              tabs: [
                Text(categories[0],style: TextStyle(fontSize: 17),),
                Text(categories[1],style: TextStyle(fontSize: 17),),
              ],

            ),
          ),
          body: Container(
            color: Color.fromRGBO(234, 191, 213, 0.8),
            child: TabBarView(
              children: [

                StreamBuilder(
                  stream: FirebaseFirestore.instance

                      .collection('applications')
                      .where('userID', isEqualTo: FirebaseAuth.instance.currentUser?.uid)



                  //.where("volunteer_pref", arrayContainsAny: volunteer_preferencies)
                  //.where("category", arrayContainsAny: ['Accomodation', 'Transfer', 'Assistance with animals'])
                      .where("status", isEqualTo: 'Application is accepted')



                  //.where("category", whereIn: ['Accomodation','Transfer','Assistance with animals'])
                  //.where("category", arrayContainsAny: ['Accomodation','Transfer','Assistance with animals'])
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot?> streamSnapshot) {
                    return Container(
                      width: 450,
                      height: 300,
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: streamSnapshot.data?.docs.length,
                          itemBuilder: (ctx, index) => Column(
                            children: [
                              MaterialButton(
                                onPressed: () {
                                  setState(() {
                                    card_title_ref=streamSnapshot.data?.docs[index]['title'] as String;
                                    card_category_ref=streamSnapshot.data?.docs[index]['category'] as String;
                                    card_comment_ref=streamSnapshot.data?.docs[index]['comment'] as String;
                                    application_ID = streamSnapshot.data?.docs[index].id as String;
                                    token_vol=streamSnapshot.data?.docs[index]["token_vol"]as String;
                                    print(card_title_ref);
                                    print(card_category_ref);
                                    print(card_comment_ref);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => PageOfApplicationRef()),
                                    );
                                    // print("print ${streamSnapshot.data?.docs[index][id]}");
                                  });

                                },
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          //streamSnapshot.data?.docs[index]['title']==null ?

                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              streamSnapshot.data?.docs[index]['title'],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),//: Text('nic'),
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                                streamSnapshot.data?.docs[index]
                                                ['category'] as String,
                                                style: TextStyle(color: Colors.grey)),
                                          ),
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Text(streamSnapshot.data?.docs[index]
                                            ['comment'] as String),
                                          ),

                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )),
                    );
                  },
                ),
                StreamBuilder(
                  stream:   FirebaseFirestore.instance
                      .collection('applications')
                      .where('userID', isEqualTo: FirebaseAuth.instance.currentUser?.uid)

                  //.where("volunteer_pref", arrayContainsAny: volunteer_preferencies)
                  //.where("category", arrayContainsAny: ['Accomodation', 'Transfer', 'Assistance with animals'])
                      .where("status", isEqualTo: 'Sent to volunteer')

                  //.where("category", whereIn: ['Accomodation','Transfer','Assistance with animals'])
                  //.where("category", arrayContainsAny: ['Accomodation','Transfer','Assistance with animals'])
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot?> streamSnapshot) {
                    return Container(
                      width: 450,
                      height: 300,
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: streamSnapshot.data?.docs.length,
                          itemBuilder: (ctx, index) => Column(
                            children: [
                              MaterialButton(
                                onPressed: () {

                                  setState(() {
                                    card_title_ref=streamSnapshot.data?.docs[index]['title'] as String;
                                    card_category_ref=streamSnapshot.data?.docs[index]['category'] as String;
                                    card_comment_ref=streamSnapshot.data?.docs[index]['comment'] as String;
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => PageOfApplicationRef()),
                                    );
                                    // print("print ${streamSnapshot.data?.docs[index][id]}");
                                  });

                                },
                                child: Card(
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                streamSnapshot.data?.docs[index]['title'] as String,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                  streamSnapshot.data?.docs[index]
                                                  ['category'] as String,
                                                  style: TextStyle(color: Colors.grey)),
                                            ),
                                            Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(streamSnapshot.data?.docs[index]
                                              ['comment'] as String),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )),
                    );
                  },
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}