import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/app_theme.dart';
import '../config/app_routes.dart';
import '../providers/auth_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _textOpacity;
  late Animation<Offset> _textSlide;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _logoScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );
    _logoOpacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _logoController, curve: const Interval(0, 0.5)),
    );
    _textOpacity = Tween<double>(begin: 0, end: 1).animate(_textController);
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));

    _logoController.forward().then((_) => _textController.forward());

    // Check auth after animations
    Future.delayed(const Duration(milliseconds: 2200), _checkAuth);
  }

  Future<void> _checkAuth() async {
    if (!mounted) return;
    final auth = context.read<AuthProvider>();
    await auth.checkAuthStatus();
    if (!mounted) return;
    if (auth.isAuthenticated) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.home);
    } else {
      Navigator.of(context).pushReplacementNamed(AppRoutes.login);
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ── Animated logo ───────────────────────────────────────────
              ScaleTransition(
                scale: _logoScale,
                child: FadeTransition(
                  opacity: _logoOpacity,
                  child: Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      borderRadius:
                          BorderRadius.circular(AppTheme.radiusXl),
                      boxShadow: AppTheme.primaryShadow,
                    ),
                    child: const Icon(
                      Icons.handshake_rounded,
                      size: 56,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 28),
              // ── Animated text ────────────────────────────────────────────
              SlideTransition(
                position: _textSlide,
                child: FadeTransition(
                  opacity: _textOpacity,
                  child: Column(
                    children: [
                      Text(
                        'CoopServices',
                        style: Theme.of(context)
                            .textTheme
                            .displayMedium
                            ?.copyWith(
                              foreground: Paint()
                                ..shader = const LinearGradient(
                                  colors: [AppTheme.primary, AppTheme.accent],
                                ).createShader(
                                    const Rect.fromLTWH(0, 0, 200, 40)),
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Trusted Cooperative Workers',
                        style:
                            Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  letterSpacing: 0.5,
                                ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 60),
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppTheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
