import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wol_pro_1/widgets/text_form_field.dart';

import '../../../../../constants.dart';
import '../../../../../services/auth.dart';
import '../../../../widgets/loading.dart';
import '../../../intro_screen/option.dart';
import '../login/sign_in_refugee.dart';

bool registrationRef = false;

bool nameRef = false;
bool phoneRef = false;
bool phoneLength = false;
bool emailRef = false;
bool passwordRef = false;

String userNameRef = '';
String phoneNumberRef = '';
TextEditingController controllerTextFieldNameRef = TextEditingController();
TextEditingController controllerTextFieldPhoneNumberRef =
    TextEditingController();
TextEditingController controllerTextFieldEmailRefRegistration =
    TextEditingController();
TextEditingController controllerTextFieldPasswordRefRegistration =
    TextEditingController();

class RegisterRef extends StatefulWidget {
  final Function toggleView;

  const RegisterRef({Key? key, required this.toggleView}) : super(key: key);

  @override
  _RegisterRefState createState() => _RegisterRefState();
}

class _RegisterRefState extends State<RegisterRef> {
  bool passwordVisible = false;

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        controllerTextFieldNameRef.clear();
        controllerTextFieldPhoneNumberRef.clear();
        controllerTextFieldEmailRefRegistration.clear();
        controllerTextFieldPasswordRefRegistration.clear();
        errorEmptyRegister = false;

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const OptionChoose()),
        );
        return true;
      },
      child: loading
          ? const LoadingRefugee()
          : SafeArea(
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
                    textAlign: TextAlign.left,
                  ),
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  leading: IconButton(
                      onPressed: () {
                        controllerTextFieldNameRef.clear();
                        controllerTextFieldPhoneNumberRef.clear();
                        controllerTextFieldEmailRefRegistration.clear();
                        controllerTextFieldPasswordRefRegistration.clear();
                        errorEmptyRegister = false;
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
                                    const EdgeInsets.symmetric(vertical: 20),
                                child: Column(
                                  children: [
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        "Welcome!",
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
                                          "Sign up to continue",
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
                                child: Text(
                                  error,
                                  style: const TextStyle(
                                      color: Colors.red, fontSize: 14.0),
                                ),
                              ),
                              Material(
                                color: Colors.transparent,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                )),
                                elevation: errorEmptyRegister == true ? 0 : 5,
                                child: CustomTextFormFieldRegisterRef(
                                  customHintText: 'Name',
                                  customErrorText: 'Enter your name',
                                  hide: false,
                                ),
                              ),
                              Visibility(
                                visible: nameRef,
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      bottom:
                                          MediaQuery.of(context).size.height *
                                              0.005,
                                    ),
                                    child: Text(
                                      "Your name should contain only letters",
                                      style: GoogleFonts.raleway(
                                        fontSize: 12,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: !errorEmptyRegister
                                    ? MediaQuery.of(context).size.height * 0.02
                                    : MediaQuery.of(context).size.height *
                                        0.015,
                              ),
                              Material(
                                color: Colors.transparent,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                  Radius.circular(24),
                                )),
                                elevation: errorEmptyRegister == true ? 0 : 5,
                                child: CustomTextFormFieldRegisterRef(
                                  customHintText: 'Phone number',
                                  customErrorText: 'Enter your phone number',
                                  hide: false,
                                ),
                              ),
                              Visibility(
                                visible: phoneRef,
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      bottom:
                                          MediaQuery.of(context).size.height *
                                              0.005,
                                    ),
                                    child: Text(
                                      phoneLength
                                          ? "Your phone number should contain only 9 numbers"
                                          : "Your phone number should contain only numbers",
                                      style: GoogleFonts.raleway(
                                        fontSize: 12,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: !errorEmptyRegister
                                    ? MediaQuery.of(context).size.height * 0.02
                                    : MediaQuery.of(context).size.height *
                                        0.015,
                              ),
                              Material(
                                color: Colors.transparent,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                )),
                                elevation: errorEmptyRegister == true ? 0 : 5,
                                child: CustomTextFormFieldRegisterRef(
                                  customHintText: 'Email',
                                  customErrorText: 'Enter your email',
                                  hide: false,
                                ),
                              ),
                              Visibility(
                                visible: emailRef,
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
                                height: !errorEmptyRegister
                                    ? MediaQuery.of(context).size.height * 0.02
                                    : MediaQuery.of(context).size.height *
                                        0.015,
                              ),
                              Material(
                                color: Colors.transparent,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                )),
                                elevation: errorEmptyRegister == true ? 0 : 5,
                                child: CustomTextFormFieldRegisterRef(
                                  customHintText: 'Password',
                                  customErrorText: 'Enter a password',
                                  hide: true,
                                ),
                              ),
                              Visibility(
                                visible: passwordRef,
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      bottom:
                                          MediaQuery.of(context).size.height *
                                              0.005,
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
                              SizedBox(
                                height: !errorEmptyRegister
                                    ? MediaQuery.of(context).size.height * 0.055
                                    : MediaQuery.of(context).size.height *
                                        0.015,
                              ),
                              Container(
                                width: double.infinity,
                                height:
                                    MediaQuery.of(context).size.height * 0.085,
                                decoration: buttonActiveDecorationRefugee,
                                child: TextButton(
                                    child: Text(
                                      "Sign Up",
                                      style: textActiveButtonStyleRefugee,
                                    ),
                                    onPressed: () async {
                                      setState(() {
                                        signInRef = false;
                                      });
                                      registrationRef = true;
                                      if (controllerTextFieldNameRef
                                          .text.isEmpty) {
                                        setState(() {
                                          errorEmptyRegister = true;
                                        });
                                      }
                                      if (controllerTextFieldPhoneNumberRef
                                          .text.isEmpty) {
                                        setState(() {
                                          errorEmptyRegister = true;
                                        });
                                      }
                                      if (controllerTextFieldEmailRefRegistration
                                          .text.isEmpty) {
                                        setState(() {
                                          errorEmptyRegister = true;
                                        });
                                      }
                                      if (controllerTextFieldPasswordRefRegistration
                                          .text.isEmpty) {
                                        setState(() {
                                          errorEmptyRegister = true;
                                        });
                                      }
                                      if (_formKey.currentState!.validate()) {
                                        setState(() => loading = true);
                                        dynamic result = await _auth
                                            .registerWithEmailAndPasswordRef(
                                                emailRegisterRef,
                                                passwordRegisterRef);

                                        if (result == null) {
                                          setState(() {
                                            errorEmptyRegister = false;
                                            loading = false;
                                            error =
                                                'Could not sign in with those credentials';
                                          });
                                        }
                                      }
                                      // Navigator.push(context,
                                    }),
                              ),
                              Align(
                                alignment: Alignment.topCenter,
                                child: TextButton(
                                    onPressed: () {
                                      widget.toggleView();
                                    },
                                    child: Text(
                                      "Sign in",
                                      style: GoogleFonts.raleway(
                                        decoration: TextDecoration.underline,
                                        fontSize: 15,
                                        color: Colors.black,
                                      ),
                                    )),
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
}
