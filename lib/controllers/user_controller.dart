import 'package:cloud_firestore/cloud_firestore.dart';
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

  Future<bool> signUp(String email, String password, String name, Role role, List specialties, {String? hospitalID}) async {
    User? user = await _authService.signUp(email, password);
    if (user != null){
      user.name = name;
      user.role = role;
      user.specialities = specialties;

      if (role == Role.Manager) {
        user.hospital = hospitalID;
      }

      await _databaseService.createUser(user);
      await _authService.signOut();
      ToastBar(text: '${role.name} successfully registered and waiting for admin approval!', color: Colors.green).show();
      return true;
    }

    return false;
  }

  Future<User?> signIn(String email, String password) async {
    User? user = await _authService.signIn(email, password);

    if (user == null){
      return null;
    }

    await _databaseService.getUserRole(user);
    return user;
  }

  Future<bool> signOut() async => await _authService.signOut();

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getHospitals() async {
    return _databaseService.getHospitals();
  }

  Future<String> getHospitalNameFromID(String id) async {
    return _databaseService.getHospitalNameFromID(id);
  }

  Future<bool> forgetPassword(String email) async {
    return await _authService.forgetPassword(email);
  }
}