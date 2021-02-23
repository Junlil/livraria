import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';

class LoginRegisterController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool success;
  String userEmail;

  void dispose() {
    nameController.dispose();
    ageController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void register() async {
    final User user = (await _auth.createUserWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    ))
        .user;
    if (user != null) {
      success = true;
      print('Registro Ok');
      Future.delayed(
        Duration(seconds: 2),
        () {
          Get.toNamed("/bookpage");
        },
      );
      userEmail = user.email;
    } else {
      success = false;
    }
  }
}

class RegisterLoginPage extends StatefulWidget {
  final String id;
  const RegisterLoginPage({this.id});

  @override
  _RegisterLoginPageState createState() => _RegisterLoginPageState();
}

enum SelectSource { camera, galeria }

class _RegisterLoginPageState extends State<RegisterLoginPage> {
  File _foto;
  String urlFoto;
  bool _isInAsyncCall = false;
  TextEditingController priceInputController;
  TextEditingController nameInputController;
  TextEditingController imageInputController;

  String id;
  final db = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();

  String name;
  num age;
  String email;
  String password;
  String uid;

  final controller = Get.put(LoginRegisterController());

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

  bool _validarlo() {
    final form = _formKey.currentState;

    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void _addUser() {
    if (_validarlo()) {
      setState(() {
        _isInAsyncCall = true;
      });

      if (name != null) {
        final Reference fireStoreRef =
            FirebaseStorage.instance.ref().child('users').child('$name.jpg');
        final UploadTask task = fireStoreRef.putFile(
            _foto, SettableMetadata(contentType: 'image/jpeg'));
        task.then((onValue) {
          onValue.ref.getDownloadURL().then((onValue) {
            setState(() {});
            urlFoto = onValue.toString();
            FirebaseFirestore.instance
                .collection('users')
                .add({
                  'name': name,
                  'image': urlFoto,
                  'age': age,
                  'email': email,
                  'password': password,
                })
                .then((value) => Navigator.of(context).pop())
                .catchError(
                    (onError) => print('Erro ao registrar seu produto bd'));
            _isInAsyncCall = false;
          });
        });
      } else {
        FirebaseFirestore.instance
            .collection('users')
            .add({
              'name': name,
              'age': age,
              'email': email,
              'password': password,
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
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return Scaffold(
      body: GetBuilder<LoginRegisterController>(
        builder: (_) {
          return Form(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                              border:
                                  Border.all(width: 1.0, color: Colors.black),
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: _foto == null
                                      ? AssetImage('assets/images/loading.gif')
                                      : FileImage(_foto))),
                        )
                      ],
                    ),
                    Text('Clique para adicionar uma foto'),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Nome'),
                      validator: (value) {
                        if (value.isEmpty) return 'Insira seu nome';
                      },
                      onSaved: (value) => name = value.trim(),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Idade'),
                      validator: (value) {
                        if (value.isEmpty) return 'Insira sua idade';
                      },
                      onSaved: (value) => age = num.parse(value),
                    ),
                    TextFormField(
                      controller: controller.emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator: (value) {
                        if (value.isEmpty) return 'Insira o email';
                      },
                      onSaved: (value) => email = value.trim(),
                    ),
                    TextFormField(
                      controller: controller.passwordController,
                      decoration: const InputDecoration(labelText: 'Senha'),
                      validator: (value) {
                        if (value.isEmpty) return 'Insira uma senha';
                      },
                      onSaved: (value) => password = value.trim(),
                      obscureText: true,
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 16.0),
                      alignment: Alignment.center,
                      child: RaisedButton(
                        child: Text('Registrar'),
                        onPressed: () async {
                          _addUser();
                          _.register();
                        },
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Text(controller.success == null
                          ? ''
                          : (controller.success
                              ? 'Sucessfully registered ' + controller.userEmail
                              : 'Registration Failed')),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
