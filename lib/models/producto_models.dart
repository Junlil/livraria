class ProdutosModelo {
  var id;

  String name;
  String image;
  String autor;
  String editora;
  String genre;
  String description;
  num price;
  int quantity;

  ProdutosModelo(
    String documentID,
    String name,
    String image,
    String autor,
    String editora,
    String genre,
    String description,
    num price,
    int quantity,
  );

  ProdutosModelo.map(dynamic obj) {
    this.id = obj['id'];
    this.name = obj['name'];
    this.image = obj['image'];
    this.autor = obj['autor'];
    this.editora = obj['editora'];
    this.genre = obj['genre'];
    this.description = obj['description'];
    this.price = obj['price'];
    this.quantity = obj['quantity'];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map['id'] = id;
    map['name'] = name;
    map['image'] = image;
    map['autor'] = autor;
    map['editora'] = editora;
    map['genre'] = genre;
    map['description'] = description;
    map['price'] = price;
    map['quantity'] = quantity;

    return map;
  }

  ProdutosModelo.fromMap(Map<String, dynamic> map) {
    this.name = map['name'];
    this.id = map['id'];
    this.image = map['image'];
    this.autor = map['autor'];
    this.editora = map['editora'];
    this.genre = map['genre'];
    this.description = map['description'];
    this.price = map['price'];
    this.quantity = 0;
  }
}

class NewUser {
  String uid;

  bool admin = false;
  String fullName;
  num age;
  String email;
  String password;

  NewUser(
    String uid,
    bool admin,
    String fullName,
    num age,
    String email,
    String password,
  );

  NewUser.map(dynamic obj) {
    this.uid = obj['id'];
    this.admin = obj['id'];
    this.fullName = obj['fullName'];
    this.age = obj['age'];
    this.email = obj['email'];
    this.password = obj['password'];
  }

  Map<String, dynamic> toMap() {
    var map = new Map<String, dynamic>();

    map['uid'] = uid;
    map['admin'] = admin;
    map['fullName'] = fullName;
    map['age'] = age;
    map['email'] = email;
    map['password'] = password;

    return map;
  }

  NewUser.fromMap(Map<String, dynamic> map) {
    this.uid = map['uid'];
    this.admin = map['admin'];
    this.fullName = map['fullName'];
    this.age = map['age'];
    this.email = map['email'];
    this.password = map['password'];
  }
}

class Pedido {
  var id;
}
