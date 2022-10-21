import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constants.dart';
import '../../../shared/loading.dart';
import '../../../volunteer/home/settings_home_vol.dart';
import '../../intro_screen/option.dart';

String chosenCategory = '';

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

  // text field state

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const OptionChoose()),
        );
        return true;
      },
      child: loading
          ? Loading()
          : SafeArea(
              child: Scaffold(
                resizeToAvoidBottomInset: true,
                backgroundColor: const Color.fromRGBO(233, 242, 253, 8),
                appBar: AppBar(
                  title: Padding(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.height * 0.1),
                    child: Text(
                      "Volunteer",
                      style: GoogleFonts.sairaStencilOne(
                        fontSize: 25,
                        color: Colors.black.withOpacity(0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  leading: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const OptionChoose()),
                        );
                      },
                      icon: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: blueColor,
                      )),
                ),
                body: Padding(
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.12),
                  child: SingleChildScrollView(
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
                                      Padding(
                                        padding: const EdgeInsets.only(top: 7),
                                        child: Align(
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
                                      // AnimatedButton(
                                      //      text: "Accommodation",
                                      //     onPress: (){
                                      //
                                      //     }),
                                      SizedBox(
                                        height: MediaQuery.of(context).size.height *
                                            0.085,
                                        child: Material(
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                            Radius.circular(24),
                                          )),
                                          color: Colors.white,
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  left: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.05,
                                                  right: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.04,
                                                ),
                                                child: const Icon(
                                                  Icons.house,
                                                  size: 35,
                                                ),
                                              ),
                                              Text(
                                                "Accommodation",
                                                style: GoogleFonts.raleway(
                                                  fontSize: 18,
                                                  color: Colors.black,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: MediaQuery.of(context).size.height *
                                            0.012,
                                      ),
                                      SizedBox(
                                        height: MediaQuery.of(context).size.height *
                                            0.085,
                                        child: Material(
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(24),
                                              )),
                                          color: Colors.white,
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  left: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                      0.05,
                                                  right: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                      0.04,
                                                ),
                                                child: const Icon(
                                                  Icons.emoji_transportation_rounded,
                                                  size: 35,
                                                ),
                                              ),
                                              Text(
                                                "Transfer",
                                                style: GoogleFonts.raleway(
                                                  fontSize: 18,
                                                  color: Colors.black,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: MediaQuery.of(context).size.height *
                                            0.012,
                                      ),
                                      SizedBox(
                                        height: MediaQuery.of(context).size.height *
                                            0.085,
                                        child: Material(
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(24),
                                              )),
                                          color: Colors.white,
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  left: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                      0.05,
                                                  right: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                      0.04,
                                                ),
                                                child: const Icon(
                                                  Icons.pets_rounded,
                                                  size: 35,
                                                ),
                                              ),
                                              Text(
                                                "Animal assistance",
                                                style: GoogleFonts.raleway(
                                                  fontSize: 18,
                                                  color: Colors.black,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: MediaQuery.of(context).size.height *
                                            0.012,
                                      ),
                                      SizedBox(
                                        height: MediaQuery.of(context).size.height *
                                            0.085,
                                        child: Material(
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(24),
                                              )),
                                          color: Colors.white,
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  left: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                      0.05,
                                                  right: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                      0.04,
                                                ),
                                                child: const Icon(
                                                  Icons.local_grocery_store_rounded,
                                                  size: 35,
                                                ),
                                              ),
                                              Text(
                                                "Grocery assistance",
                                                style: GoogleFonts.raleway(
                                                  fontSize: 18,
                                                  color: Colors.black,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: MediaQuery.of(context).size.height *
                                            0.012,
                                      ),
                                      SizedBox(
                                        height: MediaQuery.of(context).size.height *
                                            0.085,
                                        child: Material(
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(24),
                                              )),
                                          color: Colors.white,
                                          child: Row(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  left: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                      0.05,
                                                  right: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                      0.04,
                                                ),
                                                child: const Icon(
                                                  Icons.sign_language_rounded,
                                                  size: 35,
                                                ),
                                              ),
                                              Text(
                                                "Language assistance",
                                                style: GoogleFonts.raleway(
                                                  fontSize: 18,
                                                  color: Colors.black,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
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
                                //       print("QQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQQ");
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
                ),
                floatingActionButton: Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      width: double.infinity,
                      height:
                      MediaQuery.of(context).size.height * 0.075,
                      decoration: buttonDecoration,
                      child: TextButton(
                          child: Text(
                            "Next",
                            style: textButtonStyle,
                          ),
                          onPressed: () async {
                            // if (controllerTextFieldNameVol.text.isEmpty) {
                            //   setState(() {
                            //     errorEmptyRegister = true;
                            //   });
                            // }
                            // if (controllerTextFieldPhoneNumberVol.text.isEmpty) {
                            //   setState(() {
                            //     errorEmptyRegister = true;
                            //   });
                            // }
                            // if (controllerTextFieldEmailVolRegistration.text.isEmpty) {
                            //   setState(() {
                            //     errorEmptyRegister = true;
                            //   });
                            // }
                            // if (controllerTextFieldPasswordVolRegistration.text.isEmpty) {
                            //   setState(() {
                            //     errorEmptyRegister = true;
                            //   });
                            // }
                            // if (_formKey.currentState!.validate()) {
                            //   setState(() => loading = true);
                            //   dynamic result =
                            //   await _auth.registerWithEmailAndPasswordVol(
                            //       emailRegisterVol, passwordRegisterVol);
                            //
                            //   if (result == null) {
                            //     setState(() {
                            //       errorEmptyRegister = false;
                            //       loading = false;
                            //       error =
                            //       'Could not sign in with those credentials';
                            //     });
                            //   }
                            // }
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                    const SettingsHomeVol()));
                          }),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}