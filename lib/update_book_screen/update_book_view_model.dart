import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../model/book.dart';

class UpdateBookViewModel {
  final _db = FirebaseFirestore.instance
      .collection('books')
      .withConverter<Book>(
      fromFirestore: (snapshot, _) => Book.fromJson(snapshot.data()!),
      toFirestore: (book, _) => book.toJson());

  final _storage = FirebaseStorage.instance;

  bool isLoading = false;

  void startLoading() {
    isLoading = true;
  }

  void endLoading() {
    isLoading = false;
  }
  Future<String> uploadImage(String fileName, Uint8List bytes) async {
    final storageRef = _storage.ref().child('book_cover/$fileName.jpg');
    await storageRef.putData(bytes);
    String downloadUrl = await storageRef.getDownloadURL();
    return downloadUrl;
  }

  Future updateBook({
    required String title,
    required String author,
    required Uint8List? bytes,
  }) async {
    // 빈 문서 (ID를 미리 얻을 때)
    final doc = _db.doc();

    // 이미지 업로드하고 다운로드 URL 얻기
    String downloadUrl = await uploadImage(doc.id, bytes!);

    // 문서 덮어쓰기
    await _db
        .doc(doc.id)
        .set(Book(title: title, author: author, imageUrl: downloadUrl));
  }

  bool isValid(String title, String author) {
    return title.isNotEmpty && author.isNotEmpty;
  }

  // Future<void> updateBook({
  //   required String title,
  //   required String author,
  //   required Uint8List? bytes,
  // }) async{
  //   final doc = _db.doc();
  //   // 이미지 업로드하고 다운로드 URL 얻기
  //   String downloadUrl = await uploadImage(doc.id, bytes!);
  //
  //   bool isValid = title.isNotEmpty && author.isNotEmpty;
  //
  //   if (isValid) {
  //     _db.doc(doc.id).set(
  //         Book(
  //           title: title,
  //           author: author,
  //           imageUrl: downloadUrl,
  //         ));
  //   } else if (title.isEmpty && author.isEmpty) {
  //     throw '모두 입력해 주세요';
  //   } else if (title.isEmpty) {
  //     throw '제목을 입력해 주세요';
  //   } else if (author.isEmpty) {
  //     throw '저자를 입력해 주세요';
  //   }
  // }
}