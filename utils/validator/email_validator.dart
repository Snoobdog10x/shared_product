import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reel_t/models/user_profile/user_profile.dart';
import 'package:reel_t/shared_product/utils/validator/validator_impl.dart';
import 'package:email_validator/email_validator.dart' as ev;

class EmailValidator extends ValidatorImpl {
  @override
  bool isValid(String email) {
    return ev.EmailValidator.validate(email);
  }
  
  Future<bool> isEmailRegistered(String email) async {
    final db = FirebaseFirestore.instance
        .collection(UserProfile.PATH)
        .where(UserProfile.email_PATH, isEqualTo: email);
    var snapshot = await db.get();
    return snapshot.docs.isNotEmpty;
  }
}
