import '../models/tarea.dart';
import 'conexion.dart';
import 'package:sqflite/sqflite.dart';

class TareaDB {
  static Future<int> insert(Tarea tarea) async {
    final Database db = await Conexion.openDB();
    return await db.insert('tarea', tarea.toMap(),
        conflictAlgorithm: ConflictAlgorithm.fail);
  }

  static Future<List<Tarea>> getTareas() async {
    final Database db = await Conexion.openDB();
    final List<Map<String, dynamic>> maps = await db.query('tarea');
    return List.generate(maps.length, (i) {
      return Tarea(
        idTarea: maps[i]['IDTAREA'],
        idMateria: maps[i]['IDMATERIA'],
        fechaEntrega: maps[i]['F_ENTREGA'],
        descripcion: maps[i]['DESCRIPCION'],
      );
    });
  }

  static Future<int> update(Tarea tarea) async {
    final Database db = await Conexion.openDB();
    return await db.update('tarea', tarea.toMap(),
        where: 'IDTAREA = ?', whereArgs: [tarea.idTarea]);
  }

  static Future<int> delete(int idTarea) async {
    final Database db = await Conexion.openDB();
    return await db.delete('tarea', where: 'IDTAREA = ?', whereArgs: [idTarea]);
  }

  static Future<void> deleteAll() async {
    final Database db = await Conexion.openDB();
    await db.delete('tarea');
  }

  static Future<List<Tarea>> getTareasHoy() async {
    final Database db = await Conexion.openDB();
    final List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT * FROM tarea WHERE F_ENTREGA >= date("now") ORDER BY F_ENTREGA');
    return List.generate(maps.length, (i) {
      return Tarea(
        idTarea: maps[i]['IDTAREA'],
        idMateria: maps[i]['IDMATERIA'],
        fechaEntrega: maps[i]['F_ENTREGA'],
        descripcion: maps[i]['DESCRIPCION'],
      );
    });
  }
}
