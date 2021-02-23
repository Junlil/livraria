import 'package:get/get.dart';
import 'package:compras/pages/book_page.dart';
import 'package:compras/pages/home_page.dart';
import 'package:compras/pages/admin/register_login_page.dart';
import 'package:compras/pages/admin/login_page.dart';
import 'package:get/route_manager.dart';

routes() => [
      GetPage(name: "/home", page: () => HomePage()),
      GetPage(name: "/registration", page: () => RegisterLoginPage()),
      GetPage(name: "/loginpage", page: () => LoginPage()),
      GetPage(
          name: "/bookpage",
          page: () => MyBookPage(),
          transition: Transition.zoom),
    ];
