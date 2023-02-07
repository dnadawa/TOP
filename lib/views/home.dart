import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:top/controllers/job_controller.dart';
import 'package:top/views/all_jobs.dart';
import 'package:top/widgets/backdrop.dart';
import 'package:top/constants.dart';
import 'package:top/widgets/heading_card.dart';
import 'package:top/widgets/input_filed.dart';
import 'package:top/models/user_model.dart';
import 'package:top/controllers/user_controller.dart';
import 'package:top/widgets/button.dart';
import 'package:top/widgets/toast.dart';
import 'package:top/wrapper.dart';

class Home extends StatelessWidget {
  final User? user;

  Home({super.key, required this.user});

  final TextEditingController speciality = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController phone = TextEditingController();

  @override
  Widget build(BuildContext context) {
    speciality.text = user?.specialities!.join(', ') ?? '';
    email.text = user?.email ?? '';
    phone.text = user?.phone ?? '';

    return Scaffold(
      body: Backdrop(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(30.h, 10.h, 30.h, 30.h),
            child: Column(
              children: [
                SizedBox(height: ScreenUtil().statusBarHeight),

                //notice
                if (user != null)
                  FutureBuilder<List>(
                    future: Provider.of<JobController>(context).getAllNotifications(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting ||
                          !snapshot.hasData ||
                          snapshot.data!.isEmpty) {
                        return SizedBox(height: 10.h);
                      }

                      return Padding(
                        padding: EdgeInsets.only(bottom: 25.h),
                        child: Card(
                          color: Color(0xffFFF9C4),
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                            child: Row(
                              children: [
                                Icon(Icons.info, color: Colors.black, size: 25.sp),
                                SizedBox(width: 15.w),
                                Expanded(
                                  child: Text(
                                    snapshot.data![0]['text'],
                                    style: TextStyle(
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                //name
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello,',
                            style: GoogleFonts.sourceSansPro(
                              color: kRed,
                              fontSize: 25.sp,
                            ),
                          ),
                          Text(
                            user?.name ?? '',
                            style: TextStyle(
                                color: kGreyText, fontSize: 28.sp, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 20.w),
                    Image.asset(
                      'assets/nurse.png',
                      height: 135.h,
                    ),
                  ],
                ),
                SizedBox(height: 30.h),

                //details
                HeadingCard(
                  title: 'My Personal Details',
                  child: Padding(
                    padding: EdgeInsets.all(20.w),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.w),
                          child: InputField(
                            text: 'Email',
                            enabled: false,
                            controller: email,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.w),
                          child: InputField(
                            text: 'Speciality',
                            enabled: false,
                            multiLine: true,
                            controller: speciality,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.w),
                          child: InputField(
                            text: 'Mobile Number',
                            enabled: false,
                            controller: phone,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 30.h),

                SizedBox(
                  width: double.infinity,
                  child: Button(
                    text: 'Delete Profile',
                    color: kRed,
                    onPressed: () {
                      TextEditingController email = TextEditingController();
                      TextEditingController password = TextEditingController();

                      email.text = user?.email ?? '';

                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("Please re-authenticate to delete your account"),
                              SizedBox(height: 50.h),
                              InputField(text: "Email", controller: email, enabled: false),
                              SizedBox(height: 20.h),
                              InputField(
                                text: "Password",
                                isPassword: true,
                                controller: password,
                              ),
                              SizedBox(height: 40.h),
                              SizedBox(
                                width: double.infinity,
                                child: Button(
                                  text: 'Delete',
                                  color: kRed,
                                  onPressed: () async {
                                    if (email.text.trim().isEmpty || password.text.trim().isEmpty) {
                                      ToastBar(
                                              text: 'Please fill relevant fields!',
                                              color: Colors.red)
                                          .show();
                                    } else {
                                      ToastBar(
                                          text: 'Please wait...',
                                          color: Colors.orange)
                                          .show();
                                      await Provider.of<UserController>(context, listen: false)
                                          .deleteUser(
                                              context, email.text, password.text, user!.uid);
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20.h),

                //log out
                SizedBox(
                  width: double.infinity,
                  child: Button(
                    text: 'Logout',
                    color: kRed,
                    onPressed: () async {
                      ToastBar(text: 'Please wait...', color: Colors.orange).show();
                      bool signedOut =
                          await Provider.of<UserController>(context, listen: false).signOut();
                      if (signedOut) {
                        Navigator.of(context).pushAndRemoveUntil(
                            CupertinoPageRoute(builder: (context) => Wrapper()),
                            (Route<dynamic> route) => false);
                        ToastBar(text: 'Logged out!', color: Colors.green).show();
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
