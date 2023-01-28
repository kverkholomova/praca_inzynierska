
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wol_pro_1/screens/intro_screen/option.dart';

import 'package:wol_pro_1/services/auth.dart';
import 'package:wol_pro_1/widgets/wrapper.dart';

import 'models/user.dart';

bool isVolunteer = true;
String currentName = '';
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {
    return StreamProvider<Users?>.value(
      value: AuthService().user,
      initialData: null,
      child: MaterialApp(
        home: FirebaseAuth.instance.currentUser == null ? OptionChoose():Wrapper(),
        debugShowCheckedModeBanner: false,

      ),
    );
  }
}

