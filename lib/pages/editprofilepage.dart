import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shahrzad/blocs/user/users_bloc.dart';
import 'package:shahrzad/classes/color.dart';
import 'package:shahrzad/classes/style.dart';
import 'package:shahrzad/pages/loginpage.dart';
import 'package:shahrzad/widgets/customalertdialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../blocs/size/sizes_bloc.dart';
import '../models/user_model.dart';
import '../widgets/contentprivacypolicywidget.dart';
import 'home.dart';

class EditProfilePage extends StatefulWidget {
  final String userID;
  const EditProfilePage({super.key , required this.userID});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _famiyController = TextEditingController();
  final _phonenumberController = TextEditingController();
  final _passwordController = TextEditingController();
  final _repasswordController = TextEditingController();
  bool _obscureText = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _famiyController.dispose();
    _phonenumberController.dispose();
    _passwordController.dispose();
    _repasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: size.height, // یا: MediaQuery.of(context).size.height
          width: double.infinity,
          color: mzhColorThem1[0], // رنگ پس‌زمینه کل صفحه
          child: BlocListener<UsersBloc, UsersState>(
            listener: (context, state) {
              if (state is GetUserSuccess) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _nameController.text = state.user.name;
                  _famiyController.text = state.user.family;
                  _phonenumberController.text = state.user.phoneNumber;
                  () async {   }(); // اجرای فوری تابع async
                });
              } else if (state is UserError) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  // تابع async ناشناس برای استفاده از await
                  () async {
                    await customDialogBuilder(context, "خطا", state.message);
                  }(); // اجرای فوری تابع async
                });
              }else if(state is UpdateUserSuccess)
                {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    // تابع async ناشناس برای استفاده از await
                    () async {
                      await customDialogBuilder(context, "تبریک", "اطلاعات شما با موفقیت ویرایش شد .");
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (_) => BlocProvider(
                              create: (context) => SizesBloc()..add(LoadSizes(widget.userID)),
                              child: HomePage(userID: widget.userID),
                            )),
                      );
                    }(); // اجرای فوری تابع async
                  });
                }

              // TODO: implement listener
            },
            child: BlocBuilder<UsersBloc, UsersState>(
              builder: (context, state) {
                return Center(
                  child: SingleChildScrollView(
                    // برای اسکرول در گوشی‌هایی با کیبورد
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          "ویرایش کاربر",
                          style: CustomTextStyle.textappbar,
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
                                TextField(
                                  controller: _nameController,
                                  decoration: const InputDecoration(
                                    labelText: ' نام',
                                  ),
                                ),
                                const SizedBox(height: 20),
                                TextField(
                                  controller: _famiyController,
                                  decoration: const InputDecoration(
                                    labelText: ' نام خانوادگی',
                                  ),
                                ),
                                const SizedBox(height: 20),
                                SizedBox(
                                  height: 20,
                                ),
                                TextFormField(
                                  controller: _phonenumberController,
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
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 20),
                                TextFormField(
                                  controller: _repasswordController,
                                  obscureText: !_obscureText,
                                  decoration: InputDecoration(
                                    labelText: ' تکرار رمز عبور',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'رمز عبور را وارد کنید';
                                    } else if (value.length < 5) {
                                      return 'رمز عبور باید حداقل ۵ کاراکتر باشد';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 40),
                                Container(
                                  width: double.infinity,
                                  child: Row(
                                    children: [
                                      ElevatedButton(
                                        style: OutlinedButton.styleFrom(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 32, vertical: 18),
                                          backgroundColor: mzhColorThem1[5],
                                          foregroundColor: mzhColorThem1[2],
                                          side: BorderSide(
                                              color: mzhColorThem1[2]),
                                        ),
                                        onPressed: () async {
                                          UserModel user = UserModel(
                                              id: widget.userID,
                                              name: _nameController.text,
                                              family: _famiyController.text,
                                              groupId: 0,
                                              role: 2,
                                              email: "test@almaseman.ir",
                                              phoneNumber:
                                              _phonenumberController.text,
                                              password:
                                              _passwordController.text);
                                          context
                                              .read<UsersBloc>()
                                              .add((UpdateUserEvent(user)));
                                        },
                                        child: Text("ویرایش",
                                            style: CustomTextStyle.textbutton),
                                      ),
                                      ElevatedButton(
                                        style: OutlinedButton.styleFrom(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: size.width / 10,
                                              vertical: 18),
                                          backgroundColor: mzhColorThem1[5],
                                          foregroundColor: mzhColorThem1[2],
                                          side: BorderSide(
                                              color: mzhColorThem1[2]),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                                builder: (_) => BlocProvider(
                                                  create: (context) => SizesBloc()..add(LoadSizes(widget.userID)),
                                                  child: HomePage(userID: widget.userID),
                                                )),
                                          );

                                        },
                                        child: Text("بازگشت",
                                            style: CustomTextStyle.textbutton),
                                      )
                                    ],
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
                );
              },
            ),
          ),
        ),
      ),
    );
  }


}
