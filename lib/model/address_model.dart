class UserAddress {
  final String user;
  final String addressLine1;
  final String? addressLine2;
  final String city;
  final String zipCode;
  final String state;
  final bool isSharedLocation;
  final String? boothNo;

  UserAddress({
    required this.user,
    required this.addressLine1,
    this.addressLine2,
    required this.city,
    required this.zipCode,
    required this.state,
    required this.isSharedLocation,
    this.boothNo,
  });

  Map<String, dynamic> toJson() => {
        'user': user,
        'address_line_1': addressLine1,
        'address_line_2': addressLine2 ?? "",
        'city': city,
        'zip_code': zipCode,
        'state': state,
        'is_shared_location': isSharedLocation ? 1 : 0,
        'booth_no': boothNo ?? "",
      };

  factory UserAddress.fromJson(Map<String, dynamic> json) {
    return UserAddress(
      user: json['userId'] ?? json['user'] ?? "",
      addressLine1: json['address_line_1'] ?? "",
      addressLine2: json['address_line_2'],
      city: json['city'] ?? "",
      zipCode: json['zip_code'] ?? "",
      state: json['state'] ?? "",
      isSharedLocation:
          json['is_shared_location'] == 1 || json['is_shared_location'] == true,
      boothNo: json['booth_no'],
    );
  }

  @override
  String toString() {
    String address = addressLine1;
    if (addressLine2 != null && addressLine2!.isNotEmpty) {
      address += ", $addressLine2";
    }
    address += ", $city, $state - $zipCode";
    return address;
  }
}
