import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme.dart';
import '../../config/app_routes.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _phoneCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  late AnimationController _anim;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _anim, curve: Curves.easeOut),
    );
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _anim, curve: Curves.easeOut));
    _anim.forward();
  }

  @override
  void dispose() {
    _phoneCtrl.dispose();
    _passCtrl.dispose();
    _anim.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final ok = await auth.login(_phoneCtrl.text.trim(), _passCtrl.text);
    if (ok && mounted) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppTheme.spacingLg),
            child: FadeTransition(
              opacity: _fade,
              child: SlideTransition(
                position: _slide,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    // ── Header ──────────────────────────────────────────────
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: AppTheme.primaryGradient,
                        borderRadius:
                            BorderRadius.circular(AppTheme.radiusMd),
                      ),
                      child: const Icon(Icons.handshake_rounded,
                          color: Colors.white, size: 28),
                    ),
                    const SizedBox(height: AppTheme.spacingLg),
                    Text('Welcome back',
                        style: Theme.of(context).textTheme.displayMedium),
                    const SizedBox(height: 6),
                    Text(
                      'Sign in to manage your jobs',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: AppTheme.spacingXl),
                    // ── Form ────────────────────────────────────────────────
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          CustomTextField(
                            label: 'Phone Number',
                            hint: '10-digit mobile number',
                            controller: _phoneCtrl,
                            keyboardType: TextInputType.phone,
                            prefixIcon: const Icon(Icons.phone_rounded,
                                color: AppTheme.onSurface, size: 20),
                            validator: (v) {
                              if (v == null || v.trim().length < 10) {
                                return 'Enter a valid phone number';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: AppTheme.spacingMd),
                          CustomTextField(
                            label: 'Password',
                            controller: _passCtrl,
                            obscureText: true,
                            prefixIcon: const Icon(Icons.lock_outline_rounded,
                                color: AppTheme.onSurface, size: 20),
                            validator: (v) {
                              if (v == null || v.length < 6) {
                                return 'Password must be at least 6 characters';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: AppTheme.spacingLg),
                          // ── Error ──────────────────────────────────────────
                          if (auth.error != null)
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              margin: const EdgeInsets.only(
                                  bottom: AppTheme.spacingMd),
                              decoration: BoxDecoration(
                                color: AppTheme.error.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(
                                    AppTheme.radiusSm),
                                border: Border.all(
                                    color: AppTheme.error.withOpacity(0.3)),
                              ),
                              child: Text(
                                auth.error!,
                                style: const TextStyle(
                                    color: AppTheme.error, fontSize: 13),
                              ),
                            ),
                          // ── Login button ──────────────────────────────────
                          CustomButton(
                            label: 'Sign In',
                            onPressed: _submit,
                            loading: auth.loading,
                            gradient: true,
                          ),
                          const SizedBox(height: AppTheme.spacingMd),
                          // ── Register link ─────────────────────────────────
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Don't have an account? ",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              GestureDetector(
                                onTap: () => Navigator.of(context)
                                    .pushNamed(AppRoutes.register),
                                child: const Text(
                                  'Register',
                                  style: TextStyle(
                                    color: AppTheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppTheme.spacingLg),
                          // ── Divider ───────────────────────────────────────
                          Row(
                            children: [
                              const Expanded(child: Divider(color: AppTheme.divider)),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: AppTheme.spacingMd),
                                child: Text(
                                  'or',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(fontSize: 13),
                                ),
                              ),
                              const Expanded(child: Divider(color: AppTheme.divider)),
                            ],
                          ),
                          const SizedBox(height: AppTheme.spacingMd),
                          // ── Guest button ──────────────────────────────────
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: auth.loading
                                   ? null
                                   : () async {
                                       final nav = Navigator.of(context);
                                       await context
                                           .read<AuthProvider>()
                                           .loginAsGuest();
                                       nav.pushReplacementNamed(AppRoutes.home);
                                     },
                              icon: const Icon(Icons.person_outline_rounded,
                                  size: 18),
                              label: const Text('Continue as Guest'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppTheme.primary,
                                side: const BorderSide(
                                    color: AppTheme.primary, width: 1.5),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                      AppTheme.radiusMd),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: AppTheme.spacingMd),
                          // ── Guest disclaimer ──────────────────────────────
                          Center(
                            child: Text(
                              'Guest mode: browse only — login to book services',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(fontSize: 11),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
