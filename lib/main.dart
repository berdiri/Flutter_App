import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'pages/auth/splash_page.dart';
import 'utils/theme.dart';
import 'utils/theme_notifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://fvgcbceivzuwgtdkwyoe.supabase.co',
    anonKey: 'sb_publishable_zZOIkiLpcWxGKBLR-zZEIw_y3VXSjJ5',
  );

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeNotifier(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = context.watch<ThemeNotifier>();

    return MaterialApp(
      title: 'UrbanWear',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeNotifier.isDark ? ThemeMode.dark : ThemeMode.light,
      home: const SplashPage(),
    );
  }
}
