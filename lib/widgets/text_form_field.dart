import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextFormField extends StatelessWidget {
  final String customHintText;
  final String customErrorText;

  const CustomTextFormField({Key? key, required this.customHintText, required this.customErrorText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // height: MediaQuery.of(context).size.height * 0.085,
      child: TextFormField(
        decoration: InputDecoration(
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24.0),
              borderSide: BorderSide(
                color: Colors.red,
                width: 1.5,
              ),
            ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24.0),
            borderSide: BorderSide(
              color: Colors.red,
              width: 1.5,
            ),
          ),
          errorStyle: TextStyle(
            color: Colors.red
          ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(24.0),
              borderSide: BorderSide(
                color: Color.fromRGBO(2, 62, 99, 20),
                width: 1.5,
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
              fontSize: 16,
              color: Colors.black.withOpacity(0.5),
            ),
            hintText: customHintText),
        validator: (val) => val!.isEmpty ? customErrorText : null,
        // onChanged: (val) {
        //   // setState(() => email = val);
        // },
      ),
    );
  }
}
