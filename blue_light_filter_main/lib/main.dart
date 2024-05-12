import 'package:blue_light_filter_core/filter/presentation/pages/filter/filter_page.dart';
import 'package:flutter/material.dart';
import 'package:blue_light_filter_core/core/di/injection.dart' as di;
import 'package:flutter/services.dart';

//bool isServiceEnabled = false;
const _seedColor = Colors.green;
final _backgroundColor = Colors.grey.shade900;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // isServiceEnabled =
  //     await FlutterAccessibilityService.isAccessibilityPermissionEnabled();
  await di.setup();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: _backgroundColor,
      systemNavigationBarColor: _seedColor,
    ),
  );
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          brightness: Brightness.dark,
          seedColor: _seedColor,
          primary: _seedColor,
          secondary: Colors.red, 
          inverseSurface: Colors.red,
          inversePrimary: Colors.white,
          onInverseSurface: Colors.white,
          background: _backgroundColor,
          surface: _backgroundColor,
          primaryContainer: _seedColor,
        ),
      ),
      home: const FilterPageProvider(),
    );
  }
}
