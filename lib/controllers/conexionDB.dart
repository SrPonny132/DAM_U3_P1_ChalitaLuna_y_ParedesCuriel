import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Conexion {
  static Future<Database> openDB() async {
    Database db = await openDatabase(
      join(await getDatabasesPath(), 'tareas.db'),
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('PRAGMA foreign_keys = ON;');
        await _createTables(db);
      },
    );
    await db.execute('PRAGMA foreign_keys = ON;');
    return db;
  }

  static Future<void> _createTables(Database db) async {
    await db.execute(
      'CREATE TABLE materia (IDMATERIA TEXT PRIMARY KEY, NOMBRE TEXT, SEMESTRE TEXT, DOCENTE TEXT)',
    );
    await db.execute(
      'CREATE TABLE tarea (IDTAREA INTEGER PRIMARY KEY AUTOINCREMENT, IDMATERIA TEXT, F_ENTREGA TEXT, DESCRIPCION TEXT, FOREIGN KEY (IDMATERIA) REFERENCES materia(IDMATERIA) ON DELETE CASCADE ON UPDATE CASCADE)',
    );
  }

  static Future<void> closeDB() async {
    final Database db = await openDB();
    db.close();
  }

  static Future<void> deleteDB() async {
    await deleteDatabase(join(await getDatabasesPath(), 'tareas.db'));
  }


  static Future<int> deleteTarea(int idTarea) async {
    final Database db = await openDB();
    return await db.delete('tarea', where: 'IDTAREA = ?', whereArgs: [idTarea]);
  }

}
