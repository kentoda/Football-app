import 'package:cloud_firestore/cloud_firestore.dart';

class Categorys {
  String? uid;
  String? categoryName;

  Categorys(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    uid = doc.id;
    categoryName = data['categoryName'] as String?;
  }
}
