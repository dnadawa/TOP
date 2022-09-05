import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final kGreen = Color(0xff0B8542);
final kRed = Color(0xffC1272D);
final kDisabled = Color(0xff90A4AE);
final kDisabledSecondary = Color(0xffE5E5E5);
final kGreyText = Color(0xff52575D);
final kOrange = Color(0xffE68C36);

enum JobStatus { Confirmed, Available, Completed }

enum AvailabilityStatus{ Available, Booked, NotAvailable }

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

const adminEmail = "joyceplus.adm@gmail.com";
const approvalTemplateID = "d-0402a018c31f4a3580d3832dfb09b7ea";
const jobPostedTemplateID = "d-75db89af5bda42e8b3d6cbbd94a20b57";
const jobAcceptedTemplateID = "d-af1f64ff2d5146d49be239c498458fdd";
const timeSheetTemplateID = "d-c35555a2c0e04cbb92dd6f744d2ae43f";

extension TimeOfDayConverter on TimeOfDay {
  String to24hours() {
    final hour = this.hour.toString().padLeft(2, "0");
    final min = minute.toString().padLeft(2, "0");
    return "$hour:$min";
  }
}

extension FormatDate on DateTime {
  String toYYYYMMDDFormat() {
    return DateFormat('yyyy-MM-dd').format(this);
  }

  String toEEEMMMddFormat() {
    return DateFormat('EEE MMM dd').format(this);
  }
}
