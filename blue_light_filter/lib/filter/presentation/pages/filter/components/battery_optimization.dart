import 'package:disable_battery_optimization/disable_battery_optimization.dart';
import 'package:flutter/material.dart';

class BatteryOptimization extends StatefulWidget {
  const BatteryOptimization({super.key});

  @override
  State<BatteryOptimization> createState() => _BatteryOptimizationState();
}

class _BatteryOptimizationState extends State<BatteryOptimization> {
  bool _showMessage = false;

  @override
  void initState() {
    super.initState();
    checkIsBatteryOptimizationDisabled();
  }

  Future<void> checkIsBatteryOptimizationDisabled() async {
    final isDisabled =
        await DisableBatteryOptimization.isBatteryOptimizationDisabled;
    setState(() {
      _showMessage = !(isDisabled ?? false);
    });
  }

  Future<void> openBatterySaver() async {
    await DisableBatteryOptimization.showDisableBatteryOptimizationSettings();
  }

  @override
  Widget build(BuildContext context) {
    return _showMessage
        ? Card(
            color: Theme.of(context).colorScheme.inverseSurface,
            //padding: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Warning!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        color: Colors.white,
                        onPressed: () {
                          setState(() {
                            _showMessage = false;
                          });
                        },
                      ),
                    ],
                  ),
                  const Text(
                    'Battery optimization is enabled. Please disable it to ensure proper functionality in background.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  ElevatedButton(
                    child: const Text(
                      'Change battery optimization',
                    ),
                    onPressed: () async {
                      await openBatterySaver();
                      setState(() {
                        _showMessage = false;
                      });
                    },
                  ),
                ],
              ),
            ),
          )
        : Container();
  }
}
