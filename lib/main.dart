import 'package:flutter/material.dart';
import 'imc.dart';
import 'listagemIMC.dart';
import 'graficoIMC.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IMC para Adulto',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(tabs: [
              Tab(icon: Icon(Icons.insert_chart)),
              Tab(icon: Icon(Icons.list)),
              Tab(icon: Icon(Icons.edit)),
            ]),
            title: ListView(
              children: <Widget>[
                Text('Controle de IMC'),
                Text('App demonstrativo.',
                  textScaleFactor: 0.6,
                ),
              ],
            ),
          ),
          body: TabBarView(children: [
            GraficoIMC(),
            ListagemIMC(),
            FormularioIMC(),
          ]),
        ),
      ),
    );
  }
}
