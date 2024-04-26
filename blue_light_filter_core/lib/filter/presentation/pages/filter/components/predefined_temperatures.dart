import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class PredefinedTemperature {
  final String title;
  final Icon icon;
  final int temperature;

  PredefinedTemperature({
    required this.title,
    required this.icon,
    required this.temperature,
  });
}

class PredefinedTemperatures extends StatefulWidget {
  const PredefinedTemperatures(
      {super.key, this.dimension = 60, this.selectedIndex = 0, required this.onSelect});

  final double dimension;
  final int selectedIndex;
  final void Function(int temperature) onSelect;

  @override
  State<PredefinedTemperatures> createState() => _PredefinedTemperaturesState();
}

class _PredefinedTemperaturesState extends State<PredefinedTemperatures> {
  final List<PredefinedTemperature> _temperatures = [
    PredefinedTemperature(
      title: 'Candle',
      icon: Icon(
        MdiIcons.candle,
      ),
      temperature: 1800,
    ),
    PredefinedTemperature(
      title: 'Moonlight',
      icon: const Icon(
        EvaIcons.moon,
      ),
      temperature: 3200,
    ),
    PredefinedTemperature(
      title: 'Lamp',
      icon: const Icon(
        Icons.lightbulb,
      ),
      temperature: 2700,
    ),
    PredefinedTemperature(
      title: 'Sunlight',
      icon: const Icon(
        Icons.sunny,
      ),
      temperature: 4500,
    ),
    PredefinedTemperature(
      title: 'Forest',
      icon: Icon(
        MdiIcons.forest,
      ),
      temperature: 3300,
    ),
    PredefinedTemperature(
      title: 'Sundown',
      icon: const Icon(
        Icons.sunny_snowing,
      ),
      temperature: 2000,
    ),
  ];

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.selectedIndex;
  }

  late int selectedIndex; 

  void onTemperatureTap(int index) {
    if(index == selectedIndex){
      return;
    }
    setState(() {
      selectedIndex = index;
    });
    widget.onSelect(_temperatures[index].temperature);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      height: widget.dimension,
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _temperatures.length,
        itemBuilder: (_, int index) {
          return GestureDetector(
            onTap: () {
              onTemperatureTap(index);
            },
            child: SizedBox(
              width: widget.dimension,
              child: Card(
                color: index == selectedIndex
                    ? colorScheme.surfaceTint
                    : colorScheme.surface,
                child: _temperatures[index].icon,
              ),
            ),
          );
        },
      ),
    );
  }
}
