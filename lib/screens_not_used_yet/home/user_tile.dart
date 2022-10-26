import 'package:flutter/material.dart';
import 'package:wol_pro_1/models/users_all.dart';


class UserTile extends StatelessWidget {

  final AllUsers current_user;
  const UserTile({ required this.current_user});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top:8),
      child: Card(
        margin: const EdgeInsets.fromLTRB(20, 6, 20, 0),
        child: ListTile(
          leading: const CircleAvatar(
            radius: 25,
            backgroundColor: Colors.cyan,
          ),
          title: Text(current_user.name),
          subtitle: Text(current_user.role.toString()),
        ),
      ),
    
    );
  }
}
