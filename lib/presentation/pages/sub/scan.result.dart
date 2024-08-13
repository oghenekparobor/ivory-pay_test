import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:ivorypay_test/core/extension/context.dart';
import 'package:ivorypay_test/core/extension/widget.dart';
import 'package:ivorypay_test/presentation/notifier/notifier.dart';
import 'package:ivorypay_test/presentation/widgets/button.dart';
import 'package:ivorypay_test/presentation/widgets/notification.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart' as qr;

class ScanResults extends ConsumerWidget {
  const ScanResults({
    super.key,
    required this.qrCtrl,
  });

  final qr.QRViewController? qrCtrl;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(notifierProvider);

    return Align(
      alignment: Alignment.bottomCenter,
      child: StreamBuilder<Map<String, dynamic>?>(
        stream: notifier.paymentInformation.stream,
        builder: (context, snapshot) {
          if (snapshot.data == null) return const SizedBox.shrink();

          final result = snapshot.data!['data'];

          return ZoomIn(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.grey.withOpacity(.8),
                      ),
                    ),
                    8.horizontalSpace,
                    Text(
                      'Result',
                      style: context.textTheme.bodyLarge!.copyWith(
                        color: Colors.grey.withOpacity(.8),
                      ),
                    ),
                    8.horizontalSpace,
                    Expanded(
                      child: Divider(
                        color: Colors.grey.withOpacity(.8),
                      ),
                    ),
                  ],
                ),
                8.verticalSpace,
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(.0),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Wallet Adress',
                        style: context.textTheme.bodySmall!.copyWith(
                          color: Colors.white54,
                        ),
                      ),
                      6.verticalSpace,
                      Text(
                        result['address'],
                        style: context.textTheme.bodyLarge!.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      12.verticalSpace,
                      Text(
                        'Amount Payable',
                        style: context.textTheme.bodySmall!.copyWith(
                          color: Colors.white54,
                        ),
                      ),
                      6.verticalSpace,
                      Text(
                        '${result['expectedAmountWithFeeInCrypto']} ${result['crypto']}',
                        style: context.textTheme.bodyLarge!.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      8.verticalSpace,
                    ],
                  ),
                ),
                16.verticalSpace,
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        text: 'Scan again',
                        onTap: () {
                          qrCtrl?.resumeCamera();
                          notifier.paymentInformation.emit(null);
                        },
                        backgroundColor: Colors.white,
                        textColor: Colors.green,
                      ),
                    ),
                    16.horizontalSpace,
                    Expanded(
                      child: CustomButton(
                        text: 'Continue',
                        onTap: () {
                          context.push('/loading', extra: {
                            'description': 'charging ${result['email']}',
                            'action': () {
                              context.notify.addNotification(NotificationTile(
                                  message:
                                      'Successfully charge ${result['email']} ${result['expectedAmountWithFeeInCrypto']} ${result['crypto']}'));
                            },
                          });
                        },
                      ),
                    ),
                  ],
                ),
                40.verticalSpace,
              ],
            ).padHorizontal,
          );
        },
      ),
    );
  }
}
