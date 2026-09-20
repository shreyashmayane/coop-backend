class ReviewModel {
  final String customerName;
  final double rating;
  final String comment;
  final DateTime date;

  const ReviewModel({
    required this.customerName,
    required this.rating,
    required this.comment,
    required this.date,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) => ReviewModel(
        customerName: json['customerName'] ?? 'Anonymous',
        rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
        comment: json['comment'] ?? '',
        date: json['date'] != null
            ? DateTime.parse(json['date'])
            : DateTime.now(),
      );
}

class WorkerModel {
  final String id;
  final String name;
  final String serviceType;
  final String? avatarUrl;
  final double rating;
  final int reviewCount;
  final double distanceKm;
  final double hourlyRate;
  final List<String> skills;
  final List<ReviewModel> reviews;
  final bool isAvailable;
  final String? bio;

  const WorkerModel({
    required this.id,
    required this.name,
    required this.serviceType,
    this.avatarUrl,
    required this.rating,
    required this.reviewCount,
    required this.distanceKm,
    required this.hourlyRate,
    required this.skills,
    this.reviews = const [],
    required this.isAvailable,
    this.bio,
  });

  factory WorkerModel.fromJson(Map<String, dynamic> json) => WorkerModel(
        id: json['_id'] ?? json['id'] ?? '',
        name: json['name'] ?? '',
        serviceType: json['serviceType'] ?? '',
        avatarUrl: json['avatarUrl'],
        rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
        reviewCount: json['reviewCount'] ?? 0,
        distanceKm: (json['distanceKm'] as num?)?.toDouble() ?? 0.0,
        hourlyRate: (json['hourlyRate'] as num?)?.toDouble() ?? 0.0,
        skills: List<String>.from(json['skills'] ?? []),
        reviews: (json['reviews'] as List<dynamic>?)
                ?.map((r) => ReviewModel.fromJson(r as Map<String, dynamic>))
                .toList() ??
            [],
        isAvailable: json['isAvailable'] ?? true,
        bio: json['bio'],
      );

  // ─── Mock data for early UI development ──────────────────────────────────
  static List<WorkerModel> mockList(String serviceType) => [
        WorkerModel(
          id: 'w1',
          name: 'Ramesh Kumar',
          serviceType: serviceType,
          rating: 4.8,
          reviewCount: 124,
          distanceKm: 1.2,
          hourlyRate: 350,
          skills: ['Installation', 'Repair', 'Maintenance'],
          isAvailable: true,
          bio: '8 years of experience in ${serviceType.toLowerCase()} services.',
        ),
        WorkerModel(
          id: 'w2',
          name: 'Suresh Nair',
          serviceType: serviceType,
          rating: 4.5,
          reviewCount: 87,
          distanceKm: 2.4,
          hourlyRate: 300,
          skills: ['Emergency Repair', 'Wiring', 'Inspection'],
          isAvailable: true,
          bio: '5 years experience. Same-day service available.',
        ),
        WorkerModel(
          id: 'w3',
          name: 'Priya Sharma',
          serviceType: serviceType,
          rating: 4.9,
          reviewCount: 203,
          distanceKm: 0.8,
          hourlyRate: 400,
          skills: ['Deep Cleaning', 'Maintenance', 'Setup'],
          isAvailable: false,
          bio: 'Top-rated cooperative worker. Serving since 2018.',
        ),
        WorkerModel(
          id: 'w4',
          name: 'Anil Verma',
          serviceType: serviceType,
          rating: 4.3,
          reviewCount: 56,
          distanceKm: 3.7,
          hourlyRate: 280,
          skills: ['Repair', 'Installation'],
          isAvailable: true,
          bio: 'Affordable and reliable.',
        ),
      ];
}
