import 'package:top/constants.dart';

class Shift {

  final String date;
  final AvailabilityStatus am;
  final AvailabilityStatus pm;
  final AvailabilityStatus ns;

  Shift({
    required this.date,
    required this.am,
    required this.pm,
    required this.ns,
});

  DateTime get dateAsDateTime => DateTime.parse(date);

}