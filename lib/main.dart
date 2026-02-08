import 'package:flutter/material.dart';
import 'app_theme.dart';
import 'screens/home_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/disclaimer_screen.dart';
import 'services/notification_service.dart';
import 'services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 通知サービスの初期化
  final notificationService = NotificationService();
  await notificationService.initialize();
  await notificationService.requestPermissions();

  runApp(const PapillonNoteApp());
}

class PapillonNoteApp extends StatelessWidget {
  const PapillonNoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Papillon Note',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      initialRoute: '/',
      routes: {
        '/': (_) => const _StartupRouter(),
      },
    );
  }
}

/// 起動時のルーティング
/// オンボーディング → 免責事項 → ホーム
class _StartupRouter extends StatefulWidget {
  const _StartupRouter();

  @override
  State<_StartupRouter> createState() => _StartupRouterState();
}

class _StartupRouterState extends State<_StartupRouter> {
  final StorageService _storage = StorageService();
  Widget? _screen;

  @override
  void initState() {
    super.initState();
    _determineStartScreen();
  }

  Future<void> _determineStartScreen() async {
    final onboardingDone = await _storage.isOnboardingDone();
    final disclaimerAccepted = await _storage.isDisclaimerAccepted();

    setState(() {
      if (!onboardingDone) {
        _screen = OnboardingScreen(
          onCompleted: () => _onOnboardingDone(),
        );
      } else if (!disclaimerAccepted) {
        _screen = DisclaimerScreen(
          onAccepted: () => _onDisclaimerAccepted(),
        );
      } else {
        _screen = const HomeScreen();
      }
    });
  }

  void _onOnboardingDone() async {
    await _storage.setOnboardingDone();
    setState(() {
      _screen = DisclaimerScreen(
        onAccepted: () => _onDisclaimerAccepted(),
      );
    });
  }

  void _onDisclaimerAccepted() async {
    await _storage.setDisclaimerAccepted();
    setState(() {
      _screen = const HomeScreen();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_screen == null) {
      return Scaffold(
        backgroundColor: AppTheme.primaryBg,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset('assets/images/papillon_icon.jpg', width: 80, height: 80),
              ),
              const SizedBox(height: 16),
              const CircularProgressIndicator(color: AppTheme.accent),
            ],
          ),
        ),
      );
    }
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      child: _screen,
    );
  }
}
