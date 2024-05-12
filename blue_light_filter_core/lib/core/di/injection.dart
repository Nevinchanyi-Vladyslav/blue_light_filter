import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../filter/data/repositories/filter_settings_repository_impl.dart';
import '../../filter/data/repositories/profile_repository_impl.dart';
import '../../filter/domain/repositories/profiles_repository.dart';

final GetIt sl = GetIt.I;

Future<void> setup() async {
  // External
  sl.registerSingletonAsync<SharedPreferences>(
    () async => await SharedPreferences.getInstance(),
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
    () => ProfilesRepositoryImpl(),
  );

  await sl.allReady();
}
