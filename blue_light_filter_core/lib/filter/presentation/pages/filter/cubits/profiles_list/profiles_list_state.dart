part of 'profiles_list_cubit.dart';

sealed class ProfilesListState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class ProfilesInitial extends ProfilesListState {}

final class ProfilesLoading extends ProfilesListState {}

final class ProfilesLoaded extends ProfilesListState {
  final List<ProfileEntity> profiles;

  ProfilesLoaded(this.profiles);

  @override
  List<Object?> get props => [profiles];
}
