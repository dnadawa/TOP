import 'dart:typed_data';

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
import 'package:top/widgets/input_filed.dart';
import 'package:top/widgets/signature_pad.dart';

import '../widgets/shift_tile.dart';

class SingleTimesheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Backdrop(
        child: Padding(
          padding: EdgeInsets.all(30.w),
          child: Column(
            children: [
              SizedBox(height: ScreenUtil().statusBarHeight - 30.w),

              Align(
                alignment: Alignment.topLeft,
                child: BackButton(
                  color: kGreyText,
                ),
              ),

              Expanded(
                child: HeadingCard(
                  title: 'Time Sheet',
                  child: Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(height: 30.h),

                            //shift details
                            ShiftTile(
                              hospital: 'Akuressa Central Hospital',
                              suburb: 'Matara',
                              shiftType: "PM",
                              shiftTime: "13:00 to 23:53",
                              shiftDate: 'Wednesday August 2',
                              specialty: 'Speciality 1',
                              showFrontStrip: true,
                              additionalDetails: '',
                            ),
                            SizedBox(height: 50.h),

                            //text fields
                            InputField(text: 'Shift Start Time'),
                            SizedBox(height: 25.h),
                            InputField(text: 'Shift End Time'),
                            SizedBox(height: 20.h),

                            //checkbox
                            CheckboxListTile(
                              value: true,
                              onChanged: (value) {},
                              controlAffinity: ListTileControlAffinity.leading,
                              activeColor: kGreen,
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                'Meal break included in the shift',
                                style: GoogleFonts.sourceSansPro(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            SizedBox(height: 40.h),

                            //signatures
                            SizedBox(
                              width: double.infinity,
                              child: Button(
                                text: 'Nurse Signature',
                                onPressed: () => showDialog(
                                  context: context,
                                  builder: (context) => SignaturePad(
                                    onComplete: (Uint8List? sign) {},
                                  ),
                                ),
                                color: Colors.green,
                                fontSize: 18.sp,
                                padding: 10.h,
                              ),
                            ),
                            SizedBox(height: 10.h),
                            SizedBox(
                              width: double.infinity,
                              child: Button(
                                text: 'Hospital Signature',
                                onPressed: () => showDialog(
                                  context: context,
                                  builder: (context) => SignaturePad(
                                    onComplete: (Uint8List? sign) {},
                                    needSignName: true,
                                  ),
                                ),
                                color: Colors.green,
                                fontSize: 18.sp,
                                padding: 10.h,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 50.h),

              //button
              SizedBox(
                width: double.infinity,
                child: Button(
                  text: 'Submit',
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
