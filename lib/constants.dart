import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

EdgeInsetsGeometry padding = const EdgeInsets.symmetric(horizontal: 20);

BoxDecoration buttonActiveDecoration = BoxDecoration(
    color: blueColor,
    borderRadius: BorderRadius.circular(15)
);

TextStyle textActiveButtonStyle = GoogleFonts.raleway(
  fontSize: 18,
  color: Colors.white,
);

BoxDecoration buttonActiveDecorationRefugee = BoxDecoration(
    color: redColor,
    borderRadius: BorderRadius.circular(15)
);

TextStyle textActiveButtonStyleRefugee = GoogleFonts.raleway(
  fontSize: 18,
  color: Colors.white,
);

BoxDecoration buttonInactiveDecoration = BoxDecoration(
    color: Colors.white,
    border: Border.all(
      color: blueColor
    ),
    borderRadius: BorderRadius.circular(15)
);

TextStyle textInactiveButtonStyle = GoogleFonts.raleway(
  fontSize: 18,
  color: blueColor,
);

BoxDecoration buttonInactiveDecorationRefugee = BoxDecoration(
    color: Colors.white,
    border: Border.all(
        color: redColor
    ),
    borderRadius: BorderRadius.circular(15)
);

TextStyle textInactiveButtonStyleRefugee = GoogleFonts.raleway(
  fontSize: 18,
  color: redColor,
);

Color redColor = Color.fromRGBO(238, 117, 117, 8);

Color backgroundRefugee = Color.fromRGBO(255, 247, 247, 8);

Color blueColor = const Color.fromRGBO(2, 62, 99, 20);

Color background = const Color.fromRGBO(233, 242, 253, 8);

BoxDecoration categoryDecoration = BoxDecoration(

  color: Colors.white,
  borderRadius: const BorderRadius.all(
    Radius.circular(18),
  ),
);

TextStyle textCategoryStyle = GoogleFonts.raleway(
  fontSize: 14,
  color: Colors.black,
);

TextStyle textLabelSeparated = GoogleFonts.raleway(
  fontSize: 12,
  color: Colors.black,
);

TextStyle hintStyleText = GoogleFonts.raleway(
  fontSize: 14,
  color: Colors.black.withOpacity(0.5),
);

BorderRadius borderRadiusApplication = BorderRadius.circular(15);



// class Validator {
//   static String? validateEmail(String value) {
//     Pattern pattern = r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+';
//     RegExp regex = RegExp(pattern as String);
//     if (!regex.hasMatch(value)) {
//       return '🚩 Please enter a valid email address.';
//     } else {
//       return null;
//     }
//   }
//
//   static String? validatePassword(String value) {
//     if (value.length != 6) {
//       return '🚩 Password must be 6 digits';
//     } else {
//       return null;
//     }
//   }
//
//   static String? fullNameValidate(String fullName) {
//     String patttern = r'^[a-z A-Z,.\-]+$';
//     RegExp regExp = RegExp(patttern);
//     if (fullName.isEmpty) {
//       return 'Please enter full name';
//     } else if (!regExp.hasMatch(fullName)) {
//       return 'Please enter valid full name';
//     }
//     return null;
//   }
// }
//
// class CustomTextField extends StatelessWidget {
//   final TextInputType? keyboardType;
//   final bool obscureText;
//   final String? hintText;
//   final String? Function(String?)? validator;
//   final TextEditingController? controller;
//   final TextCapitalization textCapitalization;
//   final int? maxLength;
//
//   const CustomTextField({
//     Key? key,
//     this.keyboardType,
//     this.hintText,
//     this.obscureText = false,
//     this.validator,
//     this.maxLength = 30,
//     this.controller,
//     required this.textCapitalization
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       keyboardType: keyboardType,
//       obscureText: obscureText,
//       controller: controller,
//       autocorrect: false,
//       textCapitalization: textCapitalization,
//       // validator: validator,
//       // inputFormatters: [
//       //   LengthLimitingTextInputFormatter(maxLength),
//       // ],
//       decoration: InputDecoration(
//         hintText: hintText,
//         hintStyle: const TextStyle(color: Color(0xFF666666), fontSize: 13),
//         filled: true,
//         fillColor: const Color(0x99E4E4E4),
//         enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(5),
//             borderSide: const BorderSide(color: Color(0xFFE4E4E4), width: 1)),
//         focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(5),
//             borderSide: const BorderSide(color: Color(0xFFE4E4E4), width: 1)),
//       ),
//     );
//   }
// }
//
// class CustomButton extends StatelessWidget {
//   final String label;
//   final Color color;
//   final VoidCallback onPressed;
//   final Color textColor;
//   final BorderSide borderSide;
//   final Size size;
//   const CustomButton({
//     Key? key,
//     required this.label,
//     required this.color,
//     required this.onPressed,
//     required this.size,
//     required this.textColor,
//     required this.borderSide,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: size.width,
//       child: TextButton(
//         onPressed: onPressed,
//         style: TextButton.styleFrom(
//             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
//             backgroundColor: color,
//             side: borderSide,
//             // elevation: 1.5,
//             shadowColor: const Color(0xFF323247)
//         ),
//         child: Text(
//           label,
//           style: TextStyle(
//             fontSize: 15,
//             color: textColor,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//     );
//   }
// }