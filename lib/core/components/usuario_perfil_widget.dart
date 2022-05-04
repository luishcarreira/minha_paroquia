import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minha_paroquia/core/app/app_colors.dart';
import 'package:minha_paroquia/core/service/auth/auth_firebase_service.dart';
import 'package:provider/provider.dart';

class UsuarioPerfilWidget extends StatefulWidget {
  final String foto;
  final String? nome;
  final String sobre;
  const UsuarioPerfilWidget({
    Key? key,
    required this.foto,
    required this.nome,
    required this.sobre,
  }) : super(key: key);

  @override
  State<UsuarioPerfilWidget> createState() => _UsuarioPerfilWidgetState();
}

class _UsuarioPerfilWidgetState extends State<UsuarioPerfilWidget> {
  final FirebaseStorage storage = FirebaseStorage.instance;
  String ref = '';
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadImages();
  }

  loadImages() async {
    ref = await storage.ref(widget.foto).getDownloadURL();
    if (mounted) {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    AuthFirebaseService firebase =
        Provider.of<AuthFirebaseService>(context, listen: false);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(250),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.principal,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: SafeArea(
            top: true,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () {
                      firebase.logout();
                    },
                    icon: Icon(
                      Icons.logout,
                      color: Colors.white,
                    ),
                  ),
                ),
                loading == false
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(ref),
                        radius: 60,
                      )
                    : CircleAvatar(
                        backgroundImage:
                            AssetImage('assets/images/user-icon.png'),
                        radius: 60,
                      ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Olá, ${widget.nome}',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 24,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(50),
        child: Card(
          elevation: 4,
          child: Container(
            margin: EdgeInsets.all(100),
            padding: EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                (widget.sobre == '') ? Text(widget.sobre) : Text(' '),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
