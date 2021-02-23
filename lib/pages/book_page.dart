import 'package:compras/pages/admin/login_page.dart';
import 'package:compras/pages/search_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compras/pages/criar_produtos.dart';
import 'package:compras/pages/otra_pagina.dart';
import 'package:compras/pages/pedido_lista.dart';
import 'package:compras/models/producto_models.dart';
import 'package:compras/services/firebase_services.dart';
//import 'package:compras/widgets/header.dart';
import 'package:flutter/cupertino.dart';

class MyBookPage extends StatefulWidget {
  @override
  _MyBookPageState createState() => _MyBookPageState();
}

class _MyBookPageState extends State<MyBookPage> {
  final controller = Get.put(LoginController());

  List<ProdutosModelo> _produtosModelo = [];

  List<ProdutosModelo> _listaCarro = [];

  FirebaseService db = new FirebaseService();

  StreamSubscription<QuerySnapshot> productSub;

  @override
  void initState() {
    super.initState();

    _produtosModelo = new List();

    productSub?.cancel();
    productSub = db.getProductList().listen((QuerySnapshot snapshot) {
      final List<ProdutosModelo> produtos = snapshot.docs
          .map((documentSnapshot) =>
              ProdutosModelo.fromMap(documentSnapshot.data()))
          .toList();

      setState(() {
        this._produtosModelo = produtos;
      });
    });
  }

  @override
  void dispose() {
    productSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //--------Menu Lateral------
      appBar: AppBar(
        title: Text('BookStore'),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 16.0, top: 8.0),
            child: GestureDetector(
              child: Stack(
                alignment: Alignment.topCenter,
                children: <Widget>[
                  Icon(
                    Icons.shopping_cart,
                    size: 38,
                  ),
                  if (_listaCarro.length > 0)
                    Padding(
                      padding: const EdgeInsets.only(left: 2.0),
                      child: CircleAvatar(
                        radius: 8.0,
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        child: Text(
                          _listaCarro.length.toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12.0),
                        ),
                      ),
                    )
                ],
              ),
              onTap: () {
                if (_listaCarro.isNotEmpty)
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => Cart(_listaCarro),
                    ),
                  );
              },
            ),
          )
        ],
      ),
      drawer: Container(
        width: 170.0,
        child: Drawer(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.5,
            color: Colors.blue,
            child: new ListView(
              padding: EdgeInsets.only(top: 50.0),
              children: <Widget>[
                Container(
                  height: 150,
                  child: new UserAccountsDrawerHeader(
                    accountName: new Text('Bruno Lincoln Rabelo dos Santos'),
                    accountEmail: new Text('brunolincoln1998@gmail.com'),
                    decoration: new BoxDecoration(
                        image: new DecorationImage(
                            image: AssetImage('assets/images/book.png'),
                            fit: BoxFit.fill)),
                  ),
                ),
                new Divider(),
                new ListTile(
                  title: new Text(
                    'Página Principal',
                    style: TextStyle(color: Colors.white),
                  ),
                  trailing: new Icon(
                    Icons.home,
                    size: 30.0,
                    color: Colors.white,
                  ),
                  onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) => MyBookPage(),
                  )),
                ),
                new Divider(),
                new ListTile(
                  title: new Text(
                    'Perfil',
                    style: TextStyle(color: Colors.white),
                  ),
                  trailing: new Icon(
                    Icons.account_circle,
                    size: 30.0,
                    color: Colors.white,
                  ),
                  onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) => OutraPagina(),
                  )),
                ),
                new Divider(),
                new ListTile(
                  title: new Text(
                    'Adicionar Livro',
                    style: TextStyle(color: Colors.white),
                  ),
                  trailing: new Icon(
                    Icons.add_box,
                    size: 30.0,
                    color: Colors.white,
                  ),
                  onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) => CriarProdutos(),
                  )),
                ),
                new Divider(),
                new ListTile(
                  title: new Text(
                    'Procurar',
                    style: TextStyle(color: Colors.white),
                  ),
                  trailing: new Icon(
                    Icons.search,
                    size: 30.0,
                    color: Colors.white,
                  ),
                  onTap: () => Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) => SearchPage(),
                  )),
                ),
                new Divider(),
                new ListTile(
                    title: new Text(
                      'Sair',
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: new Icon(
                      Icons.login,
                      size: 30.0,
                      color: Colors.white,
                    ),
                    onTap: () async {
                      controller.signOut();
                    }),
                new Divider(),
              ],
            ),
          ),
        ),
      ),
      //--------------------------
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Container(
                        color: Colors.white,
                        height: MediaQuery.of(context).size.height / 1.18,
                        child: GridView.builder(
                          padding: const EdgeInsets.all(4.0),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2),
                          itemCount: _produtosModelo.length,
                          itemBuilder: (context, index) {
                            final String imagem = _produtosModelo[index].image;
                            var item = _produtosModelo[index];
                            return Card(
                                elevation: 4.0,
                                child: InkWell(
                                  onTap: () {
                                    showDialogFunc(context, item, imagem);
                                  },
                                  child: Center(
                                      child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Expanded(
                                        child: CachedNetworkImage(
                                            imageUrl:
                                                '${_produtosModelo[index].image}' +
                                                    '?alt=media',
                                            fit: BoxFit.cover,
                                            placeholder: (_, __) {
                                              return Center(
                                                  child:
                                                      CupertinoActivityIndicator(
                                                radius: 15,
                                              ));
                                            }),
                                      ),
                                      Text(
                                        '${_produtosModelo[index].name}',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(fontSize: 20.0),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          SizedBox(
                                            height: 25,
                                          ),
                                          Text(
                                            'R\$${_produtosModelo[index].price.toStringAsFixed(2)}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20.0,
                                                color: Colors.black),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              right: 8.0,
                                              bottom: 8.0,
                                            ),
                                            child: Align(
                                              alignment: Alignment.bottomRight,
                                              child: GestureDetector(
                                                child: (!_listaCarro
                                                        .contains(item))
                                                    ? Icon(
                                                        Icons.shopping_cart,
                                                        color: Colors.blue,
                                                        size: 38,
                                                      )
                                                    : Icon(
                                                        Icons.shopping_cart,
                                                        color: Colors.green,
                                                        size: 38,
                                                      ),
                                                onTap: () {
                                                  setState(() {
                                                    if (!_listaCarro
                                                        .contains(item))
                                                      _listaCarro.add(item);
                                                    else
                                                      _listaCarro.remove(item);
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  )),
                                ));
                          },
                        ))
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

showDialogFunc(context, item, imagem) {
  return showDialog(
      context: context,
      builder: (context) {
        return Center(
            child: SingleChildScrollView(
          child: Material(
            type: MaterialType.transparency,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.blue[100],
              ),
              padding: EdgeInsets.all(15),
              height: MediaQuery.of(context).size.height * 1.2,
              width: MediaQuery.of(context).size.width * 0.8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: CachedNetworkImage(
                        imageUrl: imagem + '?alt=media',
                        fit: BoxFit.cover,
                        placeholder: (_, __) {
                          return Center(
                              child: CupertinoActivityIndicator(
                            radius: 15,
                          ));
                        }),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      item.name,
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      'Autor: ' + item.autor,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Divider(
                    color: Colors.redAccent,
                    thickness: 5.0,
                    indent: 50.0,
                    height: 25.0,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'R\$' + item.price.toStringAsFixed(2),
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SingleChildScrollView(
                    child: Container(
                      alignment: Alignment.topCenter,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey[100],
                      ),
                      height: MediaQuery.of(context).size.height * 0.6,
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: new Text(
                        item.description,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
      });
}
