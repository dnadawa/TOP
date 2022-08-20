import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:top/constants.dart';
import 'package:top/controllers/job_controller.dart';
import 'package:top/widgets/backdrop.dart';
import 'package:top/widgets/heading_card.dart';
import 'package:top/widgets/shift_tile.dart';
import 'package:top/models/user_model.dart';
import 'package:top/models/job_model.dart';

class MyShifts extends StatefulWidget {
  final bool released;
  final User? user;

  const MyShifts({super.key, this.released = false, this.user});

  @override
  State<MyShifts> createState() => _MyShiftsState();
}

class _MyShiftsState extends State<MyShifts> {
  @override
  Widget build(BuildContext context) {
    var jobController = Provider.of<JobController>(context);

    return Scaffold(
      body: Backdrop(
        child: Padding(
          padding: EdgeInsets.all(30.w),
          child: Column(
            children: [
              SizedBox(
                  height: widget.released
                      ? ScreenUtil().statusBarHeight - 30.w
                      : ScreenUtil().statusBarHeight),
              if (widget.released)
                Align(
                  alignment: Alignment.topLeft,
                  child: BackButton(
                    color: kGreyText,
                  ),
                ),
              Expanded(
                child: HeadingCard(
                  title: widget.released ? 'Shifts' : 'My Shifts',
                  child: Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      child: RefreshIndicator(
                        onRefresh: () async => setState((){}),
                        child: FutureBuilder<List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
                          future: jobController.getAcceptedJobs(widget.user?.uid ?? ''),
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
                                  child: ShiftTile(
                                    hospital: job.hospital,
                                    shiftType: job.shiftType,
                                    shiftTime: "${job.shiftStartTime} to ${job.shiftEndTime}",
                                    shiftDate: DateFormat('EEEE MMMM dd').format(job.shiftDate),
                                    specialty: job.speciality,
                                    showAcceptButton: widget.released,
                                    showFrontStrip: true,
                                    additionalDetails: job.additionalDetails,
                                  ),
                                );
                              },
                            );
                          },
                        ),
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
