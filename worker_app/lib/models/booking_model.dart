enum BookingStatus {
  requested,
  accepted,
  inProgress,
  completed,
  cancelled,
}

extension BookingStatusExt on BookingStatus {
  String get label {
    switch (this) {
      case BookingStatus.requested:  return 'Requested';
      case BookingStatus.accepted:   return 'Accepted';
      case BookingStatus.inProgress: return 'In Progress';
      case BookingStatus.completed:  return 'Completed';
      case BookingStatus.cancelled:  return 'Cancelled';
    }
  }

  static BookingStatus fromString(String s) {
    switch (s.toLowerCase()) {
      case 'accepted':    return BookingStatus.accepted;
      case 'in_progress':
      case 'inprogress':  return BookingStatus.inProgress;
      case 'completed':   return BookingStatus.completed;
      case 'cancelled':   return BookingStatus.cancelled;
      default:            return BookingStatus.requested;
    }
  }
}

enum PaymentStatus { pending, paid, failed, refunded }

class BookingModel {
  final String id;
  final String workerId;
  final String workerName;
  final String workerAvatar;
  final String serviceType;
  final DateTime scheduledAt;
  final String address;
  final BookingStatus status;
  final PaymentStatus paymentStatus;
  final double? amountPaid;
  final String? paymentId;
  final bool isEmergency;
  final DateTime createdAt;

  const BookingModel({
    required this.id,
    required this.workerId,
    required this.workerName,
    required this.workerAvatar,
    required this.serviceType,
    required this.scheduledAt,
    required this.address,
    required this.status,
    required this.paymentStatus,
    this.amountPaid,
    this.paymentId,
    required this.isEmergency,
    required this.createdAt,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    final worker = json['worker'] as Map<String, dynamic>? ?? {};
    return BookingModel(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      workerId: (worker['_id'] ?? worker['id'] ?? json['workerId'] ?? '').toString(),
      workerName: worker['name'] ?? json['workerName'] ?? json['customerName'] ?? '',
      workerAvatar: worker['avatarUrl'] ?? json['workerAvatar'] ?? '',
      serviceType: json['serviceType'] ?? '',
      scheduledAt: json['scheduledAt'] != null
          ? DateTime.parse(json['scheduledAt'])
          : DateTime.now(),
      address: json['address'] ?? '',
      status: BookingStatusExt.fromString(json['status'] ?? 'requested'),
      paymentStatus: _parsePaymentStatus(json['paymentStatus']),
      amountPaid: (json['amountPaid'] as num?)?.toDouble(),
      paymentId: json['paymentId'],
      isEmergency: json['isEmergency'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  static PaymentStatus _parsePaymentStatus(dynamic s) {
    switch ((s ?? '').toString().toLowerCase()) {
      case 'paid':     return PaymentStatus.paid;
      case 'failed':   return PaymentStatus.failed;
      case 'refunded': return PaymentStatus.refunded;
      default:         return PaymentStatus.pending;
    }
  }

  // ─── Mock bookings ────────────────────────────────────────────────────────
  static List<BookingModel> mockHistory() => [
        BookingModel(
          id: 'b1',
          workerId: 'w1',
          workerName: 'Ramesh Kumar',
          workerAvatar: '',
          serviceType: 'Electrician',
          scheduledAt: DateTime.now().subtract(const Duration(days: 3)),
          address: '12, MG Road, Bengaluru',
          status: BookingStatus.completed,
          paymentStatus: PaymentStatus.paid,
          amountPaid: 700,
          paymentId: 'pay_test_001',
          isEmergency: false,
          createdAt: DateTime.now().subtract(const Duration(days: 3, hours: 2)),
        ),
        BookingModel(
          id: 'b2',
          workerId: 'w2',
          workerName: 'Suresh Nair',
          workerAvatar: '',
          serviceType: 'Plumber',
          scheduledAt: DateTime.now().add(const Duration(days: 1)),
          address: '45, Indiranagar, Bengaluru',
          status: BookingStatus.accepted,
          paymentStatus: PaymentStatus.pending,
          isEmergency: true,
          createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        ),
      ];
}
