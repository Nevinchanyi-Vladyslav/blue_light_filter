import 'package:blue_light_filter_core/filter/domain/repositories/profiles_repository.dart';
import 'package:blue_light_filter_core/filter/presentation/pages/filter/components/color_temperature.dart';
import 'package:blue_light_filter_core/filter/presentation/pages/filter/components/intensity.dart';
import 'package:blue_light_filter_core/filter/presentation/pages/filter/components/profiles_list.dart';
import 'package:blue_light_filter_core/filter/presentation/pages/filter/components/screen_dim.dart';
import 'package:blue_light_filter_core/filter/presentation/pages/filter/cubits/color_intencity/color_intencity_cubit.dart';
import 'package:blue_light_filter_core/filter/presentation/pages/filter/cubits/current_profile/current_profile_cubit.dart';
import 'package:blue_light_filter_core/filter/service/color_intencity_converter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overlay_service/overlay_service.dart';

import '../../../../core/di/injection.dart';
import '../../../data/repositories/filter_settings_repository_impl.dart';
import 'cubits/color_temperature/color_temperature_cubit.dart';
import 'cubits/profiles_list/profiles_list_cubit.dart';
import 'cubits/screen_dim/screen_dim_cubit.dart';

class FilterPageProvider extends StatelessWidget {
  const FilterPageProvider({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsRepository = sl<SharedPreferencesFilterSettingsRepository>();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => CurrentProfileCubit(),
        ),
        BlocProvider(
          create: (context) => ColorTemperatureCubit(
            settingsRepository,
            context.read<CurrentProfileCubit>(),
          )..loadColorTemperature(),
        ),
        BlocProvider(
          create: (context) => ColorIntencityCubit(
            cubit: context.read<ColorTemperatureCubit>(),
            calc: ColorIntencityConverter(),
            settingsRepository: settingsRepository,
            currentProfileCubit: context.read<CurrentProfileCubit>(),
          )..loadColorIntensity(),
        ),
        BlocProvider(
          create: (context) => ScreenDimCubit(
            settingsRepository,
            context.read<CurrentProfileCubit>(),
          )..loadScreenDim(),
        ),
        BlocProvider(
          create: (context) => ProfilesListCubit(
            sl<ProfilesRepository>(),
          )..loadProfiles(),
        ),
      ],
      child: const _FilterPage(),
    );
  }
}

class _FilterPage extends StatefulWidget {
  const _FilterPage();

  @override
  State<_FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<_FilterPage> {
  var overlayShowing = false;

  @override
  void initState() {
    super.initState();
    OverlayService.isActive().then((value) {
      overlayShowing = value;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CurrentProfileCubit, CurrentProfileState>(
      listener: (context, state) async {
        final intecityCubit = context.read<ColorIntencityCubit>();
        final dimCubit = context.read<ScreenDimCubit>();
        if(await OverlayService.isActive()) {
          await OverlayService.updateColor(intecityCubit.state.color);
          await OverlayService.updateDim(Colors.black.withAlpha((dimCubit.state.dim / 100 * 255).clamp(0, 255).toInt()));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Blue Light Filter'),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            final currentColor =
                context.read<ColorIntencityCubit>().state.color;
            final dim = context.read<ScreenDimCubit>().state.dim;
            final blackAlpha = (dim / 100 * 255).clamp(0, 255).toInt();
            onStartClick(currentColor, Colors.black.withAlpha(blackAlpha));
          },
          child: Icon(
            overlayShowing ? Icons.pause : Icons.play_arrow,
          ),
        ),
        body: const SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 16.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProfilesList(),
                  ColorTemperature(),
                  Intensity(),
                  ScreenDim(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onStartClick(Color color, Color blackColor) async {
    bool status = await OverlayService.checkOverlayPermission();
    if (!status) {
      await OverlayService.requestPermission();
    }
    overlayShowing = await OverlayService.isActive();
    if (overlayShowing) {
      await OverlayService.stopOverlay();
    } else {
      await OverlayService.startOverlay(color, blackColor);
    }
    overlayShowing = !overlayShowing;
    setState(() {});
  }
}
