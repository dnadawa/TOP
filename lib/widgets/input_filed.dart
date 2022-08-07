import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:top/constants.dart';

class InputField extends StatefulWidget {
  final String text;
  final bool isPassword;
  final TextInputType? keyboard;
  final TextEditingController? controller;
  final bool enabled;

  const InputField({
    super.key,
    required this.text,
    this.isPassword = false,
    this.keyboard,
    this.controller, this.enabled = true,
  });

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  bool hideText = false;

  @override
  void initState() {
    super.initState();
    hideText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      keyboardType: widget.keyboard,
      obscureText: hideText,
      cursorColor: kGreen,
      enabled: widget.enabled,
      decoration: InputDecoration(
        isDense: true,
        labelText: widget.text,
        filled: true,
        fillColor: Colors.white,
        labelStyle: TextStyle(
          color: kDisabled,
          fontWeight: FontWeight.w400,
          fontSize: 18.sp,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.r),
          borderSide: BorderSide(
            color: kDisabled,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.r),
          borderSide: BorderSide(
            color: kGreen,
            width: 2,
          ),
        ),
        suffixIcon: IconButton(
          splashColor: Colors.transparent,
          icon: Icon(
            widget.isPassword
                ? hideText
                    ? Icons.visibility_off
                    : Icons.visibility
                : null,
            color: kDisabled,
            size: 22,
          ),
          onPressed: () {
            if (widget.isPassword) {
              setState(() {
                hideText = !hideText;
              });
            }
          },
        ),
      ),
    );
  }
}
