import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ProfileDatabase {
  static final ProfileDatabase _instance = ProfileDatabase._();
  static Database? _database;

  final String _tableName = 'profiles';
  final String _id = 'id';
  final String _name = 'name';
  final String _colorTemperature = 'colorTemperature';
  final String _colorIntensity = 'colorIntensity';
  final String _screenDim = 'screenDim';

  ProfileDatabase._();

  factory ProfileDatabase() {
    return _instance;
  }

  Future<Database> get db async {
    if (_database != null) {
      return _database!;
    }
    _database = await init();
    return _database!;
  }

  Future<Database> init() async {
    final directory = await getApplicationDocumentsDirectory();
    String dbPath = join(directory.path, 'database.db');
    var database = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE $_tableName('
          '$_id INTEGER PRIMARY KEY AUTOINCREMENT,'
          '$_name TEXT,'
          '$_colorTemperature INTEGER,'
          '$_colorIntensity INTEGER,'
          '$_screenDim INTEGER'
          ')',
        );
        // Insert default profiles
        await db.insert(
          _tableName,
          {
            _name: 'Default',
            _colorTemperature: 1500,
            _colorIntensity: 40,
            _screenDim: 10,
          },
        );
        await db.insert(
          _tableName,
          {
            _name: 'Bed reading',
            _colorTemperature: 1000,
            _colorIntensity: 50,
            _screenDim: 50,
          },
        );
      },
    );
    return database;
  }
}
