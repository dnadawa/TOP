import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:top/constants.dart';
import 'package:top/controllers/job_controller.dart';
import 'package:top/models/job_model.dart';
import 'package:top/models/timesheet_model.dart';
import 'package:top/models/user_model.dart';
import 'package:top/widgets/backdrop.dart';
import 'package:top/widgets/button.dart';
import 'package:top/widgets/heading_card.dart';
import 'package:top/widgets/input_filed.dart';
import 'package:top/widgets/signature_pad.dart';
import 'package:top/widgets/shift_tile.dart';
import 'package:top/widgets/toast.dart';

class SingleTimesheet extends StatefulWidget {
  final Job job;
  final User user;

  const SingleTimesheet({super.key, required this.job, required this.user});

  @override
  State<SingleTimesheet> createState() => _SingleTimesheetState();
}

class _SingleTimesheetState extends State<SingleTimesheet> {
  final TextEditingController shiftStartTime = TextEditingController();
  final TextEditingController shiftEndTime = TextEditingController();
  final TextEditingController additionalDetails = TextEditingController();
  final TextEditingController hospitalSignatureName = TextEditingController();
  bool mealBreak = false;
  int? mealBreakTime;
  Uint8List? nurseSign, hospitalSign;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Backdrop(
          child: Padding(
            padding: EdgeInsets.fromLTRB(30.w, 10.h, 30.w, 30.h),
            child: Column(
              children: [
                SizedBox(height: ScreenUtil().statusBarHeight),

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
                          physics: BouncingScrollPhysics(),
                          child: Column(
                            children: [
                              SizedBox(height: 30.h),

                              //shift details
                              ShiftTile(
                                hospital: widget.job.hospital,
                                shiftType: widget.job.shiftType,
                                shiftTime:
                                    "${widget.job.shiftStartTime} to ${widget.job.shiftEndTime}",
                                shiftDate: DateFormat('EEEE MMMM dd')
                                    .format(widget.job.shiftDate),
                                specialty: widget.job.speciality,
                                additionalDetails: widget.job.additionalDetails,
                                showFrontStrip: true,
                              ),
                              SizedBox(height: 50.h),

                              //text fields
                              GestureDetector(
                                onTap: () async {
                                  TimeOfDay? pickedTime = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                  );

                                  shiftStartTime.text = pickedTime!.to24hours();
                                },
                                child: InputField(
                                  text: 'Shift Start Time',
                                  controller: shiftStartTime,
                                  enabled: false,
                                ),
                              ),
                              SizedBox(height: 25.h),
                              GestureDetector(
                                onTap: () async {
                                  TimeOfDay? pickedTime = await showTimePicker(
                                    context: context,
                                    initialTime: TimeOfDay.now(),
                                  );

                                  shiftEndTime.text = pickedTime!.to24hours();
                                },
                                child: InputField(
                                  text: 'Shift End Time',
                                  controller: shiftEndTime,
                                  enabled: false,
                                ),
                              ),
                              SizedBox(height: 15.h),

                              //checkbox
                              CheckboxListTile(
                                value: mealBreak,
                                onChanged: (value) =>
                                    setState(() => mealBreak = value!),
                                controlAffinity:
                                    ListTileControlAffinity.leading,
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
                              SizedBox(height: 15.h),

                              //meal break minutes
                              if (mealBreak)
                                Container(
                                  width: double.infinity,
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 15.w),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8.r),
                                      border: Border.all(color: kDisabled)),
                                  child: DropdownButton(
                                      underline: SizedBox.shrink(),
                                      isExpanded: true,
                                      hint: Text(
                                        "Select Meal Break Time",
                                        style: TextStyle(color: kDisabled),
                                      ),
                                      value: mealBreakTime,
                                      items: List.generate(
                                              60, (index) => index + 1)
                                          .map(
                                            (min) => DropdownMenuItem(
                                              value: min,
                                              child: Text(
                                                  "$min minute${min > 1 ? 's' : ''}"),
                                            ),
                                          )
                                          .toList(),
                                      onChanged: (value) {
                                        setState(
                                            () => mealBreakTime = value as int);
                                      }),
                                ),
                              if (mealBreak) SizedBox(height: 25.h),

                              //additional details
                              InputField(
                                text: 'Additional Details (Optional)',
                                multiLine: true,
                                controller: additionalDetails,
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
                                      onComplete: (Uint8List? sign) {
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                        nurseSign = sign;
                                      },
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
                                      onComplete: (Uint8List? sign) {
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                        hospitalSign = sign;
                                      },
                                      needSignName: true,
                                      name: hospitalSignatureName,
                                    ),
                                  ),
                                  color: Colors.green,
                                  fontSize: 18.sp,
                                  padding: 10.h,
                                ),
                              ),
                              SizedBox(height: 30.h),
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
                    onPressed: () async {
                      FocusManager.instance.primaryFocus?.unfocus();
                      if (shiftStartTime.text.isEmpty ||
                          shiftEndTime.text.isEmpty ||
                          hospitalSignatureName.text.trim().isEmpty ||
                          (mealBreak && mealBreakTime == null) ||
                          nurseSign == null ||
                          hospitalSign == null) {
                        ToastBar(
                                text: 'Please fill relevant fields!',
                                color: Colors.red)
                            .show();
                      } else {
                        TimeSheet timeSheet = TimeSheet(
                          job: widget.job,
                          startTime: shiftStartTime.text,
                          endTime: shiftEndTime.text,
                          mealBreakIncluded: mealBreak,
                          mealBreakTime: mealBreakTime,
                          additionalDetails: additionalDetails.text.trim(),
                          hospitalSignatureName:
                              hospitalSignatureName.text.trim(),
                        );

                        bool success = await Provider.of<JobController>(context,
                                listen: false)
                            .submitTimeSheet(
                          timeSheet,
                          nurseSign!,
                          hospitalSign!,
                          context,
                          widget.user,
                        );
                        if (success) {
                          Navigator.pop(context);
                        }
                      }
                    },
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
