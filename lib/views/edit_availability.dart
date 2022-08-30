import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:top/constants.dart';
import 'package:top/controllers/availability_controller.dart';
import 'package:top/controllers/user_controller.dart';
import 'package:top/models/shift_model.dart';
import 'package:top/models/user_model.dart';
import 'package:top/widgets/backdrop.dart';
import 'package:top/widgets/button.dart';
import 'package:top/widgets/chip_field.dart';
import 'package:top/widgets/heading_card.dart';
import 'package:top/widgets/toast.dart';

class EditAvailability extends StatelessWidget {
  final User user;
  final List<Shift> previousShifts;

  const EditAvailability({super.key, required this.user, required this.previousShifts});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AvailabilityController>(
      create: (_) {
        Map<String, List<String>> shifts = {};
        Map<String, List<String>> bookedShifts = {};

        for (Shift shift in previousShifts) {
          List<String> availableDates = [];
          List<String> bookedDates = [];
          if(shift.am == AvailabilityStatus.Available){
            availableDates.add('AM');
          } else if (shift.am == AvailabilityStatus.Booked) {
            bookedDates.add('AM');
          }

          if(shift.pm == AvailabilityStatus.Available){
            availableDates.add('PM');
          } else if (shift.pm == AvailabilityStatus.Booked) {
            bookedDates.add('PM');
          }

          if(shift.ns == AvailabilityStatus.Available){
            availableDates.add('NS');
          } else if (shift.ns == AvailabilityStatus.Booked) {
            bookedDates.add('NS');
          }

          shifts[shift.date] = availableDates;
          if(bookedDates.isNotEmpty){
            bookedShifts[shift.date] = bookedDates;
          }
        }

        return AvailabilityController(shifts, bookedShifts);
      },
      builder: (context, child) {
        var availabilityController = context.watch<AvailabilityController>();

        return Scaffold(
          body: Backdrop(
            child: Padding(
              padding: EdgeInsets.fromLTRB(30.w, 10.h, 30.w, 30.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: ScreenUtil().statusBarHeight),
                  BackButton(
                    color: kGreyText,
                  ),

                  Expanded(
                    child: HeadingCard(
                      title: 'Edit Availability',
                      child: Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.w),
                          child: SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            child: Column(
                              children: [
                                SizedBox(height: 20.h),
                                TableCalendar(
                                  firstDay: DateTime.now(),
                                  lastDay: DateTime(3000, 12, 31),
                                  focusedDay: availabilityController.focusedDay,
                                  calendarFormat: CalendarFormat.month,
                                  startingDayOfWeek: StartingDayOfWeek.monday,
                                  availableGestures: AvailableGestures.none,
                                  headerStyle:
                                      HeaderStyle(formatButtonVisible: false, titleCentered: true),
                                  calendarStyle: CalendarStyle(
                                    selectedDecoration:
                                        BoxDecoration(color: kRed, shape: BoxShape.circle),
                                  ),
                                  onPageChanged: availabilityController.onPageChanged,
                                  selectedDayPredicate: availabilityController.selectedDayPredicate,
                                  onDaySelected: availabilityController.onDaySelected,
                                ),
                                SizedBox(height: 50.h),

                                //shifts
                                if (availabilityController.currentDate != null)
                                  Consumer<AvailabilityController>(
                                    builder: (context, availabilityController, child) {
                                      return ChipField(
                                        key: UniqueKey(),
                                        text: 'Shifts on ${availabilityController.currentDate!}',
                                        items: availabilityController.getItemsForCurrentDate(previousShifts),
                                        initialItems:
                                            availabilityController.getShiftsForCurrentDate(),
                                        onChanged: availabilityController.setShiftAndDate,
                                      );
                                    },
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 50.h),

                  //button
                  SizedBox(
                    width: double.infinity,
                    child: Button(
                      text: 'Save',
                      color: kRed,
                      onPressed: () async {
                        ToastBar(text: "Please wait...", color: Colors.orange).show();
                        await Provider.of<UserController>(context, listen: false)
                            .changeAvailability(
                                user.uid, availabilityController.selectedDatesAndShifts);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
