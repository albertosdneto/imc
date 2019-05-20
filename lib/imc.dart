import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Database.dart';
import 'DataModel.dart';

class FormularioIMC extends StatefulWidget {
  @override
  _FormularioIMCState createState() => _FormularioIMCState();
}

class _FormularioIMCState extends State<FormularioIMC> {
  //Identifica cada formulário
  final _formKey = GlobalKey<FormState>();
  String _resultado = '';

  //controladores pros campos de texto do formulário
  TextEditingController alturaController = TextEditingController();
  TextEditingController pesoController = TextEditingController();
  TextEditingController dataController = TextEditingController();

  void _calcular() {
    if (_formKey.currentState.validate()) {
      //TODO função para calcular a soma.

      double altura = double.parse(alturaController.text);
      altura /= 100;
      double peso = double.parse(pesoController.text);

      double imc = peso / (altura * altura);

      FocusScope.of(context).requestFocus(nodeOne);

      setState(() {
        _resultado = imc.toStringAsFixed(1);
        Clipboard.setData(ClipboardData(text: _resultado));
      });

      //mostra mensagem na barra inferior que desaparece depois de um tempo
//      Scaffold.of(context)
//          .showSnackBar(SnackBar(content: Text('Resultado Copiado!')));
    }
  }

  void _limparFormulario() {
    //TODO função que apaga tudo
    alturaController.text = '';
    pesoController.text = '';
    FocusScope.of(context).requestFocus(nodeOne);
    setState(() {
      _resultado = '';
    });
  }

  bool isNumber(String value) {
    if (value == null) {
      return true;
    }
    final n = num.tryParse(value);
    return n != null;
  }

  FocusNode nodeOne = FocusNode();
  FocusNode nodeTwo = FocusNode();
  FocusNode nodeThree = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        children: <Widget>[
          TextFormField(
            autofocus: true,
            focusNode: nodeOne,
            keyboardType:
                TextInputType.numberWithOptions(signed: false, decimal: true),
            decoration: new InputDecoration(
              hintText: 'Peso em kg',
              labelText: 'Peso',
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Por favor, digite algo.';
              }
              if (!isNumber(value)) {
                pesoController.text = '';
                return 'Valor inválido!';
              }
            },
            controller: pesoController,
            onFieldSubmitted: (value) {
              FocusScope.of(context).requestFocus(nodeTwo);
            },
            textInputAction: TextInputAction.next,
          ),
          SizedBox(width: 10, height: 10),
          TextFormField(
            focusNode: nodeTwo,
            keyboardType:
                TextInputType.numberWithOptions(signed: false, decimal: false),
            decoration: new InputDecoration(
              hintText: 'Altura em cm',
              labelText: 'Altura',
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Por favor, digite algo.';
              }
              if (!isNumber(value)) {
                return 'Valor inválido!';
              }
            },
            controller: alturaController,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (value) {
              _calcular();
            },
          ),
          SizedBox(width: 10, height: 10),
          Text('Resultado: ' + _resultado),
          SizedBox(width: 10, height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              RaisedButton(
                onPressed: _calcular,
                child: Text(
                  'Calcular',
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.green,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                splashColor: Color(0xFF44d185),
              ),
              RaisedButton(
                onPressed: _limparFormulario,
                child: Text(
                  'Limpar',
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.blueGrey,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                splashColor: Color(0xFF44d185),
              ),
              RaisedButton(
                child: Text(
                  'Salvar',
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.blue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                splashColor: Color(0xFF44d185),
                onPressed: () async {
                  _calcular();
                  if (!(alturaController.text == '' ||
                      pesoController.text == '')) {
                    ImcMeasurement novo = ImcMeasurement(
                        clientHeight: alturaController.text,
                        clientWeight: pesoController.text,
                        clientImc: _resultado.toString());

                    await DBProvider.db.newIMCMeasurement(novo);
                    setState(() {});
                    Scaffold.of(context)
                        .showSnackBar(SnackBar(content: Text('IMC Salvo!')));
                  } else {
                    Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text('Nada ainda: digite peso e altura.')));
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
