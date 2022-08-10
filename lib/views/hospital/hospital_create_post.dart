import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:top/controllers/job_controller.dart';
import 'package:top/models/job_model.dart';
import 'package:top/widgets/backdrop.dart';
import 'package:top/constants.dart';
import 'package:top/widgets/button.dart';
import 'package:top/widgets/heading_card.dart';
import 'package:top/widgets/input_filed.dart';
import 'package:top/widgets/toast.dart';

import '../../models/user_model.dart';

class HospitalCreatePost extends StatefulWidget {
  final User hospital;

  const HospitalCreatePost({super.key, required this.hospital});

  @override
  State<HospitalCreatePost> createState() => _HospitalCreatePostState();
}

class _HospitalCreatePostState extends State<HospitalCreatePost> {
  final TextEditingController hospitalName = TextEditingController();
  final TextEditingController suburb = TextEditingController();
  final TextEditingController shiftDate = TextEditingController();
  final TextEditingController shiftStartTime = TextEditingController();
  final TextEditingController shiftEndTime = TextEditingController();
  final TextEditingController additionalDetails = TextEditingController();

  String? selectedShiftType;
  String? selectedSpeciality;
  DateTime? selectedShiftDate;

  @override
  Widget build(BuildContext context) {
    hospitalName.text = widget.hospital.name!;
    suburb.text = widget.hospital.suburb!;

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
                          child: InputField(
                            text: 'Hospital',
                            controller: hospitalName,
                            enabled: false,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 15.w),
                          child: InputField(
                            text: 'Suburb',
                            controller: suburb,
                            enabled: false,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 15.w),
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(horizontal: 15.w),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.r),
                                border: Border.all(color: kDisabled)),
                            child: DropdownButton<String?>(
                              underline: SizedBox.shrink(),
                              isExpanded: true,
                              hint: Text(
                                "Speciality",
                                style: TextStyle(color: kDisabled),
                              ),
                              value: selectedSpeciality,
                              items: specialities.map((speciality) => DropdownMenuItem(value: speciality, child: Text(speciality))).toList(),
                              onChanged: (value) {
                                setState(() => selectedSpeciality = value);
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 15.w),
                          child: GestureDetector(
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2099, 12, 31),
                              );

                              selectedShiftDate = pickedDate;
                              shiftDate.text = DateFormat('EEEE MMMM dd').format(pickedDate!);
                            },
                            child: InputField(
                              text: 'Shift Date',
                              enabled: false,
                              controller: shiftDate,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 15.w),
                          child: GestureDetector(
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
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 15.w),
                          child: GestureDetector(
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
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 15.w),
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(horizontal: 15.w),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.r),
                                border: Border.all(color: kDisabled)),
                            child: DropdownButton<String?>(
                              underline: SizedBox.shrink(),
                              isExpanded: true,
                              hint: Text(
                                "Shift Type",
                                style: TextStyle(color: kDisabled),
                              ),
                              value: selectedShiftType,
                              items: [
                                DropdownMenuItem(value: 'AM', child: Text('AM')),
                                DropdownMenuItem(value: 'PM', child: Text('PM')),
                                DropdownMenuItem(value: 'NS', child: Text('NS')),
                              ],
                              onChanged: (value) {
                                setState(() => selectedShiftType = value);
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 15.w),
                          child: InputField(
                            text: 'Additional Details (Optional)',
                            controller: additionalDetails,
                            multiLine: true,
                          ),
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
                    onPressed: () async {
                      if (shiftDate.text.isEmpty ||
                          shiftStartTime.text.isEmpty ||
                          shiftEndTime.text.isEmpty ||
                          selectedShiftType == null || selectedSpeciality == null) {
                        ToastBar(text: 'Please fill relevant fields!', color: Colors.red).show();
                      } else {
                        ToastBar(text: "Please wait...", color: Colors.orange).show();

                        Job job = Job(
                          hospital: hospitalName.text,
                          hospitalID: widget.hospital.uid,
                          suburb: suburb.text,
                          shiftDate: selectedShiftDate!,
                          shiftStartTime: shiftStartTime.text,
                          shiftEndTime: shiftEndTime.text,
                          shiftType: selectedShiftType!,
                          additionalDetails: additionalDetails.text,
                          speciality: selectedSpeciality!,
                          id: ''
                        );

                        bool isSuccess = await Provider.of<JobController>(context, listen: false).createJob(job);
                        if (isSuccess) {
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
