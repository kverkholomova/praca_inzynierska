import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wol_pro_1/constants.dart';
import 'package:wol_pro_1/screens/intro_screen/option.dart';
import 'package:wol_pro_1/services/auth.dart';
import 'package:wol_pro_1/shared/loading.dart';

import '../../../../widgets/text_form_field.dart';

TextEditingController controllerTextFieldEmailRef = TextEditingController();
TextEditingController controllerTextFieldPasswordRef = TextEditingController();
bool isVisibleRef = false;
bool errorEmptyRef = false;

class SignInRef extends StatefulWidget {
  final Function toggleView;

  const SignInRef({Key? key, required this.toggleView}) : super(key: key);

  @override
  _SignInRefState createState() => _SignInRefState();
}

class _SignInRefState extends State<SignInRef> {
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
        : WillPopScope(
      onWillPop: () async {
        controllerTextFieldEmailRef.clear();
        controllerTextFieldPasswordRef.clear();
        errorEmptyRef = false;
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
            title: Padding(
              padding: EdgeInsets.only(left: MediaQuery.of(context).size.height * 0.1),              child: Text(
                "Refugee",
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
                onPressed: (){
                  controllerTextFieldEmailRef.clear();
                  controllerTextFieldPasswordRef.clear();
                  errorEmptyRef = false;
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
                    padding: const EdgeInsets.symmetric(vertical: 100),
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
                      visible: isVisibleRef,
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
                        Card(
                          color: Colors.transparent,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(24),
                              )),
                          elevation: errorEmptyRef==true? 0:5,
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
                          elevation: errorEmptyRef==true? 0:5,
                          child: const CustomTextFormField(
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
                            if (controllerTextFieldEmailRef.text.isEmpty) {
                              setState(() {
                                errorEmpty = true;
                              });
                            }
                            if (controllerTextFieldPasswordRef.text.isEmpty) {
                              setState(() {
                                errorEmpty = true;
                              });
                            }
                            if (_formKey.currentState!.validate()) {
                              setState(() => loading = true);
                              dynamic result =
                              await _auth.signInWithEmailAndPasswordRef(
                                  email, password);

                              if (result == null) {
                                setState(() {
                                  errorEmpty = true;
                                  isVisibleRef = true;
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
        ),
      ),
    );
  }
}