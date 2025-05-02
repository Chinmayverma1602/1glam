class TravelFee {
  final String user;
  final String feeType;
  final String fee;
  final int maxDistance;

  TravelFee({
    required this.user,
    required this.feeType,
    required this.fee,
    required this.maxDistance,
  });

  Map<String, dynamic> toJson() {
    return {
      "user": user,
      "fee_type": feeType,
      "fee": fee,
      "max_distance": maxDistance,
    };
  }

  factory TravelFee.fromJson(Map<String, dynamic> json) {
    return TravelFee(
      user: json['userId'] ?? json['user'],
      feeType: json['fee_type'],
      fee: json['fee'],
      maxDistance: int.parse(json['max_distance'].toString()),
    );
  }
}
