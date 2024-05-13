import '../models/materia.dart';
import 'conexionDB.dart';
import 'package:sqflite/sqflite.dart';

class MateriaDB {
  static Future<int> insert(Materia materia) async {
    final Database db = await Conexion.openDB();
    return await db.insert('materia', materia.toMap(),
        conflictAlgorithm: ConflictAlgorithm.fail);
  }

  static Future<List<Materia>> getMaterias() async {
    final Database db = await Conexion.openDB();
    final List<Map<String, dynamic>> maps = await db.query('materia');
    return List.generate(maps.length, (i) {
      return Materia(
        idMateria: maps[i]['IDMATERIA'],
        nombre: maps[i]['NOMBRE'],
        semestre: maps[i]['SEMESTRE'],
        docente: maps[i]['DOCENTE'],
      );
    });
  }

  static Future<int> update(Materia materia) async {
    final Database db = await Conexion.openDB();
    return await db.update('materia', materia.toMap(),
        where: 'IDMATERIA = ?', whereArgs: [materia.idMateria]);
  }

  static Future<int> delete(String idMateria) async {
    final Database db = await Conexion.openDB();
    return await db.delete('materia', where: 'IDMATERIA = ?', whereArgs: [idMateria]);
  }

  static Future<void> deleteAll() async {
    final Database db = await Conexion.openDB();
    await db.delete('materia');
  }
}
