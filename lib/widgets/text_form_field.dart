import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wol_pro_1/constants.dart';
import 'package:wol_pro_1/screens/intro_screen/option.dart';
import 'package:wol_pro_1/screens/register_login/refugee/register/register_refugee.dart';
import 'package:wol_pro_1/screens/register_login/refugee/login/sign_in_refugee.dart';
import 'package:wol_pro_1/screens/register_login/volunteer/register/register_volunteer_1.dart';
import 'package:wol_pro_1/screens/register_login/volunteer/login/sign_in_volunteer.dart';

bool errorEmpty = false;
bool emailErrorSignInRef = false;
bool emailErrorSignInVol = false;
bool passwordErrorSignInRef = false;
bool passwordErrorSignInVol = false;

// String errorTxt = "";

class CustomTextFormField extends StatefulWidget {
  final String customHintText;
  final String customErrorText;
  bool hide;

  CustomTextFormField(
      {Key? key,
      required this.customHintText,
      required this.customErrorText,
      required this.hide})
      : super(key: key);

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool passwordVisible = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.customHintText == "Email"
          ? optionRefugee
              ? controllerTextFieldEmailRef
              : controllerTextFieldEmailVol
          : optionRefugee
              ? controllerTextFieldPasswordRef
              : controllerTextFieldPasswordVol,
      obscureText: widget.hide == true ? true : false,
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
        errorStyle: const TextStyle(color: Colors.red),
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
        labelText: widget.customHintText,
        labelStyle: GoogleFonts.raleway(
          fontSize: 16,
          color: Colors.black.withOpacity(0.7),
        ),
        // hintText: widget.customHintText,
        suffixIcon: widget.customHintText == "Password"
            ? IconButton(
                icon: Icon(
                  // Based on passwordVisible state choose the icon
                  passwordVisible ? Icons.visibility : Icons.visibility_off,
                  color: const Color.fromRGBO(2, 62, 99, 20),
                ),
                onPressed: () {
                  // Update the state i.e. toogle the state of passwordVisible variable
                  setState(() {
                    widget.hide = passwordVisible;
                    passwordVisible = !passwordVisible;
                  });
                },
              )
            : null,
      ),
      validator: (val) => val!.isEmpty ? widget.customErrorText : null,
      onChanged: (val) {
        if (widget.customHintText == "Email") {
          if (!val.contains("@gmail.com")) {
            setState(() {
              emailErrorSignInVol = true;
            });
          } else {
            setState(() {
              emailErrorSignInVol = false;
            });
            emailVolLog = val;
          }
          // emailVolLog = val;
        } else if (widget.customHintText == "Password") {
          if (val.length <= 8) {
            setState(() {
              passwordErrorSignInVol = true;
            });
          } else {
            setState(() {
              passwordErrorSignInVol = false;
            });
            passwordVolLog = val;
          }
          // passwordVolLog = val;
        }
      },
    );
  }
}

class CustomTextFormFieldRefugee extends StatefulWidget {
  final String customHintText;
  final String customErrorText;
  bool hide;

  CustomTextFormFieldRefugee(
      {Key? key,
      required this.customHintText,
      required this.customErrorText,
      required this.hide})
      : super(key: key);

  @override
  State<CustomTextFormFieldRefugee> createState() =>
      _CustomTextFormFieldRefugeeState();
}

