import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reel_t/generated/abstract_service.dart';

class FirestoreSearch extends AbstractService{
  String? _prevSearchText = null;
  QueryDocumentSnapshot<Map<String, dynamic>>? _lastSnapshot;
  final _db = FirebaseFirestore.instance;
  List<String> _initCollectionPath(String collectionPaths) {
    return collectionPaths.split("/");
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> searchStream({
    String collectionPaths = "",
    String searchByPath = "",
    String searchText = "",
    int limitPerSearch = 10,
  }) async {
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
    collectionRef =
        (collectionRef as CollectionReference<Map<String, dynamic>>);
    var searchResults = await _getSnapshot(collectionRef, collectionPaths,
        searchByPath, searchText, limitPerSearch);

    if (searchResults.docs.isEmpty) return [];

    return searchResults.docs;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> _getSnapshot(
    CollectionReference<Map<String, dynamic>> collectionRef,
    String collectionPaths,
    String searchByPath,
    String searchText,
    int limitPerSearch,
  ) async {
    var searchResults;
    if (_prevSearchText != searchText) {
      searchResults = await collectionRef
          .orderBy(searchByPath, descending: false)
          .where(searchByPath, isGreaterThanOrEqualTo: searchText)
          .where(searchByPath, isLessThan: searchText + 'z')
          .limit(limitPerSearch)
          .get();
      _prevSearchText = searchText;
      if (searchResults.docs.isNotEmpty)
        _lastSnapshot = searchResults.docs.last;
      return searchResults;
    }

    searchResults = await collectionRef
        .orderBy(searchByPath, descending: false)
        .where(searchByPath, isGreaterThanOrEqualTo: searchText)
        .where(searchByPath, isLessThan: searchText + 'z')
        .startAfterDocument(_lastSnapshot!)
        .limit(limitPerSearch)
        .get();
    _prevSearchText = searchText;
    if (searchResults.docs.isNotEmpty) _lastSnapshot = searchResults.docs.last;

    return searchResults;
  }
  
  @override
  void dispose() {
    // TODO: implement dispose
  }
  
  @override
  void init() {
    // TODO: implement init
  }
}
