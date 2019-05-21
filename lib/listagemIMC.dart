import 'package:flutter/material.dart';
import 'Database.dart';
import 'DataModel.dart';
import 'common.dart';

class ListagemIMC extends StatefulWidget {
  @override
  _ListagemIMCState createState() => _ListagemIMCState();
}

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

              return Card(
                color: Color(seletorDeCores(double.parse(item.clientImc))),
                child: ListTile(
                  title: Text(item.clientWeight.toString() + ' kg'),
                  leading: Text('IMC\n' + item.clientImc.toString()),
                  subtitle: Text(item.clientHeight.toString() + ' cm'),
                  trailing: FlatButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: new Text("Deletar Item"),
                              content: new Text("Apagar Permanentemente?"),
                              actions: <Widget>[
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
