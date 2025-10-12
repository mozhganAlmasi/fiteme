import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shahrzad/blocs/category/category_bloc.dart';
import 'package:shahrzad/blocs/user/users_bloc.dart';
import 'package:shahrzad/classes/color.dart';
import 'package:shahrzad/classes/style.dart';
import 'package:shahrzad/pages/loginpage.dart';
import 'package:shahrzad/widgets/customalertdialog.dart';
import 'package:shahrzad/pages/coachcode_dialogpage.dart';
import 'package:shahrzad/widgets/shake_animation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../blocs/size/sizes_bloc.dart';
import '../cubit/userinfo_cubit.dart';
import '../models/category_model.dart';
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
  final _coachCodeController = TextEditingController();

  late Size size;

  bool _obscureText = false;
  bool _isPolicyAccepted = false;
  bool dialogLoading = false;
  String? selectedGroup;
  int selectedIndex = 2;
  String? selectedTypeName;
  int selectedTypeIndex = 0;
  List<bool> fieldErrors = [false, false, false, false, false, false];

  List<String?> lstGroupname = [];
  List<int> lstGroupid =[];

  int coachCode = 0;

  final List<String> lstType = [' عضو عمومی ', ' عضو گروه ', ' مربی '];

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
    disposeController();
    super.dispose();
  }

  void disposeController() {
    _nameController.dispose();
    _famiyController.dispose();
    _phonenumberController.dispose();
    _passwordController.dispose();
    _repasswordController.dispose();
    _coachCodeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          color: mzhColorThem1[0], // رنگ پس‌زمینه کل صفحه
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                buildUIWithoutButton(),
                BlocConsumer<UsersBloc, UsersState>(
                  builder: (context, state) {
                    return buildUIButton();
                  },
                  listener: (context, state) {
                    if (state is UserLoadingState) {
                      dialogLoading = true;
                    } else if (state is UserCreateSuccessState) {
                      dialogLoading = false;
                      // ذخیره در cubit
                      context.read<UserinfoCubit>().login(
                        state.userID,
                        (selectedTypeIndex == 2) ? 1 : 2,
                        coachCodeGenerate(selectedTypeIndex),
                      );
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        // تابع async ناشناس برای استفاده از await
                        () async {
                          await customDialogBuilder(
                            context ,
                            "تبریک" ,
                            "شما با موفقیت ثبت نام کردید" ,
                          );
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => BlocProvider(
                                create: (context) =>
                                    SizesBloc()
                                      ..add(SizesLoadEvent(state.userID)),
                                child: HomePage(),
                              ),
                            ),
                          );
                        }(); // اجرای فوری تابع async
                      });
                    } else if (state is UserDuplicate) {
                      dialogLoading = false;
                      WidgetsBinding.instance.addPostFrameCallback((_) async {
                        await customDialogBuilder(
                          context ,
                          "توجه" ,
                          "کاربری با این شماره قبلا ثبت نام کرده." ,
                        );
                      });
                    } else if (state is CoachDuplicate) {
                      dialogLoading = false;
                      WidgetsBinding.instance.addPostFrameCallback((_) async {
                        await customDialogBuilder(
                          context ,
                          "توجه" ,
                          "کد مربی گری شما تکراری است " ,
                        );
                      });
                    } else if (state is UserErrorState) {
                      dialogLoading = false;
                      WidgetsBinding.instance.addPostFrameCallback((_) async {
                        await customDialogBuilder(
                          context ,
                          "خطا" ,
                          "خطا در اتصال به سرور" ,
                        );
                      });
                    }

                    // TODO: implement listener
                  },
                ),
                buildUIPrivacyPOlicy(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildUIWithoutButton() {
    return Center(
      child: Column(
        children: [
          Text("ثبت نام کاربر جدید", style: CustomTextStyle.textappbar),
          SizedBox(height: 20),
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
                  // فیلد نام
                  ShakeWidget(
                    shake: fieldErrors[0],
                    child: TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: ' نام'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'نام را وارد کنید';
                        } else if (value.length < 3) {
                          return 'نام باید حداقل سه حرف باشد';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  //فیلد نام خوانوادگی
                  ShakeWidget(
                    shake: fieldErrors[1],
                    child: TextFormField(
                      controller: _famiyController,
                      decoration: const InputDecoration(
                        labelText: ' نام خانوادگی',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'نام خانوادگی را وارد کنید';
                        } else if (value.length < 3) {
                          return 'نام خانوادگی باید حداقل سه حرف باشد';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  //لیست نوع کاربری
                  Row(
                    children: [
                      Text(
                        'نوع کاربری :',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: selectedTypeName,
                          hint: Text(' عضو عمومی '),
                          items: lstType.map((String type) {
                            return DropdownMenuItem<String>(
                              value: type,
                              child: Text(type),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            changeUserType(newValue);
                            _coachCodeController.text = generateRandomNumber().toString();
                          },
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.purple.shade50,
                            // بنفش کم‌رنگ
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          dropdownColor:
                              Colors.purple.shade50, // پس‌زمینه لیست
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  //گروه کلاس : لیست باکس گروه که از دیتابیس در دیالوگ گرفته شده
                  //اگر کاربر از نوع عضو گروه باشد نمایش داده می شود
                  if (selectedTypeIndex == 1)
                    Row(
                      children: [
                        Text(
                          'گروه کلاس:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: selectedGroup,
                            hint: Text('انتخاب کنید'),
                            items: lstGroupname
                                .where((group) => group != null)
                                .map((group) {
                                  return DropdownMenuItem<String>(
                                    value: group,
                                    child: Text(group!),
                                  );
                                })
                                .toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedGroup = newValue;
                                selectedIndex =
                                    lstGroupname.indexOf(newValue!) ;
                              });
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.purple.shade50,
                              // بنفش کم‌رنگ
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            dropdownColor:
                                Colors.purple.shade50, // پس‌زمینه لیست
                          ),
                        ),
                      ],
                    ),
                  SizedBox(height: 20),
                  // شماره موبایل
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
                        } else if (!RegExp(r'^0\d{10}$').hasMatch(value)) {
                          return 'شماره موبایل باید با ۰ شروع شود و ۱۱ رقم باشد';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  // کد مربی
                  if (selectedTypeIndex == 2)
                    ShakeWidget(
                      shake: fieldErrors[3],
                      child: TextFormField(
                        controller: _coachCodeController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'کد چهار رقمی اختصاصی مربی',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'کد چهار رقمی به دلخواه وارد کنید';
                          } else if (!RegExp(r'^\d{4}$').hasMatch(value)) {
                            return 'یک عدد چهار رقمی وارد کنید .';
                          }
                          return null;
                        },
                      ),
                    ),
                  const SizedBox(height: 20),
                  // رمز عبور
                  ShakeWidget(
                    shake: fieldErrors[4],
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
                  // تکرار رمز عبور
                  ShakeWidget(
                    shake: fieldErrors[5],
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
                        } else if (value != _passwordController.text) {
                          return 'رمز عبور و تکرار آن یکسان نیستند';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildUIButton() {
    return Container(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //دکمه ثبت نام
          ElevatedButton(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
              backgroundColor: mzhColorThem1[5],
              foregroundColor: mzhColorThem1[2],
              side: BorderSide(color: mzhColorThem1[2]),
            ),
            onPressed: () async {
              bool isValid = _formKey.currentState!.validate();
              setState(() {
                fieldErrors = [
                  _nameController.text.isEmpty,
                  _famiyController.text.isEmpty,
                  _phonenumberController.text.isEmpty,
                  (selectedTypeIndex ==2)?_coachCodeController.text.isEmpty:true,
                  _passwordController.text.isEmpty,
                  _repasswordController.text.isEmpty,
                ];
              });
              if (!_isPolicyAccepted) {
                _isPolicyAccepted = await showPrivacyPolicyDialog(context);
              } else if (isValid) {

                UserModel user = UserModel(
                  name: _nameController.text,
                  family: _famiyController.text,
                  groupid: groupIdGenerate(selectedIndex),
                  role: (selectedTypeIndex == 2) ? 1 : 2,
                  email: "test@almaseman.ir",
                  phonenumber: _phonenumberController.text,
                  password: _passwordController.text,
                  active: true,
                  coach_code: coachCodeGenerate(selectedTypeIndex),
                );
                context.read<UsersBloc>().add(UserCreateEvent(user));
              }
            },
            child: (dialogLoading)
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(),
                  )
                : Text("ثبت نام", style: CustomTextStyle.textbutton),
          ),
          // دکمه بازگشت
          ElevatedButton(
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(
                horizontal: size.width / 10,
                vertical: 18,
              ),
              backgroundColor: mzhColorThem1[5],
              foregroundColor: mzhColorThem1[2],
              side: BorderSide(color: mzhColorThem1[2]),
            ),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => BlocProvider(
                    create: (context) => UsersBloc(),
                    child: LoginPage(),
                  ),
                ),
              );
            },
            child: Text("بازگشت", style: CustomTextStyle.textbutton),
          ),
        ],
      ),
    );
  }

  Widget buildUIPrivacyPOlicy() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black,
            height: 1.5,
          ),
          children: [
            const TextSpan(text: "ورود یا ثبت نام شما به معنای پذیرفتن تمام  "),
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
      ),
    );
  }

  void changeUserType(newValue) async {
    selectedTypeName = newValue;
    selectedTypeIndex = lstType.indexOf(newValue!);
    if (selectedTypeIndex == 1) {
      final result = await showDialog(
        context: context,
        builder: (context) => BlocProvider.value(
          value: context.read<CategoryBloc>(),
          child: CoachCodeDialogPage(
            getTitle: "کد مربی",
            getContent: "لطفاً کد مربی خود را وارد کنید:",
          ),
        ),
      );

      if (result != null) {
        List<CategoryModel> tempList = result[0];
        lstGroupname = tempList.map((item) => item.categoryName).toList();
        lstGroupid = tempList.map((item)=>item.id).toList();
        coachCode = int.parse(result[1]);
      } else {
        lstGroupname = [];
      }
    } else {
      lstGroupname = [];
      selectedGroup = null;
      selectedIndex = 0;
      coachCode = 0;
      setState(() {});
    }
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
    if (selectedTypeIndex == 2) {
      return int.parse(_coachCodeController.text);
    } else if (selectedTypeIndex == 1) {
      return coachCode;
    }
    return 0;
  }

  int generateRandomNumber() {
    final random = Random();
    return 1000 + random.nextInt(9000); // عددی بین 1000 تا 9999
  }

  int groupIdGenerate(int selectedIndex) {
    if (selectedTypeIndex == 2) {
      return 0;
    } else if (selectedTypeIndex == 1) {

      return lstGroupid[selectedIndex ];
    }
    return 0;
  }


}
