// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class UserModel {
  String uid;
  String name;
  String token;
  String refreshToken;
  int role = 0;
  UserModel({
    required this.uid,
    required this.name,
    required this.token,
    required this.refreshToken,
    this.role = 0,
  });

  UserModel copyWith({
    String? uid,
    String? name,
    String? token,
    String? refreshToken,
    int? role,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      token: token ?? this.token,
      refreshToken: refreshToken ?? this.refreshToken,
      role: this.role,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'token': token,
      'refreshToken': refreshToken,
      'role': role,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] as String,
      name: map['name'] as String,
      token: map['token'] as String,
      refreshToken: map['refreshToken'] as String,
      role: map['role'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(uid: $uid, name: $name, token: $token, refreshToken: $refreshToken, role: $role)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.name == name &&
        other.token == token &&
        other.refreshToken == refreshToken &&
        other.role == role;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        name.hashCode ^
        token.hashCode ^
        refreshToken.hashCode ^
        role.hashCode;
  }
}
