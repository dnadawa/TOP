import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:top/constants.dart';
import 'package:top/widgets/backdrop.dart';
import 'package:top/widgets/input_filed.dart';
import 'package:top/widgets/button.dart';
import 'package:top/widgets/toast.dart';

class SignUp extends StatelessWidget {
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();

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
                SizedBox(height: 55.h),

                //heading
                Text(
                  "Signup to TOP",
                  style: GoogleFonts.sourceSansPro(
                    fontWeight: FontWeight.w600,
                    fontSize: 35.sp,
                  ),
                ),
                SizedBox(height: 35.h),

                //role
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: kDisabled)
                  ),
                  child: DropdownButton(
                      underline: SizedBox.shrink(),
                      isExpanded: true,
                      hint: Text("Select your role", style: TextStyle(color: kDisabled),),
                      value: '2',
                      items: [
                        DropdownMenuItem(value: '1',child: Text("Website Tasks", style: TextStyle(color: kDisabled)),),
                        DropdownMenuItem(value: '2',child: Text("Manual Tasks", style: TextStyle(color: kDisabled)),),
                      ],
                      onChanged: (value){}
                  ),
                ),
                SizedBox(height: 10.h),

                //speciality
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 15.w),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: kDisabled)
                  ),
                  child: DropdownButton(
                      underline: SizedBox.shrink(),
                      isExpanded: true,
                      hint: Text("Select your speciality", style: TextStyle(color: kDisabled),),
                      value: '1',
                      items: [
                        DropdownMenuItem(value: '1',child: Text("Website Tasks", style: TextStyle(color: kDisabled)),),
                        DropdownMenuItem(value: '2',child: Text("Manual Tasks", style: TextStyle(color: kDisabled)),),
                      ],
                      onChanged: (value){}
                  ),
                ),
                SizedBox(height: 10.h),


                //text fields
                InputFiled(
                  text: 'Name',
                  controller: name,
                ),
                SizedBox(height: 10.h),
                InputFiled(
                  text: 'Email',
                  controller: email,
                ),
                SizedBox(height: 10.h),
                InputFiled(
                  text: 'Password',
                  controller: password,
                  isPassword: true,
                ),
                SizedBox(height: 10.h),
                InputFiled(
                  text: 'Confirm Password',
                  controller: confirmPassword,
                  isPassword: true,
                ),
                SizedBox(height: 50.h),

                //buttons
                SizedBox(
                  width: double.infinity,
                  child: Button(
                    text: 'Signup',
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
