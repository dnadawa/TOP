import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:top/constants.dart';
import 'package:top/controllers/job_controller.dart';
import 'package:top/controllers/user_controller.dart';
import 'package:top/widgets/backdrop.dart';
import 'package:top/widgets/heading_card.dart';
import 'package:top/widgets/shift_tile.dart';
import 'package:top/models/user_model.dart';
import 'package:top/models/job_model.dart';
import 'package:top/widgets/toast.dart';

class MyShifts extends StatefulWidget {
  final bool released;
  final User? user;
  final String? date;

  const MyShifts({super.key, this.released = false, this.user, this.date});

  @override
  State<MyShifts> createState() => _MyShiftsState();
}

class _MyShiftsState extends State<MyShifts> {
  @override
  Widget build(BuildContext context) {
    var jobController = Provider.of<JobController>(context);
    var userController = Provider.of<UserController>(context);

    return Scaffold(
      body: Backdrop(
        child: Padding(
          padding: EdgeInsets.fromLTRB(30.w, widget.released ? 10.h : 30.h, 30.w, 30.h),
          child: Column(
            children: [
              SizedBox(height: ScreenUtil().statusBarHeight),
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
                        onRefresh: () async => setState(() {}),
                        child: FutureBuilder<List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
                          future: widget.released
                              ? jobController.getReleasedJobs(
                                  widget.user?.specialities ?? [],
                                  widget.date!,
                                )
                              : jobController.getAcceptedJobs(widget.user?.uid ?? ''),
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
                                    shiftType: job.shiftType.join(","),
                                    shiftTime: "${job.shiftStartTime} to ${job.shiftEndTime}",
                                    shiftDate: DateFormat('EEEE MMMM dd').format(job.shiftDate),
                                    specialty: job.speciality,
                                    showAcceptButton: widget.released,
                                    showFrontStrip: true,
                                    additionalDetails: job.additionalDetails,
                                    onAcceptButtonPressed: () async {
                                      ToastBar(text: "Please wait...", color: Colors.orange).show();
                                      bool isAvailable = await userController.isNurseAvailable(
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
                                                  ToastBar(text: 'Please wait...', color: Colors.orange).show();
                                                  bool success = await jobController.acceptJob(
                                                      job, widget.user!);
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
