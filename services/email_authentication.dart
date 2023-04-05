import 'dart:math';

import 'package:email_otp/email_otp.dart';

class EmailAuthentication {
  EmailOTP _emailAuth = EmailOTP();
  void init() {
    _emailAuth.setSMTP(
      host: "smtp.gmail.com",
      auth: true,
      username: "duythanh1565@gmail.com",
      password: "fynbwibexdruzwxk",
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
}
