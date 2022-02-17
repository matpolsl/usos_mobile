import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:oauth1/oauth1.dart' as oauth1;

import 'package:usos/widgets/login.dart';
import 'package:usos/widgets/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'models/user_data.dart';
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
      home: const HomePage(),
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

  late UserData _name;
  oauth1.Client? _client;
  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );
  final storage = const FlutterSecureStorage();

  Future load() async {
    //await storage.write(key: "token", value: null);
    String? _tokenStroage = await storage.read(key: "oauth_token");
    String? _tokenSecretStroage = await storage.read(key: "oauth_token_secret");
    if (_tokenStroage != null && _tokenSecretStroage != null) {
      final credit = oauth1.Credentials(_tokenStroage, _tokenSecretStroage);
      final client =
          oauth1.Client(platform.signatureMethod, clientCredentials, credit);
      client.get(Uri.parse(usosApi + 'services/users/user')).then((res) async {
        try {
          final name = UserData.fromJson(jsonDecode(res.body));
          _setStatus(client, name);
        } catch (e) {
          await storage.delete(
            key: "oauth_token",
          );
          await storage.delete(
            key: "oauth_token_secret",
          );
        }
      });
    }
  }

  _setStatus(client, name) {
    setState(() {
      _client = client;
      _name = name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _client == null ? Login(_setStatus, storage) : User(_client!, _name);
  }
}
