import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minha_paroquia/core/app/app_colors.dart';
import 'package:minha_paroquia/core/pages/pastorais/pastorais_page.dart';

class CardParoquiaWidget extends StatefulWidget {
  final String imagem;
  final String nome;
  final String endereco;
  final String ref;

  const CardParoquiaWidget({
    Key? key,
    required this.imagem,
    required this.nome,
    required this.endereco,
    required this.ref,
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
    if (mounted) {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
            ButtonBar(
              alignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  style: ButtonStyle(),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PastoraisPage(
                          ref: widget.ref,
                        ),
                      ),
                    );
                  },
                  child: const Text('Pastorais'),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.edit),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.delete),
                    )
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
    /*Container(
      height: 150,
      margin: EdgeInsets.only(left: 20, right: 20),
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
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 10, left: 10),
              child: Text(
                widget.endereco,
                style: GoogleFonts.poppins(
                  color: Color(0xFF676767),
                  fontWeight: FontWeight.normal,
                  fontSize: 12,
                ),
              ),
            ),
            trailing: PopupMenuButton<String>(
              icon: Icon(
                Icons.more_vert,
                color: AppColors.principal,
              ),
              padding: EdgeInsets.all(0),
              onSelected: (value) {
                if (value == 'editar') {
                } else {}
              },
              itemBuilder: (BuildContext contesxt) {
                return [
                  PopupMenuItem(
                    child: Text("Editar"),
                    value: 'editar',
                  ),
                  PopupMenuItem(
                    child: Text("Excluir"),
                    value: 'excluir',
                  ),
                ];
              },
            ),
          ),
        ),
      ),
    );*/
  }
}
