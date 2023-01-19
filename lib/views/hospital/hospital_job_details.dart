import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:top/controllers/job_controller.dart';
import 'package:top/widgets/backdrop.dart';
import 'package:top/constants.dart';
import 'package:top/widgets/button.dart';
import 'package:top/widgets/heading_card.dart';
import 'package:top/models/job_model.dart';
import 'package:top/widgets/input_filed.dart';
import 'package:top/widgets/shift_tile.dart';
import 'package:top/widgets/toast.dart';

class HospitalJobDetails extends StatefulWidget {
  final Job job;
  final JobStatus status;

  const HospitalJobDetails({super.key, required this.job, required this.status});

  @override
  State<HospitalJobDetails> createState() => _HospitalJobDetailsState();
}

class _HospitalJobDetailsState extends State<HospitalJobDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Backdrop(
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

              //details
              HeadingCard(
                title: 'Job Details',
                child: Padding(
                  padding: EdgeInsets.all(20.w),
                  child: ShiftTile(
                    hospital: widget.job.hospital,
                    shiftType: widget.job.shiftType.join(","),
                    shiftTime: "${widget.job.shiftStartTime} to ${widget.job.shiftEndTime}",
                    shiftDate: DateFormat('EEEE MMMM dd').format(widget.job.shiftDate),
                    specialty: widget.job.speciality,
                    additionalDetails: widget.job.additionalDetails,
                    showFrontStrip: true,
                  ),
                ),
              ),

              Expanded(child: SizedBox.shrink()),
              SizedBox(
                width: double.infinity,
                child: Button(
                  text: 'Edit Shift Time',
                  color: kGreen,
                  onPressed: () {
                    TextEditingController shiftStartTime = TextEditingController();
                    TextEditingController shiftEndTime = TextEditingController();
                    shiftStartTime.text = widget.job.shiftStartTime;
                    shiftEndTime.text = widget.job.shiftEndTime;

                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        contentPadding: EdgeInsets.zero,
                        backgroundColor: Colors.transparent,
                        content: HeadingCard(
                          title: "Edit",
                          mainAxisSize: MainAxisSize.min,
                          child: Padding(
                            padding: EdgeInsets.all(15.h),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
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
                                SizedBox(height: 80.h),
                                SizedBox(
                                  width: double.infinity,
                                  child: Button(
                                    text: 'Edit',
                                    color: kGreen,
                                    onPressed: () async {
                                      if (shiftStartTime.text.isEmpty ||
                                          shiftEndTime.text.isEmpty) {
                                        ToastBar(
                                                text: 'Please fill relevant fields!',
                                                color: Colors.red)
                                            .show();
                                      } else {
                                        ToastBar(text: "Please wait...", color: Colors.orange)
                                            .show();

                                        setState(() {
                                          widget.job.shiftStartTime = shiftStartTime.text;
                                          widget.job.shiftEndTime = shiftEndTime.text;
                                        });
                                        bool isSuccess =
                                            await Provider.of<JobController>(context, listen: false)
                                                .editTimes(widget.job);
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
                  },
                ),
              ),
              SizedBox(height: 20.h),
              SizedBox(
                width: double.infinity,
                child: Button(
                  text: 'Delete Job Post',
                  color: kRed,
                  onPressed: () => showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      content: Text('Are you sure you want to delete the job?'),
                      actions: [
                        TextButton(
                          child: Text(
                            'Yes',
                            style: TextStyle(
                              color: kGreen,
                            ),
                          ),
                          onPressed: () async {
                            ToastBar(text: "Please wait...", color: Colors.orange).show();
                            bool isDeleted =
                                await Provider.of<JobController>(context, listen: false)
                                    .deleteJob(widget.job, widget.status);
                            if (isDeleted) {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            }
                          },
                        ),
                        TextButton(
                          child: Text(
                            'No',
                            style: TextStyle(
                              color: kGreen,
                            ),
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
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
