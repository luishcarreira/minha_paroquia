import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:minha_paroquia/core/pages/home/home_page.dart';
import 'package:minha_paroquia/core/service/auth/auth_firebase_service.dart';
import 'package:provider/provider.dart';

class CheckBoxExample extends StatefulWidget {
  final String refParoquia;
  const CheckBoxExample({Key? key, required this.refParoquia})
      : super(key: key);

  @override
  State<CheckBoxExample> createState() => _CheckBoxExampleState();
}

class _CheckBoxExampleState extends State<CheckBoxExample> {
  List multipleSelected = [];
  List usuarios = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initList();
  }

  initList() {
    final uid = context.read<AuthFirebaseService>().usuario!.uid;

    context
        .read<AuthFirebaseService>()
        .firestore
        .collection('usuarios')
        .get()
        .then(
          (value) => {
            if (value.docs.isNotEmpty)
              {
                value.docs.asMap().forEach(
                  (index, data) {
                    setState(() {
                      usuarios.add(
                        {
                          'uid': value.docs[index]['uid'],
                          'value': false,
                          'nome': value.docs[index]['nome']
                        },
                      );
                    });
                  },
                ),
              }
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    AuthFirebaseService firebase =
        Provider.of<AuthFirebaseService>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Selecione os usuarios'),
        actions: [
          IconButton(
              onPressed: () async {
                print(usuarios);
                usuarios.forEach((element) {
                  Map<String, dynamic> user = element as Map<String, dynamic>;
                  user.forEach((key, value) {
                    if (user['value'] == true) {
                      firebase.firestore
                          .collection('paroquia')
                          .doc(widget.refParoquia)
                          .update(
                        {
                          'admin': FieldValue.arrayUnion([user['uid']]),
                          'participantes': FieldValue.arrayUnion([user['uid']]),
                        },
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => HomePage(),
                        ),
                      );
                    }
                  });
                });
              },
              icon: Icon(Icons.check))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            if (usuarios != [])
              Column(
                children: List.generate(
                  usuarios.length,
                  (index) => CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    title: Text(
                      usuarios[index]["nome"] ?? '',
                      style: const TextStyle(
                        fontSize: 16.0,
                        color: Colors.black,
                      ),
                    ),
                    value: usuarios[index]["value"] ?? false,
                    onChanged: (value) {
                      setState(() {
                        usuarios[index]["value"] = value;
                        if (multipleSelected.contains(usuarios[index])) {
                          multipleSelected.remove(usuarios[index]);
                        } else {
                          multipleSelected.add(usuarios[index]);
                        }
                      });
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
