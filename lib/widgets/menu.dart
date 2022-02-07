import 'package:flutter/material.dart';
import 'package:usos/models/user_data.dart';

import '../models/programme.dart';

class Menu extends StatelessWidget {
  late UserData nameUser;
  List<Programme> programmes;
  Menu(this.nameUser, this.programmes, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(programmes[0].name);
    return Drawer(
        child: ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.indigo,
          ),
          child: Text(nameUser.firstName + " " + nameUser.lastName),
        ),
        ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemBuilder: (ctx, index) => ListTile(
            title: Text(programmes[index].name),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
          itemCount: programmes.length,
        ),
      ],
    ));
  }
}
