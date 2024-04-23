import 'package:blue_light_filter_core/filter/presentation/pages/filter/filter_page.dart';
import 'package:flutter/material.dart';

//bool isServiceEnabled = false;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // isServiceEnabled =
  //     await FlutterAccessibilityService.isAccessibilityPermissionEnabled();
  runApp(const MainApp());
}

@pragma("vm:entry-point")
void overlayMain() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Container(
        color: Colors.amber.withAlpha(80),
      ),
    ),
  );
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
      home: FilterPage(),
    );
  }
}
