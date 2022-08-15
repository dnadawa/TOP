import 'package:flutter/material.dart';

final kGreen = Color(0xff0B8542);
final kRed = Color(0xffC1272D);
final kDisabled = Color(0xff90A4AE);
final kDisabledSecondary = Color(0xffE5E5E5);
final kGreyText = Color(0xff52575D);
final kOrange = Color(0xffE68C36);

enum JobStatus { Confirmed, Available, Completed }

enum Role { Nurse, Manager }

final specialities = [
  'Anaesthetic',
  'Cell Salvage',
  'Scrub/Scout',
  'Recovery',
  'Pre-admission',
  'Ward',
  'CSSD',
  'Porter',
  'None',
];

extension TimeOfDayConverter on TimeOfDay {
  String to24hours() {
    final hour = this.hour.toString().padLeft(2, "0");
    final min = minute.toString().padLeft(2, "0");
    return "$hour:$min";
  }
}
