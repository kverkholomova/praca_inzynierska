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



