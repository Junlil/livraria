import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signInWithEmailAndPassword() async {
    try {
      final User user = (await _auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      ))
          .user;
      Get.snackbar('Bem Vindo!', 'Login efetuado com sucesso.');
      print('Login bem sucedido');
      Future.delayed(
        Duration(seconds: 2),
        () {
          Get.toNamed("/bookpage");
        },
      );
    } catch (e) {
      Get.snackbar('Falha', 'Login não pode ser efetuado, tente novamente',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  void _signOut() async {
    await _auth.signOut();
  }

  void signOut() async {
    final User user = await _auth.currentUser;
    if (user == null) {
      Get.snackbar('Out', 'No one has signed in.',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    _signOut();
    final String uid = user.uid;
    Get.snackbar('Out', uid + 'has successfully signed out',
        snackPosition: SnackPosition.BOTTOM);
    Get.toNamed("/home");
  }
}

class LoginPage extends StatelessWidget {
  final controller = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<LoginController>(
        init: LoginController(),
        builder: (_) {
          return SingleChildScrollView(
            child: Form(
                key: controller.formKey,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 100,
                        ),
                        Container(
                          child: const Text(
                            'Login Page',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        TextFormField(
                          controller: controller.emailController,
                          decoration: const InputDecoration(labelText: 'Email'),
                          validator: (String value) {
                            if (value.isEmpty) return 'Please enter some text';
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: controller.passwordController,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                          ],
                          decoration:
                              const InputDecoration(labelText: 'Password'),
                          validator: (String value) {
                            if (value.isEmpty)
                              return 'Please enter some text or numbers';
                            return null;
                          },
                          obscureText: true,
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 16.0),
                          alignment: Alignment.center,
                          child: SignInButton(
                            Buttons.Email,
                            text: 'Sign In',
                            onPressed: () async {
                              _.signInWithEmailAndPassword();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
          );
        },
      ),
    );
  }
}
