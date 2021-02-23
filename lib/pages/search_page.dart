import 'package:compras/pages/book_page.dart';
import 'package:compras/services/DataController.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPage createState() => _SearchPage();
}

class _SearchPage extends State<SearchPage> {
  final TextEditingController searchController = TextEditingController();
  QuerySnapshot snapshotData;
  bool isExecuted = false;
  @override
  Widget build(BuildContext context) {
    Widget searchedData() {
      return ListView.builder(
        itemCount: snapshotData.docs.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              Get.to(MyBookPage(),
                  transition: Transition.downToUp,
                  arguments: snapshotData.docs[index]);
            },
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage:
                    NetworkImage(snapshotData.docs[index].data()['image']),
              ),
              title: Text(
                snapshotData.docs[index].data()['name'],
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 22.0),
              ),
              subtitle: Text(
                snapshotData.docs[index].data()['autor'],
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0),
              ),
            ),
          );
        },
      );
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.clear),
          onPressed: () {
            setState(() {
              isExecuted = false;
            });
          }),
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          GetBuilder<DataController>(
            init: DataController(),
            builder: (val) {
              return IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    val.queryData(searchController.text).then((value) {
                      snapshotData = value;
                      setState(() {
                        isExecuted = true;
                      });
                    });
                  });
            },
          )
        ],
        title: TextField(
          style: TextStyle(color: Colors.black),
          decoration: InputDecoration(
              hintText: 'Procurar livros',
              hintStyle: TextStyle(color: Colors.grey[800])),
          controller: searchController,
        ),
        backgroundColor: Colors.blue,
      ),
      body: isExecuted
          ? searchedData()
          : Container(
              child: Center(
                child: Text('Procure por qualquer livro',
                    style: TextStyle(color: Colors.black, fontSize: 30.0)),
              ),
            ),
    );
  }
}
