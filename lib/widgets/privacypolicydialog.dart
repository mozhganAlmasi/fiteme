import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shahrzad/widgets/privacypolicytext.dart';

void showPrivacyPolicyDialog(BuildContext context) {
  bool isPolicyAccepted = false; // مقدار محلی برای چک‌باکس

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) { // مدیریت وضعیت داخلی
          return AlertDialog(

            content: const PrivacyPolicyWidget(),
            actions: [
              Row(
                children: [
                  Checkbox(
                    value: isPolicyAccepted,
                    onChanged: (bool? value) {
                      setState(() {
                        isPolicyAccepted = value ?? false;
                      });
                    },
                  ),
                  const Text("با شرایط و قوانین موافقم"),
                ],
              ),
              TextButton(
                onPressed: isPolicyAccepted
                    ? () {
                  Navigator.of(context).pop();
                }
                    : null, // غیرفعال کردن دکمه در صورت عدم تأیید
                child: const Text("تأیید"),
              ),
            ],
          );
        },
      );
    },
  );
}

