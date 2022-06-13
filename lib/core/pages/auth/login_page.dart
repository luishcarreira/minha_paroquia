// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:minha_paroquia/core/app/app_colors.dart';
import 'package:minha_paroquia/core/pages/auth/reset_password_page.dart';
import 'package:minha_paroquia/core/service/auth/auth_firebase_service.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final email = TextEditingController();
  final nome = TextEditingController();
  final senha = TextEditingController();

  bool isLogin = true;
  late String titulo;
  late String actionButton;
  late String toggleButton;

  @override
  void initState() {
    super.initState();
    setFormAction(true);
  }

  setFormAction(bool acao) {
    setState(() {
      isLogin = acao;
      if (isLogin) {
        titulo = 'Bem vindo!';
        actionButton = 'Acessar conta';
        toggleButton = 'Ainda não tem conta? Cadastre-se agora';
      } else {
        titulo = 'Crie sua conta';
        actionButton = 'Cadastrar';
        toggleButton = 'Voltar ao login';
      }
    });
  }

  login() async {
    try {
      await context.read<AuthFirebaseService>().login(email.text, senha.text);
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.message),
        backgroundColor: Colors.red[400],
      ));
    }
  }

  registrar() async {
    try {
      await context
          .read<AuthFirebaseService>()
          .registrar(email.text, senha.text);
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.message),
        backgroundColor: Colors.red[400],
      ));
    }
  }

  googleSignIn() async {
    try {
      await context.read<AuthFirebaseService>().signInWithGoogle();
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.message),
        backgroundColor: Colors.red[400],
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 30),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 60,
              ),
              Center(
                child: Text(
                  titulo,
                  style: GoogleFonts.poppins(
                    fontSize: 36,
                    color: AppColors.principal,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 15),
                      child: Material(
                        borderRadius: BorderRadius.circular(10),
                        //color: Colors.blueGrey[50],
                        elevation: 5,
                        //shadowColor: Colors.black,
                        child: TextFormField(
                          controller: email,
                          style: TextStyle(
                            fontSize: 18,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'e-mail',
                            hintStyle: TextStyle(
                              color: AppColors.principal,
                            ),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Icon(
                                Icons.person,
                                color: AppColors.principal,
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                      child: Material(
                        borderRadius: BorderRadius.circular(10),
                        //color: Colors.blueGrey[50],
                        elevation: 5,
                        //shadowColor: Colors.black,
                        child: TextFormField(
                          controller: senha,
                          obscureText: true,
                          style: TextStyle(
                            fontSize: 18,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'senha',
                            hintStyle: TextStyle(
                              color: AppColors.principal,
                            ),
                            prefixIcon: Icon(
                              Icons.lock,
                              color: AppColors.principal,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ResetPasswordPage()));
                  },
                  child: Text(
                    'Esqueceu a senha?',
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(24),
                child: GestureDetector(
                  onTap: () {
                    if (isLogin) {
                      login();
                    } else {
                      registrar();
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.principal,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            actionButton,
                            style: GoogleFonts.poppins(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Center(
                child: TextButton(
                  onPressed: () => setFormAction(!isLogin),
                  child: Text(
                    toggleButton,
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ),
              SizedBox(
                height: 100,
              ),
              Center(child: Text('Acessar conta com')),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: googleSignIn,
                child: Center(
                  child: Image.asset(
                    'assets/images/Google.png',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
