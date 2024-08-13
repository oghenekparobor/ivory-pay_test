import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ivorypay_test/core/routes/route.dart';
import 'package:ivorypay_test/core/theme/theme.dart';
import 'package:ivorypay_test/notification_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(430, 932),
      minTextAdapt: true,
      builder: (context, child) {
        final MediaQueryData query = MediaQuery.of(context);
        final MediaQueryData mediaQuery = query.copyWith(
          textScaler: query.textScaler.clamp(
            minScaleFactor: 0.9,
            maxScaleFactor: 1.0,
          ),
        );

        return MediaQuery(
          data: mediaQuery,
          child: MaterialApp.router(
            title: 'IvoryPay',
            debugShowCheckedModeBanner: false,
            theme: theme(context),
            routerConfig: router,
            builder: (context, child) => NotificationStack(child: child!),
          ),
        );
      },
    );
  }
}
