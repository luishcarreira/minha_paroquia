import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:minha_paroquia/core/app/app_colors.dart';
import 'package:minha_paroquia/core/pages/paroquia/cadastros/alterar/paroquia_cep_alterar_page.dart';
import 'package:minha_paroquia/core/service/auth/auth_firebase_service.dart';
import 'package:provider/provider.dart';

class ParoquiaImagemAlterarPage extends StatefulWidget {
  final String ref_paroquia;
  final String foto;
  const ParoquiaImagemAlterarPage({
    Key? key,
    required this.ref_paroquia,
    required this.foto,
  }) : super(key: key);

  @override
  State<ParoquiaImagemAlterarPage> createState() =>
      _ParoquiaImagemAlterarPageState();
}

class _ParoquiaImagemAlterarPageState extends State<ParoquiaImagemAlterarPage> {
  @override
  Widget build(BuildContext context) {
    AuthFirebaseService firebase = Provider.of<AuthFirebaseService>(
      context,
      listen: false,
    );

    return FutureBuilder<DocumentSnapshot>(
      future: firebase.firestore
          .collection('paroquia')
          .doc(widget.ref_paroquia)
          .get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;

          final TextEditingController _ctrlApelido = TextEditingController(
            text: data['apelido'],
          );

          final FirebaseStorage storage = FirebaseStorage.instance;
          final TextEditingController _nome =
              TextEditingController(text: data['nome']);
          String ref = '';

          Future<XFile?> getImage() async {
            final ImagePicker _picker = ImagePicker();
            XFile? image = await _picker.pickImage(source: ImageSource.gallery);
            return image;
          }

          Future<UploadTask> upload(String path) async {
            File file = File(path);
            try {
              //storage.ref(data['ref_imagem']).delete();
              ref = 'images/img-${data['codigo']}.jpg';
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
                    final progress = 100.0 *
                        (taskSnapshot.bytesTransferred /
                            taskSnapshot.totalBytes);
                    print("Upload is $progress% complete.");
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
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Text('Erro ao alterar imagem'),
                backgroundColor: Colors.red[400],
              ));
            }
          }

          _onSubmit() async {
            try {
              firebase.firestore
                  .collection('paroquia')
                  .doc(widget.ref_paroquia)
                  .update({
                'nome': _nome.text,
                'ref_imagem': ref == '' ? data['ref_imagem'] : ref,
              });

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ParoquiaCEPAlterarPage(
                    ref_paroquia: widget.ref_paroquia,
                  ),
                ),
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Erro ao alterar informações'),
                  backgroundColor: Colors.red[400],
                ),
              );
            }
          }

          return Scaffold(
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(80),
              child: SafeArea(
                top: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
            body: ListView(
              children: [
                SizedBox(height: 40),
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
                          'Alterar Imagem',
                          style: TextStyle(color: AppColors.principal),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 40, right: 40),
                  child: Column(
                    children: [
                      Text(
                        'Nome da sua paróquia.',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Color.fromARGB(255, 101, 104, 101),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Material(
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
                          ),
                        ),
                      ),
                    ],
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
                              'Atualizar',
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

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
