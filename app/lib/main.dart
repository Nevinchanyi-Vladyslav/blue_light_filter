import 'package:blue_light_filter/core/di/injection.dart';
import 'package:blue_light_filter/filter/data/repositories/profile_repository_impl.dart';
import 'package:blue_light_filter/filter/domain/repositories/profiles_repository.dart';
import 'package:blue_light_filter/filter/presentation/pages/filter/filter_page.dart';
import 'package:flutter/material.dart';
import 'package:blue_light_filter/core/di/injection.dart' as di;
import 'package:flutter/services.dart';
import 'package:overlay_service/overlay_service_native_communicator.dart';
import 'package:sqflite_db_common/sqflite_db_common.dart';

//bool isServiceEnabled = false;
const _seedColor = Colors.green;
final _backgroundColor = Colors.grey.shade900;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  OverlayServiceNativeCommunicator.init();
  await di.setup();
  final SQFLiteCommon sqfLiteCommon = SQFLiteCommon();
  await sqfLiteCommon.init(
    contracts: [
      sl<ProfilesRepository>() as ProfilesRepositoryImpl,
    ],
  );
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
