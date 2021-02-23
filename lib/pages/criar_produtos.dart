import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CriarProdutos extends StatefulWidget {
  final String id;
  const CriarProdutos({this.id});

  @override
  _CriarProdutosState createState() => _CriarProdutosState();
}

enum SelectSource { camera, galeria }

class _CriarProdutosState extends State<CriarProdutos> {
  File _foto;
  String urlFoto;
  bool _isInAsyncCall = false;
  num price;

  TextEditingController priceInputController;
  TextEditingController nameInputController;
  TextEditingController imageInputController;

  String id;
  final db = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  String name;
  String autor;
  String editora;
  String genre;
  String description;
  String uid;

  Future captureImage(SelectSource opcao) async {
    File image;

    opcao == SelectSource.camera
        ? image = await ImagePicker.pickImage(source: ImageSource.camera)
        : image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _foto = image;
    });
  }

  Future getImage() async {
    AlertDialog alerta = new AlertDialog(
      content: Text('Selecione de onde pegar a imagem'),
      title: Text('Selecionar imagem'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            captureImage(SelectSource.camera);
            Navigator.of(context, rootNavigator: true).pop();
          },
          child: Row(
            children: <Widget>[Text('Câmera'), Icon(Icons.camera)],
          ),
        ),
        TextButton(
          onPressed: () {
            captureImage(SelectSource.galeria);
            Navigator.of(context, rootNavigator: true).pop();
          },
          child: Row(
            children: <Widget>[Text('Galeria'), Icon(Icons.image)],
          ),
        ),
      ],
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alerta;
        });
  }

  Widget divider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: Container(
        width: 0.8,
        color: Colors.black,
      ),
    );
  }

  bool _validarlo() {
    final form = _formKey.currentState;

    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void _enviar() {
    if (_validarlo()) {
      setState(() {
        _isInAsyncCall = true;
      });

      if (_foto != null) {
        final Reference fireStoreRef =
            FirebaseStorage.instance.ref().child('produtos').child('$name.jpg');
        final UploadTask task = fireStoreRef.putFile(
            _foto, SettableMetadata(contentType: 'image/jpeg'));
        task.then((onValue) {
          onValue.ref.getDownloadURL().then((onValue) {
            setState(() {});
            urlFoto = onValue.toString();
            FirebaseFirestore.instance
                .collection('produtos')
                .add({
                  'name': name,
                  'image': urlFoto,
                  'autor': autor,
                  'editora': editora,
                  'genre': genre,
                  'description': description,
                  'price': price,
                })
                .then((value) => Navigator.of(context).pop())
                .catchError(
                    (onError) => print('Erro ao registrar seu produto bd'));
            _isInAsyncCall = false;
          });
        });
      } else {
        FirebaseFirestore.instance
            .collection('produtos')
            .add({
              'name': name,
              'image': urlFoto,
              'autor': autor,
              'editora': editora,
              'genre': genre,
              'description': description,
              'price': price,
            })
            .then((value) => Navigator.of(context).pop())
            .catchError((onError) => print('Erro ao registar seu produto 2bd'));
        _isInAsyncCall = false;
      }
    } else {
      print('Objeto não validado');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Produto'),
      ),
      body: ModalProgressHUD(
        inAsyncCall: _isInAsyncCall,
        opacity: 0.5,
        dismissible: false,
        progressIndicator: CircularProgressIndicator(),
        color: Colors.blueGrey,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(left: 10, right: 15),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      child: GestureDetector(
                        onTap: getImage,
                      ),
                      margin: EdgeInsets.only(top: 20),
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                          border: Border.all(width: 1.0, color: Colors.black),
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.fill,
                              image: _foto == null
                                  ? AssetImage('assets/images/loading.gif')
                                  : FileImage(_foto))),
                    )
                  ],
                ),
                Text('Clique para mudar a foto'),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'autor',
                    fillColor: Colors.grey[300],
                    filled: true,
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Por favor digite um autor';
                    }
                  },
                  onSaved: (value) => autor = value.trim(),
                ),
                new Divider(),
                TextFormField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'editora',
                    fillColor: Colors.grey[300],
                    filled: true,
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Por favor digite uma editora';
                    }
                  },
                  onSaved: (value) => editora = value.trim(),
                ),
                new Divider(),
                TextFormField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'título',
                    fillColor: Colors.grey[300],
                    filled: true,
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Por favor digite um título';
                    }
                  },
                  onSaved: (value) => name = value.trim(),
                ),
                new Divider(),
                TextFormField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'gênero',
                    fillColor: Colors.grey[300],
                    filled: true,
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Por favor digite um gênero';
                    }
                  },
                  onSaved: (value) => genre = value.trim(),
                ),
                new Divider(),
                TextFormField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'descrição',
                    fillColor: Colors.grey[300],
                    filled: true,
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Por favor digite uma descrição';
                    }
                  },
                  onSaved: (value) => description = value.trim(),
                ),
                new Divider(),
                TextFormField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'preço',
                    fillColor: Colors.grey[300],
                    filled: true,
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Por favor digite um preço';
                    }
                  },
                  onSaved: (value) => price = num.parse(value),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    RaisedButton(
                      onPressed: _enviar,
                      child:
                          Text('Criar', style: TextStyle(color: Colors.white)),
                      color: Colors.green,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
