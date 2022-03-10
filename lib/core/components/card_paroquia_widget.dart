import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CardParoquiaWidget extends StatefulWidget {
  final String imagem;
  final String nome;
  final String endereco;

  const CardParoquiaWidget({
    Key? key,
    required this.imagem,
    required this.nome,
    required this.endereco,
  }) : super(key: key);

  @override
  State<CardParoquiaWidget> createState() => _CardParoquiaWidgetState();
}

class _CardParoquiaWidgetState extends State<CardParoquiaWidget> {
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
      margin: EdgeInsets.only(left: 20, right: 20),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: ListTile(
            leading: CircleAvatar(
              child: Container(
                child: Image.network(ref),
              ),
            ),
            title: Text(
              widget.nome,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                widget.endereco,
                style: GoogleFonts.poppins(
                  color: Color(0xFF676767),
                  fontWeight: FontWeight.normal,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
