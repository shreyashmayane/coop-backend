import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme.dart';
import '../../config/app_routes.dart';
import '../../providers/worker_provider.dart';
import '../../providers/booking_provider.dart';
import '../../widgets/rating_stars.dart';
import '../../widgets/custom_button.dart';

class WorkerProfileScreen extends StatelessWidget {
  const WorkerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final worker = context.watch<WorkerProvider>().selectedWorker;
    if (worker == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(color: AppTheme.primary)),
      );
    }

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: CustomScrollView(
          slivers: [
            // ── Hero App Bar ───────────────────────────────────────────────
            SliverAppBar(
              expandedHeight: 220,
              pinned: true,
              backgroundColor: AppTheme.background,
              leading: Padding(
                padding: const EdgeInsets.all(8),
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                    ),
                    child: const Icon(Icons.arrow_back_rounded,
                        color: Colors.white),
                  ),
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.primary.withOpacity(0.7),
                        AppTheme.accent.withOpacity(0.5),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                        CircleAvatar(
                          radius: 45,
                          backgroundColor: AppTheme.surfaceLight,
                          backgroundImage: worker.avatarUrl != null &&
                                  worker.avatarUrl!.isNotEmpty
                              ? NetworkImage(worker.avatarUrl!)
                              : null,
                          child: (worker.avatarUrl == null ||
                                  worker.avatarUrl!.isEmpty)
                              ? Text(
                                  worker.name[0].toUpperCase(),
                                  style: const TextStyle(
                                      fontSize: 36,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.primary),
                                )
                              : null,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          worker.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          worker.serviceType,
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // ── Body ──────────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spacingMd),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Stats row ─────────────────────────────────────────
                    Row(
                      children: [
                        _StatChip(
                          icon: Icons.star_rounded,
                          label: '${worker.rating}',
                          sub: '${worker.reviewCount} reviews',
                          color: AppTheme.warning,
                        ),
                        const SizedBox(width: 12),
                        _StatChip(
                          icon: Icons.location_on_rounded,
                          label: '${worker.distanceKm} km',
                          sub: 'away',
                          color: AppTheme.accent,
                        ),
                        const SizedBox(width: 12),
                        _StatChip(
                          icon: Icons.currency_rupee,
                          label: '${worker.hourlyRate.toInt()}',
                          sub: 'per hour',
                          color: AppTheme.primary,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppTheme.spacingLg),
                    // ── About ─────────────────────────────────────────────
                    if (worker.bio != null) ...[
                      Text('About',
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      Text(worker.bio!,
                          style: Theme.of(context).textTheme.bodyLarge),
                      const SizedBox(height: AppTheme.spacingLg),
                    ],
                    // ── Skills ────────────────────────────────────────────
                    Text('Skills',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: worker.skills
                          .map((s) => Chip(
                                label: Text(s),
                                backgroundColor: AppTheme.primary.withOpacity(0.15),
                                labelStyle: const TextStyle(
                                    color: AppTheme.primary, fontSize: 12),
                                side: BorderSide.none,
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: AppTheme.spacingLg),
                    // ── Availability ──────────────────────────────────────
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: worker.isAvailable
                            ? AppTheme.success.withOpacity(0.12)
                            : AppTheme.error.withOpacity(0.12),
                        borderRadius:
                            BorderRadius.circular(AppTheme.radiusSm),
                        border: Border.all(
                          color: worker.isAvailable
                              ? AppTheme.success.withOpacity(0.3)
                              : AppTheme.error.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            worker.isAvailable
                                ? Icons.check_circle_rounded
                                : Icons.cancel_rounded,
                            color: worker.isAvailable
                                ? AppTheme.success
                                : AppTheme.error,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            worker.isAvailable
                                ? 'Available for booking now'
                                : 'Currently busy — check back later',
                            style: TextStyle(
                              color: worker.isAvailable
                                  ? AppTheme.success
                                  : AppTheme.error,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingXl),
                    // ── CTAs ──────────────────────────────────────────────
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            label: '⚡ Book Now',
                            gradient: true,
                            onPressed: worker.isAvailable
                                ? () {
                                    context
                                        .read<BookingProvider>()
                                        .setEmergency(true);
                                    Navigator.of(context)
                                        .pushNamed(AppRoutes.booking);
                                  }
                                : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CustomButton(
                            label: 'Schedule',
                            outlined: true,
                            onPressed: worker.isAvailable
                                ? () {
                                    context
                                        .read<BookingProvider>()
                                        .setEmergency(false);
                                    Navigator.of(context)
                                        .pushNamed(AppRoutes.booking);
                                  }
                                : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppTheme.spacingXl),
                    // ── Reviews ───────────────────────────────────────────
                    if (worker.reviews.isNotEmpty) ...[
                      Text('Reviews',
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 12),
                      ...worker.reviews.map(
                        (r) => Container(
                          margin: const EdgeInsets.only(
                              bottom: AppTheme.spacingMd),
                          padding: const EdgeInsets.all(AppTheme.spacingMd),
                          decoration: BoxDecoration(
                            color: AppTheme.surface,
                            borderRadius: BorderRadius.circular(
                                AppTheme.radiusMd),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(r.customerName,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600)),
                                  const Spacer(),
                                  RatingStars(
                                      rating: r.rating,
                                      size: 13,
                                      readOnly: true),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(r.comment,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium),
                            ],
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final String sub;
  final Color color;

  const _StatChip({
    required this.icon,
    required this.label,
    required this.sub,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 4),
            Text(label,
                style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 16)),
            Text(sub,
                style: const TextStyle(
                    color: AppTheme.onSurface, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}
