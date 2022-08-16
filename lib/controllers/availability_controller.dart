import 'package:flutter/material.dart';
import 'package:top/constants.dart';
import 'package:top/models/shift_model.dart';

class AvailabilityController extends ChangeNotifier {
  Map<String?, List<String>> _selectedDatesAndShifts = {};
  Map<String?, List<String>> _bookedShifts = {};
  DateTime _focusedDay = DateTime.now();
  String? _currentDate;

  AvailabilityController(
      Map<String?, List<String>> datesAndShifts, Map<String?, List<String>> bookedShifts) {
    _selectedDatesAndShifts = datesAndShifts;
    _bookedShifts = bookedShifts;
  }

  DateTime get focusedDay => _focusedDay;

  String? get currentDate => _currentDate;

  Map<String?, List<String>> get selectedDatesAndShifts {
    Map<String?, List<String>> newDates = {..._selectedDatesAndShifts};

    //append 'Booked' to the shift if it is booked
    // if AM is booked new element added to the list as AMBooked
    _bookedShifts.forEach((key, value) {
      if (newDates.containsKey(key)) {
        newDates[key] = (newDates[key]! + value.map((e) => '${e}Booked').toList());
      } else {
        newDates[key] = value.map((e) => '${e}Booked').toList();
      }
    });

    newDates.removeWhere((key, value) => value.isEmpty);

    return newDates;
  }

  onDaySelected(DateTime selectedDay, DateTime newFocusedDay) {
    _currentDate = selectedDay.toYYYYMMDDFormat();
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
    String day = date.toYYYYMMDDFormat();
    return _selectedDatesAndShifts.containsKey(day) && _selectedDatesAndShifts[day]!.isNotEmpty;
  }

  List<String> getItemsForCurrentDate(List<Shift> shifts) {
    try {
      Shift shift = shifts.firstWhere((element) => element.date == _currentDate);

      List<String> returnItems = [];
      if (shift.am != AvailabilityStatus.Booked) {
        returnItems.add('AM');
      }
      if (shift.pm != AvailabilityStatus.Booked) {
        returnItems.add('PM');
      }
      if (shift.ns != AvailabilityStatus.Booked) {
        returnItems.add('NS');
      }

      return returnItems;
    } catch (e) {
      return ['AM', 'PM', 'NS'];
    }
  }
}
