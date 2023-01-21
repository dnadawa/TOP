import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:top/constants.dart';
import 'package:top/controllers/job_controller.dart';
import 'package:top/models/job_model.dart';
import 'package:top/models/user_model.dart';
import 'package:top/widgets/backdrop.dart';
import 'package:top/widgets/badge.dart';
import 'package:top/widgets/heading_card.dart';
import 'package:top/widgets/shift_tile.dart';

import '../controllers/user_controller.dart';
import '../widgets/toast.dart';

class AllJobs extends StatefulWidget {
  final User? user;

  const AllJobs({super.key, required this.user});

  @override
  State<AllJobs> createState() => _AllJobsState();
}

class _AllJobsState extends State<AllJobs> {
  @override
  Widget build(BuildContext context) {
    var jobController = Provider.of<JobController>(context);
    var userController = Provider.of<UserController>(context);

    return Scaffold(
      body: Backdrop(
        child: Padding(
          padding: EdgeInsets.only(left: 30.w, right: 30.w, bottom: 30.w),
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
                  title: "All Jobs",
                  child: Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(15.w, 25.h, 15.w, 0.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 6.w),
                                  child: SizedBox(
                                    width: 25.w,
                                    height: 20.h,
                                    child: Badge(text: '', color: kGreen, enabled: true),
                                  ),
                                ),
                                Text('Available', style: TextStyle(fontSize: 14.sp)),
                                Expanded(child: SizedBox()),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 6.w),
                                  child: SizedBox(
                                    width: 25.w,
                                    height: 20.h,
                                    child: Badge(text: '', color: kOrange, enabled: true),
                                  ),
                                ),
                                Text('Confirmed', style: TextStyle(fontSize: 14.sp)),
                                Expanded(child: SizedBox()),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 6.w),
                                  child: SizedBox(
                                    width: 25.w,
                                    height: 20.h,
                                    child: Badge(text: '', color: kRed, enabled: true),
                                  ),
                                ),
                                Text('Completed', style: TextStyle(fontSize: 14.sp)),
                              ],
                            ),
                          ),

                          //calendar
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 25.h),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2022, 1, 1),
                                    lastDate: DateTime(2099, 12, 31),
                                  );

                                  jobController.selectedDate = pickedDate;
                                },
                                child: Material(
                                  elevation: 5,
                                  borderRadius: BorderRadius.circular(5.r),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.horizontal(left: Radius.circular(5.r)),
                                          color: kGreen,
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(10.h),
                                          child: Icon(Icons.calendar_today,
                                              color: Colors.white, size: 16),
                                        ),
                                      ),
                                      SizedBox(width: 15.w),
                                      Text(
                                        jobController.selectedDate?.toYYYYMMDDFormat() ?? 'All',
                                        style: GoogleFonts.outfit(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.black),
                                      ),
                                      SizedBox(width: 15.w),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          //jobs
                          Expanded(
                            child: RefreshIndicator(
                              onRefresh: () async => setState(() {}),
                              child:
                                  FutureBuilder<List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
                                future: jobController.getAllJobsForNurse(
                                    widget.user?.uid ?? '', widget.user?.specialities ?? []),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                    return Stack(
                                      children: [
                                        Center(
                                          child: Text('No data to show!'),
                                        ),
                                        ListView(
                                          physics: AlwaysScrollableScrollPhysics(),
                                        ),
                                      ],
                                    );
                                  }

                                  return ListView.builder(
                                    padding: EdgeInsets.symmetric(vertical: 0),
                                    physics: BouncingScrollPhysics(
                                      parent: AlwaysScrollableScrollPhysics(),
                                    ),
                                    itemCount: snapshot.data!.length,
                                    itemBuilder: (context, i) {
                                      Job job = Job.createJobFromDocument(snapshot.data![i]);

                                      return Padding(
                                        padding: EdgeInsets.only(bottom: 20.h),
                                        child: ShiftTile(
                                          hospital: job.hospital,
                                          shiftType: job.shiftType.join(","),
                                          shiftTime: "${job.shiftStartTime} to ${job.shiftEndTime}",
                                          shiftDate:
                                              DateFormat('EEEE MMMM dd').format(job.shiftDate),
                                          specialty: job.speciality,
                                          showAcceptButton: job.status == JobStatus.Available,
                                          showFrontStrip: true,
                                          additionalDetails: job.additionalDetails,
                                          frontStripColor: job.status == JobStatus.Available
                                              ? kGreen
                                              : job.status == JobStatus.Confirmed
                                                  ? kOrange
                                                  : kRed,
                                          onAcceptButtonPressed: () async {
                                            ToastBar(text: "Please wait...", color: Colors.orange)
                                                .show();
                                            bool isAvailable =
                                                await userController.isNurseAvailable(
                                                    widget.user!.uid,
                                                    job.shiftDate.toYYYYMMDDFormat(),
                                                    job.shiftType);

                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) => AlertDialog(
                                                content: Text(
                                                  isAvailable
                                                      ? 'Are you sure you want to accept this job?'
                                                      : 'You are not available on this shift(s).',
                                                ),
                                                actions: [
                                                  if (isAvailable)
                                                    TextButton(
                                                      child: Text(
                                                        'Yes',
                                                        style: TextStyle(
                                                          color: kGreen,
                                                        ),
                                                      ),
                                                      onPressed: () async {
                                                        ToastBar(
                                                                text: 'Please wait...',
                                                                color: Colors.orange)
                                                            .show();
                                                        bool success = await jobController
                                                            .acceptJob(job, widget.user!);
                                                        if (success) {
                                                          Navigator.pop(context);
                                                          setState(() {});
                                                        }
                                                      },
                                                    ),
                                                  TextButton(
                                                    child: Text(
                                                      isAvailable ? 'No' : 'OK',
                                                      style: TextStyle(
                                                        color: kGreen,
                                                      ),
                                                    ),
                                                    onPressed: () => Navigator.pop(context),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
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
