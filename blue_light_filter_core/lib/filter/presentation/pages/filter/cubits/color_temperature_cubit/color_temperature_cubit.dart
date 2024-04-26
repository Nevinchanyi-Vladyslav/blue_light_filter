import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tempature_color_converter/tempature_color_converter.dart';

part 'color_temperature_state.dart';

class ColorTemperatureCubit extends Cubit<ColorTemperatureState> {
  ColorTemperatureCubit() : super(ColorTemperatureState.initial());

  void updateTemperature(int temperature) {
    final newColor = TempatureColorConverter.temperatureToColor(temperature.toDouble());
    emit(
      ColorTemperatureState(temperature: temperature, color: newColor),
    );
  }
}
