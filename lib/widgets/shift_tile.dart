import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:top/constants.dart';
import 'package:top/widgets/button.dart';
import 'package:top/widgets/input_filed.dart';
import 'package:top/widgets/toast.dart';

class ShiftTile extends StatelessWidget {
  final bool showAcceptButton;
  final String hospital;
  final String shiftType;
  final String shiftTime;
  final String shiftDate;
  final String specialty;
  final bool showFrontStrip;
  final bool showBackStrip;
  final String additionalDetails;
  final Function? onAcceptButtonPressed;

  ShiftTile({
    super.key,
    this.showAcceptButton = false,
    required this.hospital,
    required this.shiftType,
    required this.shiftTime,
    this.showFrontStrip = false,
    this.showBackStrip = false,
    this.onAcceptButtonPressed,
    required this.specialty,
    required this.shiftDate,
    required this.additionalDetails,
  });

  final TextEditingController additionalDetailsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    additionalDetailsController.text = additionalDetails;

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
                ? BorderRadius.horizontal(right: Radius.circular(10.r))
                : showBackStrip
                    ? BorderRadius.horizontal(left: Radius.circular(10.r))
                    : BorderRadius.circular(10.r),
            color: Colors.white,
          ),
          child: Padding(
            padding: EdgeInsets.all(15.h),
            child: Column(
              children: [
                //hospital
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

                //specialty
                Row(
                  children: [
                    SizedBox(
                      width: 80.w,
                      child: Text(
                        'Speciality',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Text(
                      specialty,
                      style: GoogleFonts.sourceSansPro(
                          fontSize: 15.sp, fontWeight: FontWeight.w400, color: kGreyText),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),

                //shift date
                Row(
                  children: [
                    SizedBox(
                      width: 80.w,
                      child: Text(
                        'Shift Date',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Text(
                      shiftDate,
                      style: GoogleFonts.sourceSansPro(
                          fontSize: 15.sp, fontWeight: FontWeight.w400, color: kGreyText),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),

                //shift time
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
                SizedBox(height: 8.h),

                //shift type
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

                //additional details
                if (additionalDetailsController.text.isNotEmpty) SizedBox(height: 20.h),
                if (additionalDetailsController.text.isNotEmpty)
                  InputField(
                    text: 'Additional Details ',
                    enabled: false,
                    controller: additionalDetailsController,
                    multiLine: true,
                  ),

                if (showAcceptButton) SizedBox(height: 30.h),
                if (showAcceptButton)
                  SizedBox(
                    width: 150.w,
                    child: Button(
                      text: 'Accept',
                      onPressed: () => onAcceptButtonPressed!(),
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
