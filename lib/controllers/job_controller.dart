import 'package:flutter/material.dart';
import 'package:top/services/database_service.dart';
import 'package:top/models/job_model.dart';
import 'package:top/widgets/toast.dart';

class JobController {
  final DatabaseService _databaseService = DatabaseService();

  Future<bool> createJob(Job job) async {
    try{
      await _databaseService.createJob(job);
      ToastBar(text: "Job Posted Successfully!", color: Colors.green).show();
      return true;
    } catch (e){
      ToastBar(text: e.toString(), color: Colors.red).show();
      return false;
    }
  }
}