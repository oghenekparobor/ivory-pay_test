import 'package:animate_do/animate_do.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ivorypay_test/core/extension/context.dart';
import 'package:ivorypay_test/core/extension/widget.dart';
import 'package:ivorypay_test/presentation/notifier/notifier.dart';
import 'package:ivorypay_test/presentation/widgets/button.dart';
import 'package:ivorypay_test/presentation/widgets/notification.dart';

class SearchPrinters extends ConsumerStatefulWidget {
  const SearchPrinters({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchPrintersState();
}

class _SearchPrintersState extends ConsumerState<SearchPrinters> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Durations.extralong4, () {
        final notifier = ref.watch(notifierProvider);

        notifier.scanForPrinter();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.watch(notifierProvider);

    return StreamBuilder<List<BluetoothDevice>>(
      stream: notifier.printers.stream,
      builder: (context, snapshot) {
        if (snapshot.data == null) return const SizedBox.shrink();

        final devices = snapshot.data!;

        return StreamBuilder<BluetoothDevice?>(
          stream: notifier.selectedPrinter.stream,
          builder: (context, snapshot) {
            final selectedPrinter = snapshot.data;

            return StreamBuilder<bool>(
              stream: notifier.printerConnectionStatus.stream,
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return const SizedBox.shrink();
                }

                final connectStatus = snapshot.data!;

                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    24.verticalSpace,
                    for (var device in devices) ...{
                      ListTile(
                        onTap: () {
                          notifier.selectedPrinter.emit(device);
                          notifier.connectToPrinter(device);
                        },
                        title: Text(device.name ?? ''),
                        trailing: (selectedPrinter != null &&
                                selectedPrinter.address == device.address &&
                                connectStatus)
                            ? Container(
                                width: 20.w,
                                height: 20.h,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.green,
                                ),
                              )
                            : null,
                      ),
                    },
                    16.verticalSpace,
                    StreamBuilder<bool>(
                        stream: notifier.printerConnectionStatus.stream,
                        builder: (context, snapshot) {
                          if (!(snapshot.data ?? false)) {
                            return const SizedBox.shrink();
                          }

                          return SlideInUp(
                            child: CustomButton(
                              text: 'Print',
                              onTap: () {
                                notifier.printTransactionReceipt().then((res) {
                                  if (context.mounted) {
                                    context.notify.addNotification(
                                      const NotificationTile(
                                        message: 'Receipt printed',
                                      ),
                                    );
                                  }
                                });
                              },
                            ),
                          );
                        }),
                    40.verticalSpace,
                  ],
                ).padHorizontal;
              },
            );
          },
        );
      },
    );
  }
}
