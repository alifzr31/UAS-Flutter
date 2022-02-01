import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uas_flutter/main.dart';

class Add extends StatefulWidget {
  const Add({Key? key}) : super(key: key);

  @override
  _AddState createState() => _AddState();
}

class _AddState extends State<Add> {
  TextEditingController _judulController = TextEditingController();
  TextEditingController _kontenController = TextEditingController();
  TextEditingController _image = TextEditingController();
  CollectionReference _beritaCollection =
      FirebaseFirestore.instance.collection('berita');

  Future<void> add([DocumentSnapshot? documentSnapshot]) async {
    final String? varjudul = _judulController.text;
    final String? varkonten = _kontenController.text;
    final String? varimage = _image.text;

    await _beritaCollection
        .add({"judul": varjudul, "konten": varkonten, "img": varimage});
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
          title: new Text("Tambah Data Berita"),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _judulController,
                minLines: 1,
                maxLines: 2,
                decoration: InputDecoration(labelText: "Judul"),
              ),
              TextField(
                controller: _kontenController,
                minLines: 1,
                maxLines: 20,
                decoration: InputDecoration(labelText: "Konten"),
              ),
              TextField(
                controller: _image,
                minLines: 1,
                maxLines: 2,
                decoration: InputDecoration(labelText: "Gambar (URL)"),
              ),
              SizedBox(height: 20),
              MaterialButton(
                  child: new Text("Tambah Data"),
                  color: Colors.blueAccent,
                  onPressed: () => add()),
            ],
          ),
        ),
      ),
    );
  }
}
