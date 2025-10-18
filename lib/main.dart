import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shahrzad/classes/color.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shahrzad/feature/feature_user/data/repository/repository.dart';
import 'package:shahrzad/feature/feature_user/domain/repository/userrepository.dart';
import 'package:shahrzad/feature/feature_user/domain/usecase/usercreate_usecase.dart';
import 'package:shahrzad/feature/feature_user/domain/usecase/userdelet_usecase.dart';
import 'package:shahrzad/feature/feature_user/domain/usecase/userget_usecase.dart';
import 'package:shahrzad/feature/feature_user/domain/usecase/userlogin_usecase.dart';
import 'package:shahrzad/feature/feature_user/domain/usecase/usersgetall_usecaase.dart';
import 'package:shahrzad/feature/feature_user/domain/usecase/userupdate_usecase.dart';
import 'package:shahrzad/firebase_options.dart';
import 'package:shahrzad/feature/feature_user/presentation/pages/loginpage.dart';
import 'blocs/internetconnection/connectivity_bloc.dart';
import 'cubit/userinfo_cubit.dart';
import 'feature/feature_category/data/datasource/remote/category_api_services.dart';
import 'feature/feature_category/data/repository/repository.dart';
import 'feature/feature_category/domain/usecase/categorycreate_usecase.dart';
import 'feature/feature_category/domain/usecase/categorydelete_usecase.dart';
import 'feature/feature_category/domain/usecase/categoryget_usecase.dart';
import 'feature/feature_category/presenteation/bloc/category/category_bloc.dart';
import 'feature/feature_user/data/datasource/remote/user_api_service.dart';
import 'feature/feature_user/presentation/bloc/user/users_bloc.dart';

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
          BlocProvider(create: (context) => UsersBloc(
            getUsersUseCase:UsersGetAllUseCase(usersRepository:UserRepositoryImplementation(apiService: UserApiService(),)) ,
            getUserUseCase: UserGetUseCase(usersRepository:UserRepositoryImplementation(apiService: UserApiService(),)),
            userCreateUseCase: UserCreateUseCase(usersRepository:UserRepositoryImplementation(apiService: UserApiService(),)),
            userDeletUseCase: UserDeletUseCase(usersRepository:UserRepositoryImplementation(apiService: UserApiService(),)),
            userLoginUseCase: UserLoginUseCase(usersRepository:UserRepositoryImplementation(apiService: UserApiService(),)),
            userUpdateUseCase: UserUpdateUseCase(usersRepository:UserRepositoryImplementation(apiService: UserApiService(),)),
          )
          ),
          BlocProvider(create: (context) => UserinfoCubit()),
          BlocProvider(create: (context)=>CategoryBloc(
              categoryCreateUseCase: CategoryCreateUseCase(CategoryRepositoryImpelementation(CateoryApiService())),
              categoryDeletUseCase:  CategoryDeletUseCase(CategoryRepositoryImpelementation(CateoryApiService())),
              categoryGetUseCase:CategoryGetUseCase(CategoryRepositoryImpelementation(CateoryApiService()))
          )),
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
