class TravelFee {
  final String user;
  final String feeType;
  final String paymentMethod;
  final String maxDistance;

  TravelFee({
    required this.user,
    required this.feeType,
    required this.paymentMethod,
    required this.maxDistance,
  });

  Map<String, dynamic> toJson() {
    return {
      "user": user,
      "fee_type": feeType,
      "payment_method": paymentMethod,
      "max_distance": maxDistance,
    };
  }
}
