import 'package:blue_light_filter/filter/presentation/pages/filter/cubits/color_intencity/color_intencity_cubit.dart';
import 'package:blue_light_filter/filter/presentation/pages/filter/widgets/filter_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:overlay_service/overlay_service.dart';

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
          title: 'intensity'.tr(),
          description: 'intensity_desc'.tr(),
          createLabel: (value) => '$value%',
          onChangedEnd: (double intencity) async {
            final cubit = context.read<ColorIntencityCubit>();
            await cubit.saveColorIntensity(intencity.toInt());
            final color = cubit.state.color;
            if (await OverlayService.isActive()) {
              await OverlayService.updateColor(color);
            }
          },
        );
      },
    );
  }
}
