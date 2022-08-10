import 'package:flutter/material.dart';
import 'package:top/services/auth_service.dart';
import 'package:top/constants.dart';
import 'package:top/models/user_model.dart';
import 'package:top/services/database_service.dart';
import 'package:top/widgets/toast.dart';

class UserController {

  final AuthService _authService = AuthService();
  final DatabaseService _databaseService = DatabaseService();

  Future<User?> getCurrentUser() async {
    User? user = await _authService.currentUser;

    if (user == null){
      return null;
    }

    Role role = await _databaseService.getUserRole(user);
    user.role = role;

    return user;
  }

  Future<bool> signUp(String email, String password, String name, Role role, {String? suburb, List? specialties}) async {
    User? user = await _authService.signUp(email, password);
    if (user != null){
      user.name = name;
      user.role = role;
      if (role == Role.Hospital) {
        user.suburb = suburb;
      } else {
        user.specialities = specialties;
      }

      await _databaseService.createUser(user);
      ToastBar(text: '${role.name} successfully registered!', color: Colors.green).show();
      return true;
    }

    return false;
  }

  Future<Role?> signIn(String email, String password) async {
    User? user = await _authService.signIn(email, password);

    if (user == null){
      return null;
    }

    return await _databaseService.getUserRole(user);
  }
}