import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:top/constants.dart';

class InputFiled extends StatefulWidget {
  final String text;
  final bool isPassword;
  final TextInputType? keyboard;
  final TextEditingController controller;

  const InputFiled(
      {super.key,
      required this.text,
      this.isPassword = false,
      this.keyboard,
      required this.controller});

  @override
  State<InputFiled> createState() => _InputFiledState();
}

class _InputFiledState extends State<InputFiled> {
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
      style: TextStyle(
        color: kDisabled,
      ),
      keyboardType: widget.keyboard,
      obscureText: hideText,
      cursorColor: kGreen,
      decoration: InputDecoration(
        isDense: true,
        hintText: widget.text,
        hintStyle: TextStyle(color: kDisabled, fontWeight: FontWeight.w400, fontSize: 18.sp,),
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
            widget.isPassword ? hideText ? Icons.visibility_off : Icons.visibility : null,
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
