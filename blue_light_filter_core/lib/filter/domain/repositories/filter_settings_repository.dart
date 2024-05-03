abstract class FilterSettingsRepository {
  Future<int> getColorTemperature();
  Future<void> setColorTemperature(int value);

  Future<int> getColorIntensity();
  Future<void> setColorIntensity(int value);

  Future<int> getScreenDim();
  Future<void> setScreenDim(int value);
}