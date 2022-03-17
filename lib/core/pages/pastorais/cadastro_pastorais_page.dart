import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:minha_paroquia/core/app/app_colors.dart';
import 'package:minha_paroquia/core/pages/paroquia/cadastros/paroquia_cep_page.dart';
import 'package:minha_paroquia/core/service/auth/auth_firebase_service.dart';
import 'package:provider/provider.dart';

class CadastroPastoraisPage extends StatefulWidget {
  final String codigo;
  final String docRef;
  const CadastroPastoraisPage({
    Key? key,
    required this.codigo,
    required this.docRef,
  }) : super(key: key);

  @override
  State<CadastroPastoraisPage> createState() => _CadastroPastoraisPageState();
}

class _CadastroPastoraisPageState extends State<CadastroPastoraisPage> {
  final FirebaseStorage storage = FirebaseStorage.instance;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nome = TextEditingController();
  String ref = '';

  Future<XFile?> getImage() async {
    final ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    return image;
  }

  Future<UploadTask> upload(String path) async {
    File file = File(path);
    try {
      ref = 'images/img-pastoral-${widget.codigo}.jpg';
      return storage.ref(ref).putFile(file);
    } on FirebaseException catch (e) {
      throw Exception('Erro no upload: ${e.code}');
    }
  }

  pickAndUploadImage() async {
    XFile? file = await getImage();
    if (file != null) {
      UploadTask task = await upload(file.path);
    } else {
      //mensagem de erro
    }
  }

  _onSubmit() async {
    AuthFirebaseService firebase =
        Provider.of<AuthFirebaseService>(context, listen: false);
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      DocumentReference dbRef = firebase.firestore
          .collection('paroquia')
          .doc(widget.docRef)
          .collection('pastorais')
          .doc();

      firebase.firestore
          .collection('paroquia')
          .doc(widget.docRef)
          .collection('pastorais')
          .doc(dbRef.id)
          .set({
        'codigo_pastoral': widget.codigo,
        'ref_imagem': ref,
        'nome': _nome.text,
        'ref_doc': dbRef.id,
      });

      Navigator.pop(context);
    } else {
      //mensagem de erro
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
                'Selecione a imagem e',
                style: GoogleFonts.poppins(
                  fontSize: 25,
                  color: AppColors.principal,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
              Text(
                'um nome para sua paroquia',
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
          Align(
            alignment: Alignment.center,
            child: Text(
              'Escreva o nome para sua paroquia.',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Color.fromARGB(255, 101, 104, 101),
              ),
            ),
          ),
          SizedBox(
            height: 25,
          ),
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
          Padding(
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
          ),
        ],
      ),
    );
  }
}
