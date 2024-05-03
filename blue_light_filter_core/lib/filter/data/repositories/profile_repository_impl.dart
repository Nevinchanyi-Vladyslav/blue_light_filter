import 'package:blue_light_filter_core/filter/data/entities/profile_entity.dart';
import 'package:sqflite/sqflite.dart';

import '../../domain/repositories/profiles_repository.dart';

class ProfilesRepositoryImpl implements ProfilesRepository {
  final Database _database;
  final String _tableName = 'profiles';

  ProfilesRepositoryImpl(this._database);

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
}
