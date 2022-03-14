import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:minha_paroquia/core/app/app_colors.dart';
import 'package:minha_paroquia/core/components/card_pastoral_widget.dart';
import 'package:minha_paroquia/core/pages/pastorais/cadastro_pastorais_page.dart';
import 'package:minha_paroquia/core/service/auth/auth_firebase_service.dart';
import 'package:provider/provider.dart';

class PastoraisPage extends StatefulWidget {
  final String ref;
  final String codigo;
  const PastoraisPage({Key? key, required this.codigo, required this.ref})
      : super(key: key);

  @override
  State<PastoraisPage> createState() => _PastoraisPageState();
}

class _PastoraisPageState extends State<PastoraisPage> {
  @override
  Widget build(BuildContext context) {
    AuthFirebaseService firebase =
        Provider.of<AuthFirebaseService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Pastorais'),
      ),
      body: StreamBuilder(
        stream: firebase.firestore
            .collection('paroquia')
            .doc(widget.ref)
            .collection('pastorais')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData) {
            ListView(
              children: snapshot.data!.docs.map(
                (DocumentSnapshot document) {
                  Map<String, dynamic> data =
                      document.data()! as Map<String, dynamic>;

                  return Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      CardPastoralWidget(
                        imagem: data['ref_imagem'],
                        nome: data['nome'],
                      )
                    ],
                  );
                },
              ).toList(),
            );
          }

          return Center(
            child: Text('adicione uma pastoral'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.principal,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CadastroPastoraisPage(
                codigo: widget.codigo,
                docRef: widget.ref,
              ),
            ),
          );
        },
        child: Icon(
          Icons.add,
        ),
      ),
    );
  }
}
