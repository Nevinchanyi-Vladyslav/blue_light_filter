import 'package:blue_light_filter_core/filter/presentation/pages/filter/filter_page.dart';
import 'package:flutter/material.dart';
import 'package:blue_light_filter_core/core/di/injection.dart' as di;

//bool isServiceEnabled = false;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // isServiceEnabled =
  //     await FlutterAccessibilityService.isAccessibilityPermissionEnabled();
  await di.setup();
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FilterPageProvider(),
    );
  }
}
