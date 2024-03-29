import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:top/constants.dart';

class Job {
  final String id;
  final String hospital;
  final String speciality;
  final DateTime shiftDate;
  String shiftStartTime;
  String shiftEndTime;
  final List shiftType;
  final String additionalDetails;
  final String hospitalID;
  final String managerName;
  final String managerID;
  String? nurseID;
  JobStatus? status;

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
    this.nurseID,
    this.status,
  });

  static Job createJobFromDocument(QueryDocumentSnapshot doc) {
    Job job = Job(
      id: doc.id,
      hospital: doc['hospitalName'],
      hospitalID: doc['hospitalID'],
      managerName: doc['managerName'],
      managerID: doc['managerID'],
      speciality: doc['speciality'],
      shiftDate: doc['shiftDate'].toDate(),
      shiftStartTime: doc['shiftStartTime'],
      shiftEndTime: doc['shiftEndTime'],
      shiftType: doc['shiftTypes'],
      additionalDetails: doc['additionalDetails'],
      nurseID: doc['nurse'],
      status: JobStatus.values.byName(doc['status'])
    );
    return job;
  }
}
