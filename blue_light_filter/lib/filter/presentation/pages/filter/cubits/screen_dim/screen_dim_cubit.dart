import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../data/repositories/filter_settings_repository_impl.dart';
import '../current_profile/current_profile_cubit.dart';

part 'screen_dim_state.dart';

class ScreenDimCubit extends Cubit<ScreenDimState> {
  ScreenDimCubit(this._settingsRepository, CurrentProfileCubit currentProfileCubit) : super(ScreenDimState.initial()){
    _subscription = currentProfileCubit.stream.listen((CurrentProfileState state) {
      final profile = state.profile;
      if (profile != null) {
        updateDim(
          profile.screenDim,
        );
      }
    });
  }

  final SharedPreferencesFilterSettingsRepository _settingsRepository;
  late final StreamSubscription _subscription;

  void updateDim(int dim) {
    emit(ScreenDimState(dim: dim));
  }

  Future<void> loadScreenDim() async {
    final screenDim = await _settingsRepository.getScreenDim();
    emit(ScreenDimState(dim: screenDim));
  }

  Future<void> saveScreenDim(int value) async {
    await _settingsRepository.setScreenDim(value);
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
