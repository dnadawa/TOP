import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:top/constants.dart';
import 'package:top/views/edit_availability.dart';
import 'package:top/widgets/availability_tile.dart';
import 'package:top/widgets/backdrop.dart';
import 'package:top/widgets/button.dart';
import 'package:top/widgets/heading_card.dart';
import 'package:top/widgets/shift_tile.dart';

class MyShifts extends StatelessWidget {
  final bool released;

  const MyShifts({super.key, this.released = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Backdrop(
        child: Padding(
          padding: EdgeInsets.all(30.w),
          child: Column(
            children: [
              SizedBox(
                  height: released
                      ? ScreenUtil().statusBarHeight - 30.w
                      : ScreenUtil().statusBarHeight),
              if (released)
                Align(
                  alignment: Alignment.topLeft,
                  child: BackButton(
                    color: kGreyText,
                  ),
                ),
              Expanded(
                child: HeadingCard(
                  title: released ? 'Shifts' : 'My Shifts',
                  child: Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: 3,
                        itemBuilder: (context, i) => Padding(
                          padding: EdgeInsets.only(bottom: 20.h),
                          child: ShiftTile(
                            hospital: 'Akuressa Central Hospital',
                            suburb: 'Matara',
                            shiftType: "PM",
                            shiftTime: "13:00 to 23:53",
                            showAcceptButton: released,
                            showFrontStrip: true,
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
    );
  }
}
