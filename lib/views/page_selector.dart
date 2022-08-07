import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:top/constants.dart';
import 'package:top/views/availability.dart';
import 'package:top/views/home.dart';

class PageSelector extends StatefulWidget {

  @override
  State<PageSelector> createState() => _PageSelectorState();
}

class _PageSelectorState extends State<PageSelector> {
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
          Home(),
          Availability(),
          Container(width: double.infinity, height: double.infinity,color: Colors.blue,),
          Container(width: double.infinity, height: double.infinity,color: Colors.amber,),
          Container(width: double.infinity, height: double.infinity,color: Colors.purple,),
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
