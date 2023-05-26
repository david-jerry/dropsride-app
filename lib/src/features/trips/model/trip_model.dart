enum TripStatus {
  active,
  completed,
  cancelled,
}

class Trips {
  final String uid;
  final String riderUid;
  final String driverUid;
  final String carName;
  final String plateNumber;
  final Duration duration;
  final double distance;
  final double amount;
  final String pickup;
  final String dropOff;
  final double rating;
  final TripStatus status;

  Trips({
    required this.uid,
    required this.riderUid,
    required this.driverUid,
    required this.carName,
    required this.plateNumber,
    required this.duration,
    required this.distance,
    required this.amount,
    required this.pickup,
    required this.dropOff,
    required this.rating,
    required this.status,
  });
}
