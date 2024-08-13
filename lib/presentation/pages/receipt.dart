import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:ivorypay_test/core/extension/context.dart';
import 'package:ivorypay_test/core/extension/widget.dart';
import 'package:ivorypay_test/core/permission/handler.dart';
import 'package:ivorypay_test/presentation/notifier/notifier.dart';
import 'package:ivorypay_test/presentation/widgets/button.dart';
import 'package:ivorypay_test/presentation/widgets/notification.dart';

import 'sub/printers.dart';

class TransactionReceipt extends ConsumerStatefulWidget {
  const TransactionReceipt({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TransactionReceiptState();
}

class _TransactionReceiptState extends ConsumerState<TransactionReceipt> {
  @override
  Widget build(BuildContext context) {
    final notifier = ref.watch(notifierProvider);

    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox.square(),
        title: const Text('Transaction Receipt'),
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          StreamBuilder<bool>(
              stream: notifier.bluetoothStatus.stream,
              builder: (context, snapshot) {
                if (!(snapshot.data ?? false)) {
                  return Text(
                    'Bluetooth is turned off\n Please turn on',
                    style: context.textTheme.bodyMedium!.copyWith(
                      color: Colors.red,
                    ),
                    textAlign: TextAlign.center,
                  );
                }

                return CustomButton(
                  text: 'Print Receipt',
                  onTap: () async {
                    if (await PermissionRequester().requestPermissions()) {
                      const SearchPrinters().bottomSheet.then((_) {
                        notifier.stopScanning();
                      });
                    } else {
                      if (context.mounted) {
                        context.notify.addNotification(
                          const NotificationTile(
                            message: 'Something wrong with bluetooth',
                            isError: true,
                          ),
                        );
                      }
                    }
                  },
                );
              }),
          40.verticalSpace,
        ],
      ).padHorizontal,
      body: StreamBuilder<Map<String, dynamic>?>(
        stream: notifier.paymentInformation.stream,
        builder: (context, snapshot) {
          if (snapshot.data == null) return const SizedBox.shrink();

          final result = snapshot.data!['data'];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(16.sp),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(30.r),
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 150.w,
                      height: 150.h,
                      child: Image.network(
                        'https://cdni.iconscout.com/illustration/premium/thumb/man-holding-payment-receipt-6333591-5230151.png?f=webp',
                      ),
                    ),
                    16.horizontalSpace,
                    Expanded(
                      child: Text(
                        'Transaction successful.',
                        textAlign: TextAlign.start,
                        style: context.textTheme.displaySmall!.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      24.verticalSpace,
                      Text(
                        'Transaction Detail',
                        style: context.textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      24.verticalSpace,
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Name',
                                style: context.textTheme.bodyMedium!.copyWith(
                                  color: Colors.black45,
                                ),
                              ),
                              Text(
                                'Amount',
                                style: context.textTheme.bodyMedium!.copyWith(
                                  color: Colors.black45,
                                ),
                              )
                            ],
                          ),
                          16.verticalSpace,
                          for (var i in [
                            {'Macbook pro': '0.02'},
                            {'iWatch charger': '0.005'},
                            {'Samsung galaxy s4': '0.09'},
                          ]) ...{
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  i.entries.first.key,
                                  style: context.textTheme.bodyMedium!.copyWith(
                                    color: Colors.black45,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  i.entries.first.value,
                                  style: context.textTheme.bodyMedium!.copyWith(
                                    color: Colors.black45,
                                  ),
                                )
                              ],
                            ),
                          },
                          16.verticalSpace,
                          const Divider(),
                          16.verticalSpace,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total Price: ',
                                style: context.textTheme.bodyMedium!.copyWith(
                                  color: Colors.black45,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                result['expectedAmountWithFeeInCrypto']
                                    .toString(),
                                style: context.textTheme.bodyMedium!.copyWith(
                                  color: Colors.black45,
                                ),
                              )
                            ],
                          ),
                          8.verticalSpace,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Reference: ',
                                style: context.textTheme.bodyMedium!.copyWith(
                                  color: Colors.black45,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              8.horizontalSpace,
                              Expanded(
                                child: Text(
                                  result['reference'],
                                  textAlign: TextAlign.end,
                                  style: context.textTheme.bodyMedium!.copyWith(
                                    color: Colors.black45,
                                  ),
                                ),
                              )
                            ],
                          ),
                          8.verticalSpace,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Currency: ',
                                style: context.textTheme.bodyMedium!.copyWith(
                                  color: Colors.black45,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                result['crypto'],
                                style: context.textTheme.bodyMedium!.copyWith(
                                  color: Colors.black45,
                                ),
                              )
                            ],
                          ),
                          8.verticalSpace,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Date/Time: ',
                                style: context.textTheme.bodyMedium!.copyWith(
                                  color: Colors.black45,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                DateFormat.yMMMEd()
                                    .add_jm()
                                    .format(DateTime.now()),
                                style: context.textTheme.bodyMedium!.copyWith(
                                  color: Colors.black45,
                                ),
                              )
                            ],
                          ),
                          8.verticalSpace,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Payment method: ',
                                style: context.textTheme.bodyMedium!.copyWith(
                                  color: Colors.black45,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                'Crypto',
                                style: context.textTheme.bodyMedium!.copyWith(
                                  color: Colors.black45,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      100.verticalSpace,
                    ],
                  ),
                ),
              ),
            ],
          ).padHorizontal;
        },
      ),
    );
  }
}
