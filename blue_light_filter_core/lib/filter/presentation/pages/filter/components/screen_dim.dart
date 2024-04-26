import 'package:flutter/material.dart';

class ScreenDim extends StatelessWidget {
  const ScreenDim({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Screen Dim',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        Text(
          'Description',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(
          height: 8,
        ),
        Row(
          children: [
            const Icon(Icons.brightness_6),
            Expanded(
              child: Slider(
                value: 30,
                min: 0,
                max: 90,
                //label: state.temperature.toString(),
                divisions: 90,
                onChanged: (double value) {},
              ),
            ),
          ],
        ),
      ],
    );
  }
}