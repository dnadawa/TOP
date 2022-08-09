import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:top/constants.dart';
import 'package:top/views/edit_availability.dart';
import 'package:top/views/single_timesheet.dart';
import 'package:top/widgets/availability_tile.dart';
import 'package:top/widgets/backdrop.dart';
import 'package:top/widgets/button.dart';
import 'package:top/widgets/heading_card.dart';
import 'package:top/widgets/shift_tile.dart';

class HospitalJobs extends StatelessWidget {
  final JobStatus status;

  const HospitalJobs({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Backdrop(
        child: Padding(
          padding: EdgeInsets.all(30.w),
          child: Column(
            children: [
              SizedBox(height: ScreenUtil().statusBarHeight),

              Expanded(
                child: HeadingCard(
                  title: "${status.name} Jobs",
                  child: Expanded(
                    child: Column(
                      children: [
                        SizedBox(height: 30.h),

                        //filter
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.w),
                          child: ToggleSwitch(
                            initialLabelIndex: 0,
                            activeFgColor: Colors.white,
                            inactiveBgColor: kDisabledSecondary,
                            inactiveFgColor: kGreyText,
                            totalSwitches: 4,
                            labels: ['Anaesthetic', 'Recovery', 'S/S', 'Ward'],
                            fontSize: 13.sp,
                            activeBgColor: [kOrange],
                            cornerRadius: 5.r,
                            animate: true,
                            animationDuration: 200,
                            curve: Curves.easeIn,
                            minWidth: 80.w,
                            onToggle: (index) async {},
                          ),
                        ),

                        //jobs
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15.w),
                            child: ListView.builder(
                              physics: BouncingScrollPhysics(),
                              itemCount: 4,
                              itemBuilder: (context, i) => Padding(
                                padding: EdgeInsets.only(bottom: 20.h),
                                child: GestureDetector(
                                  onTap: () {},
                                  child: IntrinsicHeight(
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        Expanded(
                                          child: ShiftTile(
                                            hospital: 'Akuressa Central Hospital',
                                            suburb: 'Matara',
                                            shiftType: "PM",
                                            shiftTime: "13:00 to 23:53",
                                            shiftDate: 'Wednesday August 2',
                                            specialty: 'Speciality 1',
                                            showBackStrip: true,
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: kRed,
                                            borderRadius: BorderRadius.horizontal(right: Radius.circular(10.r)),
                                          ),
                                          child: SizedBox(
                                            child: Icon(
                                              Icons.arrow_forward_ios,
                                              color: Colors.white,
                                              size: 20,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
