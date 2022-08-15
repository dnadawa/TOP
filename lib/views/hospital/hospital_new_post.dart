import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:top/controllers/user_controller.dart';
import 'package:top/views/hospital/hospital_create_post.dart';
import 'package:top/widgets/backdrop.dart';
import 'package:top/constants.dart';
import 'package:top/widgets/button.dart';
import 'package:top/widgets/heading_card.dart';
import 'package:top/widgets/input_filed.dart';
import 'package:top/models/user_model.dart';
import 'package:top/widgets/toast.dart';
import 'package:top/wrapper.dart';

class HospitalNewPost extends StatelessWidget {
  final User? user;

  HospitalNewPost({super.key, required this.user});

  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController hospital = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var userController = Provider.of<UserController>(context);

    name.text = user?.name ?? '';
    email.text = user?.email ?? '';

    return Scaffold(
      body: Backdrop(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(30.h),
            child: Column(
              children: [
                SizedBox(height: ScreenUtil().statusBarHeight),

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
                      'assets/hospital.png',
                      height: 80.h,
                    ),
                  ],
                ),
                SizedBox(height: 75.h),

                //details
                HeadingCard(
                  title: 'Manager Details',
                  child: Padding(
                    padding: EdgeInsets.all(20.w),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.w),
                          child: InputField(
                            text: 'Name',
                            enabled: false,
                            controller: name,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.w),
                          child: InputField(
                            text: 'Email',
                            enabled: false,
                            controller: email,
                          ),
                        ),
                        FutureBuilder<String>(
                          future: userController.getHospitalNameFromID(user == null ? '' : user!.hospital!),
                          builder: (context, snapshot){
                            hospital.text = snapshot.data ?? 'Loading...';

                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 20.w),
                              child: InputField(
                                text: 'Hospital',
                                enabled: false,
                                controller: hospital,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 40.h),
                SizedBox(
                  width: double.infinity,
                  child: Button(
                    text: 'Post a New Job',
                    onPressed: () {
                      if (user != null && hospital.text != "Loading...") {
                        Navigator.push(
                            context, CupertinoPageRoute(builder: (_) => HospitalCreatePost(manager: user!, hospitalName: hospital.text,)));
                      }
                    },
                  ),
                ),

                //log out
                SizedBox(height: 20.h),
                SizedBox(
                  width: double.infinity,
                  child: Button(
                    text: 'Logout',
                    color: kRed,
                    onPressed: () async {
                      ToastBar(text: 'Please wait...', color: Colors.orange).show();
                      bool signedOut = await Provider.of<UserController>(context, listen: false).signOut();
                      if (signedOut){
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
