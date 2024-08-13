import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:ivorypay_test/core/extension/context.dart';

class Loader extends ConsumerStatefulWidget {
  const Loader({
    super.key,
    this.extra,
  });

  final Map<String, dynamic>? extra;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoaderState();
}

class _LoaderState extends ConsumerState<Loader> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      (widget.extra?['action'] as VoidCallback).call();

      if (mounted) context.push('/receipt');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              strokeWidth: 5.w,
              backgroundColor: Colors.white,
              color: Colors.green,
            ),
            16.verticalSpace,
            Text(
              'Please wait!',
              style: context.textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            4.verticalSpace,
            Text(
              widget.extra?['description'] ?? '',
              style: context.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
