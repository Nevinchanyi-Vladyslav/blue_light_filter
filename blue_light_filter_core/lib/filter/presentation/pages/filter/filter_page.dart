import 'package:blue_light_filter_core/filter/presentation/pages/filter/components/color_temperature.dart';
import 'package:blue_light_filter_core/filter/presentation/pages/filter/components/intensity.dart';
import 'package:blue_light_filter_core/filter/presentation/pages/filter/components/screen_dim.dart';
import 'package:blue_light_filter_core/filter/presentation/pages/filter/cubits/color_intencity/color_intencity_cubit.dart';
import 'package:blue_light_filter_core/filter/service/color_intencity_calc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overlay_service/overlay_service.dart';

import 'cubits/color_temperature_cubit/color_temperature_cubit.dart';

class FilterPageProvider extends StatelessWidget {
  const FilterPageProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ColorTemperatureCubit(),
        ),
        BlocProvider(
          create: (context) => ColorIntencityCubit(
            cubit: context.read<ColorTemperatureCubit>(),
            calc:ColorIntencityCalc(),
          ),
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blue Light Filter'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: onStartClick,
        child: Icon(
          overlayShowing ? Icons.pause : Icons.play_arrow,
        ),
      ),
      body: const SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 16.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ColorTemperature(),
              Intensity(),
              ScreenDim(),
            ],
          ),
        ),
      ),
    );
  }

  void onStartClick() async {
    bool status = await OverlayService.checkOverlayPermission();
    if (!status) {
      await OverlayService.requestPermission();
    }
    if (overlayShowing) {
      await OverlayService.stopOverlay();
    } else {
      await OverlayService.startOverlay(Colors.amber);
    }
    overlayShowing = !overlayShowing;
    setState(() {});
  }
}
