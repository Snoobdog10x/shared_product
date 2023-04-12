import 'package:reel_t/shared_product/utils/validator/validator_impl.dart';

class PasswordValidator implements ValidatorImpl {
  @override
  bool isValid(String password) {
    if (password.length <= 8) return false;
    RegExp regex =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    if (!regex.hasMatch(password)) {
      return true;
    }

    return false;
  }

  List<String> getPasswordRules() {
    return [
      "Minimum 1 Upper case",
      "Minimum 1 lowercase",
      "Minimum 1 Numeric Number",
      "Minimum 1 Special Character",
      "Common Allow Character ( ! @ # \$ & * ~ )"
    ];
  }
}
