part of 'current_profile_cubit.dart';

final class CurrentProfileState extends Equatable {
  final ProfileEntity? profile;

  factory CurrentProfileState.initial() => const CurrentProfileState(
        profile: null,
      );

  const CurrentProfileState({required this.profile});

  @override
  List<Object?> get props => [profile];
}
