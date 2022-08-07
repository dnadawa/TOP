import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:top/constants.dart';
import 'package:top/widgets/button.dart';

class ShiftTile extends StatelessWidget {
  final bool showAcceptButton;
  final String hospital;
  final String suburb;
  final String shiftType;
  final String shiftTime;
  final bool showFrontStrip;
  final bool showBackStrip;
  final Function? onAcceptButtonPressed;

  const ShiftTile({
    super.key,
    this.showAcceptButton = false,
    required this.hospital,
    required this.suburb,
    required this.shiftType,
    required this.shiftTime,
    this.showFrontStrip = false,
    this.showBackStrip = false,
    this.onAcceptButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          color: showFrontStrip ? kRed : Colors.transparent,
        ),
        child: Container(
          margin: showFrontStrip ? EdgeInsets.only(left: 12.w) : EdgeInsets.zero,
          decoration: BoxDecoration(
            borderRadius: showFrontStrip
                ? BorderRadius.horizontal(right: Radius.circular(10.r)) : showBackStrip ? BorderRadius.horizontal(left: Radius.circular(10.r))
                : BorderRadius.circular(10.r),
            color: Colors.white,
          ),
          child: Padding(
            padding: EdgeInsets.all(15.h),
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 80.w,
                      child: Text(
                        'Hospital',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Text(
                      hospital,
                      style: GoogleFonts.sourceSansPro(
                          fontSize: 15.sp, fontWeight: FontWeight.w400, color: kGreyText),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    SizedBox(
                      width: 80.w,
                      child: Text(
                        'Suburb',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Text(
                      suburb,
                      style: GoogleFonts.sourceSansPro(
                          fontSize: 15.sp, fontWeight: FontWeight.w400, color: kGreyText),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    SizedBox(
                      width: 80.w,
                      child: Text(
                        'Shift Type',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Text(
                      shiftType,
                      style: GoogleFonts.sourceSansPro(
                          fontSize: 15.sp, fontWeight: FontWeight.w400, color: kGreyText),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    SizedBox(
                      width: 80.w,
                      child: Text(
                        'Shift Time',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Text(
                      shiftTime,
                      style: GoogleFonts.sourceSansPro(
                          fontSize: 15.sp, fontWeight: FontWeight.w400, color: kGreyText),
                    ),
                  ],
                ),
                if (showAcceptButton) SizedBox(height: 30.h),
                if (showAcceptButton)
                  SizedBox(
                    width: 150.w,
                    child: Button(
                      text: 'Accept',
                      onPressed: () {},
                      color: Colors.green,
                      padding: 5.h,
                      fontSize: 18.sp,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
