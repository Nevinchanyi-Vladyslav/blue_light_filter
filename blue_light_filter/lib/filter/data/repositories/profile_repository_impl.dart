import 'dart:async';

import 'package:blue_light_filter/filter/data/entities/profile_entity.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_db_common/sqflite_db_common.dart';

import '../../domain/repositories/profiles_repository.dart';

class ProfilesRepositoryImpl extends ProfilesRepository implements SQFLiteContract {
  //late final Database _database;

  final String _tableName = 'profiles';
  final String _id = 'id';
  final String _name = 'name';
  final String _colorTemperature = 'color_temperature';
  final String _colorIntensity = 'color_intensity';
  final String _screenDim = 'screen_dim';

  ProfilesRepositoryImpl();

  @override
  Future<void> addProfile(ProfileEntity profile) async {
    await database.insert(
      _tableName,
      profile.toDbMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> deleteProfile(int id) async {
    await database.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<List<ProfileEntity>> getProfiles() async {
    final List<Map<String, dynamic>> maps = await database.query(_tableName);
    return maps.map((e) => ProfileEntity.fromMap(e)).toList(); 
  }

  @override
  FutureOr<void> onCreate(Database db, int version) async {
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
            _name: 'default'.tr(),
            _colorTemperature: 1500,
            _colorIntensity: 40,
            _screenDim: 10,
          },
        );
        await db.insert(
          _tableName,
          {
            _name: 'bed_reading'.tr(),
            _colorTemperature: 1000,
            _colorIntensity: 50,
            _screenDim: 50,
          },
        );
  }
  
  @override
  late final Database database;
}
