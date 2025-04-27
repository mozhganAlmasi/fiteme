import 'package:flutter/material.dart';

class PrivacyPolicyWidget extends StatelessWidget {
  const PrivacyPolicyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: RichText(
        textAlign: TextAlign.justify,
        text: const TextSpan(
          style: TextStyle(fontSize: 14, color: Colors.black, height: 1.5),
          children: [
            TextSpan(
              text: "سیاست حفظ حریم خصوصی\n\n",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            TextSpan(
              text:
              "ما در این اپلیکیشن متعهد به حفظ حریم خصوصی شما هستیم. اطلاعاتی که از شما دریافت می‌شود شامل:\n\n",
            ),
            TextSpan(
              text: " شماره همراه: ",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: "برای ثبت‌ نام و احراز هویت کاربران که به عنوان نام کاربری ، جهت ذخیره جملات مد نظر شما در سرور مورد استفاده قرار می گیرد. \n"),
                        TextSpan(
              text: "ما این اطلاعات را فقط برای ارائه خدمات بهتر استفاده می‌کنیم و در اختیار شخص ثالث قرار نخواهد گرفت.",
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}
