import 'dart:convert';

class User{
  const User({
    this.id,
    this.password,
    this.name,
  });

  final int id;
  final String password;
  final String name;

  String toJson() {
   return jsonEncode({
     "name": "$name",
     "password": "$password"
   });
  }

}