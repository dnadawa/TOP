import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AvailabilityController extends ChangeNotifier {

  Map<String?, List<String>> _selectedDatesAndShifts = {};
  DateTime _focusedDay = DateTime.now();
  String? _currentDate;

  AvailabilityController(Map<String?, List<String>> datesAndShifts) {
    _selectedDatesAndShifts = datesAndShifts;
  }

  DateTime get focusedDay => _focusedDay;

  String? get currentDate => _currentDate;

  Map<String?, List<String>> get selectedDatesAndShifts {
    Map<String?, List<String>> newDates = {..._selectedDatesAndShifts};
    newDates.removeWhere((key, value) => value.isEmpty);
    return newDates;
  }

  onDaySelected(DateTime selectedDay, DateTime newFocusedDay) {
    _currentDate = DateFormat('yyyy-MM-dd').format(selectedDay);
    if (!_selectedDatesAndShifts.containsKey(_currentDate)) {
      setShiftAndDate([].cast());
    } else {
      notifyListeners();
    }
  }

  onPageChanged(DateTime newFocusedDay) {
    _focusedDay = newFocusedDay;
  }

  setShiftAndDate(List<String> value) {
    _selectedDatesAndShifts[_currentDate] = value;
    notifyListeners();
  }

  List<String> getShiftsForCurrentDate() {
    return _selectedDatesAndShifts.containsKey(_currentDate)
        ? (_selectedDatesAndShifts[_currentDate] ?? [])
        : [];
  }

  bool selectedDayPredicate(DateTime date) {
    String day = DateFormat('yyyy-MM-dd').format(date);
    return _selectedDatesAndShifts.containsKey(day) && _selectedDatesAndShifts[day]!.isNotEmpty;
  }
}