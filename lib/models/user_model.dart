import 'package:top/constants.dart';

class User {
  final String uid;
  final String? email;
  String? name;
  Role? role;
  String? suburb;
  List? specialities;

  User(this.uid, this.email);
}