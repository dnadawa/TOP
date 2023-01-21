import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';
import 'package:top/constants.dart';
import 'package:top/models/image_timesheet_model.dart';
import 'package:top/models/timesheet_model.dart';
import 'package:top/models/job_model.dart';
import 'package:top/services/email_service.dart';
import 'package:top/services/storage_service.dart';
import 'package:top/widgets/toast.dart';
import 'package:top/services/database_service.dart';
import 'package:top/models/user_model.dart';

class JobController extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  final StorageService _storageService = StorageService();
  final EmailService _emailService = EmailService();

  String _selectedSpeciality = specialities[0];
  DateTime? _selectedDate;

  String get selectedSpeciality => _selectedSpeciality;

  DateTime? get selectedDate => _selectedDate;

  set selectedDate(DateTime? value) {
    _selectedDate = value;
    notifyListeners();
  }

  set selectedSpeciality(String speciality) {
    _selectedSpeciality = speciality;
    notifyListeners();
  }

  Future<bool> createJob(Job job) async {
    try {
      await _databaseService.createJob(job);
      await _emailService.sendEmail(
        subject: "A New Job Posted",
        templateID: jobPostedTemplateID,
        templateData: {
          'manager': job.managerName,
          'hospital': job.hospital,
        },
      );
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

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getJobsByDate(String hospitalID) async {
    return await _databaseService.getJobsByDate(hospitalID, _selectedDate);
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getAcceptedJobs(String nurseID) async {
    return await _databaseService.getAcceptedJobs(nurseID);
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getAllJobsForNurse(String nurseID, List specialities) async {
    return await _databaseService.getAllJobsForNurse(nurseID, _selectedDate, specialities);
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getAcceptedJobsForaDateAndShift(
      String nurseID, DateTime date, String shift) async {
    return await _databaseService.getAcceptedJobsForaDateAndShift(nurseID, date, shift);
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getReleasedJobs(
      List specialities, String date) async {
    return await _databaseService.getReleasedJobs(specialities, DateTime.parse(date));
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getTodayTimeSheets(
      String nurseID) async {
    return await _databaseService.getTodayTimeSheets(nurseID);
  }

  Future<Map<String, int>> getReleasedJobsCountByDate(List specialities) async {
    List fetchedData = await _databaseService.getReleasedJobsCountByDate(specialities);
    Map<String, int> datesAndCount = {};
    for (var data in fetchedData) {
      DateTime date = data['shiftDate'].toDate();
      String dateString = date.toYYYYMMDDFormat();
      datesAndCount[dateString] =
          datesAndCount.containsKey(dateString) ? (datesAndCount[dateString]! + 1) : 1;
    }

    return datesAndCount;
  }

  Future<bool> deleteJob(Job job, JobStatus status) async {
    try {
      await _databaseService.deleteJob(job.id);
      if (status != JobStatus.Available) {
        await _databaseService.unBookNurse(
            job.nurseID!, job.shiftDate.toYYYYMMDDFormat(), job.shiftType);
      }
      ToastBar(text: "Job Deleted Successfully!", color: Colors.green).show();
      return true;
    } catch (e) {
      ToastBar(text: e.toString(), color: Colors.red).show();
      return false;
    }
  }

  Future<bool> editTimes(Job job) async {
    try {
      await _databaseService.editTimes(job);

      if (job.nurseID != null) {
        String nurseEmail = await _databaseService.getUserEmailFromUID(job.nurseID!);
        await _emailService.sendEmail(
          subject: "Job Time Changed!",
          to: [nurseEmail],
          templateID: jobTimeChangeTemplateID,
          templateData: {
            'start': job.shiftStartTime,
            'end': job.shiftEndTime,
            'date': job.shiftDate,
            'hospital': job.hospital,
          },
        );
      }

      ToastBar(text: "Shift Time Changed!", color: Colors.green).show();
      return true;
    } catch (e) {
      ToastBar(text: e.toString(), color: Colors.red).show();
      return false;
    }
  }

  Future<bool> acceptJob(Job job, User nurse) async {
    try {
      await _databaseService.acceptJob(
        job.id,
        nurse.uid,
        job.shiftDate.toYYYYMMDDFormat(),
        job.shiftType,
      );

      await _emailService.sendEmail(
        subject: "A Nurse Accepted a Job",
        templateID: jobAcceptedTemplateID,
        templateData: {
          'nurse': nurse.name,
          'hospital': job.hospital,
        },
      );
      ToastBar(text: "Job Accepted!", color: Colors.green).show();
      return true;
    } catch (e) {
      ToastBar(text: e.toString(), color: Colors.red).show();
      return false;
    }
  }

  Future<bool> submitTimeSheet(TimeSheet timeSheet, Uint8List nurseSignature,
      Uint8List hospitalSignature, BuildContext context, User nurse) async {
    SimpleFontelicoProgressDialog pd =
        SimpleFontelicoProgressDialog(context: context, barrierDimisable: false);
    pd.show(
      message: "Data uploading...",
      indicatorColor: kGreen,
      width: 0.6.sw,
      height: 130.h,
      textAlign: TextAlign.center,
      separation: 30.h,
    );
    try {
      //upload signatures
      timeSheet.nurseSignatureURL =
          await _storageService.uploadBytes("${timeSheet.job.id}_nurse", nurseSignature);
      timeSheet.hospitalSignatureURL =
          await _storageService.uploadBytes("${timeSheet.job.id}_hospital", hospitalSignature);

      //send to database
      await _databaseService.submitTimesheet(timeSheet);

      String managerEmail = await _databaseService.getUserEmailFromUID(timeSheet.job.managerID);

      //send email
      await _emailService.sendEmail(
        subject: "Timesheet Received",
        templateID: timeSheetTemplateID,
        templateData: {
          'hospital': timeSheet.job.hospital,
          'speciality': timeSheet.job.speciality,
          'date': timeSheet.job.shiftDate.toEEEMMMddFormat(),
          'startTime': timeSheet.startTime,
          'endTime': timeSheet.endTime,
          'mealBreakTime': timeSheet.mealBreakTime ?? 0,
          'additionalDetails': timeSheet.additionalDetails ?? "",
          'nurseSign': timeSheet.nurseSignatureURL,
          'hospitalSign': timeSheet.hospitalSignatureURL,
          'hospitalSignName': timeSheet.hospitalSignatureName,
          'nurse': nurse.name,
        },
      );
      await _emailService.sendEmail(
        from: 'joyceplus.adm@gmail.com',
        to: [managerEmail, nurse.email!],
        subject: "Timesheet Received",
        templateID: timeSheetTemplateID,
        templateData: {
          'hospital': timeSheet.job.hospital,
          'speciality': timeSheet.job.speciality,
          'date': timeSheet.job.shiftDate.toEEEMMMddFormat(),
          'startTime': timeSheet.startTime,
          'endTime': timeSheet.endTime,
          'mealBreakTime': timeSheet.mealBreakTime ?? 0,
          'additionalDetails': timeSheet.additionalDetails ?? "",
          'nurseSign': timeSheet.nurseSignatureURL,
          'hospitalSign': timeSheet.hospitalSignatureURL,
          'hospitalSignName': timeSheet.hospitalSignatureName,
          'nurse': nurse.name,
        },
      );

      pd.hide();
      ToastBar(text: "Timesheet Submitted!", color: Colors.green).show();
      return true;
    } catch (e) {
      pd.hide();
      ToastBar(text: e.toString(), color: Colors.red).show();
      return false;
    }
  }

  Future<bool> submitImageTimesheet(
      ImageTimeSheet timeSheet, BuildContext context, Uint8List image, User nurse) async {
    SimpleFontelicoProgressDialog pd =
        SimpleFontelicoProgressDialog(context: context, barrierDimisable: false);
    pd.show(
      message: "Data uploading...",
      indicatorColor: kGreen,
      width: 0.6.sw,
      height: 130.h,
      textAlign: TextAlign.center,
      separation: 30.h,
    );
    try {
      //upload signatures
      timeSheet.url =
          await _storageService.uploadBytes(timeSheet.job.id, image, location: "timesheets");

      //send to database
      await _databaseService.submitImageTimesheet(timeSheet);

      String managerEmail = await _databaseService.getUserEmailFromUID(timeSheet.job.managerID);

      //send email
      await _emailService.sendEmail(
        subject: "Timesheet Received",
        templateID: imageTimesheetTemplateID,
        templateData: {
          'hospital': timeSheet.job.hospital,
          'speciality': timeSheet.job.speciality,
          'date': timeSheet.job.shiftDate.toEEEMMMddFormat(),
          'image': timeSheet.url,
        },
      );
      await _emailService.sendEmail(
        from: 'joyceplus.adm@gmail.com',
        to: [managerEmail, nurse.email!],
        subject: "Timesheet Received",
        templateID: imageTimesheetTemplateID,
        templateData: {
          'hospital': timeSheet.job.hospital,
          'speciality': timeSheet.job.speciality,
          'date': timeSheet.job.shiftDate.toEEEMMMddFormat(),
          'nurse': nurse.name,
          'image': timeSheet.url,
        },
      );

      pd.hide();
      ToastBar(text: "Timesheet Submitted!", color: Colors.green).show();
      return true;
    } catch (e) {
      pd.hide();
      ToastBar(text: e.toString(), color: Colors.red).show();
      return false;
    }
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getAllNotifications() async {
    return _databaseService.getAllNotifications();
  }
}
