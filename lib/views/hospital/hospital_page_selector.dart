import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:top/constants.dart';
import 'package:top/controllers/user_controller.dart';
import 'package:top/models/user_model.dart';
import 'package:top/views/hospital/hospital_all_jobs.dart';
import 'package:top/views/hospital/hospital_jobs.dart';
import 'package:top/views/hospital/hospital_new_post.dart';

class HospitalPageSelector extends StatefulWidget {
  @override
  State<HospitalPageSelector> createState() => _HospitalPageSelectorState();
}

class _HospitalPageSelectorState extends State<HospitalPageSelector> {
  final PageController controller = PageController();
  int tabIndex = 0;
  User? user;

  getDetails() async {
    user = await Provider.of<UserController>(context, listen: false).getCurrentUser();
    setState((){});
  }

  @override
  void initState() {
    super.initState();
    getDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: controller,
        physics: NeverScrollableScrollPhysics(),
        children: [
          HospitalNewPost(user: user),
          HospitalAllJobs(user: user),
          HospitalJobs(
            status: tabIndex == 2
                ? JobStatus.Available
                : tabIndex == 3
                ? JobStatus.Confirmed
                : tabIndex == 4
                ? JobStatus.Completed
                : JobStatus.Available,
            manager: user,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: kGreen,
        unselectedItemColor: kDisabled,
        showUnselectedLabels: true,
        selectedLabelStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400),
        unselectedLabelStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400),
        type: BottomNavigationBarType.fixed,
        currentIndex: tabIndex,
        onTap: (index) {
          setState(() {
            tabIndex = index;
          });
          if(tabIndex == 0 || tabIndex == 1){
            controller.animateToPage(
              tabIndex,
              duration: Duration(milliseconds: 100),
              curve: Curves.easeInOut,
            );
          } else {
            controller.animateToPage(
              2,
              duration: Duration(milliseconds: 100),
              curve: Curves.easeInOut,
            );
          }
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.add_box), label: 'New Post'),
          BottomNavigationBarItem(icon: Icon(Icons.work), label: 'All Jobs'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Available'),
          BottomNavigationBarItem(icon: Icon(Icons.alarm), label: 'Confirmed'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment_turned_in), label: 'Completed'),
        ],
      ),
    );
  }
}
