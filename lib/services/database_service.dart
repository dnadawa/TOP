import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:top/constants.dart';
import 'package:top/models/user_model.dart';

class DatabaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createUser(User user) async {
    Map<String, dynamic> data = {
      'name': user.name,
      'id': user.uid,
      'email': user.email,
      'role': user.role?.name,
    };

    if (user.role! == Role.Hospital) {
      data['suburb'] = user.suburb;
    } else {
      data['specialities'] = user.specialities;
    }

    await _firestore.collection('users').doc(user.uid).set(data);
  }

  Future<Role> getUserRole(String uid) async {
    var doc = await _firestore.collection('users').doc(uid).get();
    return Role.values.byName(doc.data()!['role']);
  }
}
