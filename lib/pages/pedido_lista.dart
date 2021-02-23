import 'package:cached_network_image/cached_network_image.dart';
import 'package:compras/models/producto_models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'payment_page.dart';

class Cart extends StatefulWidget {
  final List<ProdutosModelo> _cart;

  Cart(this._cart);
  @override
  _CartState createState() => _CartState(this._cart);
}

class _CartState extends State<Cart> {
  _CartState(this._cart);
  final _scrollController = ScrollController();
  var _firstScroll = true;
  bool _enabled = false;

  List<ProdutosModelo> _cart;

  Container pagoTotal(List<ProdutosModelo> _cart) {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(left: 120),
      height: 70,
      width: 400,
      color: Colors.grey[200],
      child: Row(
        children: <Widget>[
          Text("Total:  R\$${valorTotal(_cart)}",
              style: new TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                  color: Colors.black))
        ],
      ),
    );
  }

  String valorTotal(List<ProdutosModelo> listaProdutos) {
    num total = 0.0;

    for (int i = 0; i < listaProdutos.length; i++) {
      total = total + listaProdutos[i].price * listaProdutos[i].quantity;
    }
    return total.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.menu_book),
            onPressed: null,
            color: Colors.white,
          )
        ],
        title: Text(
          'Detalhes',
          style: new TextStyle(
              fontWeight: FontWeight.bold, fontSize: 14.0, color: Colors.black),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
            setState(() {
              _cart.length;
            });
          },
          color: Colors.white,
        ),
        backgroundColor: Colors.transparent,
      ),
      body: GestureDetector(
        onVerticalDragUpdate: (details) {
          if (_enabled && _firstScroll) {
            _scrollController
                .jumpTo(_scrollController.position.pixels - details.delta.dy);
          }
        },
        onVerticalDragEnd: (_) {
          if (_enabled) _firstScroll = false;
        },
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _cart.length,
                  itemBuilder: (context, index) {
                    //final String imagem = _cart[index].image;
                    var item = _cart[index];
                    return Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 2.0),
                          child: Column(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Expanded(
                                      child: Container(
                                    width: 150,
                                    height: 150,
                                    child: CachedNetworkImage(
                                        imageUrl:
                                            '${item.image}' + '?alt=media',
                                        fit: BoxFit.cover,
                                        placeholder: (_, __) {
                                          return Center(
                                              child: CupertinoActivityIndicator(
                                            radius: 15,
                                          ));
                                        }),
                                  )),
                                  Column(
                                    children: <Widget>[
                                      Text(item.name,
                                          textAlign: TextAlign.justify,
                                          style: new TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.0,
                                              color: Colors.black)),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                            width: 120,
                                            height: 40,
                                            decoration: BoxDecoration(
                                                color: Colors.blue[600],
                                                boxShadow: [
                                                  BoxShadow(
                                                    blurRadius: 6.0,
                                                    color: Colors.blue[400],
                                                    offset: Offset(0.0, 1.0),
                                                  )
                                                ],
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(50.0),
                                                )),
                                            margin: EdgeInsets.only(
                                                top: 20.0, left: 4.0),
                                            padding: EdgeInsets.all(2.0),
                                            child: new Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: <Widget>[
                                                SizedBox(
                                                  height: 8.0,
                                                ),
                                                IconButton(
                                                  icon: Icon(Icons.remove),
                                                  onPressed: () {
                                                    _cart[index].quantity--;
                                                    valorTotal(_cart);
                                                  },
                                                  color: Colors.white,
                                                ),
                                                Text('${_cart[index].quantity}',
                                                    style: new TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 22.0,
                                                        color: Colors.white)),
                                                IconButton(
                                                  icon: Icon(Icons.add),
                                                  onPressed: () {
                                                    valorTotal(_cart);
                                                    _cart[index].quantity++;
                                                  },
                                                  color: Colors.white,
                                                ),
                                                SizedBox(
                                                  height: 8.0,
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    width: 38.0,
                                  ),
                                  Text(item.price.toStringAsFixed(2),
                                      style: new TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24.0,
                                          color: Colors.black))
                                ],
                              )
                            ],
                          ),
                        ),
                        Divider(
                          color: Colors.purple,
                        )
                      ],
                    );
                  }),
              SizedBox(
                width: 10.0,
              ),
              pagoTotal(_cart),
              SizedBox(
                width: 20.0,
              ),
              Container(
                height: 100,
                width: 200,
                padding: EdgeInsets.all(25),
                child: RaisedButton(
                  textColor: Colors.white,
                  color: Colors.green,
                  child: Text("PAGAR"),
                  onPressed: () =>
                      Navigator.of(context).push(new MaterialPageRoute(
                    builder: (BuildContext context) => PaymentPage(),
                  )),
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void msgListaPedido() async {
    String pedido = "";
    String data = DateTime.now().toString();
    pedido = pedido + "Data:" + data.toString();
    pedido = pedido + "\n";
    pedido = pedido + "Mega Descontos a Domicílio";
    pedido = pedido + "\n";
    pedido = pedido + "CLIENTE: FLUTTER - DART";
    pedido = pedido + "\n";
    pedido = pedido + "_____________";

    for (int i = 0; i < _cart.length; i++) {
      pedido = '$pedido' +
          "\n" +
          "Produto: " +
          _cart[i].name +
          "\n" +
          "Quantidade: " +
          _cart[i].quantity.toString() +
          "\n" +
          "Preço: " +
          _cart[i].price.toString() +
          "\n" +
          "\_________________________\n";
    }
    pedido = pedido + "TOTAL:" + valorTotal(_cart);

    await launch("https://wa.me/${5585986205136}?text=$pedido");
  }
}
