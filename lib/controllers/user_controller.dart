import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:simple_fontellico_progress_dialog/simple_fontico_loading.dart';
import 'package:top/models/shift_model.dart';
import 'package:top/services/auth_service.dart';
import 'package:top/constants.dart';
import 'package:top/models/user_model.dart';
import 'package:top/services/database_service.dart';
import 'package:top/services/email_service.dart';
import 'package:top/views/log_in.dart';
import 'package:top/widgets/toast.dart';

class UserController {
  final AuthService _authService = AuthService();
  final DatabaseService _databaseService = DatabaseService();
  final EmailService _emailService = EmailService();

  Future<User?> getCurrentUser() async {
    User? user = await _authService.currentUser;

    if (user == null) {
      return null;
    }

    Role role = await _databaseService.getUserRole(user);

    user.role = role;
    OneSignal.shared.setExternalUserId(user.uid);
    _databaseService.setNotificationID(user.uid);

    return user;
  }

  Future<bool> signUp(String email, String password, String name, Role role, List specialties,
      {String? hospitalID, String? phone}) async {
    User? user = await _authService.signUp(email, password);
    if (user != null) {
      user.name = name;
      user.role = role;
      user.specialities = specialties;

      if (role == Role.Manager) {
        user.hospital = hospitalID;
      } else {
        user.phone = phone;
      }

      await _databaseService.createUser(user);
      await _authService.signOut();
      await _emailService.sendEmail(
        subject: "A new ${role.name.toLowerCase()} registered",
        templateID: approvalTemplateID,
        templateData: {
          'role': role.name,
          'name': user.name,
        },
      );
      ToastBar(
              text: '${role.name} successfully registered and waiting for admin approval!',
              color: Colors.green)
          .show();
      return true;
    }

    return false;
  }

  Future<User?> signIn(String email, String password) async {
    User? user = await _authService.signIn(email, password);

    if (user == null) {
      return null;
    }

    await _databaseService.getUserRole(user);
    OneSignal.shared.setExternalUserId(user.uid);
    return user;
  }

  Future<bool> signOut() async {
    OneSignal.shared.removeExternalUserId();
    return await _authService.signOut();
  }

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> getHospitals() async {
    return _databaseService.getHospitals();
  }

  Future<String> getHospitalNameFromID(String id) async {
    return _databaseService.getHospitalNameFromID(id);
  }

  Future<bool> forgetPassword(String email) async {
    return await _authService.forgetPassword(email);
  }

  Future<bool> changeAvailability(String uid, Map<String?, List<String>> dates) async {
    try {
      await _databaseService.updateAvailability(uid, dates);
      ToastBar(text: "Availability Updated Successfully!", color: Colors.green).show();
      return true;
    } catch (e) {
      ToastBar(text: e.toString(), color: Colors.red).show();
      return false;
    }
  }

  Future<List<Shift>> getAllAvailability(String uid) async {
    try {
      List<QueryDocumentSnapshot<Map<String, dynamic>>> datesAndShifts =
          await _databaseService.getAllAvailability(uid);

      List<String> allDays =
          _getDaysInBetween(DateTime.now(), DateTime.parse(datesAndShifts.last['date']));

      List<Shift> shifts = allDays.map((day) {
        int index = datesAndShifts.indexWhere((element) => element['date'] == day);

        //not in db
        if (index == -1) {
          return Shift(
            date: day,
            am: AvailabilityStatus.NotAvailable,
            pm: AvailabilityStatus.NotAvailable,
            ns: AvailabilityStatus.NotAvailable,
          );
        }
        // in db
        else {
          return Shift(
            date: datesAndShifts[index]['date'],
            am: AvailabilityStatus.values.byName(datesAndShifts[index]['AM']),
            pm: AvailabilityStatus.values.byName(datesAndShifts[index]['PM']),
            ns: AvailabilityStatus.values.byName(datesAndShifts[index]['NS']),
          );
        }
      }).toList();

      return shifts;
    } catch (e) {
      return [];
    }
  }

  Future<bool> isNurseAvailable(String uid, String date, List shiftTypes) async {
    List shift = await _databaseService.getSingleAvailability(uid, date);
    if (shift.isEmpty) {
      return false;
    } else {
      for (var shiftType in shiftTypes) {
        if (shift[0][shiftType] != AvailabilityStatus.Available.name) {
          return false;
        }
      }

      return true;
    }
  }

  List<String> _getDaysInBetween(DateTime startDate, DateTime endDate) {
    List<String> days = [];
    for (int i = 0; i <= endDate.difference(startDate).inDays + 1; i++) {
      days.add(startDate.add(Duration(days: i)).toYYYYMMDDFormat());
    }
    return days;
  }

  deleteUser(BuildContext context, String email, String password, String uid, {bool isManager=false}) async {
    SimpleFontelicoProgressDialog pd =
        SimpleFontelicoProgressDialog(context: context, barrierDimisable: false);
    try {
      bool isReAuthenticated = await _authService.reAuthenticate(email, password);
      if (isReAuthenticated) {
        pd.show(
          message: "Deleting user",
          indicatorColor: kGreen,
          width: 0.6.sw,
          height: 130.h,
          textAlign: TextAlign.center,
          separation: 30.h,
        );
        await _databaseService.deleteJobs(uid, isManager);
        await _databaseService.deleteUser(uid);
        bool isDeleted = await _authService.deleteUser(context);
        if (isDeleted) {
          pd.hide();
          ToastBar(text: "User deleted!", color: Colors.green).show();
          Navigator.of(context).pushAndRemoveUntil(
              CupertinoPageRoute(builder: (context) => LogIn()), (Route<dynamic> route) => false);
        } else {
          pd.hide();
          ToastBar(text: "Something went wrong!", color: Colors.red).show();
        }
      }
    } catch (e) {
      pd.hide();
      ToastBar(text: e.toString(), color: Colors.red).show();
    }
  }

  Future<String?> getUserName(String id) async {
    try {
      String name = await _databaseService.getUserNameFromUID(id);
      return name;
    } on Exception catch (e) {
      return null;
    }
  }
}
