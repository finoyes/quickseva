import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'screens/home_discover_screen.dart';

void main() {
  runApp(const QuickSevaCustomerApp());
}

class QuickSevaCustomerApp extends StatefulWidget {
  const QuickSevaCustomerApp({super.key});

  @override
  State<QuickSevaCustomerApp> createState() => _QuickSevaCustomerAppState();
}

class _QuickSevaCustomerAppState extends State<QuickSevaCustomerApp> {
  final LanguageController _languageController = LanguageController();

  @override
  void dispose() {
    _languageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LanguageScope(
      controller: _languageController,
      child: AnimatedBuilder(
        animation: _languageController,
        builder: (context, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: BrandConfig.brandName,
            theme: QTheme.peachPopLight(),
            darkTheme: QTheme.peachPopDark(),
            themeMode: ThemeMode.light,
            builder: (context, child) {
              return MotionPolicy.wrap(child: child ?? const SizedBox.shrink());
            },
            home: CustomerMainShell(),
          );
        },
      ),
    );
  }
}
