import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:top/constants.dart';
import 'package:top/views/my_shifts.dart';
import 'package:top/widgets/badge.dart';

class ReleasedShiftTile extends StatelessWidget {
  final String dateString;
  final String count;

  const ReleasedShiftTile({super.key, required this.dateString, required this.count});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, CupertinoPageRoute(builder: (_) => MyShifts(released: true))),
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        elevation: 3,
        margin: EdgeInsets.only(bottom: 16.h, left: 8, right: 5),
        child: Row(
          children: [
            Expanded(
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
                    Badge(text: count, color: kGreyText, enabled: true),
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: kRed,
                borderRadius: BorderRadius.horizontal(right: Radius.circular(10.r)),
              ),
              child: SizedBox(
                height: 65.h,
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}