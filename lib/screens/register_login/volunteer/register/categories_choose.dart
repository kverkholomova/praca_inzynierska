import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:wol_pro_1/screens/menu/volunteer/main_screen.dart';
import 'package:wol_pro_1/screens/register_login/volunteer/register/register_volunteer_1.dart';

import '../../../../constants.dart';
import '../../../../models/categories.dart';
import '../../../../widgets/loading.dart';
import '../../../intro_screen/option.dart';
import '../../../menu/volunteer/all_applications/new_screen_with_applications.dart';
import '../../../menu/volunteer/home_page/home_vol.dart';


class ChooseCategory extends StatefulWidget {
  const ChooseCategory({
    Key? key,
  }) : super(key: key);

  @override
  _ChooseCategoryState createState() => _ChooseCategoryState();
}

class _ChooseCategoryState extends State<ChooseCategory> {
  // final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;
  bool chosen = false;

  // text field state

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        setState(() {
          controllerTabBottomVol = PersistentTabController(initialIndex: 2);
        });
        Navigator.of(context, rootNavigator: true).pushReplacement(
            MaterialPageRoute(builder: (context) => isLoggedIn? MainScreen(): OptionChoose()));
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
                            MaterialPageRoute(builder: (context) => isLoggedIn? MainScreen(): OptionChoose()));
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
                              // Padding(
                              //   padding: const EdgeInsets.all(8.0),
                              //   child: Text(
                              //     error,
                              //     style: const TextStyle(color: Colors.red, fontSize: 14.0),
                              //   ),
                              // ),
                              // Material(
                              //   color: Colors.transparent,
                              //   shape: const RoundedRectangleBorder(
                              //       borderRadius: BorderRadius.all(
                              //         Radius.circular(24),
                              //       )),
                              //   elevation: errorEmptyRegister==true? 0:5,
                              //   child: CustomTextFormFieldRegister(
                              //     customHintText: 'Name',
                              //     customErrorText: 'Enter your name',
                              //     hide: false,
                              //   ),
                              // ),
                              // SizedBox(height: !errorEmptyRegister
                              //     ?MediaQuery.of(context).size.height * 0.02
                              //     :MediaQuery.of(context).size.height * 0.015,),
                              // Material(
                              //   color: Colors.transparent,
                              //   shape: const RoundedRectangleBorder(
                              //       borderRadius: BorderRadius.all(
                              //         Radius.circular(24),
                              //       )),
                              //   elevation: errorEmptyRegister==true? 0:5,
                              //   child: CustomTextFormFieldRegister(
                              //     customHintText: 'Phone number',
                              //     customErrorText: 'Enter your phone number',
                              //     hide: false,
                              //   ),
                              // ),
                              // SizedBox(height: !errorEmptyRegister
                              //     ?MediaQuery.of(context).size.height * 0.02
                              //     :MediaQuery.of(context).size.height * 0.015,),
                              // Material(
                              //   color: Colors.transparent,
                              //   shape: const RoundedRectangleBorder(
                              //       borderRadius: BorderRadius.all(
                              //         Radius.circular(24),
                              //       )),
                              //   elevation: errorEmptyRegister==true? 0:5,
                              //   child: CustomTextFormFieldRegister(
                              //     customHintText: 'Email',
                              //     customErrorText: 'Enter your email',
                              //     hide: false,
                              //   ),
                              // ),
                              // SizedBox(height: !errorEmptyRegister
                              //     ?MediaQuery.of(context).size.height * 0.02
                              //     :MediaQuery.of(context).size.height * 0.015,),
                              // Material(
                              //
                              //   color: Colors.transparent,
                              //   shape: const RoundedRectangleBorder(
                              //       borderRadius: BorderRadius.all(
                              //         Radius.circular(24),
                              //       )),
                              //   elevation: errorEmptyRegister==true? 0:5,
                              //   child: CustomTextFormFieldRegister(
                              //     customHintText: 'Password',
                              //     customErrorText: 'Enter a password',
                              //     hide: true,
                              //   ),
                              // ),
                              // SizedBox(height: !errorEmptyRegister
                              //     ?MediaQuery.of(context).size.height * 0.075
                              //     :MediaQuery.of(context).size.height * 0.015,),

                              // ListView(
                              //   children: [
                              //
                              //   ],
                              // ),
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
                                                    decoration: buttonDecoration,
                                                    child: TextButton(
                                                        child: Text(
                                                          "Done",
                                                          style: textButtonStyle,
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
                                  // SizedBox(
                                  //   height: MediaQuery.of(context).size.height *
                                  //       0.012,
                                  // ),
                                  // SizedBox(
                                  //   height: MediaQuery.of(context).size.height *
                                  //       0.085,
                                  //   child: Material(
                                  //     shape: const RoundedRectangleBorder(
                                  //         borderRadius: BorderRadius.all(
                                  //           Radius.circular(24),
                                  //         )),
                                  //     color: Colors.white,
                                  //     child: Row(
                                  //       children: [
                                  //         Padding(
                                  //           padding: EdgeInsets.only(
                                  //             left: MediaQuery.of(context)
                                  //                 .size
                                  //                 .width *
                                  //                 0.05,
                                  //             right: MediaQuery.of(context)
                                  //                 .size
                                  //                 .width *
                                  //                 0.04,
                                  //           ),
                                  //           child: const Icon(
                                  //             Icons.pets_rounded,
                                  //             size: 35,
                                  //           ),
                                  //         ),
                                  //         Text(
                                  //           "Animal assistance",
                                  //           style: GoogleFonts.raleway(
                                  //             fontSize: 18,
                                  //             color: Colors.black,
                                  //           ),
                                  //         )
                                  //       ],
                                  //     ),
                                  //   ),
                                  // ),
                                  // SizedBox(
                                  //   height: MediaQuery.of(context).size.height *
                                  //       0.012,
                                  // ),
                                  // SizedBox(
                                  //   height: MediaQuery.of(context).size.height *
                                  //       0.085,
                                  //   child: Material(
                                  //     shape: const RoundedRectangleBorder(
                                  //         borderRadius: BorderRadius.all(
                                  //           Radius.circular(24),
                                  //         )),
                                  //     color: Colors.white,
                                  //     child: Row(
                                  //       children: [
                                  //         Padding(
                                  //           padding: EdgeInsets.only(
                                  //             left: MediaQuery.of(context)
                                  //                 .size
                                  //                 .width *
                                  //                 0.05,
                                  //             right: MediaQuery.of(context)
                                  //                 .size
                                  //                 .width *
                                  //                 0.04,
                                  //           ),
                                  //           child: const Icon(
                                  //             Icons.pets_rounded,
                                  //             size: 35,
                                  //           ),
                                  //         ),
                                  //         Text(
                                  //           "Animal assistance",
                                  //           style: GoogleFonts.raleway(
                                  //             fontSize: 18,
                                  //             color: Colors.black,
                                  //           ),
                                  //         )
                                  //       ],
                                  //     ),
                                  //   ),
                                  // )
                                ],
                              ),
                              // Slidable(
                              //   // Specify a key if the Slidable is dismissible.
                              //   key: const ValueKey(0),
                              //
                              //   // The start action pane is the one at the left or the top side.
                              //   startActionPane: ActionPane(
                              //     // A motion is a widget used to control how the pane animates.
                              //     motion: const ScrollMotion(),
                              //
                              //     // A pane can dismiss the Slidable.
                              //     dismissible: DismissiblePane(onDismissed: () {}),
                              //
                              //     // All actions are defined in the children parameter.
                              //     children: const [
                              //       // A SlidableAction can have an icon and/or a label.
                              //       SlidableAction(
                              //         onPressed: (){
                              //
                              //         },
                              //         backgroundColor: Color(0xFFFE4A49),
                              //         foregroundColor: Colors.white,
                              //         icon: Icons.delete,
                              //         label: 'Delete',
                              //       ),
                              //       SlidableAction(
                              //         onPressed: doNothing,
                              //         backgroundColor: Color(0xFF21B7CA),
                              //         foregroundColor: Colors.white,
                              //         icon: Icons.share,
                              //         label: 'Share',
                              //       ),
                              //     ],
                              //   ),
                              //
                              //   // The end action pane is the one at the right or the bottom side.
                              //   endActionPane: const ActionPane(
                              //     motion: ScrollMotion(),
                              //     children: [
                              //       SlidableAction(
                              //         // An action can be bigger than the others.
                              //         flex: 2,
                              //         onPressed: doNothing,
                              //         backgroundColor: Color(0xFF7BC043),
                              //         foregroundColor: Colors.white,
                              //         icon: Icons.archive,
                              //         label: 'Archive',
                              //       ),
                              //       SlidableAction(
                              //         onPressed: doNothing,
                              //         backgroundColor: Color(0xFF0392CF),
                              //         foregroundColor: Colors.white,
                              //         icon: Icons.save,
                              //         label: 'Save',
                              //       ),
                              //     ],
                              //   ),
                              //
                              //   // The child of the Slidable is what the user sees when the
                              //   // component is not dragged.
                              //   child: const ListTile(title: Text('Slide me')),
                              // ),

                              // Align(
                              //   alignment: Alignment.topCenter,
                              //   child: TextButton(
                              //       onPressed: () {
                              //         // widget.toggleView();
                              //       },
                              //       child: Text(
                              //         "Sign in",
                              //         style: GoogleFonts.raleway(
                              //           decoration: TextDecoration.underline,
                              //           fontSize: 15,
                              //           color: Colors.black,
                              //         ),
                              //       )),
                              // ),
                              // Padding(
                              //   padding: const EdgeInsets.only(top: 10),
                              //   child: SizedBox(
                              //     height: 55,
                              //     child: TextFormField(
                              //       decoration: textInputDecoration.copyWith(
                              //           hintText: 'Name'),
                              //       validator: (val) =>
                              //       val!.isEmpty
                              //           ? 'Enter your name'
                              //           : null,
                              //       onChanged: (val) {
                              //         setState(() => userName = val);
                              //       },
                              //     ),
                              //   ),
                              // ),
                              //
                              // Padding(
                              //   padding: const EdgeInsets.only(top: 10),
                              //   child: SizedBox(
                              //     height: 55,
                              //     child: TextFormField(
                              //       decoration: textInputDecoration.copyWith(
                              //           hintText: 'Phone number'),
                              //       validator: (val) =>
                              //       val!.isEmpty
                              //           ? 'Enter your phone number'
                              //           : null,
                              //       onChanged: (val) {
                              //         setState(() => phoneNumber = val);
                              //       },
                              //     ),
                              //   ),
                              // ),
                              // Padding(
                              //   padding: const EdgeInsets.only(top: 10),
                              //   child: SizedBox(
                              //     height: 55,
                              //     child: TextFormField(
                              //       decoration: textInputDecoration.copyWith(
                              //           hintText: 'Pesel'),
                              //       validator: (val) =>
                              //       val!.isEmpty
                              //           ? 'Enter your pesel'
                              //           : null,
                              //       onChanged: (val) {
                              //         setState(() => pesel = val);
                              //       },
                              //     ),
                              //   ),
                              // ),
                              // Padding(
                              //   padding: const EdgeInsets.all(15.0),
                              //   child: Text(
                              //     "Choose categories which are the best suitable for you",
                              //     style: TextStyle(fontSize: 14),
                              //     textAlign: TextAlign.center,),
                              // ),
                              // Row(
                              //   children: [
                              //     Padding(
                              //       padding: const EdgeInsets.all(3.0),
                              //       child: AnimatedButton(
                              //         selectedBackgroundColor: Color.fromRGBO(
                              //             69, 148, 179, 0.8),
                              //         height: 30,
                              //         width: 100,
                              //         text: 'Transfer',
                              //
                              //         textStyle: TextStyle(color: Colors.black, fontSize: 18),
                              //         isReverse: true,
                              //         selectedTextColor: Colors.white,
                              //         transitionType: TransitionType.LEFT_TO_RIGHT,
                              //         backgroundColor: Color.fromRGBO(166, 201, 215, 0.8),
                              //         borderColor: Colors.white,
                              //         borderRadius: 50,
                              //         borderWidth: 1,
                              //
                              //         onPress: () {
                              //           if (!chosenCategory.contains('Transfer')) {
                              //             chosenCategory.add('Transfer');
                              //             print(chosenCategory);
                              //           } else if (chosenCategory.contains("Transfer")) {
                              //             chosenCategory.remove('Transfer');
                              //             print("Empty: $chosenCategory");
                              //           }
                              //
                              //           //volunteer_preferencies.add('Transfer');
                              //         },
                              //       ),
                              //     ),
                              //     Padding(
                              //       padding: const EdgeInsets.all(3.0),
                              //       child: AnimatedButton(
                              //         selectedBackgroundColor: Color.fromRGBO(
                              //             69, 148, 179, 0.8),
                              //         height: 30,
                              //         width: 150,
                              //         text: 'Accomodation',
                              //
                              //         textStyle: TextStyle(color: Colors.black, fontSize: 18),
                              //         isReverse: true,
                              //         selectedTextColor: Colors.white,
                              //         transitionType: TransitionType.LEFT_TO_RIGHT,
                              //         backgroundColor: Color.fromRGBO(166, 201, 215, 0.8),
                              //         borderColor: Colors.white,
                              //         borderRadius: 50,
                              //         borderWidth: 1,
                              //         onPress: () {
                              //           if (!chosenCategory.contains('Accomodation')) {
                              //             chosenCategory.add('Accomodation');
                              //             print(chosenCategory);
                              //           } else if (chosenCategory.contains('Accomodation')) {
                              //             chosenCategory.remove('Accomodation');
                              //             print("Empty: $chosenCategory");
                              //           }
                              //
                              //           //volunteer_preferencies.add('Transfer');
                              //         },
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              // Padding(
                              //   padding: const EdgeInsets.all(3.0),
                              //   child: AnimatedButton(
                              //     selectedBackgroundColor: Color.fromRGBO(69, 148, 179, 0.8),
                              //     height: 30,
                              //     width: 240,
                              //     text: 'Assistance with animals',
                              //
                              //     textStyle: TextStyle(color: Colors.black, fontSize: 18),
                              //     isReverse: true,
                              //     selectedTextColor: Colors.white,
                              //     transitionType: TransitionType.LEFT_TO_RIGHT,
                              //     backgroundColor: Color.fromRGBO(166, 201, 215, 0.8),
                              //     borderColor: Colors.white,
                              //     borderRadius: 50,
                              //     borderWidth: 1,
                              //     onPress: () {
                              //       if (!chosenCategory.contains(
                              //           'Assistance with animals')) {
                              //         chosenCategory.add('Assistance with animals');
                              //         print(chosenCategory);
                              //       } else
                              //       if (chosenCategory.contains('Assistance with animals')) {
                              //         chosenCategory.remove('Assistance with animals');
                              //         print("Empty: $chosenCategory");
                              //       }
                              //
                              //       //volunteer_preferencies.add('Transfer');
                              //     },
                              //   ),
                              // ),

                              // Padding(
                              //   padding: const EdgeInsets.only(top: 20),
                              //   child: CircleAvatar(
                              //     radius: 25,
                              //     backgroundColor: Color.fromRGBO(49, 72, 103, 0.8),
                              //     child: IconButton(onPressed: (){
                              //       print(userName);
                              //       print(phoneNumber);
                              //       print(pesel);
                              //       Navigator.push(context,
                              //           MaterialPageRoute(builder: (context) => RegisterVol()));
                              //     }, icon: Icon(Icons.arrow_right,color: Colors.white,size: 30,)),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // floatingActionButton: Padding(
                //   padding: EdgeInsets.only(
                //     top: MediaQuery.of(context).size.height * 0.75,
                //   ),
                //   child: Align(
                //     alignment: Alignment.bottomCenter,
                //     child: StreamBuilder(
                //         stream: FirebaseFirestore.instance
                //             .collection('users')
                //             .where('id_vol',
                //                 isEqualTo:
                //                     FirebaseAuth.instance.currentUser?.uid)
                //             .snapshots(),
                //         builder: (context,
                //             AsyncSnapshot<QuerySnapshot> streamSnapshot) {
                //           return ListView.builder(
                //               itemCount: !streamSnapshot.hasData
                //                   ? 1
                //                   : streamSnapshot.data?.docs.length,
                //               itemBuilder: (ctx, index) {
                //                 return Padding(
                //                   padding: const EdgeInsets.only(left: 30),
                //                   child: Container(
                //                     width: double.infinity,
                //                     height: MediaQuery.of(context).size.height *
                //                         0.075,
                //                     decoration: buttonDecoration,
                //                     child: TextButton(
                //                         child: Text(
                //                           "Done",
                //                           style: textButtonStyle,
                //                         ),
                //                         onPressed: () async {
                //                           FirebaseFirestore.instance
                //                               .collection('users')
                //                               .doc(streamSnapshot
                //                                   .data?.docs[index].id)
                //                               .update({
                //                             "category": chosenCategoryList
                //                           });
                //                           categoriesVolunteer =
                //                               chosenCategoryList;
                //                           Future.delayed(Duration(seconds: 2),
                //                               () {
                //                             Navigator.push(
                //                                 context,
                //                                 MaterialPageRoute(
                //                                     builder: (context) =>
                //                                         const HomeVol()));
                //                           });
                //                         }),
                //                   ),
                //                 );
                //               });
                //         }),
                //   ),
                // ),
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
                        BorderRadius.circular(18)),
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
                        BorderRadius.circular(18)),
                    child: TextButton(
                        child: Text(
                          'Leave previous choice',
                          style: GoogleFonts.raleway(
                            fontSize: 16,
                            color: blueColor,
                          ),
                        ),
                        onPressed: () async {
                          Future.delayed(Duration(seconds: 1),
                                      () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (
                                              context) =>
                                          const HomeVol()));
                                  });
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
