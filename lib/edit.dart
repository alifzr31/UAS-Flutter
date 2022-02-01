import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uas_flutter/main.dart';

class Edit extends StatefulWidget {
  List list;
  int index;
  Edit({required this.index, required this.list});
  // const Edit({Key? key}) : super(key: key);

  @override
  _EditState createState() => _EditState();
}

class _EditState extends State<Edit> {
  TextEditingController _judulController = TextEditingController();
  TextEditingController _kontenController = TextEditingController();
  TextEditingController _image = TextEditingController();
  CollectionReference _beritaCollection =
      FirebaseFirestore.instance.collection('berita');

  @override
  void initState() {
    _judulController =
        new TextEditingController(text: widget.list[widget.index]['judul']);
    _kontenController =
        new TextEditingController(text: widget.list[widget.index]['konten']);
    _image = new TextEditingController(text: widget.list[widget.index]['img']);
  }

  Future<void> update([DocumentSnapshot? documentSnapshot]) async {
    final String? varjudul = _judulController.text;
    final String? varkonten = _kontenController.text;
    final String? varimage = _image.text;

    await _beritaCollection
        .doc(documentSnapshot!.id)
        .update({"judul": varjudul, "konten": varkonten, "img": varimage});
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => new MyApp()),
    );
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: new Text("Eambah Data Berita"),
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
                  child: new Text("Edit Data"),
                  color: Colors.blueAccent,
                  onPressed: () => update(widget.list[widget.index])),
            ],
          ),
        ),
      ),
    );
  }
}
