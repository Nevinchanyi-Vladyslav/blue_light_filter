import 'dart:async';

import 'package:blue_light_filter_core/filter/presentation/pages/filter/cubits/color_temperature_cubit/color_temperature_cubit.dart';
import 'package:blue_light_filter_core/filter/service/color_intencity_calc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'color_intencity_state.dart';

class ColorIntencityCubit extends Cubit<ColorIntencityState> {
  ColorIntencityCubit({
    required ColorTemperatureCubit cubit,
    required this.calc,
  }) : super(ColorIntencityState.initial()) {
    _subscription = cubit.stream.listen((ColorTemperatureState state) {
      _updateColor(state.color);
    });
  }

  late final StreamSubscription _subscription;
  final ColorIntencityCalc calc;
  late Color _currentColor;

  void _updateColor(Color color) {
    _currentColor = color;
    final colorWithIntencity =
        calc.intensityToColor(_currentColor, state.intencity);
    emit(
      state.copyWith(
        color: colorWithIntencity,
      ),
    );
  }

  void updateIntencity(int intencity) {
    final colorWithIntencity = calc.intensityToColor(_currentColor, intencity);
    emit(ColorIntencityState(
      color: colorWithIntencity,
      intencity: intencity,
    ));
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
