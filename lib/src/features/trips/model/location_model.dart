class Location {
  final String uid;
  final String name;
  final double amount;

  Location({
    required this.uid,
    required this.name,
    required this.amount,
  });
}

class Subscription {
  final String uid;
  Location locationId;
  DateTime expiresOn;
  bool isActive;

  Subscription({
    required this.uid,
    required this.locationId,
  })  : expiresOn = DateTime(2003, 1, 1),
        isActive = false;

  void startTimer() {
    isActive = true;
    expiresOn = DateTime.now();

    // Calculate the end time from the start time by adding 24 hours to the start time
    DateTime endTime = expiresOn.add(const Duration(hours: 24));

    // Start a countdown timer
    Duration remainingTime = endTime.difference(DateTime.now());
    Future.delayed(remainingTime, () {
      isActive = false;
    });
  }
}
