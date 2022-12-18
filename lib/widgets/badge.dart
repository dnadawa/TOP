import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:top/constants.dart';

class Badge extends StatelessWidget {
  final String text;
  final Color color;
  final bool enabled;
  final Function()? onTap;

  const Badge({super.key, required this.text, required this.color, required this.enabled, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: enabled ? color : kDisabledSecondary,
          borderRadius: BorderRadius.circular(5.r),
        ),
        width: 34.w,
        height: 25.h,
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 15.sp,
              color: enabled ? Colors.white : kDisabled,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
