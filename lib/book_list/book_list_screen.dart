import 'package:flutter/material.dart';

class BookListScreen extends StatelessWidget {
  const BookListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('도서 리스트 앱'),
      ),
      body: ListView(
        children: const [
          ListTile(
            title: Text('Flutter 생존코딩'),
            subtitle: Text('오준석'),
          ),
          ListTile(
            title: Text('안드로이드 생존코딩'),
            subtitle: Text('오준석'),
          ),
          ListTile(
            title: Text('될 때까지 안드로이드'),
            subtitle: Text('오준석'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}