import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:programming_quiz/Model/courses.dart';
import 'package:programming_quiz/Model/player.dart';

class FirestoreHelper {
  static Firestore instance = Firestore.instance;

  static void createEmptyPlayerDocument(String nickname) {
    String documentSkeletonJson = _createEmptyDocumentJson(nickname);
    var documentMap = json.decode(documentSkeletonJson);
    instance.collection("players").add(documentMap);
    print("Player $nickname succesfully added in Firestore");
  }

  static String _createEmptyDocumentJson(String nickname) {
    StringBuffer documentStructure = StringBuffer();

    documentStructure.write('{"nickname":"$nickname", "points":0, "courses":[');
    for (int i = 0; i < Course.values.length; i++) {
      if (i == Course.values.length - 1) {
        documentStructure.write(
            '{"correct":0,"count":0,"wrong":0,"name":"${Course.values[i].formalName}"}');
      } else {
        documentStructure.write(
            '{"correct":0,"count":0,"wrong":0,"name":"${Course.values[i].formalName}"},');
      }
    }

    documentStructure.write(']}');
    return documentStructure.toString();
  }

  static Future<DocumentReference> getDocumentByNickname(
      String nickname) async {
    Query firestoreSelection =
        instance.collection("players").where("nickname", isEqualTo: nickname);
    QuerySnapshot snapshot = await firestoreSelection.getDocuments();

    var documentId = snapshot.documents[0].documentID;
    return instance.document("players/$documentId");
  }

  static getPlayerDataFromDocument(DocumentReference document) async {
    DocumentSnapshot documentSnapshot = await document.get();
    return documentSnapshot.data;
  }

  static Query getPlayerCollection(String nickname) {
    return instance
        .collection("players")
        .where("nickname", isEqualTo: nickname);
  }

  static Stream<QuerySnapshot> getPlayerSnapshots(
      String nickname) {
      return getPlayerCollection(nickname)
              .snapshots();
  }

  static Future<QuerySnapshot> _getSnapshotTopTenPlayers() {
    return instance
        .collection("players")
        .orderBy("points", descending: true)
        .limit(10)
        .getDocuments();
  }

  static Future<List<DocumentSnapshot>> _getTopTenPlayerDocuments() async {
    QuerySnapshot topPlayerSnapshot = await _getSnapshotTopTenPlayers();
    return topPlayerSnapshot.documents;
  }

  static Future<List<Player>> getTopTenPlayers() async {
    List<DocumentSnapshot> topTenPlayerDocuments =
        await _getTopTenPlayerDocuments();
    List<Player> topTenPlayers = [];

    for (int i = 0; i < topTenPlayerDocuments.length; i++) {
      Map playerData = topTenPlayerDocuments[i].data;
      String nickname = playerData["nickname"];
      num points = playerData["points"];
      Player currentPlayer = Player(nickname, points);
      topTenPlayers.add(currentPlayer);
    }

    return topTenPlayers;
  }
}
