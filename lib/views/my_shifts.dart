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

class MyShifts extends StatelessWidget {
  final bool released;

  const MyShifts({super.key, required this.released});

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
                  title: released ? 'Shifts' : 'My Shifts',
                  child: Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: 3,
                        itemBuilder: (context, i) => Padding(
                          padding: EdgeInsets.only(bottom: 20.h),
                          child: Material(
                            elevation: 5,
                            borderRadius: BorderRadius.circular(10.r),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.r),
                                color: kRed,
                              ),
                              child: Container(
                                margin: EdgeInsets.only(left: 12.w),
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.horizontal(right: Radius.circular(10.r)),
                                    color: Colors.white),
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
                                            'Sydney Adventist Hospital',
                                            style: GoogleFonts.sourceSansPro(
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.w400,
                                                color: kGreyText),
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
                                            'Wahroonga',
                                            style: GoogleFonts.sourceSansPro(
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.w400,
                                                color: kGreyText),
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
                                            'PM',
                                            style: GoogleFonts.sourceSansPro(
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.w400,
                                                color: kGreyText),
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
                                            '13:00 to 23:58',
                                            style: GoogleFonts.sourceSansPro(
                                                fontSize: 15.sp,
                                                fontWeight: FontWeight.w400,
                                                color: kGreyText),
                                          ),
                                        ],
                                      ),
                                      if (released) SizedBox(height: 30.h),
                                      if (released)
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
