import 'package:capstone_project/model/comment_model.dart';
import 'package:capstone_project/model/service/reading_list_service.dart';
import 'package:capstone_project/utils/state/finite_state.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ArticleDetailProvider extends ChangeNotifier {
  MyState myState = MyState.initial;
  late SharedPreferences _loginData;
  List<Comment> comments = [];
  String _message = '';
  List<String> savedArticleIds = [];
  final ReadingListService _readingListService = ReadingListService();

  ArticleDetailProvider() {
    initializeSharedPreferences(); // Pindahkan pemanggilan ke dalam konstruktor
  }

  void initializeSharedPreferences() async {
    changeState(MyState.loading);
    _loginData = await SharedPreferences.getInstance();
    changeState(MyState.loaded);
  }

  void changeState(MyState state) {
    myState = state;
  }

  bool isLoggedIn() {
    return _loginData.containsKey('token') &&
        _loginData.getString('token')!.isNotEmpty;
  }

  Future<void> saveArticleStatus(String articleId, bool isSaved) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(articleId, isSaved);
  }

  Future<void> removeArticleFromReadingList(String articleId) async {
    try {
      myState = MyState.loading;
      _loginData = await SharedPreferences.getInstance();
      final token = _loginData.getString('token') ?? '';
      await _readingListService.deleteReadingList(token: token, id: articleId);
      savedArticleIds.remove(articleId);
      saveArticleStatus(articleId, false);
      myState = MyState.loaded;
      notifyListeners();
    } catch (e) {
      _message = e.toString();
      myState = MyState.failed;
    }
  }

  bool isArticleSaved(String articleId) {
    return savedArticleIds.contains(articleId);
  }

  void toggleArticleSaved(String articleId) {
    if (savedArticleIds.contains(articleId)) {
      savedArticleIds.remove(articleId);
      saveArticleStatus(articleId,
          false); // Menyimpan status false ke dalam SharedPreferences
    } else {
      savedArticleIds.add(articleId);
      saveArticleStatus(
          articleId, true); // Menyimpan status true ke dalam SharedPreferences
    }
    notifyListeners();
  }
}