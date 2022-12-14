import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'color_schemes.g.dart';
import 'firebase_options.dart';
import 'root/root_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Future text() : catchError debug issue
  //test().then((value) => null).catchError((e) => print(e));
  runApp(const MyApp());
}

//test() {
//  throw 'test';
//}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

    @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: lightColorScheme,
      ),
      home: const RootScreen(),
    );
  }
}
