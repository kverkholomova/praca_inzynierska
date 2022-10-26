import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:wol_pro_1/models/users_all.dart';
import 'package:wol_pro_1/screens_not_used_yet/home/user_tile.dart';


class UserList extends StatefulWidget {

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  Widget build(BuildContext context) {

    final usersAll=Provider.of<List<AllUsers>?>(context)??[];
  
     return ListView.builder(
        itemCount: usersAll.length,
        itemBuilder: (BuildContext context,int index){
          return UserTile(
              current_user: usersAll[index],
          );
        },
    );
  }
}
