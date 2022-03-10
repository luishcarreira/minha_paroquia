import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:minha_paroquia/core/app/app_colors.dart';
import 'package:minha_paroquia/core/service/auth/auth_firebase_service.dart';
import 'package:provider/provider.dart';

class ParoquiaImagemPage extends StatefulWidget {
  final String ref;
  const ParoquiaImagemPage({
    Key? key,
    required this.ref,
  }) : super(key: key);

  @override
  State<ParoquiaImagemPage> createState() => _ParoquiaImagemPageState();
}

class _ParoquiaImagemPageState extends State<ParoquiaImagemPage> {
  final FirebaseStorage storage = FirebaseStorage.instance;

  Future<XFile?> getImage() async {
    final ImagePicker _picker = ImagePicker();
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    return image;
  }

  Future<UploadTask> upload(String path) async {
    File file = File(path);
    try {
      String ref = 'images/img-${DateTime.now().toString()}.jpg';
      return storage.ref(ref).putFile(file);
    } on FirebaseException catch (e) {
      throw Exception('Erro no upload: ${e.code}');
    }
  }

  pickAndUploadImage() async {
    XFile? file = await getImage();
    if (file != null) {
      UploadTask task = await upload(file.path);

      print('file path: ${file.path}');

      AuthFirebaseService firebase =
          Provider.of<AuthFirebaseService>(context, listen: false);

      firebase.firestore.collection('paroquia').doc(widget.ref).update({
        'ref_imagem': file.path,
      }).onError((error, stackTrace) => print(error));
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
                'Escreva o nome',
                style: GoogleFonts.poppins(
                  fontSize: 36,
                  color: AppColors.principal,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
              Text(
                'de uma nova paroquia.',
                style: GoogleFonts.poppins(
                  fontSize: 40,
                  color: AppColors.principal,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
            ],
          ),
          SizedBox(height: 25),
          Column(
            children: [
              Text(
                'Escreva o nome para sua paroquia. Todos',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Color(0xFFA1C69C),
                ),
              ),
              Text(
                'vão identificar a paroquia pelo',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Color(0xFFA1C69C),
                ),
              ),
              Text(
                'nome que voce vai colocar aqui.',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Color(0xFFA1C69C),
                ),
              ),
            ],
          ),
          SizedBox(height: 25),
          Container(
            width: double.infinity,
            child: IconButton(
              icon: Icon(Icons.photo),
              onPressed: pickAndUploadImage,
            ),
          )
        ],
      ),
    );
  }
}
