import 'package:cloud_firestore/cloud_firestore.dart';

class Game {
  String? uid;
  String? opponentName;
  Timestamp? gameDate;
  int? tokuten;
  int? shitten;
  int? allFirstDown;
  int? allShot;

  Game(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    uid = doc.id;
    opponentName = data['opponentName'];
    gameDate = data['gameDate'];
    tokuten = data['tokuten'];
    shitten = data['shitten'];
    allFirstDown = data['allFirstDown'];
    allShot = data['allShot'];
  }
}
