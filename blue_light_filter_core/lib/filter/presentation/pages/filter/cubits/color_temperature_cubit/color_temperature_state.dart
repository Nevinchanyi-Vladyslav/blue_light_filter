part of 'color_temperature_cubit.dart';

final class ColorTemperatureState extends Equatable {
  final int temperature;
  final Color color;

  const ColorTemperatureState({required this.temperature, required this.color});

  factory ColorTemperatureState.initial() {
    return const ColorTemperatureState(
      temperature: 1000,
      color: Colors.white,
    );
  }

  @override
  List<Object?> get props => [temperature, color];
}
