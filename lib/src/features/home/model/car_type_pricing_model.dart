import 'package:dropsride/src/features/trips/model/car_types.dart';

class CarPricing {
  CarType? carType;
  String? km;
  double? amount;

  CarPricing({
    required this.carType,
    required this.km,
    required this.amount,
  });
}
