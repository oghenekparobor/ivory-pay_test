import 'dart:convert';

import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart' as bluetooth;
import 'package:intl/intl.dart';
import 'package:ivorypay_test/core/permission/handler.dart';
import 'package:ivorypay_test/core/storage/generic.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notifier.g.dart';

@riverpod
class Notifier extends _$Notifier with ChangeNotifier {
  @override
  Notifier build() {
    PermissionRequester().requestPermissions();

    bluetoothPrint = BluetoothPrint.instance;

    checkBluetoothStatus();

    // Initialization logic if needed
    return this;
  }

  late BluetoothPrint bluetoothPrint;

  var paymentInformation = GenericStore<Map<String, dynamic>?>(null);

  Future<bool> formatScanData(String data, [QRViewController? qrCtrl]) async {
    var information = jsonDecode(jsonDecode(data));

    if (information is Map) {
      if (information['data'].containsKey('address')) {
        paymentInformation.emit(information as Map<String, dynamic>);

        return true;
      }

      paymentInformation.emit(null);

      return false;
    }

    paymentInformation.emit(null);

    return false;
  }

  var printers = GenericStore<List<BluetoothDevice>>([]);
  var selectedPrinter = GenericStore<BluetoothDevice?>(null);
  var printerConnectionStatus = GenericStore<bool>(false);
  var bluetoothStatus = GenericStore<bool>(false);

  void checkBluetoothStatus() async {
    bluetooth.FlutterBluePlus.adapterState.listen((data) {
      if (data == bluetooth.BluetoothAdapterState.on) {
        bluetoothStatus.emit(true);
      }

      if (data == bluetooth.BluetoothAdapterState.off) {
        bluetoothStatus.emit(false);
      }
    });
  }

  void scanForPrinter() {
    try {
      bluetoothPrint
          .scan(timeout: const Duration(seconds: 30))
          .listen((device) {
        printers.value.add(device);
        printers.refresh();
      });

      bluetoothPrint.state.listen((i) {
        if (i == BluetoothPrint.CONNECTED) {
          printerConnectionStatus.emit(true);
        } else {
          printerConnectionStatus.emit(false);
        }
      });
    } catch (e) {}
  }

  void rescanForPrinter() {
    bluetoothPrint.scan(timeout: const Duration(seconds: 5)).listen((device) {
      printers.value.add(device);
      printers.refresh();
    });
  }

  void stopScanning() {
    printerConnectionStatus.emit(false);
    bluetoothPrint.stopScan();
  }

  void connectToPrinter(BluetoothDevice device) async {
    if (printerConnectionStatus.value) {
      await bluetoothPrint.disconnect();
    } else {
      await bluetoothPrint.connect(device);
    }
  }

  // Prints the content of the transaction reciept via Terminal printer
  Future<dynamic> printTransactionReceipt() async {
    BluetoothPrint bluetoothPrint = BluetoothPrint.instance;

    // Define your receipt data
    List<LineText> receiptData = [
      LineText(
        type: LineText.TYPE_TEXT,
        content: 'Transaction Detail',
        weight: 2,
        align: LineText.ALIGN_CENTER,
        linefeed: 1,
      ),
      LineText(
        type: LineText.TYPE_TEXT,
        content: '--------------------------------',
        weight: 1,
        align: LineText.ALIGN_CENTER,
        linefeed: 1,
      ),
      LineText(
        type: LineText.TYPE_TEXT,
        content: 'Name     Amount',
        weight: 1,
        align: LineText.ALIGN_LEFT,
        linefeed: 1,
      ),
      LineText(
        type: LineText.TYPE_TEXT,
        content: 'Macbook pro     0.02',
        weight: 1,
        align: LineText.ALIGN_LEFT,
        linefeed: 1,
      ),
      // Add more lines as needed
      LineText(
        type: LineText.TYPE_TEXT,
        content: '--------------------------------',
        weight: 1,
        align: LineText.ALIGN_CENTER,
        linefeed: 1,
      ),
      LineText(
        type: LineText.TYPE_TEXT,
        content:
            'Total Price: ${paymentInformation.value?['expectedAmountWithFeeInCrypto']}',
        weight: 1,
        align: LineText.ALIGN_RIGHT,
        linefeed: 1,
      ),
      LineText(
        type: LineText.TYPE_TEXT,
        content: 'Reference: ${paymentInformation.value?['reference']}',
        weight: 1,
        align: LineText.ALIGN_RIGHT,
        linefeed: 1,
      ),
      LineText(
        type: LineText.TYPE_TEXT,
        content: 'Currency: ${paymentInformation.value?['crypto']}',
        weight: 1,
        align: LineText.ALIGN_RIGHT,
        linefeed: 1,
      ),
      LineText(
        type: LineText.TYPE_TEXT,
        content:
            'Date/Time: ${DateFormat.yMMMEd().add_jm().format(DateTime.now())}',
        weight: 1,
        align: LineText.ALIGN_RIGHT,
        linefeed: 1,
      ),
      LineText(
        type: LineText.TYPE_TEXT,
        content: 'Payment method: Crypto',
        weight: 1,
        align: LineText.ALIGN_RIGHT,
        linefeed: 1,
      ),
    ];

    // Print the receipt
    return await bluetoothPrint.printReceipt({
      'paper_size': 80,
      'encoding': 'GBK',
      'print_speed': 'fast',
      'density': 'medium',
      'cut_paper': true,
      'beep': true,
    }, receiptData);
  }
}
