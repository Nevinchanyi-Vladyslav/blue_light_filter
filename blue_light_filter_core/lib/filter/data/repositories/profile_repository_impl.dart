import 'dart:async';

import 'package:blue_light_filter_core/filter/data/entities/profile_entity.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_db_common/sqflite_db_common.dart';

import '../../domain/repositories/profiles_repository.dart';

class ProfilesRepositoryImpl extends ProfilesRepository implements SQFLiteContract {
  late final Database _database;
  final String _tableName = 'profiles';
  final String _id = 'id';
  final String _name = 'name';
  final String _colorTemperature = 'colorTemperature';
  final String _colorIntensity = 'colorIntensity';
  final String _screenDim = 'screenDim';

  ProfilesRepositoryImpl();

  @override
  Future<void> addProfile(ProfileEntity profile) async {
    await _database.insert(
      _tableName,
      profile.toDbMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> deleteProfile(int id) async {
    await _database.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<List<ProfileEntity>> getProfiles() async {
    final List<Map<String, dynamic>> maps = await _database.query(_tableName);
    return List.generate(maps.length, (i) {
      return ProfileEntity.fromMap(
        maps[i],
      );
    });
  }

  @override
  FutureOr<void> onCreate(Database db, int version) async {
    _database = db;
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
  }
}
