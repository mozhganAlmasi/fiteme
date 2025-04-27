import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shahrzad/blocs/user/users_bloc.dart';
import 'package:shahrzad/classes/color.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shahrzad/pages/loginpage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: const Locale('fa'),
      // زبان فارسی
      supportedLocales: const [
        Locale('fa'), // فارسی
        Locale('en'), // انگلیسی یا زبان‌های دیگه
      ],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      localeResolutionCallback: (locale, supportedLocales) {
        return const Locale('fa'); // اجباری به فارسی
      },
      title: 'Gym',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: mzhColorThem1[5]),
        useMaterial3: true,
      ),
      home: BlocProvider(
        create: (context) => UsersBloc(),
        child: LoginPage(),
      ),
    );
  }
}

