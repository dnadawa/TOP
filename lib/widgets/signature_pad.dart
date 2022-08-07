import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:signature/signature.dart';
import 'package:top/constants.dart';
import 'package:top/widgets/button.dart';

class SignaturePad extends StatelessWidget {

  final Function onComplete;

  const SignaturePad({super.key, required this.onComplete});

  @override
  Widget build(BuildContext context) {
    final SignatureController controller = SignatureController(
      penStrokeWidth: 5,
      penColor: Colors.black,
      exportBackgroundColor: kDisabledSecondary,
    );

    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.r)
      ),
      contentPadding: EdgeInsets.zero,
      insetPadding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 35.h),
      content: SizedBox(
        width: 1.sw,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                color: kGreen,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(15.r),
                ),
              ),
              padding: EdgeInsets.all(15.w),
              child: Text(
                'Enter Signature',
                style: TextStyle(
                  fontSize: 22.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 30.h),

            Signature(
              controller: controller,
              width: double.infinity,
              height: 0.6.sh,
              backgroundColor: kDisabledSecondary,
            ),

            Padding(
              padding: EdgeInsets.all(15.w),
              child: Row(
                children: [
                  Expanded(
                      child: Button(
                        color: kRed,
                        text: 'Clear',
                        fontSize: 18.sp,
                        padding: 5.h,
                        onPressed: ()=>controller.clear(),
                      )
                  ),
                  SizedBox(width: 10.w,),
                  Expanded(
                      child: Button(
                        color: kGreen,
                        text: 'Done',
                        fontSize: 18.sp,
                        padding: 5.h,
                        onPressed: () async {
                          Uint8List? signBytes = await controller.toPngBytes();
                          onComplete(signBytes);
                          Navigator.pop(context);
                        },
                      )
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
