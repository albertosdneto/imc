import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'DataModel.dart';
import 'package:sqflite/sqflite.dart';

//Banco de dados e suas ferramentas.
class DBProvider {
  DBProvider._(); //Singleton: permte só uma instância do banco de dados

  static final DBProvider db = DBProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "IMC_DB.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
          await db.execute("CREATE TABLE IMCTable ("
              "id INTEGER PRIMARY KEY,"
              "client_weight TEXT,"
              "client_height TEXT,"
              "client_IMC TEXT"
              ")");
        });
  }

  newIMCMeasurement(ImcMeasurement newIMCMeasurement) async {
    final db = await database;
    //get the biggest id in the table
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM IMCTable");
    int id = table.first["id"];
    //insert to the table using the new id
    var raw = await db.rawInsert(
        "INSERT Into IMCTable (id,client_weight,client_height,client_IMC)"
            " VALUES (?,?,?,?)",
        [id, newIMCMeasurement.clientWeight, newIMCMeasurement.clientHeight, newIMCMeasurement.clientImc]);
    print("Dados para db: ");
    print(newIMCMeasurement.clientHeight);

    return raw;
  }

//  blockOrUnblock(Client client) async {
//    final db = await database;
//    Client client_IMC = Client(
//        id: client.id,
//        firstName: client.firstName,
//        lastName: client.lastName,
//        client_IMC: !client.client_IMC);
//    var res = await db.update("Client", client_IMC.toMap(),
//        where: "id = ?", whereArgs: [client.id]);
//    return res;
//  }

  updateIMC(ImcMeasurement newIMCMeasurement) async {
    final db = await database;
    var res = await db.update("IMCTable", newIMCMeasurement.toMap(),
        where: "id = ?", whereArgs: [newIMCMeasurement.id]);
    return res;
  }

  getIMC(int id) async {
    final db = await database;
    var res = await db.query("IMCTable", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? ImcMeasurement.fromMap(res.first) : null;
  }


  Future<List<ImcMeasurement>> getAllIMC() async {
    final db = await database;
    var res = await db.query("IMCTable");
    List<ImcMeasurement> list =
    res.isNotEmpty ? res.map((c) => ImcMeasurement.fromMap(c)).toList() : [];
    return list;
  }

  deleteIMCMeasurement(int id) async {
    final db = await database;
    return db.delete("IMCTable", where: "id = ?", whereArgs: [id]);
  }

  deleteAll() async {
    final db = await database;
    db.rawDelete("Delete from IMCTable");
  }
}