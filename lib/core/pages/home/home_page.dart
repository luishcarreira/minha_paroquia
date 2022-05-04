import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:minha_paroquia/core/app/app_colors.dart';
import 'package:minha_paroquia/core/pages/explorar/explorar_page.dart';
import 'package:minha_paroquia/core/pages/paroquia/minhas_paroquias_page.dart';
import 'package:minha_paroquia/core/pages/user/usuario_perfil_page.dart';
import 'package:minha_paroquia/core/service/auth/auth_firebase_service.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int paginaAtual = 0;
  late PageController pc;
  List<String> paroquiaCod = [''];

  @override
  void initState() {
    initParoquia();
    super.initState();
    pc = PageController(initialPage: paginaAtual);
  }

  void initParoquia() {
    AuthFirebaseService firebase =
        Provider.of<AuthFirebaseService>(context, listen: false);
    Stream<QuerySnapshot> _minhasParoquias = firebase.firestore
        .collection('paroquia')
        .where('participantes', arrayContains: firebase.usuario!.uid)
        .snapshots();

    _minhasParoquias.forEach((element) {
      element.docs.asMap().forEach((index, data) {
        paroquiaCod.add(element.docs[index]['codigo']);
        paroquiaCod.remove(element.docs[index]['codigo']);
      });
    });
  }

  setPaginaAtual(pagina) {
    setState(() {
      initParoquia();
      paginaAtual = pagina;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pc,
        children: [
          MinhasParoquiasPage(),
          ExplorarPage(
            paroquiaCod: paroquiaCod,
          ),
          UsuarioPerfilPage()
        ],
        onPageChanged: setPaginaAtual,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: paginaAtual,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.church), label: 'Paróquias'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Explorar'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Conta'),
        ],
        onTap: (pagina) {
          pc.animateToPage(
            pagina,
            duration: Duration(milliseconds: 400),
            curve: Curves.ease,
          );
        },
        selectedItemColor: AppColors.principal,
      ),
    );
  }
}
