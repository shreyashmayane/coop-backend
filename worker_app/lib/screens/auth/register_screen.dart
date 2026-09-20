import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme.dart';
import '../../config/app_routes.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  late AnimationController _anim;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _fade = Tween<double>(begin: 0, end: 1).animate(_anim);
    _anim.forward();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    _anim.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final ok = await auth.register(
      _nameCtrl.text.trim(),
      _phoneCtrl.text.trim(),
      _passCtrl.text,
    );
    if (ok && mounted) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.skills);
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  // ── Back ──────────────────────────────────────────────────
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceLight,
                        borderRadius:
                            BorderRadius.circular(AppTheme.radiusSm),
                      ),
                      child: const Icon(Icons.arrow_back_rounded,
                          color: AppTheme.onBackground, size: 20),
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingLg),
                  Text('Create Account',
                      style: Theme.of(context).textTheme.displayMedium),
                  const SizedBox(height: 6),
                  Text(
                    'Join our community of cooperative workers',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: AppTheme.spacingXl),
                  // ── Form ──────────────────────────────────────────────────
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CustomTextField(
                          label: 'Full Name',
                          controller: _nameCtrl,
                          prefixIcon: const Icon(Icons.person_outline_rounded,
                              color: AppTheme.onSurface, size: 20),
                          validator: (v) => (v == null || v.trim().isEmpty)
                              ? 'Enter your name'
                              : null,
                        ),
                        const SizedBox(height: AppTheme.spacingMd),
                        CustomTextField(
                          label: 'Phone Number',
                          controller: _phoneCtrl,
                          keyboardType: TextInputType.phone,
                          prefixIcon: const Icon(Icons.phone_rounded,
                              color: AppTheme.onSurface, size: 20),
                          validator: (v) =>
                              (v == null || v.trim().length < 10)
                                  ? 'Enter a valid phone number'
                                  : null,
                        ),
                        const SizedBox(height: AppTheme.spacingMd),
                        CustomTextField(
                          label: 'Password',
                          controller: _passCtrl,
                          obscureText: true,
                          prefixIcon: const Icon(Icons.lock_outline_rounded,
                              color: AppTheme.onSurface, size: 20),
                          validator: (v) => (v == null || v.length < 6)
                              ? 'Min 6 characters'
                              : null,
                        ),
                        const SizedBox(height: AppTheme.spacingMd),
                        CustomTextField(
                          label: 'Confirm Password',
                          controller: _confirmCtrl,
                          obscureText: true,
                          prefixIcon: const Icon(Icons.lock_outline_rounded,
                              color: AppTheme.onSurface, size: 20),
                          validator: (v) => v != _passCtrl.text
                              ? 'Passwords do not match'
                              : null,
                        ),
                        const SizedBox(height: AppTheme.spacingLg),
                        if (auth.error != null)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.only(
                                bottom: AppTheme.spacingMd),
                            decoration: BoxDecoration(
                              color: AppTheme.error.withOpacity(0.12),
                              borderRadius:
                                  BorderRadius.circular(AppTheme.radiusSm),
                            ),
                            child: Text(auth.error!,
                                style: const TextStyle(
                                    color: AppTheme.error, fontSize: 13)),
                          ),
                        CustomButton(
                          label: 'Create Account',
                          onPressed: _submit,
                          loading: auth.loading,
                          gradient: true,
                        ),
                        const SizedBox(height: AppTheme.spacingMd),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Already have an account? ',
                                style:
                                    Theme.of(context).textTheme.bodyMedium),
                            GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: const Text(
                                'Sign In',
                                style: TextStyle(
                                  color: AppTheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
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
    );
  }
}
