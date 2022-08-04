import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateBookViewModel {
  final _db = FirebaseFirestore.instance;

  void updateBook({
    required String id,
    required String title,
    required String author,
  }) {

    bool isValid = title.isNotEmpty && author.isNotEmpty;

    if(isValid) {
      _db.collection('books').doc(id).set({
        "title": title,
        "author": author,
      });
    } else if (title.isEmpty && author.isEmpty) {
      throw '모두 입력해 주세요';
    } else if (title.isEmpty) {
      throw '제목을 입력해 주세요';
    } else if (author.isEmpty) {
      throw '저자를 입력해 주세요';
    }
  }
}
