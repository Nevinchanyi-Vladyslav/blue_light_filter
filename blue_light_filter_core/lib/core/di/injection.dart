import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import '../../filter/data/database/profile_database.dart';
import '../../filter/data/repositories/filter_settings_repository_impl.dart';
import '../../filter/data/repositories/profile_repository_impl.dart';
import '../../filter/domain/repositories/profiles_repository.dart';

final GetIt sl = GetIt.I;

Future<void> setup() async {
  // External
  sl.registerSingletonAsync<SharedPreferences>(
    () async => await SharedPreferences.getInstance(),
  );
  sl.registerSingletonAsync<Database>(
    () async => ProfileDatabase().init(),
  );

  // Data
  sl.registerSingletonWithDependencies<
      SharedPreferencesFilterSettingsRepository>(
    () => SharedPreferencesFilterSettingsRepository(
      sl<SharedPreferences>(),
    ),
    dependsOn: [
      SharedPreferences,
    ],
  );
  sl.registerSingletonWithDependencies<ProfilesRepository>(
    () => ProfilesRepositoryImpl(
      sl<Database>(),
    ),
    dependsOn: [
      Database,
    ],
  );

  await sl.allReady();
}
