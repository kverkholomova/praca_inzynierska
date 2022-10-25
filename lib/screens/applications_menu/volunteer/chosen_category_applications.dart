import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wol_pro_1/services/auth.dart';

import '../../../volunteer/applications/page_of_application_vol.dart';
import '../../../volunteer/your_app_vol.dart';
import 'new_screen_with_applications.dart';

String? id_card = '';
class ChosenCategory extends StatefulWidget{
  const ChosenCategory({Key? key}) : super(key: key);
  @override
  State createState() => new ChosenCategoryState();
}

class ChosenCategoryState extends State<ChosenCategory> {

  final AuthService _auth_ = AuthService();
  @override

  void initState() {

  }
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Categories()),
          );
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            centerTitle: false,
            title: const Text('Home'),
            backgroundColor: Color.fromRGBO(49, 72, 103, 0.8),
            elevation: 0.0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back,color: Colors.white,),
              onPressed: () {
                // await _auth_.signOut();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Categories()),
                );
              },
            ),
            // actions: <Widget>[
            //   IconButton(
            //     icon: const Icon(Icons.settings,color: Colors.white,),
            //     //label: const Text('logout',style: TextStyle(color: Colors.white),),
            //     onPressed: () async {
            //       //await _auth.signOut();
            //       // chosen_category_settings = [];
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(builder: (context) => SettingsVol()),
            //       );
            //     },
            //   ),
            //
            //   IconButton(
            //     icon: const Icon(Icons.person,color: Colors.white,),
            //     //label: const Text('logout',style: TextStyle(color: Colors.white),),
            //     onPressed: () async {
            //       //await _auth.signOut();
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(builder: (context) => ApplicationsOfVolunteer()),
            //       );
            //     },
            //   ),
            //
            // ],
          ),
          body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('applications')
                .where("category", isEqualTo: category_chosen_button)

            //.where("volunteer_pref", arrayContainsAny: volunteer_preferencies)
            //.where("category", arrayContainsAny: ['Accomodation', 'Transfer', 'Assistance with animals'])
                .where("status", isEqualTo: 'Sent to volunteer')

            //.where("category", whereIn: ['Accomodation','Transfer','Assistance with animals'])
            //.where("category", arrayContainsAny: ['Accomodation','Transfer','Assistance with animals'])
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot?> streamSnapshot) {
              return Container(
                width: 450,
                height: double.infinity,
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: streamSnapshot.data?.docs.length,
                    itemBuilder: (ctx, index) => Column(
                      children: [
                        MaterialButton(
                          onPressed: () {

                            setState(() {
                              // FirebaseFirestore.instance
                              //     .collection('applications')
                              //     .doc(streamSnapshot.data?.docs[index].id)
                              //     .update({"Id": streamSnapshot.data?.docs[index].id});
                              //
                              // id_card = streamSnapshot.data?.docs[index].id;
                              card_title_vol=streamSnapshot.data?.docs[index]['title'];
                              card_category_vol=streamSnapshot.data?.docs[index]['category'];
                              card_comment_vol=streamSnapshot.data?.docs[index]['comment'];
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PageOfApplication()),
                              );
                              // print("print ${streamSnapshot.data?.docs[index][id]}");
                            });

                          },
                          child: Card(
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Text(
                                      streamSnapshot.data?.docs[index]['title'] as String,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                        streamSnapshot.data?.docs[index]['category'] as String,
                                        style: TextStyle(color: Colors.grey)),
                                    Text(streamSnapshot.data?.docs[index]['comment'] as String),
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
        ));
  }
}