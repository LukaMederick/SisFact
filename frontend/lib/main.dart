import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'theme/app_theme.dart';
import 'state/app_state.dart';
import 'screens/main_shell.dart';
import 'screens/auth_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('es', null);
  await initializeDateFormatting('es_ES', null);

  // Configure Android edge-to-edge UI without black bars
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const SisFactApp());
}

class SisFactApp extends StatefulWidget {
  const SisFactApp({super.key});

  @override
  State<SisFactApp> createState() => _SisFactAppState();
}

class _SisFactAppState extends State<SisFactApp> {
  late final AppState _appState;

  @override
  void initState() {
    super.initState();
    _appState = AppState();
    _appState.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _appState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nubetap - Facturación y Punto de Venta',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: _appState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: _appState.isLoading
          ? const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : (_appState.isAuthenticated
              ? MainShell(state: _appState)
              : AuthScreen(state: _appState)),
    );
  }
}
