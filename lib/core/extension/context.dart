import 'package:flutter/material.dart';
import 'package:ivorypay_test/notification_wrapper.dart';

extension CxtExtension on BuildContext {
  // theme related
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;

  // size related
  Size get size => MediaQuery.of(this).size;
  EdgeInsets get padding => MediaQuery.of(this).padding;

  // media queries
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  // focus scope
  FocusScopeNode get focusScope => FocusScope.of(this);

  Object get arg => ModalRoute.of(this)!.settings.arguments!;

  NotificationStackState get notify => NotificationStack.of(this);
}
