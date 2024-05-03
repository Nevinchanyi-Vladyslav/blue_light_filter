import 'package:blue_light_filter_core/filter/data/entities/profile_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'current_profile_state.dart';

class CurrentProfileCubit extends Cubit<CurrentProfileState> {
  CurrentProfileCubit() : super(CurrentProfileState.initial());

  void updateProfile(ProfileEntity profile) {
    emit(
      CurrentProfileState(
        profile: profile,
      ),
    );
  }
}
