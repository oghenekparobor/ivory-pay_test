import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ivorypay_test/core/extension/context.dart';
import 'package:ivorypay_test/presentation/notifier/notifier.dart';
import 'package:ivorypay_test/presentation/widgets/notification.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart' as qr;

import 'sub/scan.result.dart';

class ScannerPage extends ConsumerStatefulWidget {
  const ScannerPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ScannerPageState();
}

class _ScannerPageState extends ConsumerState<ScannerPage> {
  final GlobalKey background = GlobalKey(debugLabel: 'Background');
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  qr.Barcode? result;
  qr.QRViewController? qrCtrl;

  @override
  void initState() {
    // PermissionRequester().requestPermissions();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.watch(notifierProvider);

    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            width: context.mediaQuery.size.width,
            height: context.mediaQuery.size.height,
            child: StreamBuilder<Map<String, dynamic>?>(
              stream: notifier.paymentInformation.stream,
              builder: (context, snapshot) {
                final color =
                    snapshot.data == null ? Colors.black : Colors.green;
                return qr.QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                  overlay: qr.QrScannerOverlayShape(
                    borderColor: color,
                    borderWidth: 30.w,
                    borderLength: 40.w,
                    cutOutSize: 300.w,
                    borderRadius: 30.r,
                    overlayColor: Colors.black87,
                  ),
                  formatsAllowed: const [
                    // only QRCode is allowed here
                    qr.BarcodeFormat.qrcode,
                  ],
                );
              },
            ),
          ),
          ScanResults(qrCtrl: qrCtrl),
        ],
      ),
    );
  }

  void _onQRViewCreated(qr.QRViewController controller) {
    final notifier = ref.watch(notifierProvider);

    qrCtrl = controller;

    controller.scannedDataStream.listen((scanData) async {
      notifier.formatScanData(scanData.code, qrCtrl).then((res) {
        if (!res) {
          Future.delayed(Durations.medium1, () {
            if (mounted) {
              context.notify.addNotification(
                const NotificationTile(
                  message: 'Invalid Qrcode',
                  isError: true,
                ),
              );
            }

            controller.resumeCamera();
          });
        }
      });

      qrCtrl?.pauseCamera();
    });
  }
}
