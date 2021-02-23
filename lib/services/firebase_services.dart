import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:compras/models/producto_models.dart';
import 'dart:async';

final CollectionReference productCollection =
    FirebaseFirestore.instance.collection('produtos');

class FirebaseService {
  static final FirebaseService _instance = new FirebaseService.internal();
  factory FirebaseService() => _instance;

  FirebaseService.internal();

  Future<ProdutosModelo> createProduct(
      String name,
      String image,
      String autor,
      String editora,
      String genre,
      String description,
      double price,
      int quantity) {
    final TransactionHandler createTransaction = (Transaction tx) async {
      final DocumentSnapshot doc = await tx.get(productCollection.doc());

      final ProdutosModelo produto = new ProdutosModelo(doc.id, name, image,
          autor, editora, genre, description, price, quantity);
      final Map<String, dynamic> data = produto.toMap();

      await tx.set(doc.reference, data);

      return data;
    };

    return FirebaseFirestore.instance
        .runTransaction(createTransaction)
        .then((mapData) {
      return ProdutosModelo.fromMap(mapData);
    }).catchError((error) {
      print('error: $error');
      return null;
    });
  }

  Stream<QuerySnapshot> getProductList({int offset, int limit}) {
    Stream<QuerySnapshot> snapshot = productCollection.snapshots();

    if (offset != null) {
      snapshot = snapshot.skip(offset);
    }

    if (limit != null) {
      snapshot = snapshot.skip(limit);
    }

    return snapshot;
  }
}
