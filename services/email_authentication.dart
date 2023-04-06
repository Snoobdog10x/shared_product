import 'dart:math';

import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class EmailAuthentication {
  String _username = 'ttt.coop.mail@gmail.com';
  String _password = 'hkeielzyvuukelut';
  String _subject = "Verify your email for REEL T";
  String? _randomOTP;
  late SmtpServer _smtpServer;
  void init() {
    _smtpServer = gmail(_username, _password);
  }

  String generateOTP() {
    var rng = Random();
    var randomOTP = "";
    for (var i = 0; i < 5; i++) {
      randomOTP += rng.nextInt(10).toString();
    }
    _randomOTP = randomOTP;
    return randomOTP;
  }

  Future<bool> sendOTP(String email) async {
    final message = Message()
      ..from = Address(_username, 'REEL T')
      ..recipients.add(email)
      ..subject = _subject
      ..html = _EmailTemplate.renderEmail(email, _randomOTP ?? "");

    try {
      final sendReport = await send(message, _smtpServer);
      print('Message sent: ' + sendReport.toString());
      return true;
    } on MailerException catch (e) {
      print(e);
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
      return false;
    }
  }
}

class _EmailTemplate {
  static String renderEmail(String email, String otpCode) {
    return """<table align="center" cellpadding="0" cellspacing="0" border="0" width="100%"bgcolor="#f0f0f0">
        <tr>
        <td style="padding: 30px 30px 20px 30px;">
            <table cellpadding="0" cellspacing="0" border="0" width="100%" bgcolor="#ffffff" style="max-width: 650px; margin: auto;">
            <tr>
                <td colspan="2" align="center" style="background-color: #333; padding: 40px;">
                    <a href="http://wso2.com/" target="_blank"><img src="http://cdn.wso2.com/wso2/newsletter/images/nl-2017/wso2-logo-transparent.png" border="0" /></a>
                </td>
            </tr>
            <tr>
                <td colspan="2" align="center" style="padding: 50px 50px 0px 50px;">
                    <h1 style="padding-right: 0em; margin: 0; line-height: 40px; font-weight:300; font-family: 'Nunito Sans', Arial, Verdana, Helvetica, sans-serif; color: #666; text-align: left; padding-bottom: 1em;">
                        REEL T ENTERTAINMENT
                    </h1>
                </td>
            </tr>
            <tr>
                <td style="text-align: left; padding: 0px 50px;" valign="top">
                    <p style="font-size: 18px; margin: 0; line-height: 24px; font-family: 'Nunito Sans', Arial, Verdana, Helvetica, sans-serif; color: #666; text-align: left; padding-bottom: 3%;">
                        Hi $email,
                    </p>
                    <p style="font-size: 18px; margin: 0; line-height: 24px; font-family: 'Nunito Sans', Arial, Verdana, Helvetica, sans-serif; color: #666; text-align: left; padding-bottom: 3%;">
                        Please use this one time password $otpCode to sign in to your application
                    </p>
                </td>
            </tr>
            <tr>
                <td style="text-align: left; padding: 30px 50px 50px 50px" valign="top">
                    <p style="font-size: 18px; margin: 0; line-height: 24px; font-family: 'Nunito Sans', Arial, Verdana, Helvetica, sans-serif; color: #505050; text-align: left;">
                        Thanks,<br/>TTT Identity Server Team
                    </p>
                </td>
            </tr>
            <tr>
                <td colspan="2" align="center" style="padding: 20px 40px 40px 40px;" bgcolor="#f0f0f0">
                    <p style="font-size: 12px; margin: 0; line-height: 24px; font-family: 'Nunito Sans', Arial, Verdana, Helvetica, sans-serif; color: #777;">
                        &copy; 2023
                        <a href="http://wso2.com/" target="_blank" style="color: #777; text-decoration: none">TTT</a>
                        <br>
                        787 Castro Street, Mountain View, CA 94041.
                    </p>
                </td>
            </tr>
            </table>
        </td>
    </tr>
</table>""";
  }
}
