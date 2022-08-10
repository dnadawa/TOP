class Job {
  final String hospital;
  final String suburb;
  final String speciality;
  final DateTime shiftDate;
  final String shiftStartTime;
  final String shiftEndTime;
  final String shiftType;
  final String additionalDetails;
  final String hospitalID;

  Job({
    required this.hospital,
    required this.hospitalID,
    required this.suburb,
    required this.speciality,
    required this.shiftDate,
    required this.shiftStartTime,
    required this.shiftEndTime,
    required this.shiftType,
    required this.additionalDetails,
  });
}
