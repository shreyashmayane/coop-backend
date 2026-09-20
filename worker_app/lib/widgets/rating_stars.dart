import 'package:flutter/material.dart';
import '../config/app_theme.dart';

/// Interactive or read-only star rating widget.
class RatingStars extends StatefulWidget {
  final double rating;
  final double size;
  final bool readOnly;
  final void Function(double)? onRated;
  final int maxStars;

  const RatingStars({
    super.key,
    required this.rating,
    this.size = 20,
    this.readOnly = false,
    this.onRated,
    this.maxStars = 5,
  });

  @override
  State<RatingStars> createState() => _RatingStarsState();
}

class _RatingStarsState extends State<RatingStars> {
  late double _current;

  @override
  void initState() {
    super.initState();
    _current = widget.rating;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(widget.maxStars, (i) {
          final filled = i < _current.floor();
          final half = !filled && i < _current;
          return GestureDetector(
            onTap: widget.readOnly
                ? null
                : () {
                    setState(() => _current = i + 1.0);
                    widget.onRated?.call(i + 1.0);
                  },
            child: Padding(
              padding: const EdgeInsets.only(right: 2),
              child: Icon(
                filled
                    ? Icons.star_rounded
                    : half
                        ? Icons.star_half_rounded
                        : Icons.star_outline_rounded,
                size: widget.size,
                color: AppTheme.warning,
              ),
            ),
          );
        }),
        if (widget.readOnly) ...[
          const SizedBox(width: 4),
          Text(
            _current.toStringAsFixed(1),
            style: TextStyle(
              color: AppTheme.onSurface,
              fontSize: widget.size * 0.7,
            ),
          ),
        ],
      ],
    );
  }
}
