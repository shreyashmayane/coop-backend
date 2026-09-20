import 'package:flutter/material.dart';
import '../config/app_theme.dart';
import '../models/booking_model.dart';

/// Animated vertical stepper for booking status tracking.
class BookingStatusStepper extends StatelessWidget {
  final BookingStatus currentStatus;

  const BookingStatusStepper({super.key, required this.currentStatus});

  static const _steps = [
    BookingStatus.requested,
    BookingStatus.accepted,
    BookingStatus.inProgress,
    BookingStatus.completed,
  ];

  static const _icons = [
    Icons.send_rounded,
    Icons.check_circle_outline_rounded,
    Icons.build_rounded,
    Icons.celebration_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    final currentIdx = _steps.indexOf(currentStatus);

    return Column(
      children: List.generate(_steps.length, (i) {
        final isDone = i <= currentIdx;
        final isActive = i == currentIdx;
        final isLast = i == _steps.length - 1;
        final color = isDone ? AppTheme.primary : AppTheme.divider;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Left: icon + connecting line ──────────────────────────────
            Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isDone
                        ? (isActive
                            ? AppTheme.primary
                            : AppTheme.primary.withOpacity(0.2))
                        : AppTheme.surfaceLight,
                    border: Border.all(
                      color: color,
                      width: isActive ? 2.5 : 1.5,
                    ),
                    boxShadow: isActive ? AppTheme.primaryShadow : null,
                  ),
                  child: Icon(
                    _icons[i],
                    size: 20,
                    color: isDone ? Colors.white : AppTheme.onSurface,
                  ),
                ),
                if (!isLast)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    width: 2,
                    height: 40,
                    color: i < currentIdx ? AppTheme.primary : AppTheme.divider,
                  ),
              ],
            ),
            const SizedBox(width: 16),
            // ── Right: label ──────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _steps[i].label,
                    style: TextStyle(
                      color: isDone ? AppTheme.onBackground : AppTheme.onSurface,
                      fontWeight:
                          isActive ? FontWeight.w600 : FontWeight.normal,
                      fontSize: 15,
                    ),
                  ),
                  if (isActive)
                    Text(
                      _stepSubtitle(_steps[i]),
                      style: const TextStyle(
                        color: AppTheme.primary,
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  String _stepSubtitle(BookingStatus s) {
    switch (s) {
      case BookingStatus.requested:  return 'Waiting for worker to accept…';
      case BookingStatus.accepted:   return 'Worker is on the way';
      case BookingStatus.inProgress: return 'Work is ongoing';
      case BookingStatus.completed:  return 'Job completed!';
      default:                       return '';
    }
  }
}
