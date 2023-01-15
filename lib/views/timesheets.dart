import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:top/constants.dart';
import 'package:top/models/image_timesheet_model.dart';
import 'package:top/models/job_model.dart';
import 'package:top/models/user_model.dart';
import 'package:top/views/single_timesheet.dart';
import 'package:top/widgets/backdrop.dart';
import 'package:top/widgets/heading_card.dart';
import 'package:top/widgets/shift_tile.dart';
import 'package:top/controllers/job_controller.dart';

class TimeSheets extends StatefulWidget {
  final User? user;

  const TimeSheets({super.key, required this.user});

  @override
  State<TimeSheets> createState() => _TimeSheetsState();
}

class _TimeSheetsState extends State<TimeSheets> {
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
                  title: 'Time sheets',
                  child: Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      child: RefreshIndicator(
                        onRefresh: () async => setState(() {}),
                        child: FutureBuilder<List<QueryDocumentSnapshot<Map<String, dynamic>>>>(
                          future: jobController.getTodayTimeSheets(widget.user?.uid ?? ''),
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
                                    onTap: () => showCupertinoModalPopup(
                                        context: context,
                                        builder: (context) {
                                          return Card(
                                            margin: EdgeInsets.all(15.w),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(20.r),
                                            ),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                ListTile(
                                                  leading: Icon(
                                                    Icons.assignment,
                                                    color: kGreen,
                                                  ),
                                                  title: Text("Fill the form"),
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                    Navigator.push(
                                                      context,
                                                      CupertinoPageRoute(
                                                        builder: (context) => SingleTimesheet(
                                                          job: job,
                                                          user: widget.user!,
                                                        ),
                                                      ),
                                                    ).then((value) => setState(() {}));
                                                  },
                                                ),
                                                ListTile(
                                                  leading: Icon(
                                                    Icons.camera_alt,
                                                    color: kGreen,
                                                  ),
                                                  title: Text("Upload a photo"),
                                                  onTap: () async {
                                                    final ImagePicker imagePicker = ImagePicker();
                                                    final XFile? image = await imagePicker
                                                        .pickImage(source: ImageSource.gallery);
                                                    if (image != null) {
                                                      ImageTimeSheet timeSheet =
                                                          ImageTimeSheet(job);
                                                      Uint8List imageBytes =
                                                          await image.readAsBytes();

                                                      bool success =
                                                          await Provider.of<JobController>(context,
                                                                  listen: false)
                                                              .submitImageTimesheet(
                                                                  timeSheet,
                                                                  context,
                                                                  imageBytes,
                                                                  widget.user!);
                                                      if (success) {
                                                        Navigator.pop(context);
                                                        setState(() {});
                                                      }
                                                    }
                                                  },
                                                ),
                                              ],
                                            ),
                                          );
                                        }),
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
                                              shiftDate:
                                                  DateFormat('EEEE MMMM dd').format(job.shiftDate),
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
