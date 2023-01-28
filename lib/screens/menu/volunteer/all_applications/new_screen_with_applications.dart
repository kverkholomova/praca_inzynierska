import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wol_pro_1/screens/menu/volunteer/all_applications/your_app_vol.dart';

import '../../../../constants.dart';
import '../../../../models/categories.dart';
import '../home_page/home_vol.dart';
import 'chosen_category_applications.dart';

String chosenCategoryVolApp = '';
String? cardTitleVol = '';
String? cardCategoryVol = '';
String? cardCommentVol = '';

class Categories extends StatefulWidget {
  const Categories({Key? key}) : super(key: key);

  @override
  State createState() => CategoriesState();
}

class CategoriesState extends State<Categories> {
  FirebaseFirestore db = FirebaseFirestore.instance;

  bool loading = false;
  final CollectionReference applications =
      FirebaseFirestore.instance.collection("applications");

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomeVol()),
        );
        return true;
      },
      child: Scaffold(
        backgroundColor: background,
        body: Stack(
          children: [
            ClipPath(
              clipper: OvalBottomBorderClipper(),
              child: Container(
                decoration: BoxDecoration(
                  color: blueColor,
                  boxShadow: const <BoxShadow>[
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 5,
                    ),
                  ],
                ),
                height: MediaQuery.of(context).size.height * 0.15,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Align(
                      alignment: Alignment.center,
                      child: Column(
                        children: [
                          Text(
                            "All applications",
                            style: GoogleFonts.raleway(
                              fontSize: 24,
                              color: Colors.white,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              "Choose application",
                              style: GoogleFonts.raleway(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      )),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.17,
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: padding,
                  child: Column(
                    children: [
                      CategoryWidget(
                        text: categoriesListAll[0],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.012,
                      ),
                      CategoryWidget(
                        text: categoriesListAll[1],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.012,
                      ),
                      CategoryWidget(
                        text: categoriesListAll[2],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.012,
                      ),
                      CategoryWidget(
                        text: categoriesListAll[3],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.012,
                      ),
                      CategoryWidget(
                        text: categoriesListAll[4],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.012,
                      ),
                      CategoryWidget(
                        text: categoriesListAll[5],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.012,
                      ),
                      CategoryWidget(
                        text: categoriesListAll[6],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.012,
                      ),
                      CategoryWidget(
                        text: categoriesListAll[7],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.012,
                      ),
                      CategoryWidget(
                        text: categoriesListAll[8],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.012,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryWidget extends StatefulWidget {
  final String text;

  const CategoryWidget({Key? key, required this.text}) : super(key: key);

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.text == categoriesListAll[0]) {
          Navigator.of(context, rootNavigator: true).pushReplacement(
              MaterialPageRoute(builder: (context) => const YourCategories()));
        } else {
          setState(() {
            chosenCategoryVolApp = widget.text;
          });
          Future.delayed(const Duration(milliseconds: 500), () {
            Navigator.of(context, rootNavigator: true).pushReplacement(
                MaterialPageRoute(
                    builder: (context) => const ChosenCategory()));
          });
        }
      },
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.085,
        decoration: categoryDecoration,
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.05,
                right: MediaQuery.of(context).size.width * 0.04,
              ),
              child: Icon(
                widget.text == categoriesListAll[3]
                    ? Icons.pets_rounded
                    : widget.text == categoriesListAll[4]
                        ? Icons.local_grocery_store
                        : widget.text == categoriesListAll[2]
                            ? Icons.emoji_transportation_rounded
                            : widget.text == categoriesListAll[1]
                                ? Icons.house
                                : widget.text == categoriesListAll[6]
                                    ? Icons.sign_language_rounded
                                    : widget.text == categoriesListAll[5]
                                        ? Icons.child_care_outlined
                                        : widget.text == categoriesListAll[7]
                                            ? Icons.menu_book
                                            : widget.text ==
                                                    categoriesListAll[8]
                                                ? Icons
                                                    .medical_information_outlined
                                                : widget.text ==
                                                        categoriesListAll[0]
                                                    ? Icons.check_box
                                                    : Icons.new_label_sharp,
                size: 30,
                color: Colors.black,
              ),
            ),
            Text(
              widget.text,
              style: textCategoryStyle,
            ),
          ],
        ),
      ),
    );
  }
}
