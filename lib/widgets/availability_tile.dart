import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:top/constants.dart';
import 'package:top/widgets/badge.dart';
import 'package:top/widgets/shift_tile.dart';

import '../controllers/job_controller.dart';
import '../models/job_model.dart';

class AvailabilityTile extends StatelessWidget {
  final String nurseID;
  final String dateString;
  final AvailabilityStatus am;
  final AvailabilityStatus pm;
  final AvailabilityStatus ns;

  const AvailabilityTile(
      {super.key, required this.dateString, required this.am, required this.pm, required this.ns, required this.nurseID,});

  void onBadgeTapped(String shift, AvailabilityStatus availabilityStatus, BuildContext context){
    var jobController = Provider.of<JobController>(context, listen: false);

    if(availabilityStatus == AvailabilityStatus.Booked){
      showCupertinoModalPopup(context: context, builder: (BuildContext context){return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
          color: Colors.white,
        ),
        height: 0.75.sh,
        child: Padding(
          padding: EdgeInsets.all(30.w),
          child: FutureBuilder<List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
            future: jobController.getAcceptedJobs(nurseID),
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
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r)),
                      child: ShiftTile(
                        hospital: job.hospital,
                        shiftType: job.shiftType,
                        shiftTime: "${job.shiftStartTime} to ${job.shiftEndTime}",
                        shiftDate: DateFormat('EEEE MMMM dd').format(job.shiftDate),
                        specialty: job.speciality,
                        showFrontStrip: true,
                        additionalDetails: job.additionalDetails,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      );});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
      ),
      elevation: 3,
      margin: EdgeInsets.only(bottom: 16.h, left: 8, right: 5),
      child: Padding(
        padding: EdgeInsets.all(15.h),
        child: Row(
          children: [
            Text(
              dateString,
              style: GoogleFonts.sourceSansPro(
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
                color: kGreyText,
              ),
            ),
            Expanded(child: SizedBox.shrink()),
            Badge(
              text: 'AM',
              color: am == AvailabilityStatus.Available ? Colors.green : Colors.red,
              enabled: am != AvailabilityStatus.NotAvailable,
              onTap: () => onBadgeTapped('AM', am, context),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Badge(
                text: 'PM',
                color: pm == AvailabilityStatus.Available ? Colors.green : Colors.red,
                enabled: pm != AvailabilityStatus.NotAvailable,
                onTap: () => onBadgeTapped('PM', pm, context),
              ),
            ),
            Badge(
              text: 'NS',
              color: ns == AvailabilityStatus.Available ? Colors.green : Colors.red,
              enabled: ns != AvailabilityStatus.NotAvailable,
              onTap: () => onBadgeTapped('NS', ns,context),
            ),
          ],
        ),
      ),
    );
  }
}
