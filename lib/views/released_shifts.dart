import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:top/models/user_model.dart';
import 'package:top/widgets/backdrop.dart';
import 'package:top/widgets/heading_card.dart';
import 'package:top/widgets/released_shift_tile.dart';
import 'package:top/controllers/job_controller.dart';

import 'my_shifts.dart';

class ReleasedShifts extends StatefulWidget {
  final User? user;

  const ReleasedShifts({super.key, this.user});

  @override
  State<ReleasedShifts> createState() => _ReleasedShiftsState();
}

class _ReleasedShiftsState extends State<ReleasedShifts> {
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
                  title: 'Released Shifts',
                  child: Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      child: RefreshIndicator(
                        onRefresh: () async => setState((){}),
                        child: FutureBuilder<Map<String, int>>(
                          future: jobController.getReleasedJobsCountByDate(widget.user?.specialities ?? []),
                          builder: (context , snapshot){
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
                              itemCount: snapshot.data!.keys.length,
                              itemBuilder: (context, i) {
                                String key = snapshot.data!.keys.toList()[i];
                                int value = snapshot.data![key] ?? 0;

                                return GestureDetector(
                                  onTap: () => Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (_) => MyShifts(
                                        released: true,
                                        user: widget.user,
                                        date: key,
                                      ),
                                    ),
                                  ).then((value) => setState((){})),
                                  child: ReleasedShiftTile(
                                    dateString: key,
                                    count: value.toString(),
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
