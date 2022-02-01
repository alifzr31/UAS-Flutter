import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:uas_flutter/add.dart';
import 'package:uas_flutter/home_page.dart';
import 'package:uas_flutter/edit.dart';
import 'package:uas_flutter/view.dart';
import 'package:uas_flutter/login.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static String tag = 'home-page';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _kontenController = TextEditingController();
  final TextEditingController _image = TextEditingController();

  CollectionReference _beritaCollection =
      FirebaseFirestore.instance.collection('berita');
  Future<void> _createOrUpdate([DocumentSnapshot? documentSnapshot]) async {
    String action = 'create';
    if (documentSnapshot != null) {
      action = 'update';
      _judulController.text = documentSnapshot['judul'];
      _kontenController.text = documentSnapshot['konten'];
    }
    await showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext ctx) {
          return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _judulController,
                    decoration: InputDecoration(labelText: 'Judul'),
                  ),
                  TextField(
                    controller: _kontenController,
                    decoration: InputDecoration(labelText: 'Konten'),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  ElevatedButton(
                    child: Text(action == 'create' ? 'Create' : 'Update'),
                    onPressed: () async {
                      final String? varjudul = _judulController.text;
                      final String? varkonten = _kontenController.text;
                      if (varjudul != null && varkonten != null) {
                        if (action == 'create') {
                          await _beritaCollection
                              .add({"judul": varjudul, "konten": varkonten});
                        }
                        if (action == 'update') {
                          await _beritaCollection
                              .doc(documentSnapshot!.id)
                              .update({"judul": varjudul, "konten": varkonten});
                        }

                        _judulController.text = '';
                        _kontenController.text = '';

                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ],
              ));
        });
  }

  Future<void> _deleteProduct(String productId) async {
    await _beritaCollection.doc(productId).delete();

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Data deleted')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('UAS Flutter'),
        actions: <Widget>[
          MaterialButton(
            textColor: Colors.white,
            onPressed: () {
              Login.statusLogin = 0;
              Navigator.of(context).pushReplacementNamed(Login.tag);
            },
            child: Text("Logout"),
            shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: _beritaCollection.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];
                return new Container(
                  padding: const EdgeInsets.all(10.0),
                  child: new GestureDetector(
                    onTap: () => Navigator.of(context).push(
                        new MaterialPageRoute(
                            builder: (BuildContext context) => new View(
                                list: streamSnapshot.data!.docs,
                                index: index))),
                    child: Card(
                      margin: EdgeInsets.all(10),
                      child: ListTile(
                        title: Text(documentSnapshot['judul']),
                        subtitle: Text(documentSnapshot['konten']),
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            children: [
                              IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () => Navigator.of(context)
                                          .push(new MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            new Edit(
                                                list: streamSnapshot.data!.docs,
                                                index: index),
                                      ))),
                              IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () =>
                                      _deleteProduct(documentSnapshot.id)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(new MaterialPageRoute(
            builder: (BuildContext context) => new Add())),
        child: Icon(Icons.add),
      ),
    );
  }
}
