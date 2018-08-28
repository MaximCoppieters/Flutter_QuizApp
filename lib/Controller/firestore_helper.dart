import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:programming_quiz/Model/courses.dart';

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

    documentStructure.write('{"nickname":"$nickname", "courses":[');
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

  static getPlayerCollection(String nickname) async {
    return instance
        .collection("players")
        .where("nickname", isEqualTo: nickname);
  }
}
