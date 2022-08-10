import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../model/user_model.dart';
import '../root/root_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  String? errorMessage;

  // editing Controller
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _confirmPasswordTextController = TextEditingController();

  Widget _genEmail(){
    return TextFormField(
        autofocus: false,
        controller: _emailTextController,
        keyboardType: TextInputType.emailAddress,
        validator: (String? value) {
          if (value!.isEmpty) {
            return ("이메일 주소를 입력하세요.");
          }
          // reg expression for email validation
          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
              .hasMatch(value)) {
            return ("정확한 이메일 주소를 입력하세요.");
          }
          return null;
        },
        onSaved: (String? value) {
          _emailTextController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.mail),
          contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Email",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

  }
  Widget _genPassword() {
    return TextFormField(
        autofocus: false,
        controller: _passwordTextController,
        obscureText: true,
        validator: (String? value) {
          RegExp regex = RegExp(r'^.{6,}$');
          if (value!.isEmpty) {
            return ("로그인을 하려면 비밀번호가 필요합니다.");
          }
          if (!regex.hasMatch(value)) {
            return ("유효한 비밀번호를 입력하세요(최소 6자 입력)");
          }
          return null;
        },
        onSaved: (String? value) {
          _passwordTextController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration:_genDecoration("Password"),
        );
  }

  Widget _genConfirmPasswordField(){
    return TextFormField(
      autofocus: false,
      controller: _confirmPasswordTextController,
      obscureText: true,
      validator: (String? value) {
        if (_confirmPasswordTextController.text !=
            _passwordTextController.text) {
          return "비밀번호가 일치하지 않습니다.";
        }
        return null;
      },
      onSaved: (String? value) {
        _confirmPasswordTextController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: _genDecoration("Confirm Password"),
    );
  }

  InputDecoration _genDecoration(String text) {
    return InputDecoration(
      prefixIcon: const Icon(Icons.vpn_key),
      contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
      hintText: text,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back, color: Colors.red),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(35.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 150,
                          child: Image.asset(
                            "assets/tarotWheel.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 45),
                        _genEmail(),
                        const SizedBox(height: 20),
                        _genPassword(),
                        const SizedBox(height: 20),
                        _genConfirmPasswordField(),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                    signUp(
                    _emailTextController.text,
                    _passwordTextController.text,
                  );
                },
                child: const Text('로그인'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void signUp(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) => {postDetailsToFirestore()})
            .catchError((e) {
          Fluttertoast.showToast(msg: e!.message);
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
  postDetailsToFirestore() async {
    // calling our Firestore & Firebase_auth
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;

    // calling our userModel
    UserModel userModel = UserModel();

    // writing all the values
    userModel.email = user!.email;

    // userModel.password =user!.password;

    userModel.uid = user.uid;

    await firebaseFirestore
        .collection("users")
        .doc(user.uid)
        .set(userModel.toJson());
    Fluttertoast.showToast(msg: "계정등록에 성공했습니다.");

    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => const RootScreen()),
            (route) => false);
  }
}