import 'dart:io' show Platform, exit;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppExitHandler {
  static void exitApp(BuildContext context, {required Widget loginPage}) {
    if (kIsWeb) {
      // در وب یا PWA، برگشت به صفحه لاگین
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => loginPage),
            (route) => false,
      );
    } else {
      if (Platform.isAndroid) {
        // در اندروید، خروج کامل از اپ
        SystemNavigator.pop();
      } else if (Platform.isIOS) {
        // در iOS هم بهتره فقط به صفحه لاگین برگرده
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => loginPage),
              (route) => false,
        );
      } else {
        // برای بقیه سیستم‌عامل‌ها (مثلاً دسکتاپ)، خروج کامل
        exit(0);
      }
    }
  }
}
