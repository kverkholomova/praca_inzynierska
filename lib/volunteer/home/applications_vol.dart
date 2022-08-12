import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wol_pro_1/volunteer/applications/page_of_application_vol.dart';
import 'package:wol_pro_1/cash/screen_with_applications.dart';
import 'package:wol_pro_1/volunteer/applications/settings_of_application.dart';
import 'package:wol_pro_1/volunteer/authenticate/register_volunteer_1.dart';
import 'package:wol_pro_1/volunteer/home/settings_home_vol.dart';

import '../../screens/intro_screen/option.dart';

String card_title_accepted='';
String card_category_accepted='';
String card_comment_accepted='';
// String current_name = '';


class ApplicationsOfVolunteer extends StatefulWidget {
  const ApplicationsOfVolunteer({Key? key}) : super(key: key);

  @override
  State<ApplicationsOfVolunteer> createState() => _ApplicationsOfVolunteerState();
}

class _ApplicationsOfVolunteerState extends State<ApplicationsOfVolunteer> {


  @override
  Widget build(BuildContext context) {


    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SettingsHomeVol()),
        );
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(49, 72, 103, 0.8),
          elevation: 0.0,
          leading: IconButton(onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsHomeVol()),
            );
          }, icon: Icon(Icons.arrow_back),

          ),
          title: Text('Your applications',style: TextStyle(fontSize: 16),),

        ),
        body: Container(
          color: Color.fromRGBO(234, 191, 213, 0.8),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('applications')
                .where("volunteerID", isEqualTo: FirebaseAuth.instance.currentUser?.uid)
                .where("status", isEqualTo: 'Application is accepted')

                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
              return ListView.builder(
                  itemCount: !streamSnapshot.hasData? 1:streamSnapshot.data?.docs.length,
                  itemBuilder: (ctx, index) {
                  if (streamSnapshot.hasData){
                  switch (streamSnapshot.connectionState){
                    case ConnectionState.waiting:
                      return Column(
                          children: [
                            SizedBox(
                              width: 60,
                              height: 60,
                              child: CircularProgressIndicator(),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 16),
                              child: Text('Awaiting data...'),
                            )
                          ]

                      );

                    case ConnectionState.active:
                      return Column(
                        children: [
                          SizedBox(
                            width: 350,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 0),
                              child: MaterialButton(
                                onPressed: (){
                                  Id_Of_current_application= streamSnapshot.data?.docs[index].id;
                                  print("GGGGGGGGGGGGGGG________________GGGGGGGGGFFFFFFFFFFFFFFF");
                                  print(Id_Of_current_application);

                                  card_title_accepted=streamSnapshot.data?.docs[index]['title'] as String;
                                  card_category_accepted=streamSnapshot.data?.docs[index]['category'] as String;
                                  card_comment_accepted=streamSnapshot.data?.docs[index]['comment'] as String;

                                  // current_name = streamSnapshot.data?.docs[index]['ref_name'];

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SettingsOfApplication()),
                                  );
                                },
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Stack(
                                      children: [
                                        Align(
                                            alignment: Alignment.topRight,
                                            child: Container(child: Icon(Icons.zoom_in_rounded, color: Colors.grey[700], size: 20,))),
                                        Column(
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
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),


                        ],
                      );}}
                  return Center(
                    child: Padding(padding: EdgeInsets.only(top: 100),
                      child: Column(
                        children: [
                          SpinKitChasingDots(
                            color: Colors.brown,
                            size: 50.0,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                                "Waiting...",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,fontSize: 24,color: Colors.black,)
                            ),
                          ),
                          Padding(padding: EdgeInsets.only(top: 20),)
                        ],
                      ),
                    ),
                  );
                  });
            },
          ),
        ),
      ),
    );
  }
}


/**RaisedButton.icon(
    icon: Icon(Icons.add,color: Colors.white,),
    color: Color.fromRGBO(234, 191, 213, 0.8),
    onPressed: () {
    Navigator.push(context,
    MaterialPageRoute(builder: (context) => Categories()));

    }, label: Text("Add"),
    ),**/