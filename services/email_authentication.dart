import 'dart:math';
import 'dart:convert';
import 'package:http/http.dart' as http;

class EmailAuthentication {
  _EmailOTP _emailAuth = _EmailOTP();
  void init() {
    _emailAuth.setSMTP(
      host: "smtp.gmail.com",
      auth: true,
      username: "ttt.coop.mail@gmail.com",
      password: "hkeielzyvuukelut",
      secure: "SLL",
      port: 587,
    );
  }

  Future<bool> sendOTP(String email) async {
    _emailAuth.setConfig(
      appName: "Reel T",
      appEmail: "duythanh1565@gmail.com",
      otpLength: 5,
      otpType: OTPType.digitsOnly,
      userEmail: email,
    );

    return await _emailAuth.sendOTP();
  }

  bool verifyOTP(String otp) {
    return _emailAuth.verifyOTP(otp: otp);
  }

  void removeOTP() {
    return _emailAuth.removeOTP();
  }
}

enum OTPType { digitsOnly, stringOnly, mixed }

class _EmailOTP {
  /// Name of your application.
  String? _appName;

  /// Your email address.
  String? _appEmail;

  ///Email address of client, where you want to send OTP
  String? _userEmail;

  ///Will save correct OTP
  String? _getOTP;

  //Custom length for otp digits
  int? _otpLength;

  //Custom OTP Type
  String? _type;

  //SMTP Host Name
  String? _host;

  //SMTP Auth
  bool? _auth;

  //SMTP Username
  String? _username;

  //SMTP Password
  String? _password;

  //SMTP Secure
  String? _secure;

  //SMTP Port
  int? _port;
  void removeOTP() {
    _getOTP = null;
  }

  //Function to set custom SMTP Configuration
  void setSMTP({host, auth, username, password, secure, port}) {
    _host = host;
    _auth = auth;
    _username = username;
    _password = password;
    _secure = secure;
    _port = port;
  }

  ///Function use to config Email OTP
  void setConfig({appName, appEmail, userEmail, otpLength, otpType}) {
    _appName = appName;
    _appEmail = appEmail;
    _userEmail = userEmail;
    _otpLength = otpLength;
    switch (otpType) {
      case OTPType.digitsOnly:
        _type = "digits";
        break;
      case OTPType.stringOnly:
        _type = "string";
        break;
      case OTPType.mixed:
        _type = "mixed";
        break;
    }
  }

  ///Function will return true / false
  Future<bool> sendOTP() async {
    var url = Uri.parse('https://flutter.rohitchouhan.com/email-otpV2/v2.php');
    Map<String, dynamic> body = {
      "app_name": _appName,
      "app_email": _appEmail,
      "user_email": _userEmail,
      "otp_length": _otpLength,
      "type": _type,
      "smtp_host": _host,
      "smtp_auth": _auth,
      "smtp_username": _username,
      "smtp_password": _password,
      "smtp_secure": _secure,
      "smtp_port": _port
    };
    http.Response response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode(body),
    );
    try {
      if (response.statusCode == 200) {
        String data = response.body;
        var decodedData = jsonDecode(data);
        if (decodedData['status'] == true) {
          _getOTP = decodedData['otp'].toString();
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  ///Function will return true / false
  bool verifyOTP({otp}) {
    if (_getOTP == otp) {
      removeOTP();
      return true;
    } else {
      return false;
    }
  }
}
