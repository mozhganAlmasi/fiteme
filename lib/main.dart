import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shahrzad/blocs/category/category_bloc.dart';
import 'package:shahrzad/blocs/user/users_bloc.dart';
import 'package:shahrzad/classes/color.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shahrzad/firebase_options.dart';
import 'package:shahrzad/pages/loginpage.dart';
import 'blocs/internetconnection/connectivity_bloc.dart';
import 'cubit/userinfo_cubit.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // var message = FirebaseMessaging.instance;
  // var token = await message.getToken();
  // FirebaseMessaging.onMessage.listen((event){
  //   print("My message recieved ${event.data} : ${event.notification!.title}");
  // });
  // FirebaseMessaging.onMessageOpenedApp.listen((event){
  //   print("My message click");
  // });
  // print("My user token : ${token}" );
  runApp(
    BlocProvider(
      create: (context) => ConnectivityBloc(Connectivity()),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => UsersBloc()),
          BlocProvider(create: (context) => UserinfoCubit()),
          BlocProvider(create: (context)=>CategoryBloc()),
        ],
        child: const MyApp(),
      ),
    ),
  );
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
        home: LoginPage());
  }
}
