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
import 'package:top/widgets/shift_tile.dart';
import 'package:top/widgets/toast.dart';

class HospitalJobDetails extends StatelessWidget {
  final Job job;
  final JobStatus status;

  const HospitalJobDetails({super.key, required this.job, required this.status});

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
                    hospital: job.hospital,
                    shiftType: job.shiftType,
                    shiftTime: "${job.shiftStartTime} to ${job.shiftEndTime}",
                    shiftDate: DateFormat('EEEE MMMM dd').format(job.shiftDate),
                    specialty: job.speciality,
                    additionalDetails: job.additionalDetails,
                    showFrontStrip: true,
                  ),
                ),
              ),

              Expanded(child: SizedBox.shrink()),
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
                            bool isDeleted = await Provider.of<JobController>(context, listen: false).deleteJob(job, status);
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
