import 'package:book_list_app/update_book_screen/update_book_view_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UpdateBookScreen extends StatefulWidget {
  const UpdateBookScreen({Key? key, required this.document}) : super(key: key);
  final DocumentSnapshot document;

  @override
  State<UpdateBookScreen> createState() => _UpdateBookScreenState();
}

class _UpdateBookScreenState extends State<UpdateBookScreen> {
  final _titleTextController = TextEditingController();
  final _authorTextController = TextEditingController();

  final viewModel = UpdateBookViewModel();

  @override
  void initState() {
    super.initState();

    _titleTextController.text = widget.document['title'];
    _authorTextController.text = widget.document['author'];
  }

  @override
  void dispose() {
    _titleTextController.dispose();
    _authorTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('도서 수정')),
      body: Column(
        children: [
          TextField(
            controller: _titleTextController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: '제목',
            ),
          ),
          TextField(
            controller: _authorTextController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: '저자',
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 유효성 검사
          bool isValid = _titleTextController.text.isNotEmpty &&
              _authorTextController.text.isNotEmpty;

          if (isValid) {
            viewModel.updateBook(
              id: widget.document.id,
              title: _titleTextController.text,
              author: _authorTextController.text,
            );
            Navigator.pop(context);
          } else {
            // 에러 메시지 표시
            const snackBar = SnackBar(
              content: Text("제목과 저자를 입력해 주세요"),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        child: const Icon(Icons.done),
      ),
    );
  }
}
