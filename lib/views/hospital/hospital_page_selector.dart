import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:top/constants.dart';
import 'package:top/views/availability.dart';
import 'package:top/views/home.dart';
import 'package:top/views/hospital/hospital_new_post.dart';
import 'package:top/views/my_shifts.dart';
import 'package:top/views/released_shifts.dart';
import 'package:top/views/timesheets.dart';

class HospitalPageSelector extends StatefulWidget {

  @override
  State<HospitalPageSelector> createState() => _HospitalPageSelectorState();
}

class _HospitalPageSelectorState extends State<HospitalPageSelector> {
  final PageController controller = PageController();
  int currentIndex = 0;

  @override
  void initState(){
    super.initState();
    if(mounted){
      controller.addListener(() {
        setState(() => currentIndex = controller.page!.toInt());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: controller,
        physics: NeverScrollableScrollPhysics(),
        children: [
          HospitalNewPost(),
          Availability(),
          MyShifts(),
          ReleasedShifts(),
        ],
      ),

      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: kGreen,
        unselectedItemColor: kDisabled,
        showUnselectedLabels: true,
        selectedLabelStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400),
        unselectedLabelStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400),
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        onTap: (index){
          controller.animateToPage(index, duration: Duration(milliseconds: 100), curve: Curves.easeInOut);
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.add_box), label: 'New Post'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Available'),
          BottomNavigationBarItem(icon: Icon(Icons.alarm), label: 'Confirmed'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment_turned_in), label: 'Completed'),
        ],
      ),
    );
  }
}
