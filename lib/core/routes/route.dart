// GoRouter configuration
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ivorypay_test/presentation/pages/fullscreen.loader.dart';
import 'package:ivorypay_test/presentation/pages/receipt.dart';
import 'package:ivorypay_test/presentation/pages/scanner.dart';

final GlobalKey<NavigatorState> navkey = GlobalKey();

final router = GoRouter(
  navigatorKey: navkey,
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const ScannerPage(),
    ),
    GoRoute(
      path: '/loading',
      builder: (context, state) {
        return Loader(extra: state.extra as Map<String, dynamic>?);
      },
    ),
    GoRoute(
      path: '/receipt',
      builder: (context, state) => const TransactionReceipt(),
    ),
  ],
);
