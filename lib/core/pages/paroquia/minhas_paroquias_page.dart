import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:minha_paroquia/core/app/app_colors.dart';
import 'package:minha_paroquia/core/components/card_paroquia_widget.dart';
import 'package:minha_paroquia/core/pages/paroquia/cadastros/paroquia_imagem_page.dart';
import 'package:minha_paroquia/core/pages/pastorais/pastorais_page.dart';
import 'package:minha_paroquia/core/service/auth/auth_firebase_service.dart';
import 'package:provider/provider.dart';

class MinhasParoquiasPage extends StatefulWidget {
  const MinhasParoquiasPage({Key? key}) : super(key: key);

  @override
  State<MinhasParoquiasPage> createState() => _MinhasParoquiasPageState();
}

class _MinhasParoquiasPageState extends State<MinhasParoquiasPage> {
  final ramdom = Random();
  List<String> paroquiaCod = ['123'];

  @override
  Widget build(BuildContext context) {
    AuthFirebaseService firebase =
        Provider.of<AuthFirebaseService>(context, listen: false);
    final Stream<QuerySnapshot> _minhasParoquiasStream = FirebaseFirestore
        .instance
        .collection('paroquia')
        .where('participantes', arrayContains: firebase.usuario!.uid)
        .snapshots();

    final Stream<QuerySnapshot> _minhasParoquias = FirebaseFirestore.instance
        .collection('paroquia')
        .where('participantes', arrayContains: firebase.usuario!.uid)
        .snapshots();

    _minhasParoquias.forEach((element) {
      element.docs.asMap().forEach((index, data) {
        paroquiaCod.add(element.docs[index]['codigo']);
        print('minhas paroquinhas $paroquiaCod');
      });
    });

    final Stream<QuerySnapshot> _exploarStream = FirebaseFirestore.instance
        .collection('paroquia')
        .where('codigo', whereNotIn: paroquiaCod)
        .snapshots();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Paroquias'),
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                child: Text(
                  'Minhas Paroquias',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Tab(
                child: Text(
                  'Explorar',
                  style: TextStyle(color: Colors.white),
                ),
              )
            ],
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
                              print(data['ref']);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => PastoraisPage(
                                    codigo: data['codigo'],
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
              stream: _exploarStream,
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
                          CardParoquiaWidget(
                            imagem: data['ref_imagem'],
                            nome: data['nome'] ?? '',
                            endereco: data['endereco'] ?? '',
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
