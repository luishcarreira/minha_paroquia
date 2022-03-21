import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minha_paroquia/core/app/app_colors.dart';
import 'package:minha_paroquia/core/components/card_paroquia_widget.dart';
import 'package:minha_paroquia/core/pages/paroquia/cadastros/paroquia_imagem_page.dart';
import 'package:minha_paroquia/core/pages/pastorais/pastorais_page.dart';
import 'package:minha_paroquia/core/pages/user/usuario_perfil_page.dart';
import 'package:minha_paroquia/core/service/auth/auth_firebase_service.dart';
import 'package:provider/provider.dart';

class MinhasParoquiasPage extends StatefulWidget {
  const MinhasParoquiasPage({Key? key}) : super(key: key);

  @override
  State<MinhasParoquiasPage> createState() => _MinhasParoquiasPageState();
}

class _MinhasParoquiasPageState extends State<MinhasParoquiasPage> {
  final ramdom = Random();
  List<String> paroquiaCod = [''];

  @override
  Widget build(BuildContext context) {
    AuthFirebaseService firebase =
        Provider.of<AuthFirebaseService>(context, listen: false);

    Stream<QuerySnapshot> _minhasParoquiasStream = FirebaseFirestore.instance
        .collection('paroquia')
        .where('participantes', arrayContains: firebase.usuario!.uid)
        .snapshots();

    Stream<QuerySnapshot> _minhasParoquias = FirebaseFirestore.instance
        .collection('paroquia')
        .where('participantes', arrayContains: firebase.usuario!.uid)
        .snapshots();

    _minhasParoquias.forEach((element) {
      paroquiaCod.clear();
      element.docs.asMap().forEach((index, data) {
        paroquiaCod.add(element.docs[index]['codigo']);
      });
    });

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(200),
          child: Container(
            color: AppColors.principal,
            child: SafeArea(
              top: true,
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => UsuarioPerfilPage(),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Text(
                    'Paróquias',
                    style: GoogleFonts.poppins(
                      fontSize: 36,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  SizedBox(
                    height: 45,
                  ),
                  TabBar(
                    labelColor: Colors.black54,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(50), // Creates border
                      color: Colors.white,
                    ),
                    tabs: [
                      Tab(
                        child: Text(
                          'Minhas Paroquias',
                        ),
                      ),
                      Tab(
                        child: Text(
                          'Explorar',
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: _minhasParoquiasStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
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
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => PastoraisPage(
                                    ref: data['ref'],
                                  ),
                                ),
                              );
                            },
                            child: CardParoquiaWidget(
                              imagem: data['ref_imagem'],
                              nome: data['nome'] ?? '',
                              endereco: data['endereco'] ?? '',
                            ),
                          ),
                        ],
                      );
                    },
                  ).toList(),
                );
              },
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('paroquia')
                  .where('codigo', whereNotIn: paroquiaCod)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
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
                          GestureDetector(
                            onTap: () {
                              _showDialog(
                                context,
                                data['ref'],
                                data['nome'],
                              );
                            },
                            child: CardParoquiaWidget(
                              imagem: data['ref_imagem'],
                              nome: data['nome'] ?? '',
                              endereco: data['endereco'] ?? '',
                            ),
                          ),
                        ],
                      );
                    },
                  ).toList(),
                );
              },
            ),
          ],
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
      ),
    );
  }
}

void _showDialog(BuildContext context, String docRef, String nome) {
  AuthFirebaseService firebase =
      Provider.of<AuthFirebaseService>(context, listen: false);
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Paroquias"),
        content: Text("Deseja entrar na $nome?"),
        actions: <Widget>[
          TextButton(
            child: Text("Sim"),
            onPressed: () async {
              await firebase.firestore
                  .collection('paroquia')
                  .doc(docRef)
                  .update(
                {
                  'participantes':
                      FieldValue.arrayUnion([firebase.usuario!.uid]),
                },
              );
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text("Não"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
