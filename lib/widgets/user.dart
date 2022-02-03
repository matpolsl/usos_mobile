import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:oauth1/oauth1.dart' as oauth1;
import 'package:usos/models/user_data.dart';

import 'package:usos/usos.dart';
import 'login.dart';

class User extends StatefulWidget {
  User(this.client, {Key? key}) : super(key: key);
  late oauth1.Client client;
  @override
  _UserState createState() => _UserState(client);
}

class _UserState extends State<User> {
  late oauth1.Client client;
  late Future<UserData> nameUser;
  _UserState(this.client);

  @override
  void initState() {
    super.initState();
    nameUser = fetchName();
  }

  Future<UserData> fetchName() async {
    return client.get(Uri.parse(usosApi + 'services/users/user')).then((res) {
      return UserData.fromJson(jsonDecode(res.body));
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserData>(
      future: nameUser,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(snapshot.data!.firstName + " " + snapshot.data!.lastName);
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        // By default, show a loading spinner.
        return const CircularProgressIndicator();
      },
    );
  }
}
