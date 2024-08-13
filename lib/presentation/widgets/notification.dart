import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ivorypay_test/core/extension/context.dart';

class NotificationTile extends StatelessWidget {
  const NotificationTile({
    super.key,
    required this.message,
    this.icon,
    this.isError = false,
    this.onError,
  });

  final String? icon;
  final String message;
  final bool isError;
  final VoidCallback? onError;

  @override
  Widget build(BuildContext context) {
    return SlideInDown(
      child: Dismissible(
        key: ValueKey(DateTime.now().millisecond.toString()),
        direction: DismissDirection.up,
        onDismissed: (direction) {
          if (direction == DismissDirection.up) {
            context.notify.removeNotification();
          }
        },
        child: Container(
          margin: EdgeInsets.only(
            left: 16.w,
            right: 16.w,
            top: context.mediaQuery.padding.top * 1.5,
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          decoration: BoxDecoration(
            color: isError ? Colors.red.shade100 : const Color(0xFFEBFFF6),
            borderRadius: BorderRadius.circular(8.r),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                spreadRadius: .3,
                blurRadius: 30,
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: Text(
                    message,
                    style: context.textTheme.bodySmall!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              12.verticalSpace,
              GestureDetector(
                onTap: () {
                  context.notify.removeNotification();

                  if (isError) onError?.call();
                },
                child: Material(
                  color: Colors.transparent,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isError ? Icons.refresh : Icons.close,
                        color: isError ? Colors.red : Colors.black,
                        size: 16.sp,
                      ),
                      4.horizontalSpace,
                      Text(
                        isError ? 'Retry' : 'Dismiss',
                        style: context.textTheme.bodyMedium!.copyWith(
                          color: isError ? Colors.red : null,
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
