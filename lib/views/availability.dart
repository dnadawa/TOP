import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:top/constants.dart';
import 'package:top/views/edit_availability.dart';
import 'package:top/widgets/availability_tile.dart';
import 'package:top/widgets/backdrop.dart';
import 'package:top/widgets/button.dart';
import 'package:top/widgets/heading_card.dart';

class Availability extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Backdrop(
        child: Padding(
          padding: EdgeInsets.all(30.w),
          child: Column(
            children: [
              SizedBox(height: ScreenUtil().statusBarHeight),

              Expanded(
                child: HeadingCard(
                  title: 'Availability',
                  child: Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: 10,
                        itemBuilder: (context, i) => AvailabilityTile(
                          dateString: 'Wed Aug 2',
                          AM: true,
                          PM: true,
                          NS: true,
                        ),
                      ),
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
                  onPressed: () => Navigator.push(context, CupertinoPageRoute(builder: (context) => EditAvailability())),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
