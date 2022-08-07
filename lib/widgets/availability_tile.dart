import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:top/constants.dart';
import 'package:top/widgets/badge.dart';

class AvailabilityTile extends StatelessWidget {
  final String dateString;
  final bool AM;
  final bool PM;
  final bool NS;

  const AvailabilityTile({super.key, required this.dateString, required this.AM, required this.PM, required this.NS});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
      ),
      elevation: 3,
      margin: EdgeInsets.only(bottom: 16.h, left: 8, right: 5),
      child: Padding(
        padding: EdgeInsets.all(15.h),
        child: Row(
          children: [
            Text(
              dateString,
              style: GoogleFonts.sourceSansPro(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: kGreyText,
              ),
            ),
            Expanded(child: SizedBox.shrink()),
            Badge(text: 'AM', color: Colors.red, enabled: AM),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Badge(text: 'PM', color: Colors.amber, enabled: PM),
            ),
            Badge(text: 'NS', color: Colors.green, enabled: NS),
          ],
        ),
      ),
    );
  }
}