class _CustomTextFormFieldRefugeeState
    extends State<CustomTextFormFieldRefugee> {
  bool passwordVisible = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.customHintText == "Email"
          ? optionRefugee
              ? controllerTextFieldEmailRef
              : controllerTextFieldEmailVol
          : optionRefugee
              ? controllerTextFieldPasswordRef
              : controllerTextFieldPasswordVol,
      obscureText: widget.hide == true ? true : false,
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
        errorStyle: const TextStyle(color: Colors.red),
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
        labelText: widget.customHintText,
        labelStyle: GoogleFonts.raleway(
          fontSize: 16,
          color: Colors.black.withOpacity(0.7),
        ),
        // hintText: widget.customHintText,
        suffixIcon: widget.customHintText == "Password"
            ? IconButton(
                icon: Icon(
                  // Based on passwordVisible state choose the icon
                  passwordVisible ? Icons.visibility : Icons.visibility_off,
                  color: redColor,
                ),
                onPressed: () {
                  // Update the state i.e. toogle the state of passwordVisible variable
                  setState(() {
                    widget.hide = passwordVisible;
                    passwordVisible = !passwordVisible;
                  });
                },
              )
            : null,
      ),
      validator: (val) => val!.isEmpty ? widget.customErrorText : null,
      onChanged: (val) {
        setState(() {
          if (widget.customHintText == "Email") {
            if (optionRefugee) {
              if (!val.contains("@gmail.com")) {
                setState(() {
                  emailErrorSignInRef = true;
                });
              } else {
                setState(() {
                  emailErrorSignInRef = false;
                });
                emailRefLog = val;
              }
            } else {
              emailVolLog = val;
            }
          } else if (widget.customHintText == "Password") {
            if (optionRefugee) {
              if (val.length <= 8) {
                setState(() {
                  passwordErrorSignInRef = true;
                });
              } else {
                setState(() {
                  passwordErrorSignInRef = false;
                });
                passwordRefLog = val;
              }
            } else {
              passwordVolLog = val;
            }
          }
        });
        // setState(() => email = val);
      },
    );
  }
}

String emailRegisterVol = '';
String passwordRegisterVol = '';
String emailRegisterRef = '';
String passwordRegisterRef = '';
bool errorEmptyRegister = false;

class CustomTextFormFieldRegister extends StatefulWidget {
  final String customHintText;
  final String customErrorText;
  bool hide;

  // final Function() setData;

  CustomTextFormFieldRegister(
      {Key? key,
      required this.customHintText,
      required this.customErrorText,
      required this.hide})
      : super(key: key);

  @override
  State<CustomTextFormFieldRegister> createState() =>
      _CustomTextFormFieldRegisterState();
}

class _CustomTextFormFieldRegisterState
    extends State<CustomTextFormFieldRegister> {
  bool passwordVisible = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.customHintText == "Name"
          ? controllerTextFieldNameVol
          : widget.customHintText == "Phone number"
              ? controllerTextFieldPhoneNumberVol
              : widget.customHintText == "Email"
                  ? controllerTextFieldEmailVolRegistration
                  : widget.customHintText == "Password"
                      ? controllerTextFieldPasswordVolRegistration
                      : null,
      obscureText: widget.hide == true ? true : false,
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
        errorStyle: const TextStyle(color: Colors.red),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: Colors.black.withOpacity(0.7),
            // color: Color.fromRGBO(2, 62, 99, 20),
            width: 1.5,
          ),
        ),
        labelText: widget.customHintText,
        labelStyle: GoogleFonts.raleway(
          fontSize: 16,
          color: Colors.black.withOpacity(0.7),
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
        suffixIcon: widget.customHintText == "Password"
            ? IconButton(
                icon: Icon(
                  // Based on passwordVisible state choose the icon
                  passwordVisible ? Icons.visibility : Icons.visibility_off,
                  color: const Color.fromRGBO(2, 62, 99, 20),
                ),
                onPressed: () {
                  // Update the state i.e. toogle the state of passwordVisible variable
                  setState(() {
                    widget.hide = passwordVisible;
                    passwordVisible = !passwordVisible;
                  });
                },
              )
            : null,
      ),
      validator: (val) => val!.isEmpty ? widget.customErrorText : null,
      onChanged: (val) {
        setState(() {
          // userNameVol = val;

          if (widget.customHintText == "Name") {
            if (val.contains(RegExp(r'[0-9]')) ||
                val.contains(RegExp(r'[#?!@$%^&*-]'))) {
              setState(() {
                nameVol = true;
              });
            } else {
              setState(() {
                nameVol = false;
              });
              userName = val;
              // userNameVol = val;
            }
          } else if (widget.customHintText == "Phone number") {
            if (val.contains(RegExp(r'[A-Z]')) ||
                val.contains(RegExp(r'[a-z]')) ||
                val.contains(RegExp(r'[#?!@$%^&*-]'))) {
              setState(() {
                phoneVol = true;
              });
            } else {
              if (val.length == 9) {
                setState(() {
                  phoneVol = false;
                });
                phoneNumber = val;
              } else {
                setState(() {
                  phoneLengthVol = true;
                  phoneVol = true;
                });
              }
              // userNameRef = val;
            }

            // phoneNumberRef = val;
          } else if (widget.customHintText == "Email") {
            if (!val.contains("@gmail.com")) {
              setState(() {
                emailVol = true;
              });
            } else {
              setState(() {
                emailVol = false;
              });
              emailRegisterVol = val;
            }
          } else if (widget.customHintText == "Password") {
            if (val.length <= 8) {
              setState(() {
                passwordVol = true;
              });
            } else {
              setState(() {
                passwordVol = false;
              });
              passwordRegisterVol = val;
            }
          }
        });
      },
    );
  }
}

