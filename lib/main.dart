import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/theme/app_theme.dart';
import 'presentation/screens/piano_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Allow portrait and landscape fluid rotation
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Keep device status bar (time, battery, notifications) fully visible
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const SimpleKeysApp());
}

class SimpleKeysApp extends StatelessWidget {
  const SimpleKeysApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SimpleKeys',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const PianoScreen(),
    );
  }
}
