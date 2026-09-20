import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../config/app_theme.dart';
import '../../config/api_config.dart';
import '../../config/app_routes.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  bool _editing = false;
  String _locale = 'en';

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().user;
    _nameCtrl.text = user?.name ?? '';
    _addressCtrl.text = user?.address ?? '';
    _locale = user?.locale ?? 'en';
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveLocale(String locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(ApiConfig.langKey, locale);
    if (mounted) {
      context.read<AuthProvider>().updateLocale(locale);
      setState(() => _locale = locale);
      // Restart app to apply locale — in production use a LocaleProvider
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Language changed to ${locale == 'hi' ? 'Hindi' : 'English'}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: Icon(_editing ? Icons.save_rounded : Icons.edit_rounded),
            onPressed: () => setState(() => _editing = !_editing),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.spacingMd),
          child: Column(
            children: [
              // ── Avatar ────────────────────────────────────────────────
              CircleAvatar(
                radius: 50,
                backgroundColor: AppTheme.surfaceLight,
                child: Text(
                  (user?.name[0] ?? 'U').toUpperCase(),
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(user?.name ?? 'Customer',
                  style: Theme.of(context).textTheme.headlineMedium),
              Text(user?.phone ?? '',
                  style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: AppTheme.spacingXl),
              // ── Edit fields ───────────────────────────────────────────
              if (_editing) ...[
                CustomTextField(
                  label: 'Full Name',
                  controller: _nameCtrl,
                  prefixIcon: const Icon(Icons.person_outline_rounded,
                      color: AppTheme.onSurface, size: 20),
                ),
                const SizedBox(height: AppTheme.spacingMd),
                CustomTextField(
                  label: 'Default Address',
                  controller: _addressCtrl,
                  maxLines: 2,
                  prefixIcon: const Icon(Icons.location_on_rounded,
                      color: AppTheme.onSurface, size: 20),
                ),
                const SizedBox(height: AppTheme.spacingMd),
                CustomButton(
                  label: 'Save Changes',
                  gradient: true,
                  onPressed: () => setState(() => _editing = false),
                ),
                const SizedBox(height: AppTheme.spacingXl),
              ],
              // ── Language selector ─────────────────────────────────────
              _SectionCard(
                title: 'Language',
                child: Row(
                  children: [
                    _LangChip(
                      label: 'English',
                      selected: _locale == 'en',
                      onTap: () => _saveLocale('en'),
                    ),
                    const SizedBox(width: 10),
                    _LangChip(
                      label: 'हिंदी',
                      selected: _locale == 'hi',
                      onTap: () => _saveLocale('hi'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppTheme.spacingMd),
              // ── Settings items ────────────────────────────────────────
              _SectionCard(
                title: 'Account',
                child: Column(
                  children: [
                    _MenuItem(
                      icon: Icons.receipt_long_rounded,
                      label: 'My Bookings',
                      onTap: () =>
                          Navigator.of(context).pushNamed(AppRoutes.history),
                    ),
                    _MenuItem(
                      icon: Icons.help_outline_rounded,
                      label: 'Help & Support',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Support coming soon')),
                        );
                      },
                    ),
                    _MenuItem(
                      icon: Icons.privacy_tip_outlined,
                      label: 'Privacy Policy',
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppTheme.spacingXl),
              // ── Logout ────────────────────────────────────────────────
              CustomButton(
                label: 'Sign Out',
                outlined: true,
                icon: Icons.logout_rounded,
                onPressed: () async {
                  await auth.logout();
                  if (context.mounted) {
                    Navigator.of(context)
                        .pushReplacementNamed(AppRoutes.login);
                  }
                },
              ),
              const SizedBox(height: AppTheme.spacingXl),
              Text(
                'CoopServices v1.0.0',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: AppTheme.spacingMd),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _LangChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _LangChip(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? AppTheme.primary.withOpacity(0.15)
              : AppTheme.surfaceLight,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          border: Border.all(
            color: selected ? AppTheme.primary : AppTheme.divider,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color:
                selected ? AppTheme.primary : AppTheme.onSurface,
            fontWeight:
                selected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _MenuItem(
      {required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: AppTheme.primary, size: 20),
      title:
          Text(label, style: Theme.of(context).textTheme.bodyLarge),
      trailing: const Icon(Icons.arrow_forward_ios_rounded,
          size: 14, color: AppTheme.onSurface),
      onTap: onTap,
    );
  }
}
