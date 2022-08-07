class UserModel {
  String? uid;
  String? email;
  String? password;

  UserModel({
    this.uid,
    this.email,
    this.password,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      email: json['email'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'password': password,
    };
  }
}
