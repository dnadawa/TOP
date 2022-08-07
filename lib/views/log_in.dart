import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:top/constants.dart';
import 'package:top/widgets/backdrop.dart';
import 'package:top/widgets/input_filed.dart';
import 'package:top/widgets/button.dart';
import 'package:top/widgets/toast.dart';

class LogIn extends StatelessWidget {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Backdrop(
        child: Padding(
          padding: EdgeInsets.fromLTRB(40.w, 30.h, 40.w, 0.h),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: ScreenUtil().statusBarHeight + 40.h),

                //logo
                Center(
                  child: Container(
                    width: 150.w,
                    height: 150.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.r),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade700,
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    padding: EdgeInsets.all(20.w),
                    child: Image.asset('assets/logo.png'),
                  ),
                ),
                SizedBox(height: 75.h),

                //heading
                Text(
                  "Login to TOP",
                  style: GoogleFonts.sourceSansPro(
                    fontWeight: FontWeight.w600,
                    fontSize: 35.sp,
                  ),
                ),
                SizedBox(height: 35.h),


                //text fields
                InputField(
                  text: 'Email',
                  controller: email,
                ),
                SizedBox(height: 10.h),
                InputField(
                  text: 'Password',
                  controller: password,
                  isPassword: true,
                ),


                //forget password
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(25.w,25.h,0,40.h),
                    child: GestureDetector(
                      onTap: () async {
                        if (email.text.trim().isEmpty) {
                          ToastBar(text: 'Please fill email!', color: Colors.red).show();
                        } else {
                          ToastBar(text: 'Please wait...', color: Colors.orange).show();

                          // bool success =
                          // await Provider.of<UserController>(context, listen: false)
                              // .forgetPassword(email.text.trim());
                          // if (success) {
                          //   ToastBar(
                          //       text: 'Password reset link sent to your email! Check your inbox or spam folders.',
                          //       color: Colors.green)
                          //       .show();
                          // }
                        }
                      },
                      child: Text(
                        'Forgot Password ?',
                        style:
                        TextStyle(color: kGreen, fontSize: 18.sp, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),

                //buttons
                SizedBox(
                  width: double.infinity,
                  child: Button(
                    text: 'Login',
                    color: kRed,
                    onPressed: () async {
                      if (email.text.trim().isEmpty || password.text.trim().isEmpty) {
                        ToastBar(text: 'Please fill all the fields!', color: Colors.red)
                            .show();
                      } else {
                        ToastBar(text: 'Please wait...', color: Colors.orange).show();

                        // bool isUserLoggedIn =
                        // await Provider.of<UserController>(context, listen: false)
                        //     .signIn(email.text.trim(), password.text.trim());
                        // if (isUserLoggedIn) {
                        //   Navigator.pushAndRemoveUntil(
                        //       context,
                        //       CupertinoPageRoute(builder: (context) => Home()),
                        //           (Route<dynamic> route) => false);
                        // }
                      }
                    },
                  ),
                ),

                //or
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 40.h),
                  child: Center(
                    child: Text(
                      "OR",
                      style: TextStyle(
                        fontSize: 20.sp,
                        color: kDisabled
                      ),
                    ),
                  ),
                ),

                //buttons
                SizedBox(
                  width: double.infinity,
                  child: Button(
                    text: 'Signup',
                    color: kGreen,
                    onPressed: () async {
                      if (email.text.trim().isEmpty || password.text.trim().isEmpty) {
                        ToastBar(text: 'Please fill all the fields!', color: Colors.red)
                            .show();
                      } else {
                        ToastBar(text: 'Please wait...', color: Colors.orange).show();

                        // bool isUserLoggedIn =
                        // await Provider.of<UserController>(context, listen: false)
                        //     .signIn(email.text.trim(), password.text.trim());
                        // if (isUserLoggedIn) {
                        //   Navigator.pushAndRemoveUntil(
                        //       context,
                        //       CupertinoPageRoute(builder: (context) => Home()),
                        //           (Route<dynamic> route) => false);
                        // }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
