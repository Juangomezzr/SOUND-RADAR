import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/login_screen.dart';
import 'screens/map_screen.dart';

void main() {
  runApp(const SoundRadarApp());
}

class SoundRadarApp extends StatelessWidget {
  const SoundRadarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sound Radar',
      debugShowCheckedModeBanner: false,  
      theme: AppTheme.dark,
      initialRoute: '/login',
      routes: {
        '/login': (_) => const LoginScreen(),
        '/map': (_) => const MapScreen(),
      },
    );
  }
}
