import 'package:blue_light_filter_core/filter/presentation/pages/filter/widgets/color_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/color_temperature_cubit/color_temperature_cubit.dart';
import 'predefined_temperatures.dart';

class ColorTemperature extends StatelessWidget {
  const ColorTemperature({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Color Temperature',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        Text(
          'Predefined temperatures',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        PredefinedTemperatures(
          onSelect: (temperature) {
            context
                .read<ColorTemperatureCubit>()
                .updateTemperature(temperature);
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
              onChanged: (double value) {
                context
                    .read<ColorTemperatureCubit>()
                    .updateTemperature(value.toInt());
              },
            );
          },
        ),
      ],
    );
  }
}
