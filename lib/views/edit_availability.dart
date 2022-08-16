import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:top/constants.dart';
import 'package:top/controllers/availability_controller.dart';
import 'package:top/controllers/user_controller.dart';
import 'package:top/models/user_model.dart';
import 'package:top/widgets/backdrop.dart';
import 'package:top/widgets/button.dart';
import 'package:top/widgets/chip_field.dart';
import 'package:top/widgets/heading_card.dart';
import 'package:top/widgets/toast.dart';

class EditAvailability extends StatelessWidget {
  final User user;

  const EditAvailability({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AvailabilityController>(
      create: (_) => AvailabilityController({
        '2022-08-18': ['AM']
      }),
      builder: (context, child) {
        var availabilityController = context.watch<AvailabilityController>();

        return Scaffold(
          body: Backdrop(
            child: Padding(
              padding: EdgeInsets.all(30.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: ScreenUtil().statusBarHeight - 20.w),
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
                                        items: [
                                          'AM',
                                          'PM',
                                          'NS',
                                        ],
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
