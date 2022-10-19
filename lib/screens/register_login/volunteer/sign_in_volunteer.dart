import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wol_pro_1/constants.dart';
import 'package:wol_pro_1/services/auth.dart';
import 'package:wol_pro_1/shared/loading.dart';

import '../../../../widgets/text_form_field.dart';

TextEditingController controllerTextField = TextEditingController();
List<String> chosenCategory = [];
String userName = '';
String phoneNumber = '';
String pesel = '';
bool isVisible = false;
double paddingHeightShadow = 0.048;

class SignInVol extends StatefulWidget {
  final Function toggleView;

  const SignInVol({Key? key, required this.toggleView}) : super(key: key);

  @override
  _SignInVolState createState() => _SignInVolState();
}

class _SignInVolState extends State<SignInVol> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            resizeToAvoidBottomInset: true,
            backgroundColor: const Color.fromRGBO(233, 242, 253, 8),
            body: SingleChildScrollView(
              child: Padding(
                padding: padding,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 140),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Welcome back!",
                              style: GoogleFonts.raleway(
                                fontSize: 35,
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
                                "Sign in to continue",
                                style: GoogleFonts.raleway(
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Visibility(
                        visible: isVisible,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                            error,
                            style: const TextStyle(
                                color: Colors.red, fontSize: 12.0),
                          ),
                        ),
                      ),
                    ),
                    Stack(
                      children: [
                        // Column(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Material(
                        //       elevation: 5,
                        //       shadowColor: Colors.black45,
                        //       borderRadius: BorderRadius.circular(24),
                        //       child: TextFormField(
                        //         decoration: InputDecoration(
                        //           enabledBorder: OutlineInputBorder(
                        //             borderRadius: BorderRadius.circular(24.0),
                        //             borderSide: const BorderSide(
                        //               color: Colors.white,
                        //               width: 0,
                        //             ),
                        //           ),
                        //           filled: true,
                        //           fillColor: Colors.white,
                        //         ),
                        //       ),
                        //     ),
                        //         SizedBox(height:
                        //         MediaQuery.of(context).size.height * 0.06,),
                        //         Material(
                        //           elevation: 5,
                        //           shadowColor: Colors.black45,
                        //           borderRadius: BorderRadius.circular(24),
                        //           child: TextFormField(
                        //             decoration: InputDecoration(
                        //               enabledBorder: OutlineInputBorder(
                        //                 borderRadius: BorderRadius.circular(24.0),
                        //                 borderSide: const BorderSide(
                        //                   color: Colors.white,
                        //                   width: 0,
                        //                 ),
                        //               ),
                        //               filled: true,
                        //               fillColor: Colors.white,
                        //             ),
                        //           ),
                        //         ),
                        //
                        //
                        //   ],
                        // ),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              Card(
                                color: Colors.transparent,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(24),
                                    )),
                                elevation: errorEmpty==true? 0:5,
                                child: const CustomTextFormField(
                                  customHintText: 'Email',
                                  customErrorText: 'Enter an email',
                                  hide: false,
                                ),
                              ),
                          SizedBox(height: !errorEmpty
                                  ?MediaQuery.of(context).size.height * 0.035
                              :MediaQuery.of(context).size.height * 0.015,),
                              Card(
                                color: Colors.transparent,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(24),
                                    )),
                                elevation: errorEmpty==true? 0:5,
                                child: const CustomTextFormField(
                                  customHintText: 'Password',
                                  customErrorText: 'Enter a password',
                                  hide: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    // Center(
                    //   child: CustomButton(buttonName: 'Refugee'),
                    // ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: !errorEmpty
                          ?MediaQuery.of(context).size.height * 0.055
                      : MediaQuery.of(context).size.height * 0.02),
                      child: Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.085,
                        decoration: buttonDecoration,
                        child: TextButton(
                            child: Text(
                              "Sign In",
                              style: textButtonStyle,
                            ),
                            onPressed: () async {
                              if (controllerTextField.text.isEmpty) {
                                setState(() {
                                  errorEmpty = true;
                                  print("LLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLLL");
                                  print(errorEmpty);
                                });
                              }
                              ;
                              if (_formKey.currentState!.validate()) {
                                setState(() => loading = true);
                                dynamic result =
                                    await _auth.signInWithEmailAndPasswordVol(
                                        email, password);

                                if (result == null) {
                                  setState(() {
                                    errorEmpty = true;
                                    isVisible = true;
                                    loading = false;
                                    error =
                                        'Could not sign in with those credentials';
                                  });
                                }
                              }
                            }),
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                            onPressed: () {
                              widget.toggleView();
                            },
                            child: Text(
                              "Sign up",
                              style: GoogleFonts.raleway(
                                fontSize: 15,
                                color: Colors.black,
                              ),
                            )),
                        TextButton(
                            onPressed: () {},
                            child: Text(
                              "Forgot password",
                              style: GoogleFonts.raleway(
                                fontSize: 15,
                                color: Colors.black,
                              ),
                            )),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}

//
// class CustomButton extends StatelessWidget {
//   final String buttonName;
//   const CustomButton({
//     Key? key, required this.buttonName
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: padding,
//       child: Container(
//         width: double.infinity,
//         height: MediaQuery.of(context).size.height * 0.085,
//         decoration: buttonDecoration,
//         child: TextButton(
//
//           child: Text(buttonName,
//             style: textButtonStyle,
//           ),
//           onPressed: () async{
//
//           },
//         ),
//       ),
//     );
//   }
// }
// class CustomButton extends StatelessWidget {
//   final String buttonName;
//
//   const CustomButton({Key? key, required this.buttonName}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       height: MediaQuery.of(context).size.height * 0.085,
//       decoration: buttonDecoration,
//       child: TextButton(
//         child: Text(
//           buttonName,
//           style: textButtonStyle
//         ),
//         onPressed: () async {
//           // Navigator.push(context, MaterialPageRoute(builder: (context) => const Wrapper()));
//         },
//       ),
//     );
//   }
// }
