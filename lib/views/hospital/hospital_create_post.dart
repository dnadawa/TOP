import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:top/widgets/backdrop.dart';
import 'package:top/constants.dart';
import 'package:top/widgets/button.dart';
import 'package:top/widgets/heading_card.dart';
import 'package:top/widgets/input_filed.dart';

class HospitalCreatePost extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Backdrop(
        child: SingleChildScrollView(
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
                  title: 'Post a Job',
                  child: Padding(
                    padding: EdgeInsets.all(20.w),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 15.w),
                          child: InputField(text: 'Hospital'),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 15.w),
                          child: InputField(text: 'Suburb'),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 15.w),
                          child: InputField(text: 'Speciality'),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 15.w),
                          child: InputField(text: 'Shift Date'),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 15.w),
                          child: InputField(text: 'Shift Start Time'),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 15.w),
                          child: InputField(text: 'Shift End Time'),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 15.w),
                          child: InputField(text: 'Shift Type'),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 50.h),
                SizedBox(
                  width: double.infinity,
                  child: Button(
                    text: 'Submit',
                    onPressed: () {},
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
