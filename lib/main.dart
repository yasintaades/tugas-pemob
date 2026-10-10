import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/biodata_provider.dart';
import 'providers/grade_provider.dart';
import 'providers/profile_provider.dart';
import 'screens/main_navigation_screen.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MultiProvider ditempatkan di root agar semua provider dapat diakses dari mana saja
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BiodataProvider()),
        ChangeNotifierProvider(create: (_) => GradeProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
      ],
      child: const PemobApp(),
    );
  }
}

class PemobApp extends StatelessWidget {
  const PemobApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Membaca themeMode secara reaktif dari ProfileProvider
    final profileProvider = context.watch<ProfileProvider>();

    return MaterialApp(
      title: 'Aplikasi Pemob Mahasiswa',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: profileProvider.themeMode,
      home: const MainNavigationScreen(),
    );
  }
}
