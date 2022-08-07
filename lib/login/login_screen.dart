import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../home/home_screen.dart';
import '../singup/signup_screen.dart';
import 'login_view_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // firebase
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  final viewModel = LoginViewModel();
  String? errorMessage;

  @override
  void dispose() {
    _emailTextController.dispose();
    _passwordTextController.dispose();
    super.dispose();
  }

  Widget _genEmail() {
    return TextFormField(
      autofocus: false,
      controller: _emailTextController,
      keyboardType: TextInputType.emailAddress,
      validator: (String? value) {
        if (value!.isEmpty) {
          return ("이메일 주소를 입력하세요");
        }
        // reg expression for email validation
        if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
          return ("유효한 이메일 주소를 입력하세요");
        }
        return null;
      },
      onSaved: (String? value) {
        _emailTextController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: _genInputDecoration("Email"),
    );
  }

  Widget _genPassword() {
    return TextFormField(
      autofocus: false,
      controller: _passwordTextController,
      obscureText: true,
      validator: (String? value) {
        RegExp regex = RegExp(r'^.{6,}$');
        if (value!.isEmpty) {
          return ("로그인을 하려면 비밀번호를 입력하세요");
        }
        if (!regex.hasMatch(value)) {
          return ("최소 6 글자 이상 입력해야 합니다.");
        }
        return null;
      },
      onSaved: (String? value) {
        _passwordTextController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: _genInputDecoration("Password"),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('로그인'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                          height: 200,
                          child: Image.asset(
                            "assets/tarotWheel.png",
                            fit: BoxFit.contain,
                          )),
                      const SizedBox(height: 35),
                      _genEmail(),
                      const SizedBox(height: 25),
                      _genPassword(),
                      const SizedBox(height: 15),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  signIn(
                    _emailTextController.text,
                    _passwordTextController.text,
                  );
                },
                child: const Text('로그인'),
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text("신규등록을 하시려면!"),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUpScreen()));
                    },
                    child: const Text(
                      "신규등록",
                      style: TextStyle(
                          color: Colors.redAccent,
                          fontWeight: FontWeight.bold,
                          fontSize: 15),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {
                  viewModel.signInWithGoogle();
                },
                child: const Text('Goggle'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // login function
  void signIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth
            .signInWithEmailAndPassword(
              email: email,
              password: password,
            )
            .then((uid) => {
                  Fluttertoast.showToast(msg: "로그인에 성공하셨습니다."),
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const HomeScreen())),
                });
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "invalid-email":
            errorMessage = "이메일주소가 @ 형식에 맞지 않습니다.";
            break;
          case "wrong-password":
            errorMessage = "비밀번호가 틀렸습니다.";
            break;
          case "user-not-found":
            errorMessage = "이메일이 존재하지 않습니다.";
            break;
          case "user-disabled":
            errorMessage = "사용할 수 없는 이메일 입니다.";
            break;
          case "too-many-requests":
            errorMessage = "request가 너무 많습니다.";
            break;
          case "operation-not-allowed":
            errorMessage = "이메일과 비밀번호가 유효하지 않습니다.";
            break;
          default:
            errorMessage = "알 수 없는 에러가 발생했습니다./n다시 시작해주세요.";
        }
        Fluttertoast.showToast(msg: errorMessage!);
        print(error.code);
      }
    }
  }

  InputDecoration _genInputDecoration(String text) {
    return InputDecoration(
      prefixIcon: const Icon(Icons.mail),
      contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
      hintText: text,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
