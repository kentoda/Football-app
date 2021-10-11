import 'package:cloud_firestore/cloud_firestore.dart';

class Player {
  String? uid;
  String? playerName;
  String? position;
  int? uniformNumber;
  int? touchdown;
  int? firstdown;
  int? participation;
  int? shot;
  int? scored;
  int? tokutenParticipation;
  int? shittenParticipation;

  Player(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    uid = doc.id;
    position = data['position'];
    playerName = data['playerName'];
    uniformNumber = data['uniformNumber'];
    touchdown = data['touchdown'];
    firstdown = data['firstdown'];
    participation = data['participation'];
    shot = data['shot'];
    scored = data['scored'];
    tokutenParticipation = data['tokutenParticipation'];
    shittenParticipation = data['shittenParticipation'];
  }
}
