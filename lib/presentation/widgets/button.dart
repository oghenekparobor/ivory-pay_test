import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ivorypay_test/core/extension/context.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.text,
    this.backgroundColor,
    this.textColor,
    this.onTap,
  });

  final VoidCallback? onTap;
  final Color? textColor, backgroundColor;
  final String text;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.sp),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          color: backgroundColor ?? Colors.green,
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: context.textTheme.bodyLarge!.copyWith(
            fontWeight: FontWeight.bold,
            color: textColor ?? Colors.white,
          ),
        ),
      ),
    );
  }
}
