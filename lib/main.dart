import 'package:flutter/material.dart';
import 'dart:io';
import 'package:oauth1/oauth1.dart' as oauth1;

import 'package:usos/widgets/login.dart';
import 'package:usos/widgets/user.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Text('USOS PŚ'),
          ),
          body: HomePage()),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _status = true;
  late oauth1.Client _client;
  _setStatus(status, client) {
    setState(() {
      _status = status;
      _client = client;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _status //todo read token
        ? Login(_setStatus)
        : User(_client);
  }
}
