class Mechanic {
  final String id;
  final String name;
  final String phoneNumber;
  final String bio;
  final double rating;
  final int reviews;
  final int experienceYears;
  final double basePrice;
  final double distanceKm;
  final bool isVerified;
  final String imageUrl;

  Mechanic({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.bio,
    required this.rating,
    required this.reviews,
    required this.experienceYears,
    required this.basePrice,
    required this.distanceKm,
    required this.isVerified,
    required this.imageUrl,
  });
}
