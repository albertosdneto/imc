//Shows the chart and its meaning

import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'Database.dart';
import 'DataModel.dart';
import 'common.dart';

class GraficoIMC extends StatefulWidget {
  @override
  _GraficoIMCState createState() => _GraficoIMCState();
}

class MassaPorMedida {
  final String id;
  final int massa;
  final charts.Color color;
  final double imc;

  MassaPorMedida(this.id, this.massa, Color color, this.imc)
      : this.color = new charts.Color(
            r: color.red, g: color.green, b: color.blue, a: color.alpha);
}

class _GraficoIMCState extends State<GraficoIMC> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        //Consulting local database and building chart with the values retrieved
        FutureBuilder<List<ImcMeasurement>>(
          future: DBProvider.db.getAllIMC(),
          builder: (BuildContext context,
              AsyncSnapshot<List<ImcMeasurement>> snapshot) {
            var data = [
              new MassaPorMedida('0', 0, Colors.red, 0.0),
            ];
            if (snapshot.hasData) {
              for (var i = 0; i < snapshot.data.length; i++) {
                if (i == 0) {
                  data[0] = MassaPorMedida(
                      snapshot.data[i].id.toString(),
                      int.parse(double.parse(snapshot.data[i].clientWeight)
                          .ceil()
                          .toString()),
                      Color(seletorDeCores(
                          double.parse(snapshot.data[i].clientImc))),
                      double.parse(snapshot.data[i].clientImc));
                } else {
                  data.add(new MassaPorMedida(
                      snapshot.data[i].id.toString(),
                      int.parse(double.parse(snapshot.data[i].clientWeight)
                          .ceil()
                          .toString()),
                      Color(seletorDeCores(
                          double.parse(snapshot.data[i].clientImc))),
                      double.parse(snapshot.data[i].clientImc)));
                }
              }

              var series = [
                new charts.Series(
                  domainFn: (MassaPorMedida massaData, _) => massaData.id,
                  measureFn: (MassaPorMedida massaData, _) => massaData.imc,
                  colorFn: (MassaPorMedida massaData, _) => massaData.color,
                  id: 'Medida',
                  data: data,
                ),
              ];
              var chart = new charts.BarChart(
                series,
                animate: true,
              );
              var chartWidget = new Padding(
                padding: new EdgeInsets.all(10.0),
                child: new SizedBox(
                  height: 150.0,
                  child: chart,
                ),
              );

              return Column(
                children: <Widget>[
                  Text('Gráfico com IMC Salvo'),
                  chartWidget,
                ],
              );
            } else {
              var data = [
                new MassaPorMedida('0', 0, Colors.red, 0.0),
              ];
              var series = [
                new charts.Series(
                  domainFn: (MassaPorMedida massaData, _) => massaData.id,
                  measureFn: (MassaPorMedida massaData, _) => massaData.imc,
                  colorFn: (MassaPorMedida massaData, _) => massaData.color,
                  id: 'Medida',
                  data: data,
                ),
              ];
              var chart = new charts.BarChart(
                series,
                animate: true,
              );
              var chartWidget = new Padding(
                padding: new EdgeInsets.all(32.0),
                child: new SizedBox(
                  height: 200.0,
                  child: chart,
                ),
              );

              return Center(child: chartWidget);
            }
          },
        ),
        //Card with the meaning of each color.
        Card(
          color: Color(0xFFda64f6),
          child: Text('Obesidade III - Mórbida'),
        ),
        Card(
          color: Color(0xFFf66464),
          child: Text('Obesidade II - Severa'),
        ),
        Card(
          color: Color(0xFFf0a842),
          child: Text('Obesidade I'),
        ),
        Card(
          color: Color(0xFFfada8f),
          child: Text('Acima do ideal'),
        ),
        Card(
          color: Color(0xFF44d185),
          child: Text('Normal'),
        ),
        Card(
          color: Color(0xFF9bdaeb),
          child: Text('Abaixo do ideal'),
        ),
      ],
    );
  }
}
