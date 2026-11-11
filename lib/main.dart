import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core/theme/app_theme.dart';
import 'presentation/screens/piano_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Optimized portrait orientation for 4x5 candy pad board
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // Keep system UI bars visible with edge-to-edge transparent integration
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
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
      theme: AppTheme.candyTheme,
      home: const PianoScreen(),
    );
  }
}
