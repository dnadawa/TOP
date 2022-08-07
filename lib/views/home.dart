import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:top/widgets/backdrop.dart';
import 'package:top/constants.dart';
import 'package:top/widgets/input_filed.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Backdrop(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(30.h),
            child: Column(
              children: [
                SizedBox(height: ScreenUtil().statusBarHeight),

                //name
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello,',
                            style: GoogleFonts.sourceSansPro(
                              color: kRed,
                              fontSize: 25.sp,
                            ),
                          ),
                          Text(
                            'Sanjula Hasaranga',
                            style: TextStyle(
                                color: kGreyText, fontSize: 28.sp, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 20.w),
                    Image.asset(
                      'assets/nurse.png',
                      height: 135.h,
                    ),
                  ],
                ),
                SizedBox(height: 75.h),

                //details
                SizedBox(
                  width: double.infinity,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    elevation: 7,
                    color: Colors.white,
                    child: Column(
                      children: [
                        //title
                        Container(
                          decoration: BoxDecoration(
                            color: kGreen,
                            borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(15.r),
                            ),
                          ),
                          padding: EdgeInsets.all(15.w),
                          child: Text(
                            'My Personal Details',
                            style: TextStyle(
                              fontSize: 22.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                        //content
                        Padding(
                          padding: EdgeInsets.all(20.w),
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 20.w),
                                child: InputFiled(text: 'Email'),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 20.w),
                                child: InputFiled(text: 'Speciality'),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
