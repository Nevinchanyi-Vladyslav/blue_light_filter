import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'color_slider.dart';

class FilterSlider extends StatelessWidget {
  const FilterSlider({
    super.key,
    required this.color,
    required this.value,
    required this.min,
    required this.max,
    this.divisions,
    required this.onChanged,
    this.dimension,
    required this.title,
    required this.description,
    required this.createLabel,
    this.onChangedEnd,
  });

  final Color color;
  final double value;
  final double min;
  final double max;
  final int? divisions;
  final void Function(double value) onChanged;
  final void Function(double value)? onChangedEnd;
  final double? dimension;
  final String title;
  final String description;
  final String Function(double value) createLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            Text(
              createLabel(value),
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ],
        ),
        Text(
          description,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(
          height: 8,
        ),
        ColorSlider(
          color: color,
          value: value,
          min: min,
          max: max,
          divisions: divisions,
          onChanged: onChanged,
          label: createLabel(value),
          onChangedEnd: onChangedEnd,
        )
      ],
    );
  }
}
