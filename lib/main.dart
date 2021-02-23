import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:compras/routes/my_routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/home',
    navigatorKey: Get.key,
    getPages: routes(),
  ));
}

// SHA1: 0F:D8:E9:B1:9C:62:8C:09:DA:CB:85:C5:88:7A:97:E5:42:15:23:FA