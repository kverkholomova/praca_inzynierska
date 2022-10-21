/**import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:wol_pro_1/page_of_application_vol.dart';
import 'package:wol_pro_1/screens/option.dart';

import '../../services/auth.dart';
import '../../shared/application.dart';
import '../settings/settings_vol.dart';

/**void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase',
      home: HomeVol(),
    );
  }
}**/
//String card_title='';
//String card_category='';
//String card_comment='';

class HomeVol extends StatefulWidget {
  @override
  State createState() => new HomeVolState();
}

class HomeVolState extends State<HomeVol> {
//class HomeVol extends StatelessWidget {
  CollectionReference appl =
      FirebaseFirestore.instance.collection('applications');
  final AuthService _auth = AuthService();

  List<String> categories = ["Accomodation", "Transfer", "Assistance with animals"];

  Padding applications() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('applications')
            .where("category", isEqualTo: chosen_category)

        //.where("volunteer_pref", arrayContainsAny: volunteer_preferencies)
        //.where("category", arrayContainsAny: ['Accomodation', 'Transfer', 'Assistance with animals'])
            .where("status", isEqualTo: 'Sent to volunteer')

            //.where("category", whereIn: ['Accomodation','Transfer','Assistance with animals'])
            //.where("category", arrayContainsAny: ['Accomodation','Transfer','Assistance with animals'])
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot?> streamSnapshot) {
          return Container(
            width: 350,
            height: 300,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: streamSnapshot.data?.docs.length,
                itemBuilder: (ctx, index) => Column(
                      children: [
                        MaterialButton(
                          onPressed: () {
                            //card_title=streamSnapshot.data?.docs[index]['title'] as String;
                            //card_category=streamSnapshot.data?.docs[index]['category'] as String;
                            //card_comment=streamSnapshot.data?.docs[index]['comment'] as String;
                            setState(() {
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
                                        streamSnapshot.data?.docs[index]
                                            ['category'] as String,
                                        style: TextStyle(color: Colors.grey)),
                                    Text(streamSnapshot.data?.docs[index]
                                        ['comment'] as String),
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
    );
  }

  @override
  Widget Page(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OptionChoose()),
        );
        return true;
      },
      child: Scaffold(
          body:


          Column(
        children: [
          SizedBox(
            height: 25,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) => applications(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RaisedButton(
                      child: Text("Accomodation"),
                      onPressed: () {
                        setState(() {
                         // chosen_category = "Accomodation";

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeVol()));
                        });
                      }),
                  RaisedButton(
                    child: Text("Transfer"),
                    onPressed: () {
                      setState(() {
                       // chosen_category = "Transfer";
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => HomeVol()));
                      });
                    },
                  ),
                  RaisedButton(
                    child: Text("Animal"),
                    onPressed: () {
                      setState(() {
                       // chosen_category = "Assistance with animals";
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => HomeVol()));
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          applications(),
        ],
      )),
    );
  }

  String val_data = '';

  DatabaseReference ref = FirebaseDatabase.instance.ref();

  //String currentId=id.toString();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OptionChoose()),
        );
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          backgroundColor: Colors.brown[400],
          elevation: 0.0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () async {
              await _auth.signOut();
            },
          ),
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
            ),
            TextButton.icon(
              icon: const Icon(
                Icons.settings,
                color: Colors.white,
              ),
              label: const Text(
                'Settings',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => SetVol()));
              },
            ),
          ],
        ),
        body: Page(context),
      ),
    );
  }
}
/**Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RaisedButton(
                          child: Text("Accomodation"),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => applications()));
                          }),
                      RaisedButton(
                        child: Text("Transfer"),
                        onPressed: () {
                          chosen_category = "Transfer";
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => applications()));
                        },
                      ),
                      RaisedButton(
                        child: Text("Animal"),
                        onPressed: () {
                          chosen_category = "Assistance with animals";
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => applications()));
                        },
                      ),
                    ],
                  ),
                ),
              ),

              /**Padding(
              padding: const EdgeInsets.all(8.0),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('applications')
                    .where("category", isEqualTo: chosen_category)
                    //.where("category", whereIn: ['Accomodation','Transfer','Assistance with animals'])
                    //.where("category", arrayContainsAny: ['Accomodation','Transfer','Assistance with animals'])
                    .snapshots(),

                builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                  return Container(
                    width: 350,
                    height: 300,
                    child: ListView.builder(
                      itemCount: streamSnapshot.data?.docs.length,
                      itemBuilder: (ctx, index) =>

                      Column(
                        children: [
                          Card(
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [

                                    Text(streamSnapshot.data?.docs[index]['title'],style: TextStyle(fontWeight: FontWeight.bold),),
                                    Text(streamSnapshot.data?.docs[index]['category'], style: TextStyle(color: Colors.grey)),
                                    Text(streamSnapshot.data?.docs[index]['comment']),

                                  ],
                                ),
                              ),
                            ),
                          ),

                        ],
                      )

                    ),
                  );
                },
              ),
            ),**/
              applications(),
            ],
          )**/

/**FutureBuilder(
          future: FirebaseFirestore.instance
          .collection("applications")

          .get(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            QuerySnapshot<Object?>? documents = snapshot.data;
            List<DocumentSnapshot> docs = documents!.docs;
            docs.forEach((data) {
              data_from_database.add(data.data().toString());
              print(data.data().toString());
              print(data_from_database[0]);
              //_id= data.id;
      });
      }
          else if (snapshot.connectionState == ConnectionState.done) {
            Loading();
            //Map<String, dynamic> data =
            //snapshot.data?.docs.data() as Map<String, dynamic>;
            return Center(child: Column(
              children: [
                Text(data_from_database[0],style: TextStyle(color: Colors.black),),
              ],
            ));
          }
      return Container(
          child: Text(data_from_database[0].toString(),style: TextStyle(color: Colors.black),),
      );

      })**/

/**FutureBuilder<DocumentSnapshot>(
          future: appl.doc("X6203dvoRQxRmyFUoKut").get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Loading();
            }

            print("${!snapshot.hasData} ${!snapshot.data!.exists}"); // always "false true"
            if (!snapshot.hasData && !snapshot.data!.exists) {

              return Loading();
            }

            if (snapshot.connectionState == ConnectionState.done) {
              Loading();
              Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
              return Center(child: Column(
                children: [
                  Card(
                      child: Column(
                        children: [
                          Text(data['title']),
                          Text(data['category']),
                          Text(data['comment']),
                        ],
                      )),
                ],
              ));
            }

            return Loading();
          },
        ),**/
**/