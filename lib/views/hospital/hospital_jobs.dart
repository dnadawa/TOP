import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:top/constants.dart';
import 'package:top/controllers/job_controller.dart';
import 'package:top/models/job_model.dart';
import 'package:top/views/hospital/hospital_job_details.dart';
import 'package:top/widgets/backdrop.dart';
import 'package:top/widgets/heading_card.dart';
import 'package:top/widgets/shift_tile.dart';
import 'package:top/models/user_model.dart';

class HospitalJobs extends StatefulWidget {
  final JobStatus status;
  final User? manager;

  const HospitalJobs({super.key, required this.status, required this.manager});

  @override
  State<HospitalJobs> createState() => _HospitalJobsState();
}

class _HospitalJobsState extends State<HospitalJobs> {
  @override
  Widget build(BuildContext context) {
    var jobController = Provider.of<JobController>(context);

    return Scaffold(
      body: Backdrop(
        child: Padding(
          padding: EdgeInsets.all(30.w),
          child: Column(
            children: [
              SizedBox(height: ScreenUtil().statusBarHeight),
              Expanded(
                child: HeadingCard(
                  title: "${widget.status.name} Jobs",
                  child: Expanded(
                    child: Column(
                      children: [
                        SizedBox(height: 30.h),

                        //filter
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15.w),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: ToggleSwitch(
                              initialLabelIndex: widget.manager!.specialities!
                                  .indexOf(jobController.selectedSpeciality),
                              activeFgColor: Colors.white,
                              inactiveBgColor: kDisabledSecondary,
                              inactiveFgColor: kGreyText,
                              totalSwitches: widget.manager!.specialities!.length,
                              labels: widget.manager!.specialities!.cast(),
                              fontSize: 13.sp,
                              activeBgColor: [kOrange],
                              cornerRadius: 5.r,
                              animate: true,
                              animationDuration: 200,
                              curve: Curves.easeIn,
                              customWidths:
                                  widget.manager!.specialities!.map((e) => 110.w).toList(),
                              onToggle: (index) => jobController.selectedSpeciality =
                                  widget.manager!.specialities![index!],
                            ),
                          ),
                        ),

                        //jobs
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15.w),
                            child: RefreshIndicator(
                              onRefresh: () async => setState(() {}),
                              child:
                                  FutureBuilder<List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
                                future: jobController.getJobs(
                                    widget.manager?.hospital ?? '', widget.status),
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
                                            if (widget.status != JobStatus.Completed) {
                                              Navigator.push(
                                                      context,
                                                      CupertinoPageRoute(
                                                          builder: (_) =>
                                                              HospitalJobDetails(job: job, status: widget.status)))
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
                                                    nurse: job.nurseID,
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
                                                    color: kRed,
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
