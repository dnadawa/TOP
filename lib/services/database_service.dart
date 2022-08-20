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
      'specialities': user.specialities,
      'isApproved': false,
    };

    if (user.role! == Role.Manager) {
      data['hospitalID'] = user.hospital;
    } else {
      data['phone'] = user.phone;
    }

    await _firestore.collection('users').doc(user.uid).set(data);
  }

  Future<Role> getUserRole(User user) async {
    var doc = await _firestore.collection('users').doc(user.uid).get();
    user.name = doc.data()!['name'];
    user.specialities = doc.data()!['specialities'];
    user.isApproved = doc.data()!['isApproved'];

    Role role = Role.values.byName(doc.data()!['role']);
    user.role = role;

    if (role == Role.Manager) {
      user.hospital = doc.data()!['hospitalID'];
    } else {
      user.phone = doc.data()!['phone'];
    }

    return role;
  }

  createJob(Job job) async {
    await _firestore.collection('jobs').add({
      'hospitalName': job.hospital,
      'hospitalID': job.hospitalID,
      'managerName': job.managerName,
      'managerID': job.managerID,
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

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getAcceptedJobs(String nurseID) async {
    var sub = await _firestore
        .collection('jobs')
        .where('nurse', isEqualTo: nurseID)
        .where('status', isEqualTo: JobStatus.Confirmed.name)
        .orderBy('shiftDate')
        .get();
    return sub.docs;
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getReleasedJobsCountByDate(List specialities) async {
    var sub = await _firestore
        .collection('jobs')
        .where('speciality',whereIn: specialities)
        .where('status', isEqualTo: JobStatus.Available.name)
        .orderBy('shiftDate')
        .get();
    return sub.docs;
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getReleasedJobs(List specialities, DateTime date) async {
      var sub = await _firestore
          .collection('jobs')
          .where('speciality',whereIn: specialities)
          .where('status', isEqualTo: JobStatus.Available.name)
          .where('shiftDate', isGreaterThan: date)
          .where('shiftDate', isLessThan: date.add(Duration(days: 1)))
          .get();
      return sub.docs;
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getHospitals() async {
    var sub = await _firestore
        .collection('hospitals')
        .get();
    return sub.docs;
  }

  Future<String> getHospitalNameFromID(String id) async {
    var sub = await _firestore
        .collection('hospitals')
        .where('id', isEqualTo: id)
        .get();
    return sub.docs[0]['name'];
  }

  deleteJob(String id) async {
    await _firestore.collection('jobs').doc(id).delete();
  }

  updateAvailability(String uid, Map<String?, List<String>> dates){
    dates.forEach((key, value) async {
      await _firestore.collection('users').doc(uid).collection('shifts').doc(key).set({
        'date': key,
        'AM' : value.contains('AMBooked') ? AvailabilityStatus.Booked.name : value.contains('AM') ? AvailabilityStatus.Available.name : AvailabilityStatus.NotAvailable.name,
        'PM' : value.contains('PMBooked') ? AvailabilityStatus.Booked.name : value.contains('PM') ? AvailabilityStatus.Available.name : AvailabilityStatus.NotAvailable.name,
        'NS' : value.contains('NSBooked') ? AvailabilityStatus.Booked.name : value.contains('NS') ? AvailabilityStatus.Available.name : AvailabilityStatus.NotAvailable.name,
      });
    });
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getAllAvailability(String uid) async {
    var sub = await _firestore.collection('users').doc(uid).collection('shifts').get();
    return sub.docs;
  }
}
