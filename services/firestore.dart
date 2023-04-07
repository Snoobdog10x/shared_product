import 'package:cloud_firestore/cloud_firestore.dart';

class FireStore {
  FirebaseFirestore _db = FirebaseFirestore.instance;
  void init(bool isWeb) {
    if (isWeb) {
      _db.enablePersistence(const PersistenceSettings(synchronizeTabs: true));
      return;
    }
    _db.settings = const Settings(persistenceEnabled: true);
  }
}
