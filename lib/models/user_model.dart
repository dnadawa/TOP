import 'package:top/constants.dart';

class User {
  final String uid;
  final String? email;
  String? name;
  Role? role;
  String? hospital;
  List? specialities;
  bool? isApproved;

  User(this.uid, this.email);
}