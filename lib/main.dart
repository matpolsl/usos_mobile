import 'package:flutter/material.dart';
import 'dart:io';
import 'package:oauth1/oauth1.dart' as oauth1;

import 'package:usos/widgets/login.dart';
import 'package:usos/widgets/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'usos.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Usos PŚ',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: Scaffold(
          appBar: AppBar(
            title: const Text("Usos PŚ"),
          ),
          body: const HomePage()),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    load();
  }

  var _status = true;
  late oauth1.Client _client;
  // Read value
  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );
  final storage = const FlutterSecureStorage();
  //final options = const IOSOptions(accessibility: IOSAccessibility.first_unlock);
  Future load() async {
    //await storage.write(key: "token", value: null);
    String? _tokenStroage = await storage.read(key: "oauth_token");
    String? _tokenSecretStroage = await storage.read(key: "oauth_token_secret");
    print("Token:");
    print(_tokenStroage);
    if (_tokenStroage != null && _tokenSecretStroage != null) {
      final credit = oauth1.Credentials(_tokenStroage, _tokenSecretStroage);
      final client =
          oauth1.Client(platform.signatureMethod, clientCredentials, credit);
      _setStatus(false, client);
    }
  }

  _setStatus(status, client) {
    setState(() {
      _status = status;
      _client = client;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _status //todo read token
        ? Login(_setStatus, storage)
        : User(_client);
  }
}
