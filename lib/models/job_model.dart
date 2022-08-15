import 'package:cloud_firestore/cloud_firestore.dart';

class Job {
  final String id;
  final String hospital;
  final String speciality;
  final DateTime shiftDate;
  final String shiftStartTime;
  final String shiftEndTime;
  final String shiftType;
  final String additionalDetails;
  final String hospitalID;
  final String managerName;
  final String managerID;

  Job({
    required this.id,
    required this.hospital,
    required this.hospitalID,
    required this.speciality,
    required this.shiftDate,
    required this.shiftStartTime,
    required this.shiftEndTime,
    required this.shiftType,
    required this.additionalDetails,
    required this.managerName,
    required this.managerID,
  });

  static Job createJobFromDocument(QueryDocumentSnapshot doc) {
    return Job(
      id: doc.id,
      hospital: doc['hospitalName'],
      hospitalID: doc['hospitalID'],
      managerName: doc['managerName'],
      managerID: doc['managerID'],
      speciality: doc['speciality'],
      shiftDate: doc['shiftDate'].toDate(),
      shiftStartTime: doc['shiftStartTime'],
      shiftEndTime: doc['shiftEndTime'],
      shiftType: doc['shiftType'],
      additionalDetails: doc['additionalDetails'],
    );
  }
}
