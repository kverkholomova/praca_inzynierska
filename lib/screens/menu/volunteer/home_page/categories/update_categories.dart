import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:wol_pro_1/screens/menu/volunteer/main_screen.dart';

import '../../../../../constants.dart';
import '../../../../../models/categories.dart';
import '../../../../../widgets/loading.dart';
import '../../../../intro_screen/option.dart';
import '../home_vol.dart';



class ManageCategories extends StatefulWidget {
  final List categoriesUpdated = [];
  ManageCategories({
    Key? key, List? categoriesUpdated
  }) : super(key: key);

  @override
  _ManageCategoriesState createState() => _ManageCategoriesState();
}

class _ManageCategoriesState extends State<ManageCategories> {
  // final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;
  bool chosen = false;

  // text field state

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.categoriesUpdated);
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async {
        setState(() {
          controllerTabBottomVol = PersistentTabController(initialIndex: 2);
        });

        Navigator.of(context, rootNavigator: true).pushReplacement(
            MaterialPageRoute(builder: (context) => MainScreen()));
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => const OptionChoose()),
        // );
        return true;
      },
      child: loading
          ? const Loading()
          : SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: background,
          appBar: AppBar(
            // title: Padding(
            //   padding: EdgeInsets.only(
            //       left: MediaQuery.of(context).size.height * 0.1),
            //   child: Text(
            //     "Volunteer",
            //     style: GoogleFonts.sairaStencilOne(
            //       fontSize: 25,
            //       color: Colors.black.withOpacity(0.7),
            //     ),
            //     textAlign: TextAlign.center,
            //   ),
            // ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: IconButton(
                onPressed: () {
                  setState(() {
                    controllerTabBottomVol = PersistentTabController(initialIndex: 2);
                  });

                  Navigator.of(context, rootNavigator: true).pushReplacement(
                      MaterialPageRoute(builder: (context) => MainScreen()));
                  // setState(() {
                  //   controllerTabBottomVol = PersistentTabController(initialIndex: 2);
                  // });
                  // Navigator.of(context, rootNavigator: true).pushReplacement(
                  //     MaterialPageRoute(builder: (context) => isLoggedIn? MainScreen(): OptionChoose()));
                },
                icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: blueColor,
                )),
          ),
          body: SingleChildScrollView(
            dragStartBehavior: DragStartBehavior.down,
            scrollDirection: Axis.vertical,
            child: Padding(
              padding: padding,
              child: Column(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding:
                          const EdgeInsets.symmetric(vertical: 45),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "Your preferencies",
                                  style: GoogleFonts.raleway(
                                    fontSize: 25,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 7),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    "Choose at least one category,",
                                    style: GoogleFonts.raleway(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "where you would help.",
                                  style: GoogleFonts.raleway(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Column(
                          children: [

                            buildCategory(
                                context, categoriesListAll[1], Icons.house),
                            SizedBox(
                              height:
                              MediaQuery.of(context).size.height *
                                  0.012,
                            ),
                            buildCategory(
                              context,
                              categoriesListAll[2],
                              Icons.emoji_transportation_rounded,
                            ),
                            SizedBox(
                              height:
                              MediaQuery.of(context).size.height *
                                  0.012,
                            ),
                            buildCategory(context, categoriesListAll[3],
                                Icons.pets_rounded),

                            SizedBox(
                              height:
                              MediaQuery.of(context).size.height *
                                  0.012,
                            ),
                            buildCategory(
                              context,
                              categoriesListAll[4],
                              Icons.local_grocery_store_rounded,
                            ),
                            SizedBox(
                              height:
                              MediaQuery.of(context).size.height *
                                  0.012,
                            ),
                            buildCategory(
                                context,
                                categoriesListAll[5],
                                Icons.child_care_rounded),
                            SizedBox(
                              height:
                              MediaQuery.of(context).size.height *
                                  0.012,
                            ),
                            buildCategory(
                                context,
                                categoriesListAll[6],
                                Icons.sign_language_rounded),
                            SizedBox(
                              height:
                              MediaQuery.of(context).size.height *
                                  0.012,
                            ),
                            buildCategory(
                                context,
                                categoriesListAll[7],
                                Icons.menu_book),
                            SizedBox(
                              height:
                              MediaQuery.of(context).size.height *
                                  0.012,
                            ),
                            buildCategory(
                                context,
                                categoriesListAll[8],
                                Icons.medical_information_outlined),
                            SizedBox(
                              height:
                              MediaQuery.of(context).size.height *
                                  0.02,
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height *
                                  0.09,
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection('users')
                                        .where('id_vol',
                                        isEqualTo:
                                        FirebaseAuth.instance.currentUser?.uid)
                                        .snapshots(),
                                    builder: (context,
                                        AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                                      return ListView.builder(
                                          itemCount: !streamSnapshot.hasData
                                              ? 1
                                              : streamSnapshot.data?.docs.length,
                                          itemBuilder: (ctx, index) {
                                            return Container(
                                              width: double.infinity,
                                              height: MediaQuery.of(context).size.height *
                                                  0.085,
                                              decoration: buttonActiveDecoration,
                                              child: TextButton(
                                                  child: Text(
                                                    "Done",
                                                    style: textActiveButtonStyle,
                                                  ),
                                                  onPressed: () {
                                                    // print("PPPPPPPPPPPPPPPPPPPPPPPPPP");
                                                    // // print(chosenCategoryListChanges[0]);
                                                    // print(chosenCategoryListChanges);
                                                    // print(chosenCategoryListChanges.isEmpty);
                                                    // print(chosenCategoryListChanges!="New one");

                                                    if (categoriesVolunteer.isEmpty){
                                                      dialogBuilderEmpty(context);
                                                    } else {
                                                      dialogBuilder(context);
                                                    }

                                                  }
                                              ),
                                            );
                                          });
                                    }),
                              ),
                            ),
                            SizedBox(
                              height:
                              MediaQuery.of(context).size.height *
                                  0.015,
                            ),

                          ],
                        ),

                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

        ),
      ),
    );
  }

  String listTileBuilder(){
    String listTile = '';
    for(int i = 0;i<categoriesVolunteer.length;i++){
      if(categoriesVolunteer.length==1){
        listTile += categoriesVolunteer[i];
      } else {
        if (categoriesVolunteer.length-1==i){
          listTile += categoriesVolunteer[i];
        } else {
          listTile += "${categoriesVolunteer[i]}\n";
        }

      }

    }
    return listTile;
  }

  Future<void> dialogBuilderEmpty(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Text('Choose your categories'),
          titleTextStyle: GoogleFonts.raleway(
            fontSize: 16,
            color: blueColor,
          ),
          content: const Text("You haven't chosen any category, please supply any category"
              ' or leave your previous preferences'),
          contentTextStyle: GoogleFonts.raleway(
            fontSize: 14,
            color: blueColor,
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
                        0.075,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                        BorderRadius.circular(15)),
                    child: TextButton(
                        child: Text(
                          'Choose category',
                          style: GoogleFonts.raleway(
                            fontSize: 16,
                            color: blueColor,
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
                        0.075,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                        BorderRadius.circular(15)),
                    child: TextButton(
                        child: Text(
                          'Leave previous choice',
                          style: GoogleFonts.raleway(
                            fontSize: 16,
                            color: blueColor,
                          ),
                        ),
                        onPressed: () async {

                            setState(() {
                              print(widget.categoriesUpdated);
                              categoriesVolunteer = widget.categoriesUpdated;
                              print("Leave previous choiceeeeeeeeeeeee");
                              print(categoriesVolunteer);
                              controllerTabBottomVol = PersistentTabController(initialIndex: 2);
                            });

                          Future.delayed(Duration(milliseconds: 500),
                                  () {

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (
                                            context) =>
                                        MainScreen()));
                              });

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

          ],
        );
      },
    );
  }

  Future<String?> dialogBuilder(BuildContext context) {
    return showDialog<String?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text('Verify your choice'),
          titleTextStyle: GoogleFonts.raleway(
            fontSize: 16,
            color: blueColor,
          ),
          content:  Text("You chose categories that refer to:\n\n${listTileBuilder()}\n"),
          contentTextStyle: GoogleFonts.raleway(
            fontSize: 14,
            color: blueColor,
          ),
          actions: [
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 20),
            //   child: Text(listTileBuilder()),
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 15
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Center(
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height *
                        0.075,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                        BorderRadius.circular(18)),
                    child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .where('id_vol',
                            isEqualTo:
                            FirebaseAuth.instance.currentUser?.uid)
                            .snapshots(),
                        builder: (context,
                            AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                          return ListView.builder(
                              itemCount: !streamSnapshot.hasData
                                  ? 1
                                  : streamSnapshot.data?.docs.length,
                              itemBuilder: (ctx, index) {
                                return TextButton(
                                    child: Text(
                                      'Change my choice',
                                      style: GoogleFonts.raleway(
                                        fontSize: 16,
                                        color: blueColor,
                                      ),
                                    ),
                                    onPressed: () async {
                                      Navigator.of(context).pop();
                                    });
                              }
                          );
                        }
                    ),
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
                        0.075,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                        BorderRadius.circular(18)),
                    child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('users')
                            .where('id_vol',
                            isEqualTo:
                            FirebaseAuth.instance.currentUser?.uid)
                            .snapshots(),
                        builder: (context,
                            AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                          return ListView.builder(
                              itemCount: !streamSnapshot.hasData
                                  ? 1
                                  : streamSnapshot.data?.docs.length,
                              itemBuilder: (ctx, index) {
                                return TextButton(
                                    child: Text(
                                      'Save my changes',
                                      style: GoogleFonts.raleway(
                                        fontSize: 16,
                                        color: blueColor,
                                      ),
                                    ),
                                    onPressed: () async {
                                      // Navigator.push(
                                      //   context,
                                      //   MaterialPageRoute(builder: (context) => const HomeVol()),);

                                      // if(chosenCategoryList==[]){
                                      //   dialogBuilder(context);
                                      // }
                                      // else if(chosenCategoryList!=[]){
                                      FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(streamSnapshot
                                          .data?.docs[index].id)
                                          .update({
                                        "category": categoriesVolunteer
                                      });
                                      // categoriesVolunteer =
                                      //     chosenCategoryListChanges;
                                      // }
                                      Future.delayed(Duration(seconds: 1),
                                              () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (
                                                        context) => MainScreen()));

                                          });

                                    });
                              }
                          );
                        }
                    ),
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

  GestureDetector buildCategory(
      BuildContext context, String text, IconData icon) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (categoriesVolunteer.contains(text)) {
            categoriesVolunteer.remove(text);
          } else {
            categoriesVolunteer.add(text);
          }
        });
      },
      child: AnimatedContainer(
        height: MediaQuery.of(context).size.height * 0.085,
        duration: const Duration(milliseconds: 500),
        decoration: BoxDecoration(
          border: Border.all(
            color: categoriesVolunteer.contains(text) ? blueColor : Colors.white,
            width: 2,

          ),
          // color: categoriesVolunteer.contains(text) ? blueColor : Colors.white,
          borderRadius: const BorderRadius.all(
            Radius.circular(18),

          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.05,
                    right: MediaQuery.of(context).size.width * 0.04,
                  ),
                  child: Icon(
                    icon,
                    size: 30,
                    color:
                    // categoriesVolunteer.contains(text)
                    //     ? Colors.white
                    //     :
                    Colors.black,
                  ),
                ),
                Text(
                  text,
                  style: GoogleFonts.raleway(
                    fontSize: 15,
                    color:
                    // categoriesVolunteer.contains(text)
                    //     ? Colors.white
                    //     :
                    Colors.black,
                  ),
                ),
              ],
            ),

            categoriesVolunteer.contains(text)
                ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Icon(
                  Icons.check_rounded,
                  size: 30,
                  color: blueColor
                // categoriesVolunteer.contains(text)
                //     ? Colors.white
                //     :
                // Colors.black,
              ),
            )
                :Container(),
          ],
        ),
      ),
    );
  }
}