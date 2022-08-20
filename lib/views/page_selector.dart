import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:top/constants.dart';
import 'package:top/views/availability.dart';
import 'package:top/views/home.dart';
import 'package:top/views/my_shifts.dart';
import 'package:top/views/released_shifts.dart';
import 'package:top/views/timesheets.dart';

import '../controllers/user_controller.dart';
import '../models/user_model.dart';

class PageSelector extends StatefulWidget {

  @override
  State<PageSelector> createState() => _PageSelectorState();
}

class _PageSelectorState extends State<PageSelector> {
  final PageController controller = PageController();
  int currentIndex = 0;
  User? user;

  getDetails() async {
    user = await Provider.of<UserController>(context, listen: false).getCurrentUser();
    setState((){});
  }

  @override
  void initState(){
    super.initState();
    getDetails();
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
          Home(user: user),
          Availability(user: user),
          MyShifts(user: user),
          ReleasedShifts(),
          TimeSheets(),
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
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.event_available), label: 'Availability'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'My Shifts'),
          BottomNavigationBarItem(icon: Icon(Icons.work), label: 'Released'),
          BottomNavigationBarItem(icon: Icon(Icons.pending_actions), label: 'Time Sheet'),
        ],
      ),
    );
  }
}
