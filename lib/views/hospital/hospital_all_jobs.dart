import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:top/models/user_model.dart';

import '../../constants.dart';
import '../../controllers/job_controller.dart';
import '../../models/job_model.dart';
import '../../widgets/backdrop.dart';
import '../../widgets/badge.dart';
import '../../widgets/heading_card.dart';
import '../../widgets/shift_tile.dart';
import 'hospital_job_details.dart';

class HospitalAllJobs extends StatefulWidget {
  final User? user;

  const HospitalAllJobs({super.key, required this.user});

  @override
  State<HospitalAllJobs> createState() => _HospitalAllJobsState();
}

class _HospitalAllJobsState extends State<HospitalAllJobs> {
  @override
  Widget build(BuildContext context) {
    var jobController = Provider.of<JobController>(context);

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
                  title: "Jobs",
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
                                future: jobController.getJobsByDate(widget.user?.hospital ?? ''),
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
                                        child: GestureDetector(
                                          onTap: () {
                                            if (job.status != JobStatus.Completed) {
                                              Navigator.push(
                                                      context,
                                                      CupertinoPageRoute(
                                                          builder: (_) => HospitalJobDetails(
                                                              job: job, status: job.status!)))
                                                  .then((value) => setState(() {}));
                                            }
                                          },
                                          child: IntrinsicHeight(
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.stretch,
                                              children: [
                                                Expanded(
                                                  child: ShiftTile(
                                                    hospital: job.hospital,
                                                    shiftType: job.shiftType.join(","),
                                                    shiftTime:
                                                        "${job.shiftStartTime} to ${job.shiftEndTime}",
                                                    shiftDate: DateFormat('EEEE MMMM dd')
                                                        .format(job.shiftDate),
                                                    specialty: job.speciality,
                                                    additionalDetails: job.additionalDetails,
                                                    showBackStrip: true,
                                                  ),
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    color: job.status == JobStatus.Available ? kGreen : job.status == JobStatus.Confirmed ? kOrange : kRed,
                                                    borderRadius: BorderRadius.horizontal(
                                                        right: Radius.circular(10.r)),
                                                  ),
                                                  child: SizedBox(
                                                    child: Icon(
                                                      Icons.arrow_forward_ios,
                                                      color: Colors.white,
                                                      size: 20,
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
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
