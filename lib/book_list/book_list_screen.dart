import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../add_book/add_book_screen.dart';
import '../model/book.dart';
import '../update_book_screen/update_book_screen.dart';
import 'book_list_view_model.dart';

class BookListScreen extends StatelessWidget {
  BookListScreen({Key? key}) : super(key: key);

  final viewModel = BookListViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('도서 리스트 앱'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              viewModel.logout();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: viewModel.booksStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text("Loading");
            }
            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Book book = document.data()! as Book;

                return Dismissible(
                  onDismissed: (_) {
                    viewModel.deleteBook(document.id);
                  },
                  background: Container(
                    alignment: Alignment.centerLeft,
                    color: Colors.red,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  key: ValueKey(document.id),
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UpdateBookScreen(document)),
                      );
                    },
                    leading: Image.network(
                      book.imageUrl,
                      width: 100,
                      height: 100,
                    ),
                    title: Text(book.title),
                    subtitle: Text(book.author),
                  ),
                );
              }).toList(),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddBookScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}