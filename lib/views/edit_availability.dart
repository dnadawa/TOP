import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:top/constants.dart';
import 'package:top/widgets/backdrop.dart';
import 'package:top/widgets/button.dart';
import 'package:top/widgets/chip_field.dart';
import 'package:top/widgets/heading_card.dart';

class EditAvailability extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                              focusedDay: DateTime(2022, 8, 12),
                              calendarFormat: CalendarFormat.month,
                              startingDayOfWeek: StartingDayOfWeek.monday,
                              availableGestures: AvailableGestures.none,
                              headerStyle: HeaderStyle(formatButtonVisible: false, titleCentered: true),
                              calendarStyle: CalendarStyle(
                                selectedDecoration:
                                    BoxDecoration(color: Color(0xffFA1E0E), shape: BoxShape.circle),
                              ),
                              // onPageChanged: (focusedDay) {
                              // _focusedDay = focusedDay;
                              // },
                              // selectedDayPredicate: (day) {
                              // return _selectedDays.contains(day);
                              // },
                              // onDaySelected: _onDaySelected,
                            ),


                            SizedBox(height: 50.h),
                            ChipField(
                              text: 'Shifts',
                              items: [
                                'AM',
                                'PM',
                                'NS',
                              ],
                              initialItems: [
                                'AM',
                              ],
                              onChanged: (value) {
                                print(value);
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
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
