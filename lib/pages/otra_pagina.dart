import 'package:flutter/material.dart';

class OutraPagina extends StatefulWidget {
  @override
  _OutraPaginaState createState() => _OutraPaginaState();
}

class _OutraPaginaState extends State<OutraPagina> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Outra pagina',
          style: TextStyle(fontSize: 15.0),
        ),
      ),
    );
  }
}
