class LoginRequestModel {
  final String username;
  final String password;

  LoginRequestModel({
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'usr': username,
      'pwd': password,
    };
  }
}

class LoginResponseModel {
  final bool success;
  final String message;
  final String? token;
  final Map<String, dynamic>? userData;

  LoginResponseModel({
    required this.success,
    required this.message,
    this.token,
    this.userData,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    // The API might return success in different formats
    // Handle common success indicators
    bool isSuccess = false;
    String message = 'Unknown response';
    String? token;
    Map<String, dynamic>? userData;

    // Check different success indicators
    if (json.containsKey('success')) {
      isSuccess = json['success'] == true;
    } else if (json.containsKey('status') && json['status'] == 'success') {
      isSuccess = true;
    } else if (json.containsKey('message') &&
        (json['message'] == 'Logged In' ||
            json['message'].toString().toLowerCase().contains('success'))) {
      isSuccess = true;
    } else if (json.containsKey('token') && json['token'] != null) {
      isSuccess = true; // If we got a token, it's likely successful
    }

    // Extract message
    if (json.containsKey('message')) {
      message = json['message'].toString();
    } else if (json.containsKey('msg')) {
      message = json['msg'].toString();
    }

    // Extract token
    if (json.containsKey('token')) {
      token = json['token']?.toString();
    }

    // Extract user data
    if (json.containsKey('user_data')) {
      userData = json['user_data'];
    } else if (json.containsKey('user')) {
      userData = json['user'];
    }

    return LoginResponseModel(
      success: isSuccess,
      message: message,
      token: token,
      userData: userData,
    );
  }

  factory LoginResponseModel.error(String errorMessage) {
    return LoginResponseModel(
      success: false,
      message: errorMessage,
    );
  }
}
