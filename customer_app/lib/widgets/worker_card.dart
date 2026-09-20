import 'package:flutter/material.dart';
import '../config/app_theme.dart';
import '../models/worker_model.dart';
import 'rating_stars.dart';

/// Worker list tile card with avatar, name, rating, distance, availability.
class WorkerCard extends StatelessWidget {
  final WorkerModel worker;
  final VoidCallback onTap;

  const WorkerCard({super.key, required this.worker, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppTheme.spacingMd),
        padding: const EdgeInsets.all(AppTheme.spacingMd),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          border: Border.all(color: AppTheme.divider),
          boxShadow: AppTheme.cardShadow,
        ),
        child: Row(
          children: [
            // ── Avatar ────────────────────────────────────────────────────
            Stack(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppTheme.surfaceLight,
                  backgroundImage: worker.avatarUrl != null &&
                          worker.avatarUrl!.isNotEmpty
                      ? NetworkImage(worker.avatarUrl!)
                      : null,
                  child:
                      (worker.avatarUrl == null || worker.avatarUrl!.isEmpty)
                          ? Text(
                              worker.name[0].toUpperCase(),
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.primary,
                              ),
                            )
                          : null,
                ),
                if (worker.isAvailable)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: AppTheme.success,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppTheme.surface, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: AppTheme.spacingMd),
            // ── Info ──────────────────────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          worker.name,
                          style: Theme.of(context).textTheme.titleMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (!worker.isAvailable)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.error.withOpacity(0.15),
                            borderRadius:
                                BorderRadius.circular(AppTheme.radiusSm),
                          ),
                          child: const Text(
                            'Busy',
                            style: TextStyle(
                                color: AppTheme.error, fontSize: 11),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  RatingStars(rating: worker.rating, size: 14, readOnly: true),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on_rounded,
                          size: 13, color: AppTheme.onSurface),
                      const SizedBox(width: 2),
                      Text(
                        '${worker.distanceKm.toStringAsFixed(1)} km',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.currency_rupee,
                          size: 13, color: AppTheme.onSurface),
                      Text(
                        '${worker.hourlyRate.toStringAsFixed(0)}/hr',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // ── Arrow ─────────────────────────────────────────────────────
            const Icon(Icons.arrow_forward_ios_rounded,
                size: 16, color: AppTheme.onSurface),
          ],
        ),
      ),
    );
  }
}
