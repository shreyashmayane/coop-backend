import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme.dart';
import '../../config/app_routes.dart';
import '../../providers/booking_provider.dart';
import '../../widgets/rating_stars.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';

class RatingScreen extends StatefulWidget {
  const RatingScreen({super.key});

  @override
  State<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends State<RatingScreen>
    with SingleTickerProviderStateMixin {
  double _rating = 0;
  final _commentCtrl = TextEditingController();
  bool _submitted = false;
  late AnimationController _anim;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _anim, curve: Curves.elasticOut),
    );
  }

  @override
  void dispose() {
    _commentCtrl.dispose();
    _anim.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a star rating')),
      );
      return;
    }
    await context.read<BookingProvider>().submitRating(
          _rating,
          _commentCtrl.text.trim(),
        );
    _anim.forward();
    setState(() => _submitted = true);
  }

  @override
  Widget build(BuildContext context) {
    final booking = context.watch<BookingProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rate & Review'),
        automaticallyImplyLeading: !_submitted,
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingMd),
          child: _submitted
              ? _SuccessView(scaleAnim: _scale)
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: AppTheme.spacingLg),
                    // ── Worker avatar ───────────────────────────────────
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: AppTheme.surfaceLight,
                      child: Text(
                        (booking.activeBooking?.workerName[0] ?? 'W')
                            .toUpperCase(),
                        style: const TextStyle(
                          color: AppTheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'How was ${booking.activeBooking?.workerName ?? 'your worker'}?',
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Your feedback helps improve cooperative services',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppTheme.spacingXl),
                    // ── Stars ────────────────────────────────────────────
                    RatingStars(
                      rating: _rating,
                      size: 48,
                      readOnly: false,
                      onRated: (r) => setState(() => _rating = r),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _ratingLabel(_rating),
                      style: const TextStyle(
                          color: AppTheme.warning,
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: AppTheme.spacingXl),
                    // ── Comment ──────────────────────────────────────────
                    CustomTextField(
                      label: 'Write a comment (optional)',
                      controller: _commentCtrl,
                      maxLines: 4,
                      prefixIcon: const Icon(Icons.comment_rounded,
                          color: AppTheme.onSurface, size: 20),
                    ),
                    const Spacer(),
                    CustomButton(
                      label: 'Submit Review',
                      gradient: true,
                      icon: Icons.send_rounded,
                      onPressed: _submit,
                    ),
                    const SizedBox(height: AppTheme.spacingMd),
                    TextButton(
                      onPressed: () => Navigator.of(context)
                          .pushReplacementNamed(AppRoutes.home),
                      child: const Text('Skip for now',
                          style: TextStyle(color: AppTheme.onSurface)),
                    ),
                    const SizedBox(height: AppTheme.spacingMd),
                  ],
                ),
        ),
      ),
    );
  }

  String _ratingLabel(double r) {
    if (r == 0) return 'Tap to rate';
    if (r <= 1) return 'Poor';
    if (r <= 2) return 'Fair';
    if (r <= 3) return 'Good';
    if (r <= 4) return 'Very Good';
    return 'Excellent!';
  }
}

class _SuccessView extends StatelessWidget {
  final Animation<double> scaleAnim;
  const _SuccessView({required this.scaleAnim});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ScaleTransition(
            scale: scaleAnim,
            child: Container(
              padding: const EdgeInsets.all(AppTheme.spacingXl),
              decoration: BoxDecoration(
                color: AppTheme.success.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.favorite_rounded,
                  color: AppTheme.success, size: 72),
            ),
          ),
          const SizedBox(height: AppTheme.spacingLg),
          Text('Thank You!',
              style: Theme.of(context).textTheme.displayMedium),
          const SizedBox(height: 8),
          Text(
            'Your review helps the community\nchoose trusted workers.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.spacingXl),
          CustomButton(
            label: 'Back to Home',
            gradient: true,
            onPressed: () => Navigator.of(context)
                .pushNamedAndRemoveUntil(AppRoutes.home, (r) => false),
          ),
        ],
      ),
    );
  }
}
