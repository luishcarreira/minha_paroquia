import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CardPastoralWidget extends StatefulWidget {
  final String? imagem;
  final String? nome;

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
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.fromBorderSide(
          BorderSide(
            color: Color(0xFFE1E1E6),
          ),
        ),
        color: Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          loading == false
              ? CircleAvatar(
                  backgroundImage: NetworkImage(ref),
                  radius: 40,
                )
              : CircularProgressIndicator(),
          SizedBox(
            height: 20,
          ),
          Text(
            widget.nome!,
          ),
        ],
      ),
    );
  }
}
