part of 'screen_dim_cubit.dart';

final class ScreenDimState extends Equatable {
  final int dim;

  const ScreenDimState({required this.dim});

  factory ScreenDimState.initial() {
    return const ScreenDimState(
      dim: 0,
    );
  }

  @override
  List<Object?> get props => [dim];
}
