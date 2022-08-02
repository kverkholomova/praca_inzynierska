import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wol_pro_1/screens/option.dart';
import 'package:wol_pro_1/services/auth.dart';

import 'models/user.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<Users?>.value(
      value: AuthService().user,
      initialData: null,
      child: const MaterialApp(
        home: OptionChoose(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

