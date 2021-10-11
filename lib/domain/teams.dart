import 'package:cloud_firestore/cloud_firestore.dart';

class Team {
  String? uid;
  String? teamName;

  Team(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    uid = doc.id;
    teamName = data['teamName'] as String?;
  }
}
