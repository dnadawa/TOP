import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:top/widgets/backdrop.dart';
import 'package:top/constants.dart';
import 'package:top/widgets/button.dart';
import 'package:top/widgets/heading_card.dart';
import 'package:top/widgets/input_filed.dart';

import '../../widgets/shift_tile.dart';

class HospitalJobDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Backdrop(
        child: Padding(
          padding: EdgeInsets.all(30.h),
          child: Column(
            children: [
              SizedBox(height: ScreenUtil().statusBarHeight - 30.h),

              Align(
                alignment: Alignment.topLeft,
                child: BackButton(
                  color: kGreyText,
                ),
              ),

              //details
              HeadingCard(
                title: 'Job Details',
                child: Padding(
                  padding: EdgeInsets.all(20.w),
                  child: ShiftTile(
                    hospital: 'Akuressa Central Hospital',
                    suburb: 'Matara',
                    shiftType: "PM",
                    shiftTime: "13:00 to 23:53",
                    shiftDate: 'Wednesday August 2',
                    specialty: 'Speciality 1',
                    showFrontStrip: true,
                  ),
                ),
              ),

              Expanded(child: SizedBox.shrink()),
              SizedBox(
                width: double.infinity,
                child: Button(
                  text: 'Delete Job Post',
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
