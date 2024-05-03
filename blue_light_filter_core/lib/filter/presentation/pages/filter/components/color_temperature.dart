import 'package:blue_light_filter_core/filter/presentation/pages/filter/cubits/color_intencity/color_intencity_cubit.dart';
import 'package:blue_light_filter_core/filter/presentation/pages/filter/widgets/color_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overlay_service/overlay_service.dart';

import '../cubits/color_temperature/color_temperature_cubit.dart';

import 'predefined_temperatures.dart';

class ColorTemperature extends StatelessWidget {
  const ColorTemperature({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Color Temperature',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            BlocBuilder<ColorTemperatureCubit, ColorTemperatureState>(
              builder: (_, state) {
                return Text(
                  '${state.temperature}K',
                  style: Theme.of(context).textTheme.labelLarge,
                );
              },
            )
          ],
        ),
        Text(
          'Predefined temperatures',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        PredefinedTemperatures(
          onSelect: (temperature, title) async {
            final cubit = context.read<ColorTemperatureCubit>();
            cubit.updateTemperature(temperature);

            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(title),
                action: SnackBarAction(
                  label: 'Ok',
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  },
                ),
                duration: const Duration(
                  seconds: 2,
                ),
              ),
            );
            
            final intecityCubit = context.read<ColorIntencityCubit>();
            final color = intecityCubit.state.color;
            if (await OverlayService.isActive()) {
              await OverlayService.updateColor(color);
            }
            await cubit.saveColorTemperature(temperature);
          },
        ),
        const SizedBox(
          height: 8,
        ),
        BlocBuilder<ColorTemperatureCubit, ColorTemperatureState>(
          builder: (context, state) {
            return ColorSlider(
              color: state.color,
              value: state.temperature.toDouble(),
              min: 1000,
              max: 5000,
              divisions: 4000,
              onChanged: (double value) {
                context
                    .read<ColorTemperatureCubit>()
                    .updateTemperature(value.toInt());
              },
              label: '${state.temperature}K',
              onChangedEnd: (double temperature) async {
                await context
                    .read<ColorTemperatureCubit>()
                    .saveColorTemperature(temperature.toInt())
                    .then((_) async {
                  final color = context.read<ColorIntencityCubit>().state.color;
                  if (await OverlayService.isActive()) {
                    await OverlayService.updateColor(color);
                  }
                });
              },
            );
          },
        ),
      ],
    );
  }
}
