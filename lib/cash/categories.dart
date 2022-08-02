/**import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wol_pro_1/page_of_application_vol.dart';
import 'package:wol_pro_1/shared/application.dart';


//String card_title='';
//String card_category='';
//String card_comment='';
class Categories_1 extends StatefulWidget {
  @override
  _Categories_1State createState() => _Categories_1State();
}

class _Categories_1State extends State<Categories_1> {
  List<String> categories = ["Accomodation", "Transfer", "Assistance with animals"];
  // By default our first item will be selected
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 220),
        child: SizedBox(
          height: 25,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) => buildCategory(index),
          ),
        ),
      ),
    );
  }

  Widget buildCategory(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {

          print(index);
          if(index==0){
            //chosen_category="Accomodation";
          }
          else if(index==1){
          //  chosen_category="Transfer";
          }
          else if(index==2){
           // chosen_category="Assistance with animals";
          }
          selectedIndex = index;
          StreamBuilder(
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
          );

        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              categories[index],
              style: TextStyle(
                fontWeight: FontWeight.bold,

              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20 / 3), //top padding 5
              height: 2,
              width: 100,
              color: selectedIndex == index ? Colors.black : Colors.transparent,
            )
          ],
        ),
      ),
    );
  }
}**/