import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shahrzad/blocs/category/category_bloc.dart';
import 'package:shahrzad/blocs/size/sizes_bloc.dart';
import 'package:shahrzad/blocs/user/users_bloc.dart';
import 'package:shahrzad/classes/color.dart';
import 'package:shahrzad/classes/style.dart';
import 'package:shahrzad/pages/addsizepage.dart';
import 'package:shahrzad/pages/adminpage.dart';
import 'package:shahrzad/pages/editprofilepage.dart';
import 'package:shahrzad/pages/loginpage.dart';
import 'package:shahrzad/pages/manageCategory.dart';
import 'package:shahrzad/pages/showchartpage.dart';
import '../classes/appexisthandler.dart';
import '../cubit/userinfo_cubit.dart';
import '../models/size_model.dart';
import '../widgets/customalertdialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<SizeModel> lstSize = [];
  late String userID; // متغیر برای ذخیره userID
  late int userRole; // متغیر برای ذخیره userRole
  late int coachCode;

  @override
  void initState() {
    super.initState();
    // اطلاعات userID و userRole را از Cubit می‌خوانیم و در متغیر ذخیره می‌کنیم.
    final userInfo = context.read<UserinfoCubit>().state;
    if (userInfo is UserinfoLoaded) {
      userID = userInfo.userID;
      userRole = userInfo.userRole;
      coachCode = userInfo.coachCode;
    }
  }

  void _deleteItem(int index, int rowID) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("تأیید حذف"),
        content: const Text("آیا از حذف این آیتم مطمئن هستید؟"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("لغو"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text("حذف"),
          ),
        ],
      ),
    );

    if (confirm == true) {
      // فقط در صورتی حذف کن که کاربر تأیید کرده باشه
      context.read<SizesBloc>().add(SizeDeletEvent(userID, rowID));
    }
  }

  void _onMenuSelected(BuildContext context, String value) {
    if (value == 'edit_profile') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => UsersBloc()..add(UserGetEvant(userID)),
            child: EditProfilePage(),
          ),
        ),
      );
    } else if (value == 'manag_users') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => UsersBloc()..add(UsersLoadEvent(coachCode)),
            child: AdminPage(),
          ),
        ),
      );
    } else if (value == 'manag_category') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => CategoryBloc()..add(LoadCategoryEvent(coachCode)),
            child: Managecategory(coachCode),
          ),
        ),
      );
    } else if (value == 'exit') {
      AppExitHandler.exitApp(context, loginPage: LoginPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // حذف آیکون back
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) => _onMenuSelected(context, value),
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                value: 'edit_profile',
                child: Text('ویرایش پروفایل'),
              ),
              if (userRole == 1)
                PopupMenuItem(
                  value: 'manag_users',
                  child: Text('مدیریت لیست کاربران'),
                ),
              if (userRole == 1)
                PopupMenuItem(
                  value: 'manag_category',
                  child: Text('مدیریت لیست گروه بندی'),
                ),
              PopupMenuItem(value: 'exit', child: Text(' خروج')),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Container(
          color: mzhColorThem1[5],
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: BlocListener<SizesBloc, SizesState>(
              listener: (context, state) {
                // TODO: implement listener
                if (state is SizeLoadSuccess) {
                  lstSize = state.lstSize;
                } else if (state is SizeDeletSuccess) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    // تابع async ناشناس برای استفاده از await
                    () async {
                      await customDialogBuilder(
                        context,
                        "تبریک",
                        "حذف با موفقیت انجام شد",
                      );

                      setState(() {
                        lstSize.removeWhere((item) => item.id == state.rowID);
                      });
                    }(); // اجرای فوری تابع async
                  });
                } else if (state is SizeDeleteFail) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    // تابع async ناشناس برای استفاده از await
                    () async {
                      await customDialogBuilder(
                        context,
                        "خطا",
                        "مشکلی در حذف اندازه پیش آمده",
                      );
                    }(); // اجرای فوری تابع async
                  });
                }
              },
              child: BlocBuilder<SizesBloc, SizesState>(
                builder: (context, state) {
                  if (state is SizeLoading) {
                    return const Center(
                      child: SizedBox(
                        width: 60,
                        height: 60,
                        child: CircularProgressIndicator(
                          strokeWidth: 6,
                          color: Colors.deepPurple, // یا هر رنگی که خواستی
                        ),
                      ),
                    );
                  } else if (state is SizeLoadSuccess ||
                      state is SizeDeletSuccess) {
                    return Container(
                      color: mzhColorThem1[2],
                      child: Column(
                        children: [
                          if (userRole == 1)
                            Container(
                              color: mzhColorThem1[3],
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "کد مربیگری شما : " + coachCode.toString(),
                                  style: CustomTextStyle.textbutton,
                                ),
                              ),
                            ),
                          Expanded(
                            child: AnimationLimiter(
                              child: ListView.builder(
                                itemCount: lstSize.length,
                                padding: const EdgeInsets.all(12),
                                itemBuilder: (context, index) {
                                  final item = lstSize[index];
                                  return AnimationConfiguration.staggeredList(
                                    position: index,
                                    duration: const Duration(milliseconds: 400),
                                    child: SlideAnimation(
                                      verticalOffset: 50,
                                      child: FadeInAnimation(
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          elevation: 6,
                                          margin: EdgeInsets.symmetric(
                                            vertical: 10,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(16),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              children: [
                                                Text(
                                                  'تاریخ اندازه گیری : ${item.dateInsert}',
                                                  style: GoogleFonts.vazirmatn(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                Wrap(
                                                  spacing: 10,
                                                  runSpacing: 6,
                                                  children: item
                                                      .toDisplayMap()
                                                      .entries
                                                      .map(
                                                        (e) => ActionChip(
                                                          avatar: Icon(
                                                            Icons.insights,
                                                            size: 20,
                                                            color:
                                                                Colors.purple,
                                                          ),
                                                          label: Text(
                                                            '${e.key}: ${e.value.toString()} cm',
                                                            style:
                                                                GoogleFonts.vazirmatn(
                                                                  fontSize: 14,
                                                                ),
                                                          ),
                                                          backgroundColor:
                                                              Colors
                                                                  .teal
                                                                  .shade50,
                                                          onPressed: () {
                                                            Navigator.pushReplacement(
                                                              context,
                                                              MaterialPageRoute(
                                                                builder: (context) =>
                                                                    ShowChartPage(
                                                                      userID:
                                                                          userID,
                                                                      lstSize:
                                                                          lstSize,
                                                                      title:
                                                                          e.key,
                                                                    ),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      )
                                                      .toList(),
                                                ),
                                                const SizedBox(height: 12),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Tooltip(
                                                      message: 'حذف',
                                                      child: IconButton(
                                                        icon: Icon(
                                                          Icons.delete,
                                                          color: Colors.red,
                                                        ),
                                                        onPressed: () =>
                                                            _deleteItem(
                                                              index,
                                                              item.id,
                                                            ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (state is SizeLoadFail || state is SizeEmpty) {
                    return Container(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            children: [
                              if (userRole == 1)
                                Container(
                                  color: mzhColorThem1[3],
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "کد مربیگری شما : " +
                                          coachCode.toString(),
                                      style: CustomTextStyle.textbutton,
                                    ),
                                  ),
                                ),
                              SizedBox(height: 50),
                              Text(
                                "هیچ اطلاعاتی برای نمایش وجود ندارد ، لطفا با انتخاب گزینه افزودن ، سایز های خود را به برنامه اضافه کنید",
                                style: CustomTextStyle.textinputdata,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  return Container();
                },
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "افزودن",
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (context) => SizesBloc(),
                child: AddsizePage(userID: userID),
              ),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
