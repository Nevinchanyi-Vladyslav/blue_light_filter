import 'dart:async';

import 'package:blue_light_filter_core/filter/presentation/pages/filter/cubits/current_profile/current_profile_cubit.dart';
import 'package:blue_light_filter_core/filter/service/color_intencity_converter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../../data/repositories/filter_settings_repository_impl.dart';
import '../color_temperature/color_temperature_cubit.dart';

part 'color_intencity_state.dart';

class ColorIntencityCubit extends Cubit<ColorIntencityState> {
  ColorIntencityCubit({
    required ColorTemperatureCubit cubit,
    required this.calc,
    required SharedPreferencesFilterSettingsRepository settingsRepository,
    required CurrentProfileCubit currentProfileCubit,
  })  : _settingsRepository = settingsRepository,
        super(ColorIntencityState.initial()) {
    _subscription = cubit.stream.listen((ColorTemperatureState state) {
      _updateColor(state.color);
    });
    _profileSubscription =
        currentProfileCubit.stream.listen((CurrentProfileState state) {
      final profile = state.profile;
      if (profile != null) {
        updateIntencity(
          profile.colorIntensity,
        );
      }
    });
  }

  final SharedPreferencesFilterSettingsRepository _settingsRepository;
  late final StreamSubscription _subscription;
  late final StreamSubscription _profileSubscription;
  final ColorIntencityConverter calc;
  late Color _currentColor;

  void _updateColor(Color color) {
    _currentColor = color;
    final colorWithIntencity = calc.convertColorIntensity(
        _currentColor, state.intencity.toDouble() / 100);
    emit(
      state.copyWith(
        color: colorWithIntencity,
      ),
    );
  }

  void updateIntencity(int intencity) {
    final colorWithIntencity =
        calc.convertColorIntensity(_currentColor, intencity.toDouble() / 100);
    emit(ColorIntencityState(
      color: colorWithIntencity,
      intencity: intencity,
    ));
  }

  Future<void> loadColorIntensity() async {
    final colorIntensity = await _settingsRepository.getColorIntensity();
    emit(
      state.copyWith(
        intencity: colorIntensity,
      ),
    );
  }

  Future<void> saveColorIntensity(int value) async {
    await _settingsRepository.setColorIntensity(value);
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    _profileSubscription.cancel();
    return super.close();
  }
}
