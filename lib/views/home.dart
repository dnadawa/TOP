import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:top/widgets/backdrop.dart';
import 'package:top/constants.dart';
import 'package:top/widgets/heading_card.dart';
import 'package:top/widgets/input_filed.dart';
import 'package:top/models/user_model.dart';

import '../controllers/user_controller.dart';
import '../widgets/button.dart';
import '../widgets/toast.dart';
import '../wrapper.dart';

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

                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    child: Icon(Icons.exit_to_app),
                    onTap: (){},
                  ),
                ),
                SizedBox(height: 10.h),


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
                SizedBox(height: 20.h),

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
                SizedBox(height: 20.h),

                //notifications
                HeadingCard(
                  title: 'Notifications',
                  child: Padding(
                    padding: EdgeInsets.all(20.w),
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: 5,
                      itemBuilder: (context, i) => Text(i.toString()),
                    ),
                  ),
                ),

                //log out
                SizedBox(height: 30.h),
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
