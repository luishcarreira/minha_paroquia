import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minha_paroquia/core/app/app_colors.dart';
import 'package:minha_paroquia/core/components/card_paroquia_explorar_widget.dart';
import 'package:minha_paroquia/core/service/auth/auth_firebase_service.dart';
import 'package:provider/provider.dart';

class ExplorarPage extends StatefulWidget {
  const ExplorarPage({
    Key? key,
  }) : super(key: key);

  @override
  State<ExplorarPage> createState() => _ExplorarPageState();
}

class _ExplorarPageState extends State<ExplorarPage> {
  String searchtxt = '';
  List<String> paroquiaCod = [''];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initParoquias();
  }

  initParoquias() {
    AuthFirebaseService firebase =
        Provider.of<AuthFirebaseService>(context, listen: false);
    Stream<QuerySnapshot> _minhasParoquias = firebase.firestore
        .collection('paroquia')
        .where('participantes', arrayContains: firebase.usuario!.uid)
        .snapshots();

    _minhasParoquias.forEach((element) {
      element.docs.asMap().forEach((index, data) {
        setState(() {
          paroquiaCod.add(element.docs[index]['codigo']);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  'Explorar',
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
        stream: FirebaseFirestore.instance
            .collection('paroquia')
            .where('codigo', whereNotIn: paroquiaCod)
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
                    GestureDetector(
                      onTap: () {
                        _showDialog(
                          context,
                          data['ref'],
                          data['nome'],
                        );
                      },
                      child: CardParoquiaExplorarWidget(
                        imagem: data['ref_imagem'],
                        nome: data['nome'] ?? '',
                        endereco: data['endereco_completo'] ?? '',
                        ref: data['ref'],
                      ),
                    ),
                  ],
                );
              },
            ).toList(),
          );
        },
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
        title: const Text("Par??quias"),
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
            child: Text("N??o"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
