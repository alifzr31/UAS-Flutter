import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uas_flutter/home_page.dart';
import 'package:uas_flutter/register.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);
  static String tag = 'login-page';
  static int statusLogin = 0;

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();
  CollectionReference _beritaCollection =
      FirebaseFirestore.instance.collection('admin');

  Future<void> login([DocumentSnapshot? documentSnapshot]) async {
    final String? varuser = _username.text;
    final String? varpwd = _password.text;
    var result = await _beritaCollection
        .where("pwd", isEqualTo: varpwd)
        .where("user", isEqualTo: varuser)
        .get();
    if (result.docs.length == 1) {
      Login.statusLogin = 1;
      Navigator.of(context).pushReplacementNamed(HomePage.tag);
    } else {
      var snackBar = const SnackBar(
        content: Text('Username atau Password salah!'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  void initState() {
    Future(() {
      if (Login.statusLogin == 1) {
        Navigator.of(context).pushReplacementNamed(HomePage.tag);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Login Page"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 15),
              child: TextField(
                controller: _username,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Username",
                    hintText: 'Enter Valid Username'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15.0, top: 15, bottom: 15),
              child: TextField(
                controller: _password,
                obscureText: true,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter Secure Password'),
              ),
            ),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: MaterialButton(
                onPressed: () {
                  login();
                },
                child: const Text(
                  'Login',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => new Register())),
              child: Text("Register"),
            ),
          ],
        ),
      ),
    );
  }
}