class CustomTextFormFieldRegisterRef extends StatefulWidget {
  final String customHintText;
  final String customErrorText;
  bool hide;

  // final Function() setData;

  CustomTextFormFieldRegisterRef(
      {Key? key,
      required this.customHintText,
      required this.customErrorText,
      required this.hide})
      : super(key: key);

  @override
  State<CustomTextFormFieldRegisterRef> createState() =>
      _CustomTextFormFieldRegisterRefState();
}

class _CustomTextFormFieldRegisterRefState
    extends State<CustomTextFormFieldRegisterRef> {
  bool passwordVisible = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.customHintText == "Name"
          ? controllerTextFieldNameRef
          : widget.customHintText == "Phone number"
              ? controllerTextFieldPhoneNumberRef
              : widget.customHintText == "Email"
                  ? controllerTextFieldEmailRefRegistration
                  : widget.customHintText == "Password"
                      ? controllerTextFieldPasswordRefRegistration
                      : null,
      obscureText: widget.hide == true ? true : false,
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
        errorStyle: const TextStyle(color: Colors.red),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: redColor.withOpacity(0.7),
            // color: Color.fromRGBO(2, 62, 99, 20),
            width: 1.5,
          ),
        ),
        labelText: widget.customHintText,
        labelStyle: GoogleFonts.raleway(
          fontSize: 16,
          color: Colors.black.withOpacity(0.7),
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
        suffixIcon: widget.customHintText == "Password"
            ? IconButton(
                icon: Icon(
                  // Based on passwordVisible state choose the icon
                  passwordVisible ? Icons.visibility : Icons.visibility_off,
                  color: redColor,
                ),
                onPressed: () {
                  // Update the state i.e. toogle the state of passwordVisible variable
                  setState(() {
                    widget.hide = passwordVisible;
                    passwordVisible = !passwordVisible;
                  });
                },
              )
            : null,
      ),
      validator: (val) => val!.isEmpty ? widget.customErrorText : null,
      onChanged: (val) {
        setState(() {
          if (widget.customHintText == "Name") {
            if (val.contains(RegExp(r'[0-9]')) ||
                val.contains(RegExp(r'[#?!@$%^&*-]'))) {
              setState(() {
                nameRef = true;
              });
            } else {
              setState(() {
                nameRef = false;

                userNameRef = val;
              });
            }
          } else if (widget.customHintText == "Phone number") {
            if (val.contains(RegExp(r'[A-Z]')) ||
                val.contains(RegExp(r'[a-z]')) ||
                val.contains(RegExp(r'[#?!@$%^&*-]'))) {
              setState(() {
                phoneRef = true;
              });
            } else {
              if (val.length == 9) {
                setState(() {
                  phoneRef = false;
                });
                phoneNumberRef = val;
              } else {
                setState(() {
                  phoneLength = true;
                  phoneRef = true;
                });
              }
              // userNameRef = val;
            }

            // phoneNumberRef = val;
          } else if (widget.customHintText == "Email") {
            if (!val.contains("@gmail.com")) {
              setState(() {
                emailRef = true;
              });
            } else {
              setState(() {
                emailRef = false;
              });
              emailRegisterRef = val;
            }
          } else if (widget.customHintText == "Password") {
            if (val.length <= 8) {
              setState(() {
                passwordRef = true;
              });
            } else {
              setState(() {
                passwordRef = false;
              });
              passwordRegisterRef = val;
            }
          }
        });
      },
    );
  }
}
