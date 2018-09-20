import 'dart:async';

import 'package:flutter/material.dart';
import 'package:programming_quiz/Model/player.dart';
import 'package:programming_quiz/View/utility_widgets.dart';

class LeaderBoardPage extends StatelessWidget {
  final Future<List<Player>> topPlayers;

  LeaderBoardPage() : topPlayers = Player.getTopTenPlayers();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Leaderboard"),
        leading: Icon(
          Icons.star,
          color: Colors.yellow,
          size: 40.0,
        ),
      ),
      body: FutureBuilder(
          future: topPlayers,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  VerticalSpacer(10.0),
                  TextTitle(
                    text: "Top Players",
                    textAlign: TextAlign.center,
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding:
                          EdgeInsets.symmetric(horizontal: 40.0, vertical: 4.0),
                      itemCount: snapshot.data.length,
                      itemBuilder: (BuildContext context, int ranking) =>
                          PlayerRankingCard(ranking, snapshot.data),
                    ),
                  )
                ],
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}

class PlayerRankingCard extends StatelessWidget {
  final int _ranking;
  final _playerList;

  PlayerRankingCard(this._ranking, this._playerList);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        height: 50.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Expanded(
              child: TextTitle(
                text: (_ranking + 1).toString(),
                fontSize: 25.0,
              ),
            ),
            getRankingImage(_ranking),
            Expanded(child: Container()),
            Expanded(
              flex: 3,
              child: TextTitle(text: _playerList[_ranking].nickname),
            ),
            Expanded(
              flex: 1,
              child: TextTitle(text: _playerList[_ranking].score.floor().toString()),
            ),
          ],
        ),
      ),
    );
  }

  Widget getRankingImage(int ranking) {
    switch (ranking) {
      case 0:
        return Expanded(child: Image.asset("images/trophy_gold.png", height: 40.0));
        break;
      case 1:
        return Expanded(child: Image.asset("images/trophy_silver.png", height: 35.0));
        break;
      case 2:
        return Expanded(child: Image.asset("images/trophy_bronze.png", height: 30.0));
        break;
      default:
        return Expanded(
          child: Container(),
          flex: 1,
        );
    }
  }
}
