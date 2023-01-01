import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wol_pro_1/constants.dart';
import 'package:wol_pro_1/screens/intro_screen/option.dart';
import 'package:wol_pro_1/screens/register_login/volunteer/register/register_volunteer_1.dart';
import 'package:wol_pro_1/services/auth.dart';
import 'package:wol_pro_1/widgets/loading.dart';
import 'package:wol_pro_1/widgets/wrapper.dart';

import '../../../../../widgets/text_form_field.dart';
import 'forgot_password.dart';

TextEditingController controllerTextFieldEmailVol = TextEditingController();
TextEditingController controllerTextFieldPasswordVol = TextEditingController();
bool isVisible = false;
double paddingHeightShadow = 0.048;
String emailVolLog = '';
String passwordVolLog = '';
bool justSignedIn = false;

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


  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : WillPopScope(
      onWillPop: () async {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const OptionChoose()),
        );
        return true;
      },
          child: SafeArea(
            child: Scaffold(
                resizeToAvoidBottomInset: true,
                backgroundColor: const Color.fromRGBO(233, 242, 253, 8),
                appBar: AppBar(
                  title: Text(
                    "Volunteer",
                    style: GoogleFonts.sairaStencilOne(
                      fontSize: 25,
                      color: Colors.black.withOpacity(0.7),

                    ),
                    textAlign: TextAlign.center,
                  ),
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  leading: IconButton(
                      onPressed: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const OptionChoose()),
                        );
                      },
                      icon: Icon(Icons.arrow_back_ios_new_rounded, color: blueColor,)),
                ),
                body: SingleChildScrollView(
                  child: Padding(
                    padding: padding,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.08),
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
                              Align(
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
                        Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              Material(
                                color: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                    borderRadius: borderRadiusApplication),
                                elevation: errorEmpty==true? 0:5,
                                child: CustomTextFormField(
                                  customHintText: 'Email',
                                  customErrorText: 'Enter an email',
                                  hide: false,
                                ),
                              ),
                          SizedBox(height: !errorEmpty
                                  ?MediaQuery.of(context).size.height * 0.02
                              :MediaQuery.of(context).size.height * 0.015,),
                              Material(
                                color: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                    borderRadius: borderRadiusApplication,
                                    ),
                                elevation: errorEmpty==true? 0:5,
                                child: CustomTextFormField(
                                  customHintText: 'Password',
                                  customErrorText: 'Enter a password',
                                  hide: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Center(
                        //   child: CustomButton(buttonName: 'Refugee'),
                        // ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: !errorEmpty
                              ?MediaQuery.of(context).size.height * 0.17
                          : MediaQuery.of(context).size.height * 0.02),
                          child: Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.085,
                            decoration: buttonActiveDecoration,
                            child: TextButton(
                                child: Text(
                                  "Sign In",
                                  style: textActiveButtonStyle,
                                ),
                                onPressed: () async {
                                  registrationVol = false;
                                  if (controllerTextFieldEmailVol.text.isEmpty) {
                                    setState(() {
                                      errorEmpty = true;

                                    });
                                  }
                                  if (controllerTextFieldPasswordVol.text.isEmpty) {
                                    setState(() {
                                      errorEmpty = true;

                                    });
                                  }
                                  if (_formKey.currentState!.validate()) {
                                    setState(() => loading = true);
                                    dynamic result =
                                        await _auth.signInWithEmailAndPasswordVol(
                                            emailVolLog, passwordVolLog);


                                    if (result == null) {
                                      setState(() {
                                        errorEmpty = true;
                                        isVisible = true;
                                        loading = false;
                                        error =
                                            'Could not sign in with those credentials';
                                      });
                                    } else{
                                      justSignedIn = true;
    // Future.delayed(const Duration(milliseconds: 500), () {
    //                                   Navigator.of(context, rootNavigator: true).pushReplacement(
    //                                       MaterialPageRoute(builder: (context) => Wrapper()));
    // });
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
                                onPressed: () {
                                  Navigator.of(context, rootNavigator: true).pushReplacement(
                                                                            MaterialPageRoute(builder: (context) => ForgotPasswordVol()));
                                },
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
