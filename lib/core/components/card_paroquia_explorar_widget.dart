import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minha_paroquia/core/app/app_colors.dart';
import 'package:minha_paroquia/core/pages/paroquia/cadastros/alterar/paroquia_imagem_alterar_page.dart';
import 'package:minha_paroquia/core/pages/pastorais/pastorais_page.dart';
import 'package:minha_paroquia/core/service/auth/auth_firebase_service.dart';
import 'package:provider/provider.dart';

class CardParoquiaExplorarWidget extends StatefulWidget {
  final String imagem;
  final String nome;
  final String endereco;
  final String ref;

  const CardParoquiaExplorarWidget({
    Key? key,
    required this.imagem,
    required this.nome,
    required this.endereco,
    required this.ref,
  }) : super(key: key);

  @override
  State<CardParoquiaExplorarWidget> createState() =>
      _CardParoquiaExplorarWidgetState();
}

class _CardParoquiaExplorarWidgetState
    extends State<CardParoquiaExplorarWidget> {
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
    if (mounted) {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    AuthFirebaseService firebase = Provider.of<AuthFirebaseService>(
      context,
      listen: false,
    );

    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: Card(
        elevation: 4,
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            ListTile(
              title: Text(
                widget.nome,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  color: AppColors.principal,
                  fontWeight: FontWeight.w900,
                  height: 1.2,
                ),
              ),
            ),
            loading == false
                ? Image.network(
                    ref,
                    height: 150,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  )
                : Center(child: CircularProgressIndicator()),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.endereco,
                style: TextStyle(color: Colors.black.withOpacity(0.6)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
