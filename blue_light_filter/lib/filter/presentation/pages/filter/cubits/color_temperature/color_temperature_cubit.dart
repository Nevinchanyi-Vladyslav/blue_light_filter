import 'dart:async';

import 'package:blue_light_filter/filter/presentation/pages/filter/cubits/current_profile/current_profile_cubit.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tempature_color_converter/tempature_color_converter.dart';

import '../../../../../data/repositories/filter_settings_repository_impl.dart';

part 'color_temperature_state.dart';

class ColorTemperatureCubit extends Cubit<ColorTemperatureState> {
  ColorTemperatureCubit(
    this._settingsRepository,
    CurrentProfileCubit currentProfileCubit,
  ) : super(ColorTemperatureState.initial()) {
    _subscription =
        currentProfileCubit.stream.listen((CurrentProfileState state) {
      final profile = state.profile;
      if (profile != null) {
        updateTemperature(
          profile.colorTemperature,
        );
      }
    });
  }

  final SharedPreferencesFilterSettingsRepository _settingsRepository;
  late final StreamSubscription _subscription;

  void updateTemperature(int temperature) {
    final newColor =
        TempatureColorConverter.temperatureToColor(temperature.toDouble());
    emit(
      ColorTemperatureState(
        temperature: temperature,
        color: newColor,
      ),
    );
  }

  Future<void> loadColorTemperature() async {
    final temperature = await _settingsRepository.getColorTemperature();
    final newColor =
        TempatureColorConverter.temperatureToColor(temperature.toDouble());
    emit(ColorTemperatureState(temperature: temperature, color: newColor));
  }

  Future<void> saveColorTemperature(int value) async {
    await _settingsRepository.setColorTemperature(value);
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
