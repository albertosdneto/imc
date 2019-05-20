import 'package:flutter/material.dart';
import 'Database.dart';
import 'DataModel.dart';

class ListagemIMC extends StatefulWidget {
  @override
  _ListagemIMCState createState() => _ListagemIMCState();
}

var _corFundo = 0x88FF0000;

class _ListagemIMCState extends State<ListagemIMC> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ImcMeasurement>>(
      future: DBProvider.db.getAllIMC(),
      builder:
          (BuildContext context, AsyncSnapshot<List<ImcMeasurement>> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              ImcMeasurement item = snapshot.data[index];
              var temp = double.parse(item.clientImc);

              if (temp >= 40.0)
                _corFundo = 0xFFda64f6;
              else {
                if (temp >= 35.0 && temp < 40.0)
                  _corFundo = 0xFFf66464;
                else {
                  if (temp >= 30.0 && temp < 35.0)
                    _corFundo = 0xFFf0a842;
                  else {
                    if (temp >= 25.0 && temp < 30.0)
                      _corFundo = 0xFFfada8f;
                    else {
                      if (temp >= 18.5 && temp < 25.0)
                        _corFundo = 0xFF44d185;
                      else
                        _corFundo = 0xFF9bdaeb;
                    }
                  }
                }
              }

              return Card(
                color: Color(_corFundo),
                child: ListTile(
                  title: Text(item.clientWeight.toString() + ' kg'),
                  leading: Text('IMC\n' + item.clientImc.toString()),
                  subtitle: Text(item.clientHeight.toString() + ' cm'),
                  trailing: FlatButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            // return object of type Dialog
                            return AlertDialog(
                              title: new Text("Deletar Item"),
                              content: new Text("Apagar Permanentemente?"),
                              actions: <Widget>[
                                // usually buttons at the bottom of the dialog
                                new FlatButton(
                                    onPressed: () async {
                                      await DBProvider.db
                                          .deleteIMCMeasurement(item.id);
                                      setState(() {});
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Apagar')),

                                new FlatButton(
                                  child: new Text("Cancelar"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );

                        setState(() {});
                      },
                      child: Icon(Icons.delete)),
                ),
              );
            },
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
