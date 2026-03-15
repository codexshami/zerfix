enum JobStatus {
  pending,
  accepted,
  mechanicArrived,
  inProgress, // OTP verified
  completed,
  cancelled
}

class Job {
  final String id;
  final String customerId;
  final String mechanicId;
  final DateTime requestedAt;
  JobStatus status;
  final String address;
  final double homingCharge;
  final String otp;
  
  double? partsCost;
  double? serviceCharge;

  Job({
    required this.id,
    required this.customerId,
    required this.mechanicId,
    required this.requestedAt,
    required this.status,
    required this.address,
    required this.homingCharge,
    required this.otp,
    this.partsCost,
    this.serviceCharge,
  });

  double get totalCost => homingCharge + (partsCost ?? 0) + (serviceCharge ?? 0);
}
