import 'package:blue_light_filter_core/filter/data/entities/profile_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../domain/repositories/profiles_repository.dart';

part 'profiles_list_state.dart';

class ProfilesListCubit extends Cubit<ProfilesListState> {
  ProfilesListCubit(this._profilesRepository) : super(ProfilesInitial());

  final ProfilesRepository _profilesRepository;

  void loadProfiles() async {
    emit(ProfilesLoading());
    final profiles = await _profilesRepository.getProfiles();
    emit(ProfilesLoaded(profiles));
  }

  Future<void> addProfile(ProfileEntity profile) async {
    await _profilesRepository.addProfile(profile);
    loadProfiles();
  }

  Future<void> deleteProfile(int id) async {
    await _profilesRepository.deleteProfile(id);
    loadProfiles();
  }
}
