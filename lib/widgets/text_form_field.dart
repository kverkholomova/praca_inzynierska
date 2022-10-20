import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wol_pro_1/screens/intro_screen/option.dart';
import 'package:wol_pro_1/screens/register_login/refugee/sign_in_refugee.dart';
import 'package:wol_pro_1/screens/register_login/volunteer/register_volunteer_1.dart';
import 'package:wol_pro_1/screens/register_login/volunteer/sign_in_volunteer.dart';

bool errorEmpty = false;

class CustomTextFormField extends StatefulWidget {
  final String customHintText;
  final String customErrorText;
  bool hide;

  CustomTextFormField({Key? key, required this.customHintText, required this.customErrorText, required this.hide})
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
            ?optionRefugee
            ?controllerTextFieldEmailRef
            :controllerTextFieldEmailVol
            :optionRefugee
            ?controllerTextFieldPasswordRef
            :controllerTextFieldPasswordVol,
        obscureText: widget.hide ==true?true:false,
        decoration: InputDecoration(
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24.0),
              borderSide: const BorderSide(
                color: Colors.red,
                width: 1.5,
              ),
            ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24.0),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 1.5,
            ),
          ),
          errorStyle: const TextStyle(
            color: Colors.red
          ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24.0),
              borderSide: BorderSide(
                color: Colors.black.withOpacity(0.7),
                width: 1.5,
              ),
            ),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24.0),
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
          suffixIcon: widget.customHintText=="Password"?IconButton(
            icon: Icon(
              // Based on passwordVisible state choose the icon
              passwordVisible
                  ? Icons.visibility
                  : Icons.visibility_off,
              color: const Color.fromRGBO(2, 62, 99, 20),
            ),
            onPressed: () {
              // Update the state i.e. toogle the state of passwordVisible variable
              setState(() {
                widget.hide = passwordVisible;
                passwordVisible = !passwordVisible;
              });
            },
          ):null,
        ),
        validator: (val) =>val!.isEmpty ? widget.customErrorText : null,
        // onChanged: (val) {
        //   // setState(() => email = val);
        // },

      );
  }
}


String emailRegisterVol = '';
String passwordRegisterVol = '';
bool errorEmptyRegister = false;


class CustomTextFormFieldRegister extends StatefulWidget {
  final String customHintText;
  final String customErrorText;
  bool hide;
  // final Function() setData;
  String setData;


  CustomTextFormFieldRegister({Key? key, required this.customHintText, required this.customErrorText, required this.hide, required this.setData})
      : super(key: key);

  @override
  State<CustomTextFormFieldRegister> createState() => _CustomTextFormFieldRegisterState();
}

class _CustomTextFormFieldRegisterState extends State<CustomTextFormFieldRegister> {
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
          ?controllerTextFieldNameVol
          : widget.customHintText == "Phone number"
          ?controllerTextFieldPhoneNumberVol
          : widget.customHintText == "Email"
          ?controllerTextFieldEmailVolRegistration
          :widget.customHintText == "Password"
          ?controllerTextFieldPasswordVolRegistration
          :null,
      obscureText: widget.hide ==true?true:false,
      decoration: InputDecoration(
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24.0),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24.0),
          borderSide: const BorderSide(
            color: Colors.red,
            width: 1.5,
          ),
        ),
        errorStyle: const TextStyle(
            color: Colors.red
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24.0),
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
          borderRadius: BorderRadius.circular(24.0),
          borderSide: const BorderSide(
            color: Colors.white,
            width: 0,
          ),
        ),
        filled: true,
        fillColor: Colors.white,
        // hintStyle: GoogleFonts.raleway(
        //   fontSize: 16,
        //   color: Colors.black.withOpacity(0.5),
        // ),
        // hintText: widget.customHintText,
        suffixIcon: widget.customHintText=="Password"?IconButton(
          icon: Icon(
            // Based on passwordVisible state choose the icon
            passwordVisible
                ? Icons.visibility
                : Icons.visibility_off,
            color: const Color.fromRGBO(2, 62, 99, 20),
          ),
          onPressed: () {
            // Update the state i.e. toogle the state of passwordVisible variable
            setState(() {
              widget.hide = passwordVisible;
              passwordVisible = !passwordVisible;
            });
          },
        ):null,
      ),
      validator: (val) =>val!.isEmpty ? widget.customErrorText : null,
      onChanged: (val) {
        setState(() {
          widget.setData = val;
        });
      },
    );
  }
}
