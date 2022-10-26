import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wol_pro_1/volunteer/applications/page_of_application_vol.dart';
import 'package:wol_pro_1/screens/my_applications/applications_vol.dart';
import 'package:wol_pro_1/screens/intro_screen/option.dart';
import 'package:wol_pro_1/services/auth.dart';
import 'package:wol_pro_1/volunteer/settings_vol_info.dart';

import '../screens/menu/volunteer/all_applications/new_screen_with_applications.dart';
import '../screens/menu/volunteer/home_page/settings_home_vol.dart';


String card_title='';
String card_category='';
String card_comment='';
String userID_vol ='';

List<String> chosen_category_settings = [];
class YourCategories extends StatefulWidget {
  const YourCategories({Key? key}) : super(key: key);
  @override
  State createState() => new YourCategoriesState();
}

class YourCategoriesState extends State<YourCategories> {


  FirebaseFirestore db = FirebaseFirestore.instance;

  bool loading = false;
  final AuthService _auth_Vol_your = AuthService();
  final CollectionReference applications = FirebaseFirestore.instance.collection("applications");

  // List<String> cat = [];

  // List<String> categories = ["Your categories", "Accomodation", "Transfer", "Assistance with animals"];

  // List list_cat = [];
  //
  // List getList() {
  //     DocumentReference docRef = FirebaseFirestore.instance.collection("users").doc(userID_vol);
  //     docRef.set("category").toString();
  //     List data = [];
  //     data.add(docRef.set("category").toString());
  //     // docRef.get().then((datasnapshot){
  //     //     data.add(datasnapshot.get("category"));
  //     // });
  //     return data as List;
  //   }

    // @override
    // void main() async{
    //
    //   list_cat = await getList() as List;
    // }

  @override

  void initState() {

  }
  Widget build(BuildContext context) {

    print(userID_vol);
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Categories()),
        );
        return true;
      },
      child:
      // DefaultTabController(
      //
      //   length: categories.length,
        Scaffold(
          appBar:

          AppBar(
            title: const Text('Home'),
            backgroundColor: Color.fromRGBO(49, 72, 103, 0.8),
            elevation: 0.0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back,color: Colors.white,),
              onPressed: () async {
                // await _auth_Vol_your.signOut();
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
            //       chosen_category_settings = [];
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
            // bottom: TabBar(
            //   indicatorColor: Color.fromRGBO(85, 146, 169, 0.8),
            //   isScrollable: true,
            //   tabs: [
            //     Text(categories[0],style: TextStyle(fontSize: 17),),
            //     Text(categories[1],style: TextStyle(fontSize: 17),),
            //     Text(categories[2],style: TextStyle(fontSize: 17),),
            //     Text(categories[3],style: TextStyle(fontSize: 17),),
            //   ],
            //
            // ),
          ),
        body:
    // TabBarView(
    //       children: [

            Container(
              color: Color.fromRGBO(234, 191, 213, 0.8),
              child: StreamBuilder(
                stream:  applications
                    .where("status", isEqualTo: 'Sent to volunteer')
                    .where("category", whereIn: categories_user_Register)

                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot?> streamSnapshot) {
                  return ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: !streamSnapshot.hasData? 1:streamSnapshot.data?.docs.length,
                      itemBuilder: (ctx, index) {

                  if (streamSnapshot.hasData){
                  switch (streamSnapshot.connectionState){
                    case ConnectionState.waiting:
                      return  Column(
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
                          MaterialButton(
                            onPressed: () {
                              setState(() {
                                card_title_vol=streamSnapshot.data?.docs[index]['title'] as String;
                                card_category_vol=streamSnapshot.data?.docs[index]['category'] as String;
                                card_comment_vol=streamSnapshot.data?.docs[index]['comment'] as String;

                                print(card_title);
                                print(card_category);
                                print(card_comment);
                                Id_Of_current_application = streamSnapshot.data?.docs[index].id;
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
                                      //streamSnapshot.data?.docs[index]['title']==null ?

                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(
                                          streamSnapshot.data?.docs[index]['title'],
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold, ),
                                          textAlign: TextAlign.left,
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


          // ],
        // ),
        ),
      // ),
    );
  }
}