import 'package:cloud_firestore/cloud_firestore.dart';

class GameDetail {
  String? uid;
  String? rnrs;
  String? tokutenPattern;
  String? shittenPattern;
  String? tokutenTime;
  String? shittenTime;
  String? tokutenPlayer;
  int? scoreTime;

  GameDetail(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    uid = doc.id;
    rnrs = data['rnrs'];
    tokutenPattern = data['tokutenPattern'];
    shittenPattern = data['shittenPattern'];
    tokutenTime = data['tokutenTime'];
    shittenTime = data['shittenTime'];
    tokutenPlayer = data['tokutenPlayer'];
    scoreTime = data['scoreTime'];
  }
}
