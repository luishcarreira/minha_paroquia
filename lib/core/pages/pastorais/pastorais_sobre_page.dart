import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minha_paroquia/core/app/app_colors.dart';
import 'package:minha_paroquia/core/components/card_evento_page.dart';
import 'package:minha_paroquia/core/pages/chat/chat_message_page.dart';
import 'package:minha_paroquia/core/pages/pastorais/eventos/alterar_evento_page.dart';
import 'package:minha_paroquia/core/pages/pastorais/eventos/cadastro_evento_page.dart';
import 'package:minha_paroquia/core/service/auth/auth_firebase_service.dart';
import 'package:provider/provider.dart';

class PastoraisSobrePage extends StatefulWidget {
  final String refParoquia;
  final String codigo_pastoral;
  final String imagem;
  final String nome;
  const PastoraisSobrePage({
    Key? key,
    required this.codigo_pastoral,
    required this.imagem,
    required this.nome,
    required this.refParoquia,
  }) : super(key: key);

  @override
  State<PastoraisSobrePage> createState() => _PastoraisSobrePageState();
}

class _PastoraisSobrePageState extends State<PastoraisSobrePage> {
  void _onDelete(String doc) async {
    AuthFirebaseService firebase =
        Provider.of<AuthFirebaseService>(context, listen: false);

    firebase.firestore.collection('eventos').doc(doc).delete();
  }

  @override
  Widget build(BuildContext context) {
    AuthFirebaseService firebase =
        Provider.of<AuthFirebaseService>(context, listen: false);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(330),
          child: Container(
            color: AppColors.principal,
            child: SafeArea(
              top: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      PopupMenuButton<String>(
                        icon: Icon(
                          Icons.more_vert,
                          color: Colors.white,
                        ),
                        padding: EdgeInsets.all(0),
                        onSelected: (value) {
                          if (value == 'chat') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ChatMessagePage(
                                  codigo_pastoral: widget.codigo_pastoral,
                                  imagem: widget.imagem,
                                  nome: widget.nome,
                                ),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CadastroEventoPage(
                                  codigo_pastoral: widget.codigo_pastoral,
                                ),
                              ),
                            );
                          }
                        },
                        itemBuilder: (BuildContext contesxt) {
                          return [
                            PopupMenuItem(
                              child: Text("Chat"),
                              value: 'chat',
                            ),
                            PopupMenuItem(
                              child: Text("Adicionar Evento"),
                              value: 'evento',
                            ),
                          ];
                        },
                      ),
                    ],
                  ),
                  Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 150,
                          child: CircleAvatar(
                            radius: 80,
                            backgroundImage: NetworkImage(widget.imagem),
                          ),
                        ),
                        Text(
                          widget.nome,
                          style: GoogleFonts.poppins(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  TabBar(
                    labelColor: Colors.black54,
                    indicatorColor: Colors.white,
                    indicator: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(50), // Creates border
                        color: Colors.white),
                    tabs: <Widget>[
                      Tab(
                        text: 'Eventos',
                      ),
                      Tab(
                        text: 'Sobre',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            StreamBuilder(
              stream: firebase.firestore
                  .collection('eventos')
                  .where('cod_pastoral', isEqualTo: widget.codigo_pastoral)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Something went wrong'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Ainda não temos nenhum evento.',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          color: AppColors.principal,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                      Text(
                        'Clique aqui para adicionar um!',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          color: AppColors.principal,
                          fontWeight: FontWeight.bold,
                          height: 1.2,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CadastroEventoPage(
                                codigo_pastoral: widget.codigo_pastoral,
                              ),
                            ),
                          );
                        },
                        icon: Icon(Icons.add),
                        label: Text('Adicionar'),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            AppColors.principal,
                          ),
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                            Radius.circular(30.0),
                          ))),
                        ),
                      )
                    ],
                  );
                } else {
                  return ListView(
                    children: snapshot.data!.docs.map(
                      (DocumentSnapshot document) {
                        Map<String, dynamic> data =
                            document.data()! as Map<String, dynamic>;

                        return Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  border: Border.fromBorderSide(
                                    BorderSide(
                                      color: Color(0xFFE1E1E6),
                                    ),
                                  ),
                                  color: Color(0xFFFFFFFF),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ListTile(
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        data['nome'],
                                        style: GoogleFonts.poppins(
                                          fontSize: 25,
                                          color: AppColors.principal,
                                          fontWeight: FontWeight.w900,
                                          height: 1.2,
                                        ),
                                      ),
                                      Text(
                                        'Data: ${data['data']}',
                                        style: TextStyle(
                                            fontSize: 13, color: Colors.grey),
                                      )
                                    ],
                                  ),
                                  subtitle: Padding(
                                    padding: const EdgeInsets.only(top: 15),
                                    child: Text(data['descricao']),
                                  ),
                                  trailing: PopupMenuButton<String>(
                                    icon: Icon(
                                      Icons.more_vert,
                                      color: AppColors.principal,
                                    ),
                                    padding: EdgeInsets.all(0),
                                    onSelected: (value) {
                                      if (value == 'editar') {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => AlterarEventoPage(
                                              refEvento: data['ref_evento'],
                                            ),
                                          ),
                                        );
                                      } else {
                                        _onDelete(data['ref_evento']);
                                      }
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
                            ],
                          ),
                        );
                      },
                    ).toList(),
                  );
                }
              },
            ),
            StreamBuilder(
              stream: firebase.firestore
                  .collection('paroquia')
                  .doc(widget.refParoquia)
                  .collection('pastorais')
                  .where('codigo_pastoral', isEqualTo: widget.codigo_pastoral)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Something went wrong'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                return ListView(
                  children: snapshot.data!.docs.map(
                    (DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;

                      return Padding(
                        padding: const EdgeInsets.all(50),
                        child: Card(
                          elevation: 4,
                          child: Container(
                            margin: EdgeInsets.all(100),
                            padding: EdgeInsets.all(20),
                            child: Column(
                              children: <Widget>[
                                Text(data['sobre']),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
