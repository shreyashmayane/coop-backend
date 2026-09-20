import 'package:flutter/material.dart';

class ServiceCategoryModel {
  final String id;
  final String name;
  final IconData icon;
  final Color color;

  const ServiceCategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });

  factory ServiceCategoryModel.fromJson(Map<String, dynamic> json) =>
      ServiceCategoryModel(
        id: json['_id'] ?? json['id'] ?? '',
        name: json['name'] ?? '',
        icon: _iconFromName(json['icon'] ?? ''),
        color: Color(int.tryParse(
                (json['color'] ?? '0xFF6C63FF').replaceFirst('#', '0xFF')) ??
            0xFF6C63FF),
      );

  static IconData _iconFromName(String name) {
    const map = <String, IconData>{
      'electrician':   Icons.electrical_services_rounded,
      'plumber':       Icons.plumbing_rounded,
      'cleaner':       Icons.cleaning_services_rounded,
      'carpenter':     Icons.handyman_rounded,
      'painter':       Icons.format_paint_rounded,
      'gardener':      Icons.yard_rounded,
      'cook':          Icons.restaurant_rounded,
      'security':      Icons.security_rounded,
    };
    return map[name.toLowerCase()] ?? Icons.build_rounded;
  }

  // ─── Mock categories ──────────────────────────────────────────────────────
  static List<ServiceCategoryModel> mockList() => const [
        ServiceCategoryModel(
          id: 'c1',
          name: 'Electrician',
          icon: Icons.electrical_services_rounded,
          color: Color(0xFF6C63FF),
        ),
        ServiceCategoryModel(
          id: 'c2',
          name: 'Plumber',
          icon: Icons.plumbing_rounded,
          color: Color(0xFF00D4AA),
        ),
        ServiceCategoryModel(
          id: 'c3',
          name: 'Cleaner',
          icon: Icons.cleaning_services_rounded,
          color: Color(0xFFFF6B6B),
        ),
        ServiceCategoryModel(
          id: 'c4',
          name: 'Carpenter',
          icon: Icons.handyman_rounded,
          color: Color(0xFFFFB347),
        ),
        ServiceCategoryModel(
          id: 'c5',
          name: 'Painter',
          icon: Icons.format_paint_rounded,
          color: Color(0xFF4FC3F7),
        ),
        ServiceCategoryModel(
          id: 'c6',
          name: 'Gardener',
          icon: Icons.yard_rounded,
          color: Color(0xFF81C784),
        ),
        ServiceCategoryModel(
          id: 'c7',
          name: 'Cook',
          icon: Icons.restaurant_rounded,
          color: Color(0xFFFF8A65),
        ),
        ServiceCategoryModel(
          id: 'c8',
          name: 'Security',
          icon: Icons.security_rounded,
          color: Color(0xFFBA68C8),
        ),
      ];
}
