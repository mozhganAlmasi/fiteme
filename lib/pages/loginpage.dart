import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shahrzad/blocs/size/sizes_bloc.dart';
import 'package:shahrzad/blocs/user/users_bloc.dart';
import 'package:shahrzad/classes/color.dart';
import 'package:shahrzad/classes/style.dart';
import 'package:shahrzad/pages/home.dart';
import 'package:shahrzad/pages/registerpage.dart';
import '../blocs/internetconnection/connectivity_bloc.dart';
import '../widgets/customalertdialog.dart';

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

  @override
  void initState() {
    super.initState();
    context.read<ConnectivityBloc>().add(CheckConnectivity());
  }

  @override
  void dispose() {
    super.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool internetDisconnect = false;
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: MultiBlocListener(
          listeners: [
            BlocListener<UsersBloc, UsersState>(
              listener: (contextbuilder, state) {
                if (state is UserLoginSuccess) {
                  _userLoading = false;
                  print("UserID:" + state.userID);
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (_) => BlocProvider(
                                create: (context) =>
                                    SizesBloc()..add(LoadSizes(state.userID)),
                                child: HomePage(userID: state.userID),
                              )),
                    );
                  });
                } else if (state is UserLoginFail) {
                  _userLoading = false;
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    customDialogBuilder(context, "خطا در ورود کاربر",
                        "شماره همراه یا رمز ورود صحیح نمی باشد");
                  });
                } else if (state is UserError) {
                  _userLoading = false;
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    customDialogBuilder(context, "", "خطا در دریافت اطلاعت");
                  });
                } else if (state is UserLoading) {
                  _userLoading = true;
                }
              },
            ),
            BlocListener<ConnectivityBloc, ConnectivityState>(
              listener: (context, state) {
                if (state is ConnectivityDisconnected) {
                  internetDisconnect = true;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('اتصال به اینترنت برقرار نیست') ,
                      backgroundColor: Colors.red,
                    ),
                  );
                } else if (state is ConnectivityConnected) {
                  internetDisconnect = false;
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
                                  child: ElevatedButton(
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 32, vertical: 18),
                                      backgroundColor: mzhColorThem1[9],
                                      foregroundColor: mzhColorThem1[2],
                                      side: BorderSide(color: mzhColorThem1[2]),
                                    ),
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        final phone = _phoneController.text.trim();
                                        final pass = _passwordController.text.trim();

                                        context.read<ConnectivityBloc>().add(CheckConnectivity());
                                        if (internetDisconnect) {
                                          return;
                                        }
                                        context.read<UsersBloc>().add(LoginSubmittedEvent(
                                          phoneNumber: phone,
                                          password: pass,
                                        ));
                                      }

                                    },
                                    child: (_userLoading)
                                        ? CircularProgressIndicator()
                                        : Text("ورود",
                                            style: CustomTextStyle.textbutton),
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
