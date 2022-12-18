import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:top/constants.dart';
import 'package:top/controllers/user_controller.dart';
import 'package:top/models/shift_model.dart';
import 'package:top/models/user_model.dart';
import 'package:top/views/edit_availability.dart';
import 'package:top/widgets/availability_tile.dart';
import 'package:top/widgets/backdrop.dart';
import 'package:top/widgets/button.dart';
import 'package:top/widgets/heading_card.dart';
import 'package:top/widgets/badge.dart';

class Availability extends StatefulWidget {
  final User? user;

  const Availability({super.key, required this.user});

  @override
  State<Availability> createState() => _AvailabilityState();
}

class _AvailabilityState extends State<Availability> {
  @override
  Widget build(BuildContext context) {
    var userController = Provider.of<UserController>(context);

    return Scaffold(
      body: Backdrop(
        child: Padding(
          padding: EdgeInsets.all(30.w),
          child: Column(
            children: [
              SizedBox(height: 30.h),

              Expanded(
                child: HeadingCard(
                  title: 'Availability',
                  child: Expanded(
                    child: Column(
                      children: [
                        SizedBox(height: ScreenUtil().statusBarHeight),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.w),
                              child: SizedBox(
                                width: 25.w,
                                height: 20.h,
                                child: Badge(text: '', color: Colors.green, enabled: true),
                              ),
                            ),
                            Text('Available', style: TextStyle(fontSize: 14.sp)),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.w),
                              child: SizedBox(
                                width: 25.w,
                                height: 20.h,
                                child: Badge(text: '', color: Colors.red, enabled: true),
                              ),
                            ),
                            Text('Booked', style: TextStyle(fontSize: 14.sp)),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.w),
                              child: SizedBox(
                                width: 25.w,
                                height: 20.h,
                                child: Badge(text: '', color: Colors.green, enabled: false),
                              ),
                            ),
                            Text('Not Available', style: TextStyle(fontSize: 14.sp)),
                          ],
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15.w),
                            child: RefreshIndicator(
                              onRefresh: () async => setState(() {}),
                              child: FutureBuilder<List<Shift>>(
                                future: userController.getAllAvailability(widget.user?.uid ?? ''),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return Center(child: CircularProgressIndicator());
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

                                      Shift shift = snapshot.data![i];

                                      return AvailabilityTile(
                                        nurseID: widget.user!.uid,
                                        dateString: shift.dateAsDateTime.toEEEMMMddFormat(),
                                        am: shift.am,
                                        pm: shift.pm,
                                        ns: shift.ns,
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
              SizedBox(height: 50.h),

              //button
              SizedBox(
                width: double.infinity,
                child: Button(
                  text: 'Edit Availability',
                  color: kRed,
                  onPressed: () async {
                    if (widget.user != null) {
                      List<Shift> shifts = await userController.getAllAvailability(widget.user?.uid ?? '');
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => EditAvailability(
                            user: widget.user!,
                            previousShifts: shifts,
                          ),
                        ),
                      ).then((value) => setState((){}));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
