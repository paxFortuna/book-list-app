import 'dart:typed_data';

import 'package:book_list_app/update_book_screen/update_book_view_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UpdateBookScreen extends StatefulWidget {
  const UpdateBookScreen(this.document, {Key? key}) : super(key: key);
  final DocumentSnapshot document;

  @override
  State<UpdateBookScreen> createState() => _UpdateBookScreenState();
}

class _UpdateBookScreenState extends State<UpdateBookScreen> {
  final _titleTextController = TextEditingController();
  final _authorTextController = TextEditingController();

  final viewModel = UpdateBookViewModel();
  final ImagePicker _picker = ImagePicker();

  // byte array
  Uint8List? _bytes;

  @override
  void initState() {
    super.initState();
    _titleTextController.text = widget.document['title'];
    _authorTextController.text = widget.document['author'];
    _bytes = widget.document['imageUrl'];
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
        appBar: AppBar(
          title: const Text('도서 수정'),
          centerTitle: true,
        ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                GestureDetector(
                  onTap: () async {
                    XFile? image =
                    await _picker.pickImage(source: ImageSource.gallery);
                    if (image != null) {
                      // byte array
                      _bytes = await image.readAsBytes();

                      setState(() {});
                    }
                  },
                  child: _bytes == null
                      ? Container(
                    width: 200,
                    height: 200,
                    color: Colors.grey,
                  )
                      : Image.memory(_bytes!, width: 200, height: 200),
                ),
                const SizedBox(height: 20),
                TextField(
                  onChanged: (_) {
                    setState(() {});
                  },
                  controller: _titleTextController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '제목',
                  ),
                ),
                TextField(
                  onChanged: (_) {
                    setState(() {});
                  },
                  controller: _authorTextController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '저자',
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: viewModel.isValid(
                      _titleTextController.text,
                      _authorTextController.text,
                    )
                        ? null
                        : () async {
                      setState(() {
                        viewModel.startLoading();
                      });

                      await viewModel.updateBook(
                        title: _titleTextController.text,
                        author: _authorTextController.text,
                        bytes: _bytes,
                      );

                      setState(() {
                        viewModel.endLoading();
                      });

                      Navigator.pop(context);
                    },
                    child: const Text('도서 수정')),
              ],
            ),
            if (viewModel.isLoading)
              Container(
                color: Colors.black45,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
