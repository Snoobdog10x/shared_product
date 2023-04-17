import 'package:hive/hive.dart';

import '../../models/search_history/search_history.dart';
import '../../models/user_profile/user_profile.dart';

class LocalSearchHistory {
  late Box<SearchHistory> _searchBox;
  String SEARCH_HISTORY_BOX = SearchHistory.PATH;
  Future<void> init(String userId) async {
    var searchAdapter = SearchHistoryAdapter();
    if (!Hive.isAdapterRegistered(searchAdapter.typeId)) {
      Hive.registerAdapter(searchAdapter);
    }
    if (userId != "")
      _searchBox = await Hive.openBox("${SEARCH_HISTORY_BOX}_$userId");
  }

  Future<void> clear() async {
    await _searchBox.clear();
  }

  Future<void> addSearchHistory(SearchHistory searchHistory) async {
    await _searchBox.put(searchHistory.searchText, searchHistory);
  }

  Future<void> removeSearchHistory(SearchHistory searchHistory) async {
    if (_searchBox.containsKey(searchHistory.searchText))
      await _searchBox.delete(searchHistory.searchText);
  }

  List<SearchHistory> getSearchHistories() {
    return _searchBox.values.toList();
  }
}
