class BusinessProfile {
  String user;
  String businessName;
  String businessType;
  String ownerName;
  String phone;
  String address;
  bool atMyPlace;
  bool atClientLocation;

  BusinessProfile({
    required this.user,
    required this.businessName,
    required this.businessType,
    required this.ownerName,
    required this.phone,
    required this.address,
    this.atMyPlace = false,
    this.atClientLocation = false,
  });

  Map<String, dynamic> toJson() {
    return {
      "user": user,
      "business_name": businessName,
      "business_type": businessType,
      "owner_name": ownerName,
      "phone": phone,
      "address": address,
      "at_my_place": atMyPlace ? 1 : 0,
      "at_client_location": atClientLocation ? 1 : 0,
    };
  }

  factory BusinessProfile.fromJson(Map<String, dynamic> json) {
    return BusinessProfile(
      user: json["user"],
      businessName: json["business_name"],
      businessType: json["business_type"],
      ownerName: json["owner_name"],
      phone: json["phone"],
      address: json["address"],
      atMyPlace: json["at_my_place"] == 1,
      atClientLocation: json["at_client_location"] == 1,
    );
  }
}
