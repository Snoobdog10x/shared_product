import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreSearch {
  final _db = FirebaseFirestore.instance;
  List<String> _initCollectionPath(String collectionPaths) {
    return collectionPaths.split("/");
  }

  Stream? searchStream({
    String collectionPaths = "",
    String searchByPath = "",
    String searchText = "",
    int limitPerSearch = 10,
  }) {
    List<String> _collectionPaths = _initCollectionPath(collectionPaths);
    assert(_collectionPaths.length.isOdd);

    dynamic collectionRef = _db;
    for (var path in _collectionPaths) {
      if (_collectionPaths.indexOf(path).isEven) {
        collectionRef = collectionRef.collection(path);
        continue;
      }

      collectionRef = collectionRef.doc(path);
    }

    (collectionRef as CollectionReference)
        .orderBy(searchByPath, descending: false)
        .where(searchByPath, isGreaterThanOrEqualTo: searchText)
        .where(searchByPath, isLessThan: searchText + 'z')
        .limit(limitPerSearch)
        .snapshots()
        // .map(dataListFromSnapshot!);
    ;
  }
}
