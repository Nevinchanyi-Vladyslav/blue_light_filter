import 'package:blue_light_filter/filter/data/entities/profile_entity.dart';

abstract class ProfilesRepository {
  Future<List<ProfileEntity>> getProfiles();

  Future<void> addProfile(
    ProfileEntity profile,
  );

  Future<void> deleteProfile(int id);
}
