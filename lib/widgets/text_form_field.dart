import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wol_pro_1/screens/register_login/volunteer/sign_in_volunteer.dart';

bool errorEmpty = false;


class CustomTextFormField extends StatefulWidget {
  final String customHintText;
  final String customErrorText;
  final bool hide;

  const CustomTextFormField({Key? key, required this.customHintText, required this.customErrorText, required this.hide})
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
    return
      // height: MediaQuery.of(context).size.height * 0.085,
      TextFormField(
        controller: controllerTextField,
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
              borderSide: const BorderSide(
                color: Color.fromRGBO(2, 62, 99, 20),
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
            hintText: widget.customHintText,
          suffixIcon: widget.hide==true?IconButton(
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
