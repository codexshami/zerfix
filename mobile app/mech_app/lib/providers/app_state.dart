import 'package:flutter/foundation.dart';
import '../models/mechanic.dart';
import '../models/job.dart';

enum UserRole { none, customer, mechanic }

class AppState extends ChangeNotifier {
  UserRole _role = UserRole.none;
  UserRole get role => _role;

  final List<Mechanic> _mechanics = [
    Mechanic(
      id: 'm1',
      name: 'Raju Sharma',
      phoneNumber: '+91 9876543210',
      bio: 'Expert in split AC and refrigerator repair with 10 years experience.',
      rating: 4.8,
      reviews: 124,
      experienceYears: 10,
      basePrice: 200, // Homing charge
      distanceKm: 2.5,
      isVerified: true,
      imageUrl: 'https://i.pravatar.cc/150?img=11',
    ),
    Mechanic(
      id: 'm2',
      name: 'Amit Kumar',
      phoneNumber: '+91 9876543211',
      bio: 'Quick and reliable service for all brands of ACs.',
      rating: 4.5,
      reviews: 89,
      experienceYears: 5,
      basePrice: 150,
      distanceKm: 4.0,
      isVerified: true,
      imageUrl: 'https://i.pravatar.cc/150?img=12',
    ),
    Mechanic(
      id: 'm3',
      name: 'Suresh Singh',
      phoneNumber: '+91 9876543212',
      bio: 'Specialist in deep cleaning and gas refilling.',
      rating: 4.9,
      reviews: 210,
      experienceYears: 8,
      basePrice: 250,
      distanceKm: 1.2,
      isVerified: true,
      imageUrl: 'https://i.pravatar.cc/150?img=13',
    ),
  ];

  List<Mechanic> get mechanics => _mechanics;

  Job? _currentJob;
  Job? get currentJob => _currentJob;

  void setRole(UserRole newRole) {
    _role = newRole;
    notifyListeners();
  }

  void createJob(Mechanic mechanic, String address) {
    _currentJob = Job(
      id: 'job_${DateTime.now().millisecondsSinceEpoch}',
      customerId: 'c1', // Mock current customer
      mechanicId: mechanic.id,
      requestedAt: DateTime.now(),
      status: JobStatus.pending,
      address: address,
      homingCharge: mechanic.basePrice,
      otp: '1234', // Mock OTP
    );
    notifyListeners();
  }

  void updateJobStatus(JobStatus newStatus) {
    if (_currentJob != null) {
      _currentJob!.status = newStatus;
      notifyListeners();
    }
  }

  void completeJob(double parts, double service) {
    if (_currentJob != null) {
      _currentJob!.partsCost = parts;
      _currentJob!.serviceCharge = service;
      _currentJob!.status = JobStatus.completed;
      notifyListeners();
    }
  }

  void cancelJob() {
    if (_currentJob != null) {
      _currentJob!.status = JobStatus.cancelled;
      _currentJob = null;
      notifyListeners();
    }
  }
}
