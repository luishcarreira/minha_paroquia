import 'package:flutter/material.dart';
import 'package:flutter_cep2/flutter_cep2.dart';

class CEPTeste extends StatefulWidget {
  const CEPTeste({Key? key}) : super(key: key);

  @override
  State<CEPTeste> createState() => _CEPTesteState();
}

class _CEPTesteState extends State<CEPTeste> {
  final TextEditingController _cep = TextEditingController();
  var CEP = flutter_cep2();
  var result;

  _searchCEP() async {
    try {
      result = await CEP.search(_cep.text);

      print('CEP: ' + result.cep);
      print('Logradouro: ' + result.logradouro);
      print('Complemento: ' + result.complemento!);
      print('Bairro: ' + result.bairro);
      print('Localidade: ' + result.localidade);
      print('UF: ' + result.uf);
      print('Unidade: ' + result.unidade!);
      print('IBGE ' + result.ibge);
      print('GIA: ' + result.gia!);
      print('DDD: ' + result.ddd!);
      print('SIAF: ' + result.siaf!);
    } catch (e) {
      print(e);
    }

    setState(() => {result});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Teste CEP'),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: _cep,
              ),
            ),
            ElevatedButton(
              onPressed: _searchCEP,
              child: Text('Pesquisar'),
            ),
            if (result != null)
              Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      initialValue: result.logradouro,
                      enabled: false,
                    ),
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }
}
