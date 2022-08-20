import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:top/constants.dart';
import 'package:top/services/database_service.dart';
import 'package:top/models/job_model.dart';
import 'package:top/widgets/toast.dart';

class JobController extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();

  String _selectedSpeciality = specialities[0];

  String get selectedSpeciality => _selectedSpeciality;

  set selectedSpeciality(String speciality) {
    _selectedSpeciality = speciality;
    notifyListeners();
  }

  Future<bool> createJob(Job job) async {
    try {
      await _databaseService.createJob(job);
      ToastBar(text: "Job Posted Successfully!", color: Colors.green).show();
      return true;
    } catch (e) {
      ToastBar(text: e.toString(), color: Colors.red).show();
      return false;
    }
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getJobs(
      String hospitalID, JobStatus status) async {
    return await _databaseService.getJobs(hospitalID, _selectedSpeciality, status);
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getAcceptedJobs(String nurseID) async {
    return await _databaseService.getAcceptedJobs(nurseID);
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getReleasedJobs(List specialities, String date) async {
    return await _databaseService.getReleasedJobs(specialities, DateTime.parse(date));
  }

  Future<Map<String, int>> getReleasedJobsCountByDate(List specialities) async {
    List fetchedData = await _databaseService.getReleasedJobsCountByDate(specialities);
    Map<String, int> datesAndCount = {};
    for (var data in fetchedData) {
      DateTime date = data['shiftDate'].toDate();
      String dateString = date.toYYYYMMDDFormat();
      datesAndCount[dateString] = datesAndCount.containsKey(dateString) ? (datesAndCount[dateString]! + 1) : 1;
    }

    return datesAndCount;
  }

  Future<bool> deleteJob(String id) async {
    try {
      await _databaseService.deleteJob(id);
      ToastBar(text: "Job Deleted Successfully!", color: Colors.green).show();
      return true;
    } catch (e) {
      ToastBar(text: e.toString(), color: Colors.red).show();
      return false;
    }
  }

  Future<bool> acceptJob(Job job, String nurseID) async {
    try {
      await _databaseService.acceptJob(job.id, nurseID, job.shiftDate.toYYYYMMDDFormat(), job.shiftType);
      ToastBar(text: "Job Accepted!", color: Colors.green).show();
      return true;
    } catch (e) {
      ToastBar(text: e.toString(), color: Colors.red).show();
      return false;
    }
  }
}
