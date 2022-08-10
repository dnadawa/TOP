import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:top/constants.dart';
import 'package:top/models/job_model.dart';
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

  Future<Role> getUserRole(User user) async {
    var doc = await _firestore.collection('users').doc(user.uid).get();
    user.name = doc.data()!['name'];

    Role role = Role.values.byName(doc.data()!['role']);

    if (role == Role.Hospital) {
      user.suburb = doc.data()!['suburb'];
    } else {
      user.specialities = doc.data()!['specialities'];
    }

    return role;
  }

  createJob(Job job) async {
    await _firestore.collection('jobs').add({
      'hospitalName': job.hospital,
      'hospitalID': job.hospitalID,
      'suburb': job.suburb,
      'speciality': job.speciality,
      'shiftDate': job.shiftDate,
      'shiftStartTime': job.shiftStartTime,
      'shiftEndTime': job.shiftEndTime,
      'shiftType': job.shiftType,
      'additionalDetails': job.additionalDetails,
      'status': JobStatus.Available.name,
      'nurse': null,
    });
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getJobs(String hospitalID, String speciality, JobStatus status) async {
    var sub = await _firestore
        .collection('jobs')
        .where('hospitalID', isEqualTo: hospitalID)
        .where('speciality', isEqualTo: speciality)
        .where('status', isEqualTo: status.name)
        .get();
    return sub.docs;
  }

  deleteJob(String id) async {
    await _firestore.collection('jobs').doc(id).delete();
  }
}