import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wol_pro_1/constants.dart';
import 'package:wol_pro_1/services/auth.dart';
import 'package:wol_pro_1/shared/loading.dart';

import '../../../../widgets/text_form_field.dart';

List<String> chosen_category = [];
String user_name = '';
String phone_number = '';
String pesel = '';
bool isVisible = false;
double paddingHeightShadow = 0.048;

class SignInVol extends StatefulWidget {
  final Function toggleView;

  SignInVol({required this.toggleView});

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
            resizeToAvoidBottomInset: false,
            backgroundColor: const Color.fromRGBO(233, 242, 253, 8),
            body: Padding(
              padding: padding,
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 150),
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
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.52),
                    child: Column(
                      children: <Widget>[
                        Material(
                          elevation: 5,
                          shadowColor: Colors.black45,
                          borderRadius: BorderRadius.circular(24),
                          child: TextFormField(
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24.0),
                                borderSide: BorderSide(
                                  color: Colors.white,
                                  width: 0,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),

                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * paddingHeightShadow),
                          child:
                          Material(
                            elevation: 5,
                            shadowColor: Colors.black45,
                            borderRadius: BorderRadius.circular(24),
                            child: TextFormField(

                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(24.0),
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                    width: 0,
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                              ),

                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.52),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          Container(
                              height: MediaQuery.of(context).size.height * 0.135,
                              child: const CustomTextFormField(customHintText: 'Email', customErrorText: 'Enter an email',)),
                          const CustomTextFormField(customHintText: 'Password', customErrorText: 'Enter a password',),
                        ],
                      ),
                    ),
                  ),
                  // Center(
                  //   child: CustomButton(buttonName: 'Refugee'),
                  // ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.795),
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
                            if (_formKey.currentState!.validate()) {
                              setState(() => loading = true);
                              dynamic result =
                                  await _auth.signInWithEmailAndPasswordVol(
                                      email, password);
                              if (result == null) {
                                setState(() {
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

                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.48),
                    child: Visibility(
                      visible: isVisible,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          // "AAAAAAAA",
                        error,
                        style: const TextStyle(color: Colors.red, fontSize: 12.0),
                    ),
                      ),),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height * 0.87),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(onPressed: (){

                        }, child: Text(
                          "Sign up",
                          style: GoogleFonts.raleway(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        )),
                        TextButton(onPressed: (){

                        }, child: Text(
                          "Forgot password",
                          style: GoogleFonts.raleway(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        )),
                      ],
                    ),
                  ),

                ],
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

