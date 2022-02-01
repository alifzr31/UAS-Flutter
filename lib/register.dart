import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uas_flutter/main.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController _userController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  CollectionReference _adminCollection =
      FirebaseFirestore.instance.collection('admin');

  Future<void> add([DocumentSnapshot? documentSnapshot]) async {
    final String? varuser = _userController.text;
    final String? varpwd = _passwordController.text;
    await _adminCollection.add({"user": varuser, "pwd": varpwd});
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => new MyApp()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: new Text("Register"),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _userController,
                minLines: 1,
                maxLines: 2,
                decoration: InputDecoration(labelText: "User"),
              ),
              TextField(
                controller: _passwordController,
                minLines: 1,
                maxLines: 20,
                decoration: InputDecoration(labelText: "Password"),
              ),
              SizedBox(height: 20),
              MaterialButton(
                  child: new Text("Register"),
                  color: Colors.blueAccent,
                  onPressed: () => add()),
            ],
          ),
        ),
      ),
    );
  }
}
