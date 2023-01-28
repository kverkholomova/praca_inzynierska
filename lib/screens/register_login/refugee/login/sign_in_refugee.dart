import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wol_pro_1/constants.dart';
import 'package:wol_pro_1/screens/intro_screen/option.dart';
import 'package:wol_pro_1/services/auth.dart';
import 'package:wol_pro_1/widgets/loading.dart';

import '../../../../../widgets/text_form_field.dart';
import 'forgot_password_ref.dart';

TextEditingController controllerTextFieldEmailRef = TextEditingController();
TextEditingController controllerTextFieldPasswordRef = TextEditingController();
bool isVisibleRef = false;
bool errorEmptyRef = false;
String emailRefLog = '';
String passwordRefLog = '';
bool signInRef = true;

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
  bool passwordVisible = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? const LoadingRefugee()
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
                backgroundColor: backgroundRefugee,
                appBar: AppBar(
                  title: Text(
                    "Refugee",
                    style: GoogleFonts.sairaStencilOne(
                      fontSize: 25,
                      color: Colors.black.withOpacity(0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  leading: IconButton(
                      onPressed: () {
                        controllerTextFieldEmailRef.clear();
                        controllerTextFieldPasswordRef.clear();
                        errorEmptyRef = false;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const OptionChoose()),
                        );
                      },
                      icon: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: redColor,
                      )),
                ),
                body: SingleChildScrollView(
                  child: Padding(
                    padding: padding,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical:
                                  MediaQuery.of(context).size.height * 0.08),
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
                              Material(
                                color: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                    borderRadius: borderRadiusApplication),
                                elevation: errorEmptyRef == true ? 0 : 5,
                                child: CustomTextFormFieldRefugee(
                                  customHintText: 'Email',
                                  customErrorText: 'Enter an email',
                                  hide: false,
                                ),
                              ),
                              Visibility(
                                visible: emailErrorSignInRef,
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      bottom:
                                          MediaQuery.of(context).size.height *
                                              0.005,
                                    ),
                                    child: Text(
                                      "Your email should contain @gmail.com",
                                      style: GoogleFonts.raleway(
                                        fontSize: 12,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: !errorEmptyRef
                                    ? MediaQuery.of(context).size.height * 0.02
                                    : MediaQuery.of(context).size.height *
                                        0.015,
                              ),
                              Material(
                                color: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                    borderRadius: borderRadiusApplication),
                                elevation: errorEmptyRef == true ? 0 : 5,
                                child: CustomTextFormFieldRefugee(
                                  customHintText: 'Password',
                                  customErrorText: 'Enter a password',
                                  hide: true,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: passwordErrorSignInRef,
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).size.height * 0.005,
                              ),
                              child: Text(
                                "Your password should contain 9 signs or more",
                                style: GoogleFonts.raleway(
                                  fontSize: 12,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: !errorEmptyRef
                                  ? MediaQuery.of(context).size.height * 0.17
                                  : MediaQuery.of(context).size.height * 0.02),
                          child: Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.085,
                            decoration: buttonActiveDecorationRefugee,
                            child: TextButton(
                                child: Text(
                                  "Sign In",
                                  style: textActiveButtonStyle,
                                ),
                                onPressed: () async {
                                  setState(() {
                                    signInRef = true;
                                  });
                                  if (controllerTextFieldEmailRef
                                      .text.isEmpty) {
                                    setState(() {
                                      errorEmptyRef = true;
                                    });
                                  }
                                  if (controllerTextFieldPasswordRef
                                      .text.isEmpty) {
                                    setState(() {
                                      errorEmptyRef = true;
                                    });
                                  }
                                  if (_formKey.currentState!.validate()) {
                                    setState(() => loading = true);
                                    dynamic result = await _auth
                                        .signInWithEmailAndPasswordRef(
                                            emailRefLog, passwordRefLog);

                                    if (result == null) {
                                      setState(() {
                                        errorEmptyRef = true;
                                        isVisibleRef = true;
                                        loading = false;
                                        error =
                                            'Could not sign in with those credentials';
                                      });
                                    } else {
                                      controllerTextFieldEmailRef.clear();
                                      controllerTextFieldPasswordRef.clear();
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
                                  setState(() {});
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
                                  Navigator.of(context, rootNavigator: true)
                                      .pushReplacement(MaterialPageRoute(
                                          builder: (context) =>
                                              const ForgotPasswordRef()));
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
