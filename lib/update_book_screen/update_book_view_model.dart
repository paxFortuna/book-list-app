import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateBookViewModel {
  final _db = FirebaseFirestore.instance;

  void updateBook({
    required String id,
    required String title,
    required String author,
  }) {
    _db.collection('books').doc(id).set({
      "title": title,
      "author": author,
    });
  }
}
