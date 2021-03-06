import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:minha_paroquia/core/app/app_colors.dart';
import 'package:minha_paroquia/core/pages/auth/auth_check.dart';
import 'package:minha_paroquia/core/pages/user/cadastro/cadastro_nascimento_usuario.dart';
import 'package:minha_paroquia/core/service/auth/auth_firebase_service.dart';
import 'package:provider/provider.dart';

class CadastroFotoUsuarioPage extends StatefulWidget {
  const CadastroFotoUsuarioPage({Key? key}) : super(key: key);

  @override
  State<CadastroFotoUsuarioPage> createState() =>
      _CadastroFotoUsuarioPageState();
}

class _CadastroFotoUsuarioPageState extends State<CadastroFotoUsuarioPage> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseStorage storage = FirebaseStorage.instance;
  final TextEditingController _nome = TextEditingController();
  String ref = '';
  bool success = false;

  Future<XFile?> getImage() async {
    final ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    return image;
  }

  Future<UploadTask> upload(String path) async {
    AuthFirebaseService firebase =
        Provider.of<AuthFirebaseService>(context, listen: false);
    File file = File(path);
    try {
      ref = 'images/img-usr-${firebase.usuario!.uid}.jpg';
      return storage.ref(ref).putFile(file);
    } on FirebaseException catch (e) {
      throw Exception('Erro no upload: ${e.code}');
    }
  }

  pickAndUploadImage() async {
    XFile? file = await getImage();
    if (file != null) {
      UploadTask task = await upload(file.path);

      task.snapshotEvents.listen((taskSnapshot) {
        switch (taskSnapshot.state) {
          case TaskState.running:
            loading();
            break;
          case TaskState.paused:
            print("Upload is paused.");
            break;
          case TaskState.canceled:
            print("Upload was canceled");
            break;
          case TaskState.error:
            // Handle unsuccessful uploads
            break;
          case TaskState.success:
            setState(() {
              success = true;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('O arquivo foi carregado com sucesso!'),
                backgroundColor: Colors.green,
              ),
            );
            // ...
            break;
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao inserir a imagem'),
          backgroundColor: Colors.red[400],
        ),
      );
    }
  }

  _onSubmit() async {
    try {
      AuthFirebaseService firebase =
          Provider.of<AuthFirebaseService>(context, listen: false);

      firebase.firestore.collection('usuarios').doc(firebase.usuario!.uid).set(
        {
          'uid': firebase.usuario!.uid,
          'email': firebase.usuario!.email,
          'nome': _nome.text,
          'ref_imagem': ref,
        },
      );

      firebase.usuario!.updateDisplayName(_nome.text);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CadastroNascimentoUsuario(),
        ),
      );
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message),
          backgroundColor: Colors.red[400],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          SizedBox(height: 40),
          Column(
            children: [
              Text(
                'Selecione uma foto para',
                style: GoogleFonts.poppins(
                  fontSize: 25,
                  color: AppColors.principal,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
              Text(
                'seu perfil.',
                style: GoogleFonts.poppins(
                  fontSize: 25,
                  color: AppColors.principal,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
            ],
          ),
          SizedBox(height: 25),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: TextButton(
              onPressed: pickAndUploadImage,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.image,
                    color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Adiconar Imagem',
                    style: TextStyle(color: AppColors.principal),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Column(
            children: [
              Text(
                'Nome ou apelido que ser?? exibido para os outros',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Color.fromARGB(255, 185, 185, 185),
                ),
              ),
              Text(
                'usu??rios do aplicativo.',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Color.fromARGB(255, 185, 185, 185),
                ),
              ),
            ],
          ),
          SizedBox(height: 25),
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.only(left: 40, right: 40),
              child: Material(
                borderRadius: BorderRadius.circular(10),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _nome,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                    keyboardType: TextInputType.name,
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'Preencha o campo corretamente!';
                      }

                      return null;
                    },
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 25),
          success
              ? Padding(
                  padding: EdgeInsets.all(24),
                  child: GestureDetector(
                    onTap: () {
                      _onSubmit();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.principal,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(16),
                            child: Text(
                              'Continuar',
                              style: GoogleFonts.poppins(
                                fontSize: 24,
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : const Text(''),
        ],
      ),
    );
  }
}

void _showDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return const AlertDialog(
        title: Text("Carregando arquivo"),
        content: CircularProgressIndicator(),
      );
    },
  );
}
