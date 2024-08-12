// GoRouter configuration
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> navkey = GlobalKey();

final router = GoRouter(
  navigatorKey: navkey,
  routes: [
    // GoRoute(
    //   path: '/',
    //   builder: (context, state) => const Dashboard(),
    // ),
  ],
);
