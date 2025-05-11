import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shahrzad/blocs/size/sizes_bloc.dart';
import 'package:shahrzad/blocs/user/users_bloc.dart';
import 'package:shahrzad/classes/color.dart';
import 'package:shahrzad/widgets/shake_animation.dart';
import 'package:shahrzad/classes/style.dart';
import 'package:shahrzad/widgets/privacypolicydialog.dart';
import 'package:shahrzad/widgets/customalertdialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/size_model.dart';
import '../models/user_model.dart';
import '../widgets/contentprivacypolicywidget.dart';
import '../widgets/persiandatepicker.dart';
import 'home.dart';

class AddsizePage extends StatefulWidget {
  final String userID;
  final GlobalKey<PersianDatePickerState> datePickerKey = GlobalKey();

  AddsizePage({super.key , required this.userID});

  @override
  State<AddsizePage> createState() => _AddsizePageState();
}

class _AddsizePageState extends State<AddsizePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController waistController = TextEditingController();
  final TextEditingController chestController = TextEditingController();
  final TextEditingController hipsController = TextEditingController();
  final TextEditingController armController = TextEditingController();
  final TextEditingController thighController = TextEditingController();
  final TextEditingController shoulderController = TextEditingController();
  final TextEditingController bellyController = TextEditingController();
  bool _obscureText = false;
  bool _isPolicyAccepted = false;
  String? selectedGroup;
  int selectedIndex =1;
  String selectedMonth = '';
  int selectedYear = 0;

  final List<String> lstGroupname = [
    'ایروبیک',
    'ایروبیک فانکشنال',
    'CX',
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
    waistController.dispose();
    chestController.dispose();
    hipsController.dispose();
    armController.dispose();
    thighController.dispose();
    shoulderController.dispose();
    bellyController.dispose();
  }
  List<bool> fieldErrors = [false, false, false, false, false, false, false];
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Container(
          height: size.height, // یا: MediaQuery.of(context).size.height
          width: double.infinity,
          color: mzhColorThem1[0], // رنگ پس‌زمینه کل صفحه
          child: BlocListener<SizesBloc, SizesState>(
            listener: (context, state) {
              if(state is SizeCreateSuccess)
                {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    () async{
                     await customDialogBuilder(context, "تبریک", "سایز شما با موفقیت ثبت شد");
                     waistController.clear();
                     chestController.clear();
                     hipsController.clear();
                     armController.clear();
                     thighController.clear();
                     shoulderController.clear();
                     bellyController.clear();

                    }();

                  });

                }
              // TODO: implement listener
            },
            child: BlocBuilder<SizesBloc, SizesState>(
              builder: (context, state) {
                return Center(
                  child: SingleChildScrollView(
                    // برای اسکرول در گوشی‌هایی با کیبورد
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          "افزودن سایز جدید",
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
                                    controller: waistController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(labelText: 'دور کمر '),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) return 'لطفاً دور کمر را وارد کنید';
                                      if (double.tryParse(value) == null) return 'فقط عدد وارد کنید';
                                      return null;
                                    },
                                  ),
                                ),
                                ShakeWidget(
                                  shake: fieldErrors[1],
                                  child: TextFormField(
                                    controller: chestController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(labelText: 'دور سینه '),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) return 'لطفاً دور سینه را وارد کنید';
                                      if (double.tryParse(value) == null) return 'فقط عدد وارد کنید';
                                      return null;
                                    },
                                  ),
                                ),
                                ShakeWidget(
                                  shake: fieldErrors[2],
                                  child: TextFormField(
                                    controller: hipsController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(labelText: 'دور باسن '),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) return 'لطفاً دور باسن را وارد کنید';
                                      if (double.tryParse(value) == null) return 'فقط عدد وارد کنید';
                                      return null;
                                    },
                                  ),
                                ),
                                ShakeWidget(
                                  shake: fieldErrors[3],
                                  child: TextFormField(
                                    controller: armController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(labelText: 'دور بازو '),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) return 'لطفاً دور بازو را وارد کنید';
                                      if (double.tryParse(value) == null) return 'فقط عدد وارد کنید';
                                      return null;
                                    },
                                  ),
                                ),
                                ShakeWidget(
                                  shake: fieldErrors[4],
                                  child: TextFormField(
                                    controller: thighController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(labelText: 'دور ران '),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) return 'لطفاً دور ران را وارد کنید';
                                      if (double.tryParse(value) == null) return 'فقط عدد وارد کنید';
                                      return null;
                                    },
                                  ),
                                ),
                                ShakeWidget(
                                  shake: fieldErrors[5],
                                  child: TextFormField(
                                    controller: shoulderController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(labelText: 'عرض شانه '),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) return 'لطفاً عرض شانه را وارد کنید';
                                      if (double.tryParse(value) == null) return 'فقط عدد وارد کنید';
                                      return null;
                                    },
                                  ),
                                ),
                                ShakeWidget(
                                  shake: fieldErrors[6],
                                  child: TextFormField(
                                    controller: bellyController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(labelText: 'دور شکم '),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) return 'لطفاً دور شکم را وارد کنید';
                                      if (double.tryParse(value) == null) return 'فقط عدد وارد کنید';
                                      return null;
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                PersianDatePicker(
                                  key: widget.datePickerKey,
                                  onDateChanged: (month, year) {
                                    print('تاریخ انتخاب شده: $month $year');
                                    setState(() {
                                      selectedMonth = month;
                                      selectedYear = year;
                                    });
                                  },
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  width: double.infinity,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      ElevatedButton(
                                        style: OutlinedButton.styleFrom(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: size.width/10, vertical: 18),
                                          backgroundColor: mzhColorThem1[5],
                                          foregroundColor: mzhColorThem1[2],
                                          side: BorderSide(color: mzhColorThem1[2]),
                                        ),
                                        onPressed: () async {
                                          bool isValid = _formKey.currentState!.validate();
                                          setState(() {
                                            fieldErrors = [
                                              waistController.text.isEmpty || double.tryParse(waistController.text) == null,
                                              chestController.text.isEmpty || double.tryParse(chestController.text) == null,
                                              hipsController.text.isEmpty || double.tryParse(hipsController.text) == null,
                                              armController.text.isEmpty || double.tryParse(armController.text) == null,
                                              thighController.text.isEmpty || double.tryParse(thighController.text) == null,
                                              shoulderController.text.isEmpty || double.tryParse(shoulderController.text) == null,
                                              bellyController.text.isEmpty || double.tryParse(bellyController.text) == null,
                                            ];
                                          });
                                          if (isValid){
                                            SizeModel size = SizeModel(
                                              id: 0, // در سرور به‌صورت UUID ساخته میشه، پس اینجا خالی بذار
                                              waist: double.parse(waistController.text),
                                              chest: double.parse(chestController.text),
                                              hips: double.parse(hipsController.text),
                                              arm: double.parse(armController.text),
                                              thigh: double.parse(thighController.text),
                                              shoulder: double.parse(shoulderController.text),
                                              belly: double.parse(bellyController.text),
                                              dateInsert: selectedYear.toString()+"/" +selectedMonth,
                                              userId: widget.userID, // مقدار مورد نظر شما
                                            );
                                            context
                                                .read<SizesBloc>()
                                                .add(CreateSize(size));
                                          }

                                        },
                                        child: Text("ذخیره",
                                            style: CustomTextStyle.textbutton),
                                      ),
                                      ElevatedButton(
                                        style: OutlinedButton.styleFrom(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: size.width/10, vertical: 18),
                                          backgroundColor: mzhColorThem1[5],
                                          foregroundColor: mzhColorThem1[2],
                                          side: BorderSide(color: mzhColorThem1[2]),
                                        ),
                                        onPressed: (){
                                          Navigator.pushReplacement(
                                              context,  MaterialPageRoute(
                                              builder: (_) => BlocProvider(
                                                create: (context) => SizesBloc()..add(LoadSizes( widget.userID)),
                                                child: HomePage(),
                                              )));

                                        }, child:  Text("بازگشت",
                                          style: CustomTextStyle.textbutton),)
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
}
