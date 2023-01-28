import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wol_pro_1/widgets/text_form_field.dart';

import '../../../../constants.dart';
import '../../../../services/auth.dart';
import '../../../../widgets/loading.dart';
import '../../../intro_screen/option.dart';
import '../../../menu/volunteer/home_page/home_vol.dart';

bool nameVol = false;
bool phoneVol = false;
bool phoneLengthVol = false;
bool emailVol = false;
bool passwordVol = false;

int volunteerAge = 0;
bool registrationVol = false;
double volunteerRate = 5;
List<String> chosenCategoryListChanges = [];
String userName = '';
String phoneNumber = '';
TextEditingController controllerTextFieldNameVol = TextEditingController();
TextEditingController controllerTextFieldPhoneNumberVol =
    TextEditingController();
TextEditingController controllerTextFieldEmailVolRegistration =
    TextEditingController();
TextEditingController controllerTextFieldPasswordVolRegistration =
    TextEditingController();

class RegisterVol1 extends StatefulWidget {
  final Function toggleView;

  const RegisterVol1({Key? key, required this.toggleView}) : super(key: key);

  @override
  _RegisterVol1State createState() => _RegisterVol1State();
}

class _RegisterVol1State extends State<RegisterVol1> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;

  // text field state

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        controllerTextFieldNameVol.clear();
        controllerTextFieldPhoneNumberVol.clear();
        controllerTextFieldEmailVolRegistration.clear();
        controllerTextFieldPasswordVolRegistration.clear();
        errorEmptyRegister = false;

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const OptionChoose()),
        );
        return true;
      },
      child: loading
          ? const Loading()
          : SafeArea(
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
                      onPressed: () {
                        controllerTextFieldNameVol.clear();
                        controllerTextFieldPhoneNumberVol.clear();
                        controllerTextFieldEmailVolRegistration.clear();
                        controllerTextFieldPasswordVolRegistration.clear();
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
                                shape: RoundedRectangleBorder(
                                    borderRadius: borderRadiusApplication),
                                elevation: errorEmptyRegister == true ? 0 : 5,
                                child: CustomTextFormFieldRegister(
                                  customHintText: 'Name',
                                  customErrorText: 'Enter your name',
                                  hide: false,
                                ),
                              ),
                              Visibility(
                                visible: nameVol,
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
                                shape: RoundedRectangleBorder(
                                    borderRadius: borderRadiusApplication),
                                elevation: errorEmptyRegister == true ? 0 : 5,
                                child: CustomTextFormFieldRegister(
                                  customHintText: 'Phone number',
                                  customErrorText: 'Enter your phone number',
                                  hide: false,
                                ),
                              ),
                              Visibility(
                                visible: phoneVol,
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      bottom:
                                          MediaQuery.of(context).size.height *
                                              0.005,
                                    ),
                                    child: Text(
                                      phoneLengthVol
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
                                shape: RoundedRectangleBorder(
                                    borderRadius: borderRadiusApplication),
                                elevation: errorEmptyRegister == true ? 0 : 5,
                                child: CustomTextFormFieldRegister(
                                  customHintText: 'Email',
                                  customErrorText: 'Enter your email',
                                  hide: false,
                                ),
                              ),
                              Visibility(
                                visible: emailVol,
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
                                shape: RoundedRectangleBorder(
                                    borderRadius: borderRadiusApplication),
                                elevation: errorEmptyRegister == true ? 0 : 5,
                                child: CustomTextFormFieldRegister(
                                  customHintText: 'Password',
                                  customErrorText: 'Enter a password',
                                  hide: true,
                                ),
                              ),
                              Visibility(
                                visible: passwordVol,
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
                                    ? MediaQuery.of(context).size.height * 0.070
                                    : MediaQuery.of(context).size.height *
                                        0.015,
                              ),
                              Container(
                                width: double.infinity,
                                height:
                                    MediaQuery.of(context).size.height * 0.075,
                                decoration: buttonActiveDecoration,
                                child: TextButton(
                                    child: Text(
                                      "Sign Up",
                                      style: textActiveButtonStyle,
                                    ),
                                    onPressed: () async {
                                      registrationVol = true;
                                      setState(() {
                                        isLoggedIn = false;
                                      });
                                      if (controllerTextFieldNameVol
                                          .text.isEmpty) {
                                        setState(() {
                                          errorEmptyRegister = true;
                                        });
                                      }
                                      if (controllerTextFieldPhoneNumberVol
                                          .text.isEmpty) {
                                        setState(() {
                                          errorEmptyRegister = true;
                                        });
                                      }
                                      if (controllerTextFieldEmailVolRegistration
                                          .text.isEmpty) {
                                        setState(() {
                                          errorEmptyRegister = true;
                                        });
                                      }
                                      if (controllerTextFieldPasswordVolRegistration
                                          .text.isEmpty) {
                                        setState(() {
                                          errorEmptyRegister = true;
                                        });
                                      }
                                      if (_formKey.currentState!.validate()) {
                                        setState(() => loading = true);
                                        dynamic result = await _auth
                                            .registerWithEmailAndPasswordVol(
                                                emailRegisterVol,
                                                passwordRegisterVol);

                                        if (result == null) {
                                          setState(() {
                                            errorEmptyRegister = false;
                                            loading = false;
                                            error =
                                                'Could not sign in with those credentials';
                                          });
                                        }
                                      }
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
