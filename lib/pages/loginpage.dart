import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shahrzad/blocs/size/sizes_bloc.dart';
import 'package:shahrzad/blocs/user/users_bloc.dart';
import 'package:shahrzad/classes/color.dart';
import 'package:shahrzad/classes/style.dart';
import 'package:shahrzad/pages/home.dart';
import 'package:shahrzad/pages/registerpage.dart';
import '../blocs/internetconnection/connectivity_bloc.dart';
import '../cubit/userinfo_cubit.dart';
import '../widgets/customalertdialog.dart';
import 'package:flutter/foundation.dart' show kIsWeb;


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = false;
  bool _userLoading = false;
  bool internetDisconnect = false;


  @override
  void dispose() {
    super.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: MultiBlocListener(
          listeners: [
            BlocListener<UsersBloc, UsersState>(
              listener: (contextbuilder, state) {
                if (state is UserLoginSuccessState) {
                  _userLoading = false;
                  if(state.user.active)
                    {
                      context.read<UserinfoCubit>().login(state.user.id!, state.user.role , state.user.coach_code);
                      print("UserID:" + state.user.id.toString());
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (_) => BlocProvider(
                                create: (context) =>
                                SizesBloc()..add(SizesLoadEvent(state.user.id!)),
                                child: HomePage(),
                              )),
                        );
                      });
                    }else{
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      customDialogBuilder(context, "خطا در ورود کاربر",
                          "شما توسط مدیر غیر فعال شده اید");
                    });
                  }

                } else if (state is UserLoginFailState) {
                  _userLoading = false;
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    customDialogBuilder(context, "خطا در ورود کاربر",
                        "شماره همراه یا رمز ورود صحیح نمی باشد");
                  });
                } else if (state is UserErrorState) {
                  _userLoading = false;
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    customDialogBuilder(context, "" , "خطا در دریافت اطلاعت");
                  });
                } else if (state is UserLoadingState) {
                  _userLoading = true;
                }
              },
            ),
            if (!kIsWeb)  BlocListener<ConnectivityBloc, ConnectivityState>(
              listener: (context, state) {
                if (state is ConnectivityDisconnected) {
                  setState(() {
                    internetDisconnect = true;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('اتصال به اینترنت برقرار نیست') ,
                      backgroundColor: Colors.red,
                    ),
                  );
                } else if (state is ConnectivityConnected) {
                  setState(() {
                    internetDisconnect = false;
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('اتصال به اینترنت برقرار شد') ,
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
            ),
          ],
          child: BlocBuilder<UsersBloc, UsersState>(
            builder: (contextbuilder, state) {
              return Container(
                height: size.height , // یا: MediaQuery.of(context).size.height
                width: double.infinity ,
                color: mzhColorThem1[0] , // رنگ پس‌زمینه کل صفحه
                child: Center(
                  child: SingleChildScrollView(
                    // برای اسکرول در گوشی‌هایی با کیبورد
                    padding: const EdgeInsets.all(16) ,
                    child: Column(
                      children: [
                        Text(
                          "ورود کاربر",
                          style: CustomTextStyle.textappbar ,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: 360, // عرض کادر فرم
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: mzhColorThem1[2], // رنگ کادر داخلی فرم
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset("assets/icon/icon.png"),
                                TextFormField(
                                  controller: _phoneController,
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    labelText: 'شماره موبایل',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'شماره موبایل را وارد کنید';
                                    } else if (!RegExp(r'^0\d{10}$')
                                        .hasMatch(value)) {
                                      return 'شماره موبایل باید با ۰ شروع شود و ۱۱ رقم باشد';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 20),
                                TextFormField(
                                  controller: _passwordController,
                                  obscureText: !_obscureText,
                                  decoration: InputDecoration(
                                    labelText: 'رمز عبور',
                                    border: OutlineInputBorder(),
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        _obscureText ? Icons.visibility_off : Icons.visibility,
                                      ),
                                      onPressed: (){
                                        setState(() {
                                          _obscureText = !_obscureText;

                                        });
                                      },
                                    ),
                                  ),

                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'رمز عبور را وارد کنید';
                                    } else if (value.length < 5) {
                                      return 'رمز عبور باید حداقل ۵ کاراکتر باشد';
                                    }
                                    else if (value.length >50) {
                                      return 'رمز عبور باید حداگثر 50 کاراکتر باشد';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 40),
                                Container(
                                  width: double.infinity,
                                  child: kIsWeb
                                      ? ElevatedButton(
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
                                      backgroundColor: mzhColorThem1[9],
                                      foregroundColor: mzhColorThem1[2],
                                      side: BorderSide(color: mzhColorThem1[2]),
                                    ),
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        final phone = _phoneController.text.trim();
                                        final pass = _passwordController.text.trim();
                                        context.read<UsersBloc>().add(LoginSubmittedEvent(
                                          phoneNumber: phone,
                                          password: pass,
                                        ));
                                      }
                                    },
                                    child: (_userLoading)
                                        ? CircularProgressIndicator()
                                        : Text("ورود", style: CustomTextStyle.textbutton),
                                  )
                                      :  BlocSelector<ConnectivityBloc, ConnectivityState, bool>(
                                    selector: (state) => state is ConnectivityConnected,
                                    builder: (context, isConnected) {
                                      return ElevatedButton(
                                        style: OutlinedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
                                          backgroundColor: mzhColorThem1[9],
                                          foregroundColor: mzhColorThem1[2],
                                          side: BorderSide(color: mzhColorThem1[2]),
                                        ),
                                        onPressed: isConnected
                                            ? () {
                                          if (_formKey.currentState!.validate()) {
                                            final phone = _phoneController.text.trim();
                                            final pass = _passwordController.text.trim();
                                            context.read<UsersBloc>().add(LoginSubmittedEvent(
                                              phoneNumber: phone,
                                              password: pass,
                                            ));
                                          }
                                        }
                                            : null,
                                        child: (_userLoading)
                                            ? CircularProgressIndicator()
                                            : Text("ورود", style: CustomTextStyle.textbutton),
                                      );
                                    },
                                  ),

                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 32, vertical: 18),
                                      backgroundColor: mzhColorThem1[5],
                                      foregroundColor: mzhColorThem1[2],
                                      side: BorderSide(color: mzhColorThem1[2]),
                                    ),
                                    onPressed: () async {
                                      Navigator.of(context)
                                          .pushReplacement(MaterialPageRoute(
                                              builder: (_) => BlocProvider(
                                                    create: (context) =>
                                                        UsersBloc(),
                                                    child: RegisterPage(),
                                                  )));
                                    },
                                    child: Text("ثبت نام",
                                        style: CustomTextStyle.textbutton),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}


