import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shahrzad/blocs/user/users_bloc.dart';
import 'package:shahrzad/classes/color.dart';
import 'package:shahrzad/classes/style.dart';
import 'package:shahrzad/pages/loginpage.dart';
import 'package:shahrzad/widgets/customalertdialog.dart';
import 'package:shahrzad/widgets/shake_animation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../blocs/size/sizes_bloc.dart';
import '../cubit/userinfo_cubit.dart';
import '../models/user_model.dart';
import '../widgets/contentprivacypolicywidget.dart';
import 'home.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _famiyController = TextEditingController();
  final _phonenumberController = TextEditingController();
  final _passwordController = TextEditingController();
  final _repasswordController = TextEditingController();
  final _coachcodeController = TextEditingController();
  bool _obscureText = false;
  bool _isPolicyAccepted = false;
  String? selectedGroup;
  int selectedIndex = 2;
  String? selectedType;
  int selectedIndexType = 0;
  List<bool> fieldErrors = [false, false, false, false, false, false];

  final List<String> lstGroupname = [
    'ایروبیک',
    'ایروبیک فانکشنال',
    'CX',
  ];

  final List<String> lstType = [
    ' عضو عمومی ',
    ' عضو گروه ',
    ' مربی ',
  ];

  @override
  void initState() {
    super.initState();
    _loadPrivacyPolicyAcceptance(); // مقدار ذخیره‌شده رو بخون
  }

  Future<void> _loadPrivacyPolicyAcceptance() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isPolicyAccepted = prefs.getBool('isPrivacyPolicyAccepted') ?? false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _nameController.dispose();
    _famiyController.dispose();
    _phonenumberController.dispose();
    _passwordController.dispose();
    _repasswordController.dispose();
    _coachcodeController.dispose();
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
              if (state is UserCreateSuccessState) {
                // ذخیره در cubit
                context.read<UserinfoCubit>().login(state.userID,(selectedIndexType ==2)?1:2 ,coachCodeGenerate(selectedIndexType) );
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  // تابع async ناشناس برای استفاده از await
                  () async {
                    await customDialogBuilder(
                        context, "تبریک", "شما با موفقیت ثبت نام کردید");
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => BlocProvider(
                          create: (context) =>
                              SizesBloc()..add(LoadSizes(state.userID)),
                          child: HomePage(),
                        ),
                      ),
                    );
                  }(); // اجرای فوری تابع async
                });
              } else if (state is UserDuplicate) {
                WidgetsBinding.instance.addPostFrameCallback((_) async {
                  await customDialogBuilder(context, "توجه",
                      "کاربری با این شماره قبلا ثبت نام کرده.");
                });
              } else if (state is UserErrorState) {
                WidgetsBinding.instance.addPostFrameCallback((_) async {
                  await customDialogBuilder(context, "خطا", state.message);
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
                          "ثبت نام کاربر جدید",
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
                                ShakeWidget(
                                  shake: fieldErrors[0],
                                  child: TextFormField(
                                    controller: _nameController,
                                    decoration: const InputDecoration(
                                      labelText: ' نام',
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                ShakeWidget(
                                  shake: fieldErrors[1],
                                  child: TextFormField(
                                    controller: _famiyController,
                                    decoration: const InputDecoration(
                                      labelText: ' نام خانوادگی',
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  children: [
                                    Text(
                                      'نوع کاربری :',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 20),
                                    Expanded(
                                      child: DropdownButtonFormField<String>(
                                        value: selectedType,
                                        hint: Text(' عضو عمومی '),
                                        items: lstType.map((String type) {
                                          return DropdownMenuItem<String>(
                                            value: type,
                                            child: Text(type),
                                          );
                                        }).toList(),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            selectedType = newValue;
                                            selectedIndexType = lstType.indexOf(newValue!) ;

                                            print(selectedIndexType.toString());
                                          });
                                        },
                                        decoration: InputDecoration(
                                          filled: true,
                                          fillColor: Colors.purple.shade50,
                                          // بنفش کم‌رنگ
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 10),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            borderSide: BorderSide.none,
                                          ),
                                        ),
                                        dropdownColor: Colors
                                            .purple.shade50, // پس‌زمینه لیست
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                if (selectedIndexType == 1)
                                  Column(
                                    children: [
                                      ShakeWidget(
                                        shake: fieldErrors[5],
                                        child: TextFormField(
                                          controller: _coachcodeController,
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.digitsOnly,       // فقط عدد
                                            LengthLimitingTextInputFormatter(4),          // حداکثر ۴ رقم
                                          ],
                                          decoration: InputDecoration(
                                            labelText: ' کد مربی',
                                            border: OutlineInputBorder(),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'کد مربی را وارد کنید';
                                            }else if (value.length != 4) {
                                              return 'کد باید دقیقاً ۴ رقم باشد';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'گروه کلاس:',
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(height: 20),
                                          Expanded(
                                            child:
                                                DropdownButtonFormField<String>(
                                              value: selectedGroup,
                                              hint: Text('انتخاب کنید'),
                                              items: lstGroupname
                                                  .map((String group) {
                                                return DropdownMenuItem<String>(
                                                  value: group,
                                                  child: Text(group),
                                                );
                                              }).toList(),
                                              onChanged: (String? newValue) {
                                                setState(() {
                                                  selectedGroup = newValue;
                                                  selectedIndex = lstGroupname
                                                          .indexOf(newValue!) +
                                                      1;
                                                  print(
                                                      selectedIndex.toString());
                                                });
                                              },
                                              decoration: InputDecoration(
                                                filled: true,
                                                fillColor:
                                                    Colors.purple.shade50,
                                                // بنفش کم‌رنگ
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 10),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  borderSide: BorderSide.none,
                                                ),
                                              ),
                                              dropdownColor: Colors.purple
                                                  .shade50, // پس‌زمینه لیست
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                SizedBox(
                                  height: 20,
                                ),
                                ShakeWidget(
                                  shake: fieldErrors[2],
                                  child: TextFormField(
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
                                ),
                                const SizedBox(height: 20),
                                ShakeWidget(
                                  shake: fieldErrors[3],
                                  child: TextFormField(
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
                                ),
                                const SizedBox(height: 20),
                                ShakeWidget(
                                  shake: fieldErrors[4],
                                  child: TextFormField(
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
                                          bool isValid =
                                              _formKey.currentState!.validate();
                                          setState(() {
                                            fieldErrors = [
                                              _nameController.text.isEmpty,
                                              _famiyController.text.isEmpty,
                                              _phonenumberController
                                                  .text.isEmpty,
                                              _passwordController.text.isEmpty,
                                              _repasswordController
                                                  .text.isEmpty,
                                              (selectedIndexType == 1)
                                                  ? _coachcodeController
                                                      .text.isEmpty
                                                  : true
                                            ];
                                          });
                                          if (!_isPolicyAccepted) {
                                            _isPolicyAccepted =
                                                await showPrivacyPolicyDialog(
                                                    context);
                                          } else if (isValid) {
                                            UserModel user = UserModel(
                                                name: _nameController.text,
                                                family: _famiyController.text,
                                                groupid:groupIdGenerate(selectedIndex) ,
                                                role: (selectedIndexType == 2)
                                                    ? 1
                                                    : 2,
                                                email: "test@almaseman.ir",
                                                phonenumber:
                                                    _phonenumberController.text,
                                                password:
                                                    _passwordController.text,
                                                active: true,
                                                coach_code: coachCodeGenerate(
                                                    selectedIndexType));
                                            context
                                                .read<UsersBloc>()
                                                .add(CreateUserEvent(user));
                                          }
                                        },
                                        child: Text("ثبت نام",
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
                                                      create: (context) =>
                                                          UsersBloc(),
                                                      child: LoginPage(),
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
                                RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        height: 1.5),
                                    children: [
                                      const TextSpan(
                                        text:
                                            "ورود یا ثبت نام شما به معنای پذیرفتن تمام  ",
                                      ),
                                      TextSpan(
                                        text: "قوانین حریم خصوصی",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            showPrivacyPolicyDialog(context);
                                          },
                                      ),
                                      const TextSpan(text: " می باشد."),
                                    ],
                                  ),
                                )
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

  Future<bool> showPrivacyPolicyDialog(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              content: const PrivacyPolicyWidget(),
              actions: [
                Row(
                  children: [
                    Checkbox(
                      value: _isPolicyAccepted,
                      onChanged: (value) {
                        setState(() {
                          _isPolicyAccepted = value ?? false;
                        });
                      },
                    ),
                    const Text("با شرایط و قوانین موافقم"),
                  ],
                ),
                TextButton(
                  onPressed: _isPolicyAccepted
                      ? () async {
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setBool('isPrivacyPolicyAccepted', true);
                          Navigator.of(context).pop();
                        }
                      : null,
                  child: const Text("تأیید"),
                ),
              ],
            );
          },
        );
      },
    );
    return _isPolicyAccepted;
  }

  int coachCodeGenerate(int selectIndexType) {
    if (selectedIndexType == 2) {
      final random = Random();
      return 1000 + random.nextInt(9000); // عددی بین 1000 تا 9999
    } else if (selectedIndexType == 1) {
      return int.parse(_coachcodeController.text);
    }
    return 0;
  }
  int groupIdGenerate(int selectedGroup) {
    if (selectedIndexType == 2) {
      return 0;
    } else if (selectedIndexType == 1) {
      return selectedGroup;
    }
    return 0;
  }
}
