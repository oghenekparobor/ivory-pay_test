import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ivorypay_test/core/routes/route.dart';

extension WidgetExtension on Widget {
  Padding get padHorizontal => Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: this,
      );

  Future<dynamic> get bottomSheet {
    return showModalBottomSheet<dynamic>(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.r),
          topRight: Radius.circular(25.r),
        ),
      ),
      enableDrag: true,
      isScrollControlled: true,
      context: navkey.currentContext!,
      builder: (_) => ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.r),
          topRight: Radius.circular(25.r),
        ),
        child: SizedBox(
          width: double.infinity,
          child: this,
        ),
      ),
    );
  }
}
