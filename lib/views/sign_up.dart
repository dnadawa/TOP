import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:top/constants.dart';
import 'package:top/views/hospital/hospital_page_selector.dart';
import 'package:top/views/page_selector.dart';
import 'package:top/widgets/backdrop.dart';
import 'package:top/widgets/input_filed.dart';
import 'package:top/widgets/button.dart';
import 'package:top/widgets/toast.dart';
import 'package:top/controllers/user_controller.dart';

import '../widgets/chip_field.dart';

class SignUp extends StatefulWidget {
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController name = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();

  Role selectedRole = Role.Nurse;
  List selectedSpecialities = [];
  String? selectedHospital;
  List hospitals = [];

  setDropDownData() async {
    hospitals = await Provider.of<UserController>(context, listen: false).getHospitals();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    setDropDownData();
  }

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
                RichText(
                  text: TextSpan(
                      text: 'Signup to',
                      style: GoogleFonts.sourceSansPro(
                        fontWeight: FontWeight.w700,
                        fontSize: 35.sp,
                        color: Colors.black,
                      ),
                      children: [
                        TextSpan(
                          text: ' TOP',
                          style: TextStyle(
                            color: kGreen,
                          ),
                        )
                      ]),
                ),
                Text(
                  "Theatre Operation Professional",
                  style: GoogleFonts.sourceSansPro(
                    fontWeight: FontWeight.w600,
                    fontSize: 23.sp,
                    color: kGreen,
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
                      border: Border.all(color: kDisabled)),
                  child: DropdownButton(
                      underline: SizedBox.shrink(),
                      isExpanded: true,
                      hint: Text(
                        "Select your role",
                        style: TextStyle(color: kDisabled),
                      ),
                      value: selectedRole,
                      items: Role.values
                          .map(
                            (role) => DropdownMenuItem(
                              value: role,
                              child: Text(role.name),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() => selectedRole = value as Role);
                      }),
                ),
                SizedBox(height: 10.h),

                //speciality
                ChipField(
                  text: 'Specialities',
                  items: specialities,
                  initialItems: [],
                  onChanged: (value) {
                    selectedSpecialities = value;
                  },
                ),
                SizedBox(height: 10.h),

                //hospitals
                if (selectedRole == Role.Manager)
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: 15.w),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(color: kDisabled)),
                    child: DropdownButton(
                      underline: SizedBox.shrink(),
                      isExpanded: true,
                      hint: Text(
                        "Hospital",
                        style: TextStyle(color: kDisabled),
                      ),
                      value: selectedHospital,
                      items: hospitals
                          .map((hospital) =>
                              DropdownMenuItem(value: hospital.id, child: Text(hospital['name'])))
                          .toList(),
                      onChanged: (value) {
                        setState(() => selectedHospital = value as String?);
                      },
                    ),
                  ),
                if (selectedRole == Role.Manager) SizedBox(height: 10.h),

                //text fields
                InputField(
                  text: 'Name',
                  controller: name,
                ),
                SizedBox(height: 10.h),
                InputField(
                  text: 'Email',
                  controller: email,
                  keyboard: TextInputType.emailAddress,
                ),
                SizedBox(height: 10.h),

                InputField(
                  text: 'Password',
                  controller: password,
                  isPassword: true,
                ),
                SizedBox(height: 10.h),
                InputField(
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
                      if (name.text.trim().isEmpty ||
                          email.text.trim().isEmpty ||
                          password.text.trim().isEmpty ||
                          confirmPassword.text.trim().isEmpty ||
                          selectedSpecialities.isEmpty ||
                          (selectedRole == Role.Manager && selectedHospital == null)) {
                        ToastBar(text: 'Please fill all the fields!', color: Colors.red).show();
                      } else if (password.text != confirmPassword.text) {
                        ToastBar(text: 'Password does not match', color: Colors.red).show();
                      } else {
                        ToastBar(text: 'Please wait...', color: Colors.orange).show();

                        bool isUserSignedUp =
                            await Provider.of<UserController>(context, listen: false).signUp(
                          email.text.trim(),
                          password.text.trim(),
                          name.text.trim(),
                          selectedRole,
                          selectedSpecialities,
                          hospitalID: selectedHospital,
                        );

                        if (isUserSignedUp) {
                          Navigator.pop(context);
                        }
                      }
                    },
                  ),
                ),
                SizedBox(height: 30.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
