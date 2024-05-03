import 'package:blue_light_filter_core/filter/presentation/pages/filter/widgets/filter_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overlay_service/overlay_service.dart';

import '../cubits/screen_dim/screen_dim_cubit.dart';

class ScreenDim extends StatelessWidget {
  const ScreenDim({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ScreenDimCubit, ScreenDimState>(
      builder: (context, state) {
        return FilterSlider(
          color: Colors.black.withAlpha((state.dim / 100 * 255).toInt()),
          value: state.dim.toDouble(),
          min: 0,
          max: 75,
          onChanged: (double value) {
            context.read<ScreenDimCubit>().updateDim(value.toInt());
          },
          divisions: 75,
          title: 'Screen Dim',
          description: 'Description',
          createLabel: (double value) {
            return '$value%';
          },
          onChangedEnd: (double dim) async {
            await context.read<ScreenDimCubit>().saveScreenDim(dim.toInt());
            if (await OverlayService.isActive()) {
              final blackAlpha = (dim / 100 * 255).clamp(0, 255).toInt();
              await OverlayService.updateDim(Colors.black.withAlpha(blackAlpha));
            }
          },
        );
      },
    );
  }
}
