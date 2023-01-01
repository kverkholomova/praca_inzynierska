import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:wol_pro_1/services/auth.dart';

import 'package:wol_pro_1/screens/menu/volunteer/all_applications/your_app_vol.dart';

import '../../../../constants.dart';
import '../../../../models/categories.dart';
import '../../../intro_screen/option.dart';
import '../home_page/home_vol.dart';
import 'chosen_category_applications.dart';

String chosenCategoryVolApp = '';
String? card_title_vol='';
String? card_category_vol='';
String? card_comment_vol='';
// String userID_vol ='';



class Categories extends StatefulWidget {
  const Categories({Key? key}) : super(key: key);
  @override
  State createState() => new CategoriesState();
}

class CategoriesState extends State<Categories> {


  FirebaseFirestore db = FirebaseFirestore.instance;

  bool loading = false;
  final AuthService _auth = AuthService();
  final CollectionReference applications = FirebaseFirestore.instance.collection("applications");


  // @override
  //
  // void initState() {
  //   print("UUUUUUUUUUUpadaaaaaaaaateeeeed222222222222");
  //
  //   print(categoriesVolunteer);
  // }
  Widget build(BuildContext context) {

    print(userID_vol);
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeVol()),
        );
        return true;
      },
      child: Scaffold(
        backgroundColor: background,
        // appBar: AppBar(
        //       centerTitle: false,
        //       title: const Text('Home'),
        //         backgroundColor: Color.fromRGBO(49, 72, 103, 0.8),
        //         elevation: 0.0,
        //         leading: IconButton(
        //           icon: const Icon(Icons.arrow_back,color: Colors.white,),
        //           onPressed: () async {
        //             // await _auth.signOut();
        //             Navigator.push(
        //               context,
        //               MaterialPageRoute(builder: (context) => SettingsHomeVol()),
        //             );
        //           },
        //         ),
        //         // actions: <Widget>[
        //         //   IconButton(
        //         //     icon: const Icon(Icons.settings,color: Colors.white,),
        //         //     //label: const Text('logout',style: TextStyle(color: Colors.white),),
        //         //     onPressed: () async {
        //         //       //await _auth.signOut();
        //         //       // chosen_category_settings = [];
        //         //       Navigator.push(
        //         //         context,
        //         //         MaterialPageRoute(builder: (context) => SettingsVol()),
        //         //       );
        //         //     },
        //         //   ),
        //         //
        //         //   IconButton(
        //         //     icon: const Icon(Icons.person,color: Colors.white,),
        //         //     //label: const Text('logout',style: TextStyle(color: Colors.white),),
        //         //     onPressed: () async {
        //         //       //await _auth.signOut();
        //         //       Navigator.push(
        //         //         context,
        //         //         MaterialPageRoute(builder: (context) => ApplicationsOfVolunteer()),
        //         //       );
        //         //     },
        //         //   ),
        //         //
        //         // ],
        // ),
                body: Stack(
                  children: [
                    ClipPath(
                      clipper: OvalBottomBorderClipper(),
                      child: Container(
                        decoration: BoxDecoration(
                          color: blueColor,
                          boxShadow: const <BoxShadow>[
                            BoxShadow(
                              color: Colors.black,
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        height: MediaQuery.of(context).size.height * 0.15,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Align(
                            alignment: Alignment.center,
                              child: Column(
                                children: [
                                  Text(
                                    "All applications",
                                    style:  GoogleFonts.raleway(
                                      fontSize: 24,
                                      color: Colors.white,
                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      "Choose application",
                                      style: GoogleFonts.raleway(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              )),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.17,
                      // bottom: MediaQuery.of(context).size.height * 0.04
                      ),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: padding,
                          child: Column(
                            children: [
                              CategoryWidget(text: categoriesListAll[0],),
                              SizedBox(
                                height:
                                MediaQuery.of(context).size.height *
                                    0.012,
                              ),
                              CategoryWidget(text: categoriesListAll[1],),
                              SizedBox(
                                height:
                                MediaQuery.of(context).size.height *
                                    0.012,
                              ),
                              CategoryWidget(text: categoriesListAll[2],),
                              SizedBox(
                                height:
                                MediaQuery.of(context).size.height *
                                    0.012,
                              ),
                              CategoryWidget(text: categoriesListAll[3],),
                              SizedBox(
                                height:
                                MediaQuery.of(context).size.height *
                                    0.012,
                              ),
                              CategoryWidget(text: categoriesListAll[4],),
                              SizedBox(
                                height:
                                MediaQuery.of(context).size.height *
                                    0.012,
                              ),
                              CategoryWidget(text: categoriesListAll[5],),
                              SizedBox(
                                height:
                                MediaQuery.of(context).size.height *
                                    0.012,
                              ),
                              CategoryWidget(text: categoriesListAll[6],),
                              SizedBox(
                                height:
                                MediaQuery.of(context).size.height *
                                    0.012,
                              ),
                              CategoryWidget(text: categoriesListAll[7],),
                              SizedBox(
                                height:
                                MediaQuery.of(context).size.height *
                                    0.012,
                              ),
                              CategoryWidget(text: categoriesListAll[8],),
                              SizedBox(
                                height:
                                MediaQuery.of(context).size.height *
                                    0.012,
                              ),
                              CategoryWidget(text: categoriesListAll[9],),


                      // Padding(
                      //     padding: const EdgeInsets.only(top: 10),
                      //     child: Center(
                      //       child: Container(
                      //         width: 300,
                      //         height: 60,
                      //         decoration: BoxDecoration(
                      //             borderRadius: BorderRadius.circular(20)
                      //         ),
                      //         child: MaterialButton(
                      //           color: const Color.fromRGBO(137, 102, 120, 0.8),
                      //           child: Text(categories_list_all[1], style: (TextStyle(color: Colors.white, fontSize: 15)),),
                      //           onPressed: () {
                      //
                      //             category_chosen_button = categories_list_all[1];
                      //             Navigator.push(context, MaterialPageRoute(builder: (context) => const ChosenCategory()));
                      //           },
                      //         ),
                      //       ),
                      //     ),
                      // ),
                      // Padding(
                      //     padding: const EdgeInsets.only(top: 10),
                      //     child: Center(
                      //       child: Container(
                      //         width: 300,
                      //         height: 60,
                      //         decoration: BoxDecoration(
                      //             borderRadius: BorderRadius.circular(20)
                      //         ),
                      //         child: MaterialButton(
                      //           color: const Color.fromRGBO(137, 102, 120, 0.8),
                      //           child: Text(categories_list_all[2], style: (TextStyle(color: Colors.white, fontSize: 15)),),
                      //           onPressed: () {
                      //
                      //             category_chosen_button = categories_list_all[2];
                      //             Navigator.push(context, MaterialPageRoute(builder: (context) => const ChosenCategory()));
                      //           },
                      //         ),
                      //       ),
                      //     ),
                      // ),
                      // Padding(
                      //     padding: const EdgeInsets.only(top: 10),
                      //     child: Center(
                      //       child: Container(
                      //         width: 300,
                      //         height: 60,
                      //         decoration: BoxDecoration(
                      //             borderRadius: BorderRadius.circular(20)
                      //         ),
                      //         child: MaterialButton(
                      //           color: const Color.fromRGBO(137, 102, 120, 0.8),
                      //           child: Text(categories_list_all[3], style: (TextStyle(color: Colors.white, fontSize: 15)),),
                      //           onPressed: () {
                      //
                      //             category_chosen_button = categories_list_all[3];
                      //             Navigator.push(context, MaterialPageRoute(builder: (context) => const ChosenCategory()));
                      //           },
                      //         ),
                      //       ),
                      //     ),
                      // ),
                      // Padding(
                      //     padding: const EdgeInsets.only(top: 10),
                      //     child: Center(
                      //       child: Container(
                      //         width: 300,
                      //         height: 60,
                      //         decoration: BoxDecoration(
                      //             borderRadius: BorderRadius.circular(20)
                      //         ),
                      //         child: MaterialButton(
                      //           color: const Color.fromRGBO(137, 102, 120, 0.8),
                      //           child: Text(categories_list_all[4], style: (TextStyle(color: Colors.white, fontSize: 15)),),
                      //           onPressed: () {
                      //
                      //             category_chosen_button = categories_list_all[4];
                      //             Navigator.push(context, MaterialPageRoute(builder: (context) => const ChosenCategory()));
                      //           },
                      //         ),
                      //       ),
                      //     ),
                      // ),
                      // Padding(
                      //     padding: const EdgeInsets.only(top: 10),
                      //     child: Center(
                      //       child: Container(
                      //         width: 300,
                      //         height: 60,
                      //         decoration: BoxDecoration(
                      //             borderRadius: BorderRadius.circular(20)
                      //         ),
                      //         child: MaterialButton(
                      //           color: const Color.fromRGBO(137, 102, 120, 0.8),
                      //           child: Text(categories_list_all[5], style: (TextStyle(color: Colors.white, fontSize: 15)),),
                      //           onPressed: () {
                      //
                      //             category_chosen_button = categories_list_all[5];
                      //             Navigator.push(context, MaterialPageRoute(builder: (context) => const ChosenCategory()));
                      //           },
                      //         ),
                      //       ),
                      //     ),
                      // ),
                      // Padding(
                      //     padding: const EdgeInsets.only(top: 10),
                      //     child: Center(
                      //       child: Container(
                      //         width: 300,
                      //         height: 60,
                      //         decoration: BoxDecoration(
                      //             borderRadius: BorderRadius.circular(20)
                      //         ),
                      //         child: MaterialButton(
                      //           color: const Color.fromRGBO(137, 102, 120, 0.8),
                      //           child: Text(categories_list_all[6], style: (TextStyle(color: Colors.white, fontSize: 15)),),
                      //           onPressed: () {
                      //
                      //             category_chosen_button = categories_list_all[6];
                      //             Navigator.push(context, MaterialPageRoute(builder: (context) => const ChosenCategory()));
                      //           },
                      //         ),
                      //       ),
                      //     ),
                      // ),
                      // Padding(
                      //     padding: const EdgeInsets.only(top: 10),
                      //     child: Center(
                      //       child: Container(
                      //         width: 300,
                      //         height: 60,
                      //         decoration: BoxDecoration(
                      //             borderRadius: BorderRadius.circular(20)
                      //         ),
                      //         child: MaterialButton(
                      //           color: const Color.fromRGBO(137, 102, 120, 0.8),
                      //           child: Text(categories_list_all[7], style: (TextStyle(color: Colors.white, fontSize: 15)),),
                      //           onPressed: () {
                      //
                      //             category_chosen_button = categories_list_all[7];
                      //             Navigator.push(context, MaterialPageRoute(builder: (context) => const ChosenCategory()));
                      //           },
                      //         ),
                      //       ),
                      //     ),
                      // ),
                      // Padding(
                      //     padding: const EdgeInsets.only(top: 10),
                      //     child: Center(
                      //       child: Container(
                      //         width: 300,
                      //         height: 60,
                      //         decoration: BoxDecoration(
                      //             borderRadius: BorderRadius.circular(20)
                      //         ),
                      //         child: MaterialButton(
                      //           color: const Color.fromRGBO(137, 102, 120, 0.8),
                      //           child: Text(categories_list_all[8], style: (TextStyle(color: Colors.white, fontSize: 15)),),
                      //           onPressed: () {
                      //
                      //             category_chosen_button = categories_list_all[8];
                      //             Navigator.push(context, MaterialPageRoute(builder: (context) => const ChosenCategory()));
                      //           },
                      //         ),
                      //       ),
                      //     ),
                      // ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}

class CategoryWidget extends StatefulWidget {
  final String text;
  CategoryWidget({
    Key? key, required this.text
  }) : super(key: key);

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {

        // setState(() {
        //   if(widget.text != categoriesListAll[0]){
        //
        //   }
        //
        // });
        // category_chosen_button = categories_list_all[0];
        // print(categories_list_all[7]);

        if (widget.text == categoriesListAll[0]){
          Navigator.of(context, rootNavigator: true).pushReplacement(
              MaterialPageRoute(builder: (context) => YourCategories()));
          // Navigator.push(context, MaterialPageRoute(builder: (context) => const YourCategories()));
        }
        else {
          setState(() {
            chosenCategoryVolApp = widget.text;
          });
          Future.delayed(const Duration(milliseconds: 500), ()
          {
            Navigator.of(context, rootNavigator: true).pushReplacement(
                MaterialPageRoute(builder: (context) => ChosenCategory()));
          });
          // Navigator.push(context, MaterialPageRoute(builder: (context) => const ChosenCategory()));
        }

      },
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.085,
            decoration: categoryDecoration,
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.05,
                    right: MediaQuery.of(context).size.width * 0.04,
                  ),
                  child: Icon(
                      widget.text==categoriesListAll[3]
                          ?Icons.pets_rounded
                          :widget.text==categoriesListAll[4]
                          ?Icons.local_grocery_store
                          :widget.text==categoriesListAll[2]
                          ?Icons.emoji_transportation_rounded
                          :widget.text==categoriesListAll[1]
                          ?Icons.house
                          :widget.text==categoriesListAll[6]
                          ?Icons.sign_language_rounded
                          :widget.text==categoriesListAll[5]
                          ?Icons.child_care_outlined
                          :widget.text==categoriesListAll[7]
                          ?Icons.menu_book
                          :widget.text==categoriesListAll[8]
                          ?Icons.medical_information_outlined
                          :widget.text==categoriesListAll[0]
                          ?Icons.check_box
                          :Icons.new_label_sharp,
                    size: 30,
                    color: Colors.black,
                  ),
                ),
                Text(widget.text, style: textCategoryStyle,),
              ],
            ),
          ),
        );
  }
}



// class YourCategory extends StatefulWidget{
//   const YourCategory({Key? key}) : super(key: key);
//   @override
//   State createState() => new YourCategoryState();
// }
//
// class YourCategoryState extends State<YourCategory> {
//
//   final CollectionReference applications = FirebaseFirestore.instance.collection("applications");
//   final AuthService _auth_your = AuthService();
//   @override
//
//   void initState() {
//
//   }
//   Widget build(BuildContext context) {
//     print(userID_vol);
//     return WillPopScope(
//         onWillPop: () async {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (context) => SettingsHomeVol()),
//           );
//           return true;
//         },
//         child: Scaffold(
//           appBar: AppBar(
//             centerTitle: false,
//             title: const Text('Home'),
//             backgroundColor: Color.fromRGBO(49, 72, 103, 0.8),
//             elevation: 0.0,
//             leading: IconButton(
//               icon: const Icon(Icons.exit_to_app,color: Colors.white,),
//               onPressed: () async {
//                 await _auth_your.signOut();
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => SettingsHomeVol()),
//                 );
//               },
//             ),
//             // actions: <Widget>[
//             //   IconButton(
//             //     icon: const Icon(Icons.settings,color: Colors.white,),
//             //     //label: const Text('logout',style: TextStyle(color: Colors.white),),
//             //     onPressed: () async {
//             //       //await _auth.signOut();
//             //       chosen_category_settings = [];
//             //       Navigator.push(
//             //         context,
//             //         MaterialPageRoute(builder: (context) => SettingsVol()),
//             //       );
//             //     },
//             //   ),
//             //
//             //   IconButton(
//             //     icon: const Icon(Icons.person,color: Colors.white,),
//             //     //label: const Text('logout',style: TextStyle(color: Colors.white),),
//             //     onPressed: () async {
//             //       //await _auth.signOut();
//             //       Navigator.push(
//             //         context,
//             //         MaterialPageRoute(builder: (context) => ApplicationsOfVolunteer()),
//             //       );
//             //     },
//             //   ),
//             //
//             // ],
//           ),
//           body: Container(
//             child: StreamBuilder(
//             stream:  applications
//                 .where("status", isEqualTo: 'Sent to volunteer')
//                 // .where("category", whereIn: categories_user_Register)
//
//                 .where("status", isEqualTo: 'Transfer')
//                 .snapshots(),
//             builder: (context, AsyncSnapshot<QuerySnapshot?> streamSnapshot) {
//               print("PPPPPPPPPPPPPPUUUUUUUUUUUU___________NNNNNNNNNNNNOOOOOOOOOO");
//               print(categories_user_Register);
//               return Container(
//                 width: 450,
//                 height: double.infinity,
//                 child: ListView.builder(
//                     scrollDirection: Axis.vertical,
//                     itemCount: streamSnapshot.data?.docs.length,
//                     itemBuilder: (ctx, index) => Column(
//                       children: [
//                         MaterialButton(
//                           onPressed: () {
//                             setState(() {
//                               card_title=streamSnapshot.data?.docs[index]['title'] as String;
//                               card_category=streamSnapshot.data?.docs[index]['category'] as String;
//                               card_comment=streamSnapshot.data?.docs[index]['comment'] as String;
//
//                               print(card_title);
//                               print(card_category);
//                               print(card_comment);
//                               Id_Of_current_application = streamSnapshot.data?.docs[index].id;
//                               Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) => PageOfApplication()),
//                               );
//                               // print("print ${streamSnapshot.data?.docs[index][id]}");
//                             });
//
//                           },
//                           child: Card(
//                             child: Center(
//                               child: Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Column(
//                                   children: [
//                                     //streamSnapshot.data?.docs[index]['title']==null ?
//
//                                     Text(
//                                       streamSnapshot.data?.docs[index]['title'],
//                                       style: TextStyle(
//                                         fontWeight: FontWeight.bold, ),
//                                       textAlign: TextAlign.left,
//                                     ),
//                                     Text(
//                                         streamSnapshot.data?.docs[index]
//                                         ['category'] as String,
//                                         style: TextStyle(color: Colors.grey)),
//                                     Text(streamSnapshot.data?.docs[index]
//                                     ['comment'] as String),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     )),
//               );
//             },
//         ),
//           ),
//         ));
//   }
// }


          // appBar:
          //
          // AppBar(
          //   title: const Text('Home'),
          //   backgroundColor: Color.fromRGBO(49, 72, 103, 0.8),
          //   elevation: 0.0,
          //   leading: IconButton(
          //     icon: const Icon(Icons.exit_to_app,color: Colors.white,),
          //     onPressed: () async {
          //       await _auth.signOut();
          //       Navigator.push(
          //         context,
          //         MaterialPageRoute(builder: (context) => OptionChoose()),
          //       );
          //     },
          //   ),
          //   actions: <Widget>[
          //     IconButton(
          //       icon: const Icon(Icons.settings,color: Colors.white,),
          //       //label: const Text('logout',style: TextStyle(color: Colors.white),),
          //       onPressed: () async {
          //         //await _auth.signOut();
          //         chosen_category_settings = [];
          //         Navigator.push(
          //           context,
          //           MaterialPageRoute(builder: (context) => SettingsVol()),
          //         );
          //       },
          //     ),
          //
          //     IconButton(
          //       icon: const Icon(Icons.person,color: Colors.white,),
          //       //label: const Text('logout',style: TextStyle(color: Colors.white),),
          //       onPressed: () async {
          //         //await _auth.signOut();
          //         Navigator.push(
          //           context,
          //           MaterialPageRoute(builder: (context) => ApplicationsOfVolunteer()),
          //         );
          //       },
          //     ),
          //
          //   ],
          //   bottom: TabBar(
          //     indicatorColor: Color.fromRGBO(85, 146, 169, 0.8),
          //     isScrollable: true,
          //     tabs: [
          //       Text(categories[0],style: TextStyle(fontSize: 17),),
          //       Text(categories[1],style: TextStyle(fontSize: 17),),
          //       Text(categories[2],style: TextStyle(fontSize: 17),),
          //       Text(categories[3],style: TextStyle(fontSize: 17),),
          //     ],
          //
          //   ),
          // ),
          // body: TabBarView(
          //   children: [
          //
          //     StreamBuilder(
          //       stream:  applications
          //           .where("status", isEqualTo: 'Sent to volunteer')
          //           .where("category", whereIn: categories_user)
          //
          //           .snapshots(),
          //       builder: (context, AsyncSnapshot<QuerySnapshot?> streamSnapshot) {
          //         return Container(
          //           width: 450,
          //           height: 300,
          //           child: ListView.builder(
          //               scrollDirection: Axis.vertical,
          //               itemCount: streamSnapshot.data?.docs.length,
          //               itemBuilder: (ctx, index) => Column(
          //                 children: [
          //                   MaterialButton(
          //                     onPressed: () {
          //                       setState(() {
          //                         card_title=streamSnapshot.data?.docs[index]['title'] as String;
          //                         card_category=streamSnapshot.data?.docs[index]['category'] as String;
          //                         card_comment=streamSnapshot.data?.docs[index]['comment'] as String;
          //
          //                         print(card_title);
          //                         print(card_category);
          //                         print(card_comment);
          //                         Id_Of_current_application = streamSnapshot.data?.docs[index].id;
          //                         Navigator.push(
          //                           context,
          //                           MaterialPageRoute(
          //                               builder: (context) => PageOfApplication()),
          //                         );
          //                         // print("print ${streamSnapshot.data?.docs[index][id]}");
          //                       });
          //
          //                     },
          //                     child: Card(
          //                       child: Center(
          //                         child: Padding(
          //                           padding: const EdgeInsets.all(8.0),
          //                           child: Column(
          //                             children: [
          //                               //streamSnapshot.data?.docs[index]['title']==null ?
          //
          //                               Text(
          //                                 streamSnapshot.data?.docs[index]['title'],
          //                                 style: TextStyle(
          //                                   fontWeight: FontWeight.bold, ),
          //                                 textAlign: TextAlign.left,
          //                               ),
          //                               Text(
          //                                   streamSnapshot.data?.docs[index]
          //                                   ['category'] as String,
          //                                   style: TextStyle(color: Colors.grey)),
          //                               Text(streamSnapshot.data?.docs[index]
          //                               ['comment'] as String),
          //                             ],
          //                           ),
          //                         ),
          //                       ),
          //                     ),
          //                   ),
          //                 ],
          //               )),
          //         );
          //       },
          //     ),
          //     StreamBuilder(
          //       stream:   FirebaseFirestore.instance
          //           .collection('applications')
          //           .where("category", isEqualTo: "Accomodation")
          //
          //       //.where("volunteer_pref", arrayContainsAny: volunteer_preferencies)
          //       //.where("category", arrayContainsAny: ['Accomodation', 'Transfer', 'Assistance with animals'])
          //           .where("status", isEqualTo: 'Sent to volunteer')
          //
          //       //.where("category", whereIn: ['Accomodation','Transfer','Assistance with animals'])
          //       //.where("category", arrayContainsAny: ['Accomodation','Transfer','Assistance with animals'])
          //           .snapshots(),
          //       builder: (context, AsyncSnapshot<QuerySnapshot?> streamSnapshot) {
          //         return Container(
          //           width: 450,
          //           height: 300,
          //           child: ListView.builder(
          //               scrollDirection: Axis.vertical,
          //               itemCount: streamSnapshot.data?.docs.length,
          //               itemBuilder: (ctx, index) => Column(
          //                 children: [
          //                   MaterialButton(
          //                     onPressed: () {
          //
          //                       setState(() {
          //                         card_title=streamSnapshot.data?.docs[index]['title'] as String;
          //                         card_category=streamSnapshot.data?.docs[index]['category'] as String;
          //                         card_comment=streamSnapshot.data?.docs[index]['comment'] as String;
          //                         Navigator.push(
          //                           context,
          //                           MaterialPageRoute(
          //                               builder: (context) => PageOfApplication()),
          //                         );
          //                         // print("print ${streamSnapshot.data?.docs[index][id]}");
          //                       });
          //
          //                     },
          //                     child: Card(
          //                       child: Center(
          //                         child: Padding(
          //                           padding: const EdgeInsets.all(8.0),
          //                           child: Column(
          //                             children: [
          //                               Text(
          //                                 streamSnapshot.data?.docs[index]['title'] as String,
          //                                 style: TextStyle(
          //                                     fontWeight: FontWeight.bold),
          //                               ),
          //                               Text(
          //                                   streamSnapshot.data?.docs[index]
          //                                   ['category'] as String,
          //                                   style: TextStyle(color: Colors.grey)),
          //                               Text(streamSnapshot.data?.docs[index]
          //                               ['comment'] as String),
          //                             ],
          //                           ),
          //                         ),
          //                       ),
          //                     ),
          //                   ),
          //                 ],
          //               )),
          //         );
          //       },
          //     ),
          //     StreamBuilder(
          //       stream: FirebaseFirestore.instance
          //           .collection('applications')
          //           .where("category", isEqualTo: "Transfer")
          //
          //       //.where("volunteer_pref", arrayContainsAny: volunteer_preferencies)
          //       //.where("category", arrayContainsAny: ['Accomodation', 'Transfer', 'Assistance with animals'])
          //           .where("status", isEqualTo: 'Sent to volunteer')
          //
          //       //.where("category", whereIn: ['Accomodation','Transfer','Assistance with animals'])
          //       //.where("category", arrayContainsAny: ['Accomodation','Transfer','Assistance with animals'])
          //           .snapshots(),
          //       builder: (context, AsyncSnapshot<QuerySnapshot?> streamSnapshot) {
          //         return Container(
          //           width: 450,
          //           height: 300,
          //           child: ListView.builder(
          //               scrollDirection: Axis.vertical,
          //               itemCount: streamSnapshot.data?.docs.length,
          //               itemBuilder: (ctx, index) => Column(
          //                 children: [
          //                   MaterialButton(
          //                     onPressed: () {
          //                       card_title=streamSnapshot.data?.docs[index]['title'] as String;
          //                       card_category=streamSnapshot.data?.docs[index]['category'] as String;
          //                       card_comment=streamSnapshot.data?.docs[index]['comment'] as String;
          //                       setState(() {
          //                         Navigator.push(
          //                           context,
          //                           MaterialPageRoute(
          //                               builder: (context) => PageOfApplication()),
          //                         );
          //                         // print("print ${streamSnapshot.data?.docs[index][id]}");
          //                       });
          //
          //                     },
          //                     child: Card(
          //                       child: Center(
          //                         child: Padding(
          //                           padding: const EdgeInsets.all(8.0),
          //                           child: Column(
          //                             children: [
          //                               Text(
          //                                 streamSnapshot.data?.docs[index]['title'] as String,
          //                                 style: TextStyle(
          //                                     fontWeight: FontWeight.bold),
          //                               ),
          //                               Text(
          //                                   streamSnapshot.data?.docs[index]
          //                                   ['category'] as String,
          //                                   style: TextStyle(color: Colors.grey)),
          //                               Text(streamSnapshot.data?.docs[index]
          //                               ['comment'] as String),
          //                             ],
          //                           ),
          //                         ),
          //                       ),
          //                     ),
          //                   ),
          //                 ],
          //               )),
          //         );
          //       },
          //     ),
          //     StreamBuilder(
          //       stream: FirebaseFirestore.instance
          //           .collection('applications')
          //           .where("category", isEqualTo: "Assistance with animals")
          //
          //       //.where("volunteer_pref", arrayContainsAny: volunteer_preferencies)
          //       //.where("category", arrayContainsAny: ['Accomodation', 'Transfer', 'Assistance with animals'])
          //           .where("status", isEqualTo: 'Sent to volunteer')
          //
          //       //.where("category", whereIn: ['Accomodation','Transfer','Assistance with animals'])
          //       //.where("category", arrayContainsAny: ['Accomodation','Transfer','Assistance with animals'])
          //           .snapshots(),
          //       builder: (context, AsyncSnapshot<QuerySnapshot?> streamSnapshot) {
          //         return Container(
          //           width: 450,
          //           height: 300,
          //           child: ListView.builder(
          //               scrollDirection: Axis.vertical,
          //               itemCount: streamSnapshot.data?.docs.length,
          //               itemBuilder: (ctx, index) => Column(
          //                 children: [
          //                   MaterialButton(
          //                     onPressed: () {
          //                       card_title=streamSnapshot.data?.docs[index]['title'] as String;
          //                       card_category=streamSnapshot.data?.docs[index]['category'] as String;
          //                       card_comment=streamSnapshot.data?.docs[index]['comment'] as String;
          //                       setState(() {
          //                         Navigator.push(
          //                           context,
          //                           MaterialPageRoute(
          //                               builder: (context) => PageOfApplication()),
          //                         );
          //                         // print("print ${streamSnapshot.data?.docs[index][id]}");
          //                       });
          //
          //                     },
          //                     child: Card(
          //                       child: Center(
          //                         child: Padding(
          //                           padding: const EdgeInsets.all(8.0),
          //                           child: Column(
          //                             children: [
          //                               Text(
          //                                 streamSnapshot.data?.docs[index]['title'] as String,
          //                                 style: TextStyle(
          //                                     fontWeight: FontWeight.bold),
          //                               ),
          //                               Text(
          //                                   streamSnapshot.data?.docs[index]
          //                                   ['category'] as String,
          //                                   style: TextStyle(color: Colors.grey)),
          //                               Text(streamSnapshot.data?.docs[index]
          //                               ['comment'] as String),
          //                             ],
          //                           ),
          //                         ),
          //                       ),
          //                     ),
          //                   ),
          //                 ],
          //               )),
          //         );
          //       },
          //     ),
          //   ],
          // ),
