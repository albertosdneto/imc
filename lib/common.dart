import 'package:flutter/material.dart';

int seletorDeCores(double valor) {
  if(valor == 0.0)
    return 0xFFFFFFFF;
  if (valor >= 40.0)
    return 0xFFda64f6; //Obesidade Morbida Grau 3
  else {
    if (valor >= 35.0 && valor < 40.0)
      return 0xFFf66464; //Obesidade Severa Grau 2
    else {
      if (valor >= 30.0 && valor < 35.0)
        return 0xFFf0a842; //Obesidade Grau I
      else {
        if (valor >= 25.0 && valor < 30.0)
          return 0xFFfada8f; //Sobrepeso
        else {
          if (valor >= 18.5 && valor < 25.0)
            return 0xFF44d185; //Saudável
          else
            return 0xFF9bdaeb; //Magreza
        }
      }
    }
  }
}

Widget categoriaIMC(double valor) {
  if(valor == 0.0)
    return Text('');
  if (valor >= 40.0)
    return Text('Obesidade Mórbida Grau 3');
  else {
    if (valor >= 35.0 && valor < 40.0)
      return Text('Obesidade Severa Grau 2');
    else {
      if (valor >= 30.0 && valor < 35.0)
        return Text('Obesidade Grau 1');
      else {
        if (valor >= 25.0 && valor < 30.0)
          return Text('Sobrepeso');
        else {
          if (valor >= 18.5 && valor < 25.0)
            return Text('Saudável');
          else
            return Text('Magreza');
        }
      }
    }
  }
}

class ResultadoIMC extends StatelessWidget {
  ResultadoIMC({this.imc});

  double imc;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text('Resultado: '),
        Text(
          imc.toString(),
          style: TextStyle(
              fontSize: 45.0,
              color: Colors.black,
              backgroundColor:
                  Color(seletorDeCores(double.parse(imc.toString())))),
        ),
        categoriaIMC(imc),
      ],
    );
  }
}
