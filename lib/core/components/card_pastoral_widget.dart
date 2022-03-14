import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CardPastoralWidget extends StatefulWidget {
  final String imagem;
  final String nome;

  const CardPastoralWidget({
    Key? key,
    required this.imagem,
    required this.nome,
  }) : super(key: key);

  @override
  State<CardPastoralWidget> createState() => _CardPastoralWidgetState();
}

class _CardPastoralWidgetState extends State<CardPastoralWidget> {
  final FirebaseStorage storage = FirebaseStorage.instance;
  String ref = '';
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadImages();
  }

  loadImages() async {
    ref = await storage.ref(widget.imagem).getDownloadURL();
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      margin: EdgeInsets.only(left: 40, right: 40),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: ListTile(
            leading: Container(
              width: 40,
              child:
                  ref != '' ? Image.network(ref) : CircularProgressIndicator(),
            ),
            title: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                widget.nome,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
