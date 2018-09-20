import 'dart:async';

import 'package:programming_quiz/Controller/firestore_helper.dart';

class Player {
  String _nickname;
  num _score;

  String get nickname => _nickname;
  num get score => _score;

  Player(this._nickname, this._score);

  static Future<List<Player>> getTopTenPlayers() async {
    return await FirestoreHelper.getTopTenPlayers();
  }
}