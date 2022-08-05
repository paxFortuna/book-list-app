import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class BookListViewModel {
  final _db = FirebaseFirestore.instance;
  final _googleSignIn = GoogleSignIn();

  Stream<QuerySnapshot> get booksStream => _db.collection('books').snapshots();

  void deleteBook(String id) {
    _db.collection('books').doc(id).delete();
  }

  void logout() async {
    await _googleSignIn.signOut();
    await FirebaseAuth.instance.signOut();
    // google signOut
  }
}