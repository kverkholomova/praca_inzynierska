import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

EdgeInsetsGeometry padding = const EdgeInsets.symmetric(horizontal: 30);

BoxDecoration buttonDecoration = BoxDecoration(
    color: const Color.fromRGBO(2, 62, 99, 20),
    borderRadius: BorderRadius.circular(24)
);

TextStyle textButtonStyle = GoogleFonts.raleway(
  fontSize: 22,
  color: Colors.white,
);

Color blueColor = const Color.fromRGBO(2, 62, 99, 20);

Color background = const Color.fromRGBO(233, 242, 253, 8);

BoxDecoration categoryDecoration = BoxDecoration(

  color: Colors.white,
  borderRadius: const BorderRadius.all(
    Radius.circular(24),
  ),
);

TextStyle textCategoryStyle = GoogleFonts.raleway(
  fontSize: 18,
  color: Colors.black,
);
