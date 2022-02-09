import 'package:flutter/material.dart';
import 'package:usos/models/user_data.dart';

import '../models/programme.dart';

class Menu extends StatelessWidget {
  late UserData nameUser;
  List<Programme> programmes;
  late Function setProg;
  Menu(this.nameUser, this.programmes, this.setProg, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: [
        Container(
          height: 150,
          child: DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.indigo,
            ),
            child: Container(
              alignment: Alignment.bottomLeft,
              height: 10,
              child: Text(
                "${nameUser.firstName} ${nameUser.lastName}",
                style: const TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemBuilder: (ctx, index) => ListTile(
            title: Text(programmes[index].name),
            onTap: () {
              setProg(index);
              Navigator.pop(context);
            },
          ),
          itemCount: programmes.length,
        ),
      ],
    ));
  }
}
