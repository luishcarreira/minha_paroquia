import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minha_paroquia/core/app/app_colors.dart';
import 'package:minha_paroquia/core/service/auth/auth_firebase_service.dart';
import 'package:provider/provider.dart';

class ParoquiaNomePage extends StatefulWidget {
  const ParoquiaNomePage({Key? key}) : super(key: key);

  @override
  State<ParoquiaNomePage> createState() => _ParoquiaNomePageState();
}

class _ParoquiaNomePageState extends State<ParoquiaNomePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nome = TextEditingController();
  //final ramdom = Random();

  _onSubmit() async {
    //final numero = ramdom.nextInt(999999);

    AuthFirebaseService firebase =
        Provider.of<AuthFirebaseService>(context, listen: false);
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      DocumentReference docRef = firebase.firestore.collection('grupos').doc();
      firebase.firestore.collection('usuarios').doc(docRef.id).set({
        'codigo': 1, //numero randomico
        'nome': _nome.text,
        //'reg_imagem':
        'participantes': [
          firebase.usuario!.uid,
        ],
      });

      /*Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => UserRegisterNascimentoPage(),
        ),
      );*/
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          SizedBox(height: 40),
          Column(
            children: [
              Text(
                'Escreva o nome',
                style: GoogleFonts.poppins(
                  fontSize: 36,
                  color: AppColors.principal,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
              Text(
                'de uma nova paroquia.',
                style: GoogleFonts.poppins(
                  fontSize: 40,
                  color: AppColors.principal,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
            ],
          ),
          SizedBox(height: 25),
          Column(
            children: [
              Text(
                'Escreva o nome para sua paroquia. Todos',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Color(0xFFA1C69C),
                ),
              ),
              Text(
                'vão identificar a paroquia pelo',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Color(0xFFA1C69C),
                ),
              ),
              Text(
                'nome que voce vai colocar aqui.',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Color(0xFFA1C69C),
                ),
              ),
            ],
          ),
          SizedBox(height: 25),
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.only(left: 40, right: 40),
              child: Material(
                borderRadius: BorderRadius.circular(10),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _nome,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                    keyboardType: TextInputType.name,
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'Preencha o campo corretamente!';
                      }

                      return null;
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
