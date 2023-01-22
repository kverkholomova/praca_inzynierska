import 'package:flutter/material.dart';

List<String> categoriesListAll = [
  "Your categories",
  "Accommodation",
  "Transfer",
  "Animal assistance",
  "Grocery assistance",
  "Assistance with children",
  "Language assistance",
  "Law consult",
  "Medical assistance",
  // "Other"
];

List<String> categoriesListAllRefugee = [
  "Accommodation",
  "Transfer",
  "Animal assistance",
  "Grocery assistance",
  "Assistance with children",
  "Language assistance",
  "Law consult",
  "Medical assistance",
  // "Other"
];

List dropdownItemList = [
  {
    'icon': Icon(
      Icons.house,
    ),
    'label': categoriesListAll[1],
    'value': categoriesListAll[1],

  }, // label is required and unique
  {
    'label': categoriesListAll[2],
    'value': categoriesListAll[2],
    'icon': Icon(Icons.emoji_transportation_rounded)

  },
  {
    'label': categoriesListAll[3],
    'value': categoriesListAll[3],
    'icon': Icon(
      Icons.pets_rounded,
    )
  },
  {
    'label': categoriesListAll[4],
    'value': categoriesListAll[4],
    'icon': Icon(Icons.local_grocery_store)
  },
  {
    'label': categoriesListAll[5],
    'value': categoriesListAll[5],
    'icon': Icon(
      Icons.child_care_outlined,
    )
  },
  {
    'label': categoriesListAll[6],
    'value': categoriesListAll[6],
    'icon': Icon(
      Icons.sign_language_rounded,
    )
  },
  {
    'label': categoriesListAll[7],
    'value': categoriesListAll[7],
    'icon': Icon(
      Icons.menu_book,
    )
  },
  {
    'label': categoriesListAll[8],
    'value': categoriesListAll[8],
    'icon': Icon(
      Icons.medical_information_outlined,
    )
  },
];