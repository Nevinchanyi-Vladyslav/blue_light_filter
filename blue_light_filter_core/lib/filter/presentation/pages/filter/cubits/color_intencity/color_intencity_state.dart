part of 'color_intencity_cubit.dart';

final class ColorIntencityState extends Equatable {
  final Color color;
  final int intencity;

  const ColorIntencityState({required this.color, required this.intencity});

  factory ColorIntencityState.initial() {
    return const ColorIntencityState(
      color: Colors.white,
      intencity: 0,
    );
  }

  ColorIntencityState copyWith({Color? color, int? intencity}) {
    return ColorIntencityState(
      color: color ?? this.color,
      intencity: intencity ?? this.intencity,
    );
  }

  @override
  List<Object?> get props => [color, intencity];
}
