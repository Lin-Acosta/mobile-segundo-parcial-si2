import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/incidente_local.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('app_database.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const textNullable = 'TEXT';
    const boolType = 'BOOLEAN NOT NULL';

    await db.execute('''
CREATE TABLE incidentes (
  id $idType,
  coordenadagps $textType,
  descripcion $textNullable,
  fecha $textType,
  estado $textType,
  is_synced $boolType
)
''');
  }

  Future<IncidenteLocal> create(IncidenteLocal incidente) async {
    final db = await instance.database;
    final id = await db.insert('incidentes', incidente.toMap());
    return incidente.copyWith(id: id);
  }

  Future<List<IncidenteLocal>> readAllUnsyncedIncidentes() async {
    final db = await instance.database;
    final result = await db.query(
      'incidentes',
      where: 'is_synced = ?',
      whereArgs: [0],
    );

    return result.map((json) => IncidenteLocal.fromMap(json)).toList();
  }

  Future<int> update(IncidenteLocal incidente) async {
    final db = await instance.database;
    return db.update(
      'incidentes',
      incidente.toMap(),
      where: 'id = ?',
      whereArgs: [incidente.id],
    );
  }

  Future<void> markAsSynced(int id) async {
    final db = await instance.database;
    await db.update(
      'incidentes',
      {'is_synced': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
