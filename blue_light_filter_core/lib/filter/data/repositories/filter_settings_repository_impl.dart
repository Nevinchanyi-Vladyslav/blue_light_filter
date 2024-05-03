import 'package:blue_light_filter_core/filter/domain/repositories/filter_settings_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesFilterSettingsRepository extends FilterSettingsRepository{
  static const String _colorTemperatureKey = 'colorTemperature';
  static const String _colorIntensityKey = 'colorIntensity';
  static const String _screenDimKey = 'screenDim';

  final SharedPreferences _preferences;

  SharedPreferencesFilterSettingsRepository(this._preferences);

   @override
  Future<int> getColorTemperature() async {
    return _preferences.getInt(_colorTemperatureKey) ?? 1000;
  }

  @override
  Future<void> setColorTemperature(int value) async {
    await _preferences.setInt(_colorTemperatureKey, value);
  }

  @override
  Future<int> getColorIntensity() async {
    return _preferences.getInt(_colorIntensityKey) ?? 30;
  }

  @override
  Future<void> setColorIntensity(int value) async {
    await _preferences.setInt(_colorIntensityKey, value);
  }

  @override
  Future<int> getScreenDim() async {
    return _preferences.getInt(_screenDimKey) ?? 0;
  }

  @override
  Future<void> setScreenDim(int value) async {
    await _preferences.setInt(_screenDimKey, value);
  }
}