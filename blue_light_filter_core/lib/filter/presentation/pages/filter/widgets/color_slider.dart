import 'package:flutter/material.dart';

class ColorSlider extends StatelessWidget {
  const ColorSlider({
    super.key,
    required this.color,
    required this.value,
    required this.min,
    required this.max,
    this.divisions,
    required this.onChanged,
    this.dimension = 24,
    this.label,
    this.onChangedEnd
  });

  final Color color;
  final double value;
  final double min;
  final double max;
  final int? divisions;
  final void Function(double value) onChanged;
  final void Function(double value)? onChangedEnd;
  final double dimension;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox.square(
          dimension: 24,
          child: CircleAvatar(
            backgroundColor: color,
          ),
        ),
        Expanded(
          child: Slider(
            value: value,
            min: min,
            max: max,
            label: label,
            divisions: divisions,
            onChanged: onChanged,
            onChangeEnd: onChangedEnd,
          ),
        ),
      ],
    );
  }
}
