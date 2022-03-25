import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minha_paroquia/core/app/app_colors.dart';
import 'package:minha_paroquia/core/components/card_minhas_paroquia_widget.dart';
import 'package:minha_paroquia/core/pages/paroquia/cadastros/inserir/paroquia_imagem_page.dart';
import 'package:minha_paroquia/core/service/auth/auth_firebase_service.dart';
import 'package:provider/provider.dart';

class MinhasParoquiasPage extends StatefulWidget {
  const MinhasParoquiasPage({Key? key}) : super(key: key);

  @override
  State<MinhasParoquiasPage> createState() => _MinhasParoquiasPageState();
}

class _MinhasParoquiasPageState extends State<MinhasParoquiasPage> {
  final ramdom = Random();
  String searchtxt = '';

  @override
  Widget build(BuildContext context) {
    AuthFirebaseService firebase =
        Provider.of<AuthFirebaseService>(context, listen: false);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(180),
        child: Container(
          color: AppColors.principal,
          child: SafeArea(
            top: true,
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                Text(
                  'Minhas Paróquias',
                  style: GoogleFonts.poppins(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                  child: TextFormField(
                    onChanged: (text) => {
                      searchtxt = text,
                      setState(() {
                        searchtxt;
                      })
                    },
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.fromLTRB(10, 10, 15, 0),
                      fillColor: Colors.white,
                      filled: true,
                      prefixIcon: Icon(Icons.search),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: (searchtxt != '' && searchtxt != null)
            ? firebase.firestore
                .collection('paroquia')
                .where('participantes', arrayContains: firebase.usuario!.uid)
                .where('nome', isGreaterThanOrEqualTo: searchtxt)
                .where('nome', isLessThanOrEqualTo: searchtxt + '\uf7ff')
                .snapshots()
            : firebase.firestore
                .collection('paroquia')
                .where('participantes', arrayContains: firebase.usuario!.uid)
                .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView(
            children: snapshot.data!.docs.map(
              (DocumentSnapshot document) {
                Map<String, dynamic> data =
                    document.data()! as Map<String, dynamic>;

                return Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    CardMinhasParoquiaWidget(
                      imagem: data['ref_imagem'],
                      nome: data['nome'] ?? '',
                      endereco: data['endereco_completo'] ?? '',
                      ref: data['ref'],
                    ),
                  ],
                );
              },
            ).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final numero = ramdom.nextInt(999999);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ParoquiaImagemPage(
                codigo: numero.toString(),
              ),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: AppColors.principal,
      ),
    );
  }
}
