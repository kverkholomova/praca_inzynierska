import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wol_pro_1/services/auth.dart';
import 'package:wol_pro_1/shared/loading.dart';
import 'package:wol_pro_1/volunteer/authenticate/register_volunteer_1.dart';

import '../../../shared/constants.dart';
import '../../../cash/screen_with_applications.dart';

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

  // text field state
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Color.fromRGBO(233, 242, 253, 8),
            // appBar: AppBar(
            //   backgroundColor: Color.fromRGBO(49, 72, 103, 0.8),
            //   elevation: 0.0,
            //   title: Text('Sign in', style: TextStyle(fontSize: 16),),
            //   actions: <Widget>[
            //     FlatButton.icon(
            //       icon: const Icon(Icons.person, color: Colors.white,),
            //       label: const Text('Register', style: TextStyle(color: Colors.white),),
            //       onPressed: () => widget.toggleView(),
            //     ),
            //   ],
            // ),
            body: Container(
              color: Color.fromRGBO(233, 242, 253, 8),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.height * 0.02,
                        top: MediaQuery.of(context).size.height * 0.1),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 120),
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
                                fontSize: 20,
                                color: Colors.black,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        children: <Widget>[
                          CustomTextFormField(customHintText: 'Email'),
                          Padding(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.05),
                            child:
                                CustomTextFormField(customHintText: 'Password'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      width: double.infinity,
                      height: 63,
                      decoration: BoxDecoration(
                          color: const Color.fromRGBO(2, 62, 99, 20),
                          borderRadius: BorderRadius.circular(24)),
                      child: TextButton(
                          child: Text(
                            "Sign In",
                            style: GoogleFonts.raleway(
                              fontSize: 23,
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() => loading = true);
                              dynamic result =
                                  await _auth.signInWithEmailAndPasswordVol(
                                      email, password);
                              if (result == null) {
                                setState(() {
                                  loading = false;
                                  error =
                                      'Could not sign in with those credentials';
                                });
                              }
                            }
                          }),
                    ),
                  ),
                  // Container(
                  //   height: 55,
                  //   width: 275,
                  //   decoration:
                  //       BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  //   child: MaterialButton(
                  //       color: Color.fromRGBO(49, 72, 103, 0.8),
                  //       child: Text(
                  //         'Sign In',
                  //         style: TextStyle(color: Colors.white),
                  //       ),
                  //       onPressed: () async {
                  //         if (_formKey.currentState!.validate()) {
                  //           setState(() => loading = true);
                  //           dynamic result = await _auth
                  //               .signInWithEmailAndPasswordVol(email, password);
                  //           if (result == null) {
                  //             setState(() {
                  //               loading = false;
                  //               error =
                  //                   'Could not sign in with those credentials';
                  //             });
                  //           }
                  //         }
                  //       }),
                  // ),
                  const SizedBox(height: 12.0),
                  Text(
                    error,
                    style: const TextStyle(color: Colors.red, fontSize: 14.0),
                  ),
                ],
              ),
            ),
          );
  }
}

class CustomButton extends StatelessWidget {
  final String buttonName;

  const CustomButton({Key? key, required this.buttonName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        height: 63,
        decoration: BoxDecoration(
            color: const Color.fromRGBO(2, 62, 99, 20),
            borderRadius: BorderRadius.circular(24)),
        child: TextButton(
          child: Text(
            buttonName,
            style: GoogleFonts.raleway(
              fontSize: 23,
              color: Colors.white,
            ),
          ),
          onPressed: () async {
            // Navigator.push(context, MaterialPageRoute(builder: (context) => const Wrapper()));
          },
        ),
      ),
    );
  }
}

class CustomTextFormField extends StatelessWidget {
  final String customHintText;

  const CustomTextFormField({Key? key, required this.customHintText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 63,
      child: Material(
        elevation: 5,
        shadowColor: Colors.black,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
            side: BorderSide(color: Colors.white, width: 0)),
        child: TextFormField(
          decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24.0),
                borderSide: BorderSide(
                  color: Color.fromRGBO(2, 62, 99, 20),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(24.0),
                borderSide: BorderSide(
                  color: Colors.white,
                  width: 0,
                ),
              ),
              filled: true,
              fillColor: Colors.white,
              hintStyle: GoogleFonts.raleway(
                fontSize: 18,
                color: Colors.black.withOpacity(0.5),
              ),
              hintText: customHintText),
          validator: (val) => val!.isEmpty ? 'Enter an email' : null,
          onChanged: (val) {
            // setState(() => email = val);
          },
        ),
      ),
    );
  }
}