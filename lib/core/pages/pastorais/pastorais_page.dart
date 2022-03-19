import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minha_paroquia/core/app/app_colors.dart';
import 'package:minha_paroquia/core/components/card_pastoral_widget.dart';
import 'package:minha_paroquia/core/pages/chat/chat_message_page.dart';
import 'package:minha_paroquia/core/pages/pastorais/cadastro_pastorais_page.dart';
import 'package:minha_paroquia/core/pages/pastorais/pastorais_sobre_page.dart';
import 'package:minha_paroquia/core/service/auth/auth_firebase_service.dart';
import 'package:provider/provider.dart';

class PastoraisPage extends StatefulWidget {
  final String ref;
  const PastoraisPage({Key? key, required this.ref}) : super(key: key);

  @override
  State<PastoraisPage> createState() => _PastoraisPageState();
}

class _PastoraisPageState extends State<PastoraisPage> {
  final ramdom = Random();
  @override
  Widget build(BuildContext context) {
    AuthFirebaseService firebase =
        Provider.of<AuthFirebaseService>(context, listen: false);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(106),
        child: SafeArea(
          top: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Text(
              'Pastorais',
              style: GoogleFonts.poppins(
                fontSize: 36,
                color: AppColors.principal,
                fontWeight: FontWeight.bold,
                height: 1.2,
              ),
            ),
            SizedBox(
              height: 150,
            ),
            Expanded(
              child: StreamBuilder(
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

                  return GridView.count(
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 1,
                    crossAxisCount: 2,
                    children: snapshot.data!.docs.map(
                      (DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;

                        return Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            GestureDetector(
                              onTap: () async {
                                final FirebaseStorage storage =
                                    FirebaseStorage.instance;
                                String ref = '';
                                ref = await storage
                                    .ref(data['ref_imagem'])
                                    .getDownloadURL();

                                if (ref != '')
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => PastoraisSobrePage(
                                        codigo_pastoral:
                                            data['codigo_pastoral'],
                                        imagem: ref,
                                        nome: data['nome'],
                                      ),
                                    ),
                                  );
                              },
                              child: CardPastoralWidget(
                                imagem: data['ref_imagem'],
                                nome: data['nome'],
                              ),
                            )
                          ],
                        );
                      },
                    ).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.principal,
        onPressed: () {
          final numero = ramdom.nextInt(999999);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CadastroPastoraisPage(
                codigo: numero.toString(),
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
