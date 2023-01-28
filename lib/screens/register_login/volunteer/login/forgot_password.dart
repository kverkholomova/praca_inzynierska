


import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wol_pro_1/constants.dart';
import 'package:wol_pro_1/screens/intro_screen/option.dart';
import 'package:wol_pro_1/services/auth.dart';
import 'package:wol_pro_1/widgets/loading.dart';
import 'package:wol_pro_1/widgets/wrapper.dart';


import '../../../../../widgets/text_form_field.dart';


TextEditingController controllerTextFieldForgotPasswordVol = TextEditingController();
bool isVisibleForgotPassword = false;
String emailResetPassword = '';

class ForgotPasswordVol extends StatefulWidget {

  const ForgotPasswordVol({Key? key}) : super(key: key);

  @override
  _ForgotPasswordVolState createState() => _ForgotPasswordVolState();
}

class _ForgotPasswordVolState extends State<ForgotPasswordVol> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String error = '';
  bool loading = false;


  @override
  Widget build(BuildContext context) {
    return loading
        ? const Loading()
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
                  optionRefugee = false;
                  Navigator.of(context, rootNavigator: true).pushReplacement(
                      MaterialPageRoute(builder: (context) => Wrapper())
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
                            "Forgot Password",
                            style: GoogleFonts.raleway(
                              fontSize: 27,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Please enter your email address to recover your password",
                            style: GoogleFonts.raleway(
                              fontSize: 15,
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
                      visible: errorEmpty,
                      child: const Align(
                        alignment: Alignment.topCenter,
                        child: Text(
                          "Supply an email to reset password",
                          style: TextStyle(
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
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(24),
                              )),
                          elevation: errorEmpty==true? 0:5,
                          child: TextFormField(
                            controller: controllerTextFieldForgotPasswordVol,
                            // obscureText: widget.hide ==true?true:false,
                            decoration: InputDecoration(
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                  width: 1.5,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                  color: Colors.red,
                                  width: 1.5,
                                ),
                              ),
                              errorStyle: const TextStyle(
                                  color: Colors.red
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(
                                  color: Colors.black.withOpacity(0.7),
                                  width: 1.5,
                                ),
                              ),

                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                  width: 0,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              hintStyle: GoogleFonts.raleway(
                                fontSize: 16,
                                color: Colors.black.withOpacity(0.5),
                              ),
                              labelText: "Email",
                              labelStyle: GoogleFonts.raleway(
                                fontSize: 16,
                                color: Colors.black.withOpacity(0.7),
                              ),
                              // hintText: widget.customHintText,

                            ),
                            validator: (val) =>val!.isEmpty ? "Enter an email" : null,
                            onChanged: (val) {
                              setState(() {
                                emailResetPassword= val;

                              });
                              // setState(() => email = val);
                            },

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
                            ?MediaQuery.of(context).size.height * 0.385
                            : MediaQuery.of(context).size.height * 0.365),
                    child: Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height * 0.085,
                      decoration: buttonActiveDecoration,
                      child: TextButton(
                          child: Text(
                            "Reset password",
                            style: textActiveButtonStyle,
                          ),
                          onPressed: () async {

                             if (controllerTextFieldForgotPasswordVol.text.isEmpty){
                                setState(() {
                                  errorEmpty = true;
                                });
                            } else{
                               _auth.resetPassword(email: emailResetPassword);
                               dialogBuilderPasswordReset(context);
                             }

                          }),
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

  Future<void> dialogBuilderPasswordReset(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text('Set a new password'),
          titleTextStyle: GoogleFonts.raleway(
            fontSize: 16,
            color: blueColor,
          ),
          content: const Text("A letter to reset your password has been sent to your email. Provide a new password and sign in."),
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
                        0.085,
                    decoration: buttonActiveDecoration,
                    child: TextButton(
                        child: Text(
                          'Get it',
                          style: textActiveButtonStyle,
                        ),
                        onPressed: () async {
                          optionRefugee = false;
                          Navigator.of(context, rootNavigator: true).pushReplacement(
                              MaterialPageRoute(builder: (context) => Wrapper()));
                          // Navigator.of(context).pop();
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

          ],
        );
      },
    );
  }
}

