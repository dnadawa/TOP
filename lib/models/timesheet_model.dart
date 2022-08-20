import 'package:top/models/job_model.dart';

class TimeSheet {
  final Job job;
  final String startTime;
  final String endTime;
  final bool mealBreakIncluded;
  final int? mealBreakTime;
  final String? additionalDetails;
  String? nurseSignatureURL;
  String? hospitalSignatureURL;
  final String? hospitalSignatureName;

  TimeSheet({
    required this.job,
    required this.startTime,
    required this.endTime,
    required this.mealBreakIncluded,
    this.mealBreakTime,
    this.additionalDetails,
    this.nurseSignatureURL,
    this.hospitalSignatureURL,
    this.hospitalSignatureName,
  });
}
