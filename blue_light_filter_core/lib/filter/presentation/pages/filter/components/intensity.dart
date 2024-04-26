import 'package:blue_light_filter_core/filter/presentation/pages/filter/cubits/color_intencity/color_intencity_cubit.dart';
import 'package:blue_light_filter_core/filter/presentation/pages/filter/widgets/filter_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Intensity extends StatelessWidget {
  const Intensity({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ColorIntencityCubit, ColorIntencityState>(
      builder: (context, state) {
        return FilterSlider(
          color: state.color,
          value: state.intencity.toDouble(),
          min: 0,
          max: 100,
          onChanged: (value) {
            context.read<ColorIntencityCubit>().updateIntencity(value.toInt());
          },
          divisions: 100,
          title: 'Intencity',
          description: 'Description',
          createLabel: (value) => '$value%',
        );
      },
    );
  }
}