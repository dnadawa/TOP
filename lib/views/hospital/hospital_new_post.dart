import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:top/views/hospital/hospital_create_post.dart';
import 'package:top/widgets/backdrop.dart';
import 'package:top/constants.dart';
import 'package:top/widgets/button.dart';
import 'package:top/widgets/heading_card.dart';
import 'package:top/widgets/input_filed.dart';

class HospitalNewPost extends StatelessWidget {
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
                            'Akuressa Central Hospital',
                            style: TextStyle(
                                color: kGreyText, fontSize: 28.sp, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 20.w),
                    Image.asset(
                      'assets/hospital.png',
                      height: 80.h,
                    ),
                  ],
                ),
                SizedBox(height: 75.h),

                //details
                HeadingCard(
                  title: 'Hospital Details',
                  child: Padding(
                    padding: EdgeInsets.all(20.w),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.w),
                          child: InputField(text: 'Hospital Name'),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.w),
                          child: InputField(text: 'Email'),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 220.h),
                SizedBox(
                  width: double.infinity,
                  child: Button(
                    text: 'Post a New Job',
                    onPressed: () => Navigator.push(context, CupertinoPageRoute(builder: (_) => HospitalCreatePost())),
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
