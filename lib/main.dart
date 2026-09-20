import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/constants/app_colors.dart';
import 'features/global_search/presentation/views/main_dashboard_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: OmniSearchApp(),
    ),
  );
}

class OmniSearchApp extends StatelessWidget {
  const OmniSearchApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OmniSearch Engine',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.backgroundDark,
        primaryColor: AppColors.accentPrimary,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.accentPrimary,
          surface: AppColors.cardSurface,
        ),
        useMaterial3: true,
      ),
      home: const MainDashboardView(),
    );
  }
}