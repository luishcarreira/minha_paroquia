import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:minha_paroquia/core/app/app_colors.dart';
import 'package:minha_paroquia/core/service/auth/auth_firebase_service.dart';
import 'package:provider/provider.dart';

class CardPastoralWidget extends StatefulWidget {
  final String refPastoral;
  final String refParoquia;
  final String? imagem;
  final String? nome;
  final bool admin;

  const CardPastoralWidget({
    Key? key,
    required this.imagem,
    required this.nome,
    required this.refPastoral,
    required this.refParoquia,
    required this.admin,
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
    AuthFirebaseService firebase = Provider.of<AuthFirebaseService>(
      context,
      listen: false,
    );
    if (widget.admin) {
      return Container(
        height: 20,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(top: 10),
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
          children: [
            loading == false
                ? CircleAvatar(
                    backgroundImage: NetworkImage(ref),
                    radius: 40,
                  )
                : CircularProgressIndicator(),
            SizedBox(
              height: 5,
            ),
            Text(
              widget.nome!,
            ),
            ButtonBar(
              alignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.edit,
                    color: AppColors.principal,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    try {
                      firebase.firestore
                          .collection('paroquia')
                          .doc(widget.refParoquia)
                          .collection('pastorais')
                          .doc(widget.refPastoral)
                          .delete();

                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Pastoral excluida com sucesso!'),
                        backgroundColor: Colors.green,
                      ));
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Erro ao excluir pastoral'),
                          backgroundColor: Colors.red[400],
                        ),
                      );
                    }
                  },
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                )
              ],
            ),
          ],
        ),
      );
    } else {
      return Container(
        height: 20,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.only(top: 10),
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
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      );
    }
  }
}
