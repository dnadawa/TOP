import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:top/constants.dart';

class Button extends StatelessWidget {
  final String text;
  final Function onPressed;
  final Color? color;
  final Color? textColor;
  final bool enabled;
  final double? padding;
  final double? fontSize;

  const Button({super.key, required this.text, required this.onPressed, this.color, this.textColor, this.enabled = true, this.padding, this.fontSize});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: enabled ? color ?? kGreen : kDisabledSecondary,
          padding: EdgeInsets.all(padding ?? 14.h),
      ),
      child: Text(
        text,
        style: TextStyle(
            color: enabled ? textColor ?? Colors.white : kDisabled,
            fontSize: fontSize ?? 24.sp,
            fontWeight: FontWeight.w600
        ),
      ),
      onPressed: () {
        if (enabled){
          onPressed();
        }
      },
    );
  }
}
