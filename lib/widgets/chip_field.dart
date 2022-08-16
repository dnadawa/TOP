import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChipField extends StatefulWidget {
  final String text;
  final List<String> items;
  final Function onChanged;
  final List<String> initialItems;

  const ChipField({
    super.key,
    required this.text,
    required this.items,
    required this.onChanged,
    required this.initialItems,
  });

  @override
  _ChipFieldState createState() => _ChipFieldState();
}

class _ChipFieldState extends State<ChipField> {
  List<Widget> items = [];
  List<String> selectedItems = [];

  buildItems() {
    items.clear();

    for (var element in widget.items) {
      items.add(GestureDetector(
        onTap: () {
          if (selectedItems.contains(element)) {
            selectedItems.remove(element);
          } else {
            selectedItems.add(element);
          }

          widget.onChanged(selectedItems);
          buildItems();
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.green,
              width: 2,
            ),
            color: selectedItems.contains(element) ? Colors.green : Colors.white,
            borderRadius: BorderRadius.circular(5.r),
          ),
          margin: EdgeInsets.symmetric(
            vertical: 5.h,
            horizontal: 3.w,
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 6.h,
              horizontal: 15.w,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (selectedItems.contains(element))
                  Padding(
                    padding: EdgeInsets.only(right: 5.w),
                    child: Icon(
                      Icons.check_circle_outline,
                      color: Colors.white,
                      size: 20.sp,
                    ),
                  ),
                Text(
                  element,
                  style: TextStyle(
                    color: selectedItems.contains(element) ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ));
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    selectedItems = widget.initialItems;
    buildItems();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //header
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(10.r),
            ),
            color: Colors.green,
          ),
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.all(10.h),
            child: Text(
              widget.text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        //bottom
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(10.r),
            ),
            border: Border.all(
              color: Colors.green,
              width: 2,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(8.w),
            child: Wrap(
              children: items,
            ),
          ),
        ),
      ],
    );
  }
}
