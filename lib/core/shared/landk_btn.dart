import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../theme/theme.dart';

class LandkBtn extends StatelessWidget {
  const LandkBtn(
      {super.key,
      required this.onTap,
      required this.title,
      required this.width,
      required this.height});

  final VoidCallback onTap;
  final Widget title;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ButtonStyle(
        alignment: Alignment.center,
        minimumSize: MaterialStateProperty.all(
          Size(width.w, height.h),
        ),
        maximumSize: MaterialStateProperty.all(
          Size(width.w, height.h),
        ),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        backgroundColor: MaterialStateProperty.all(orange),
      ),
      child: title,
    );
  }
}
