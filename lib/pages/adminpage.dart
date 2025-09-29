import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shahrzad/blocs/user/users_bloc.dart';
import 'package:shahrzad/classes/style.dart';
import 'package:shahrzad/models/user_model.dart';
import '../classes/color.dart';
import '../widgets/customalertdialog.dart';
import '../widgets/userstatusselector.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  List<UserModel> lstUser = [];
  List<UserModel> lstUserMain = [];
  String? selectedGroup;
  int selectedIndex = 1;
  String deletItemID = "";
  final List<String> lstGroupname = [
    'همه گروه ها',
    'ایروبیک',
    'ایروبیک فانکشنال',
    'CX',
  ];

  void _deleteItem(String phoneNumber) async {
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
      context.read<UsersBloc>().add(DeleteUserEvent(phoneNumber));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context); // برای بازگشت به صفحه قبلی
            },
          ),
          title: Text(
            "مدیریت کاربران",
            style: GoogleFonts.vazirmatn(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [],
        ),
        body: SafeArea(
          child: Container(
            color: mzhColorThem1[5],
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: BlocConsumer<UsersBloc, UsersState>(
                listener: (context, state) {
                  // TODO: implement listener
                  if (state is UserLoadedState) {
                    lstUser = state.users;
                    lstUserMain = state.users;
                  } else if (state is UserDeletSuccessState) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      // تابع async ناشناس برای استفاده از await
                      () async {
                        await customDialogBuilder(
                          context,
                          "تبریک",
                          "حذف با موفقیت انجام شد",
                        );

                        setState(() {
                          lstUser.removeWhere((item) => item.id == deletItemID);
                        });
                      }(); // اجرای فوری تابع async
                    });
                  } else if (state is UserDeletFailState) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      // تابع async ناشناس برای استفاده از await
                      () async {
                        await customDialogBuilder(
                          context,
                          "خطا",
                          "مشکلی در حذف اطلاعات پیش آمده .",
                        );
                        setState(() {
                          // lstUser.removeWhere((item) => item.id == state.);
                        });
                      }(); // اجرای فوری تابع async
                    });
                  }
                },

                builder: (context, state) {
                  if (state is UserLoadingState) {
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
                  } else if (state is UserLoadedState ||
                      state is UserDeletSuccessState ||
                      state is UpdateUserSuccessState) {
                    return Container(
                      color: mzhColorThem1[2],
                      child: Column(
                        children: [
                          DropdownButtonFormField<String>(
                            value: selectedGroup,
                            hint: Text(' همه گروه ها'),
                            items: lstGroupname.map((String group) {
                              return DropdownMenuItem<String>(
                                value: group,
                                child: Text(group),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                selectedGroup = newValue;
                                selectedIndex = lstGroupname.indexOf(newValue!);
                                (selectedIndex == 0)
                                    ? lstUser = lstUserMain
                                    : lstUser = lstUserMain
                                          .where(
                                            (user) =>
                                                user.groupid == selectedIndex,
                                          )
                                          .toList();
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
                          Expanded(
                            child: AnimationLimiter(
                              child: ListView.builder(
                                itemCount: lstUser.length,
                                padding: const EdgeInsets.all(12),
                                itemBuilder: (context, index) {
                                  final item = lstUser[index];
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
                                                  ' ${item.name}  ${item.family}',
                                                  style: GoogleFonts.vazirmatn(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 20),
                                                Wrap(
                                                  children: [
                                                    Center(
                                                      child: UserStatusSelector(
                                                        initialStatus:
                                                            (item.active)
                                                            ? 'active'
                                                            : 'inactive',
                                                        // یا 'active'
                                                        onStatusChanged: (status) {
                                                          UserModel
                                                          user = UserModel(
                                                            id: item.id,
                                                            name: item.name,
                                                            family: item.family,
                                                            groupid:
                                                                selectedIndex,
                                                            role: item.role,
                                                            email:
                                                                "test@almaseman.ir",
                                                            phonenumber: item
                                                                .phonenumber,
                                                            password: "",
                                                            active:
                                                                (item.active)
                                                                ? false
                                                                : true,
                                                            coach_code:
                                                                item.coach_code,
                                                          );
                                                          context
                                                              .read<UsersBloc>()
                                                              .add(
                                                                (UserUpdateEvent(
                                                                  user,
                                                                )),
                                                              );
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 12),
                                                ElevatedButton(
                                                  style:
                                                      OutlinedButton.styleFrom(
                                                        padding:
                                                            EdgeInsets.symmetric(
                                                              horizontal:
                                                                  size.width /
                                                                  10,
                                                              vertical: 18,
                                                            ),
                                                        backgroundColor:
                                                            mzhColorThem1[5],
                                                        foregroundColor:
                                                            mzhColorThem1[2],
                                                        side: BorderSide(
                                                          color:
                                                              mzhColorThem1[2],
                                                        ),
                                                      ),
                                                  onPressed: () {
                                                    customDialogBuilder(
                                                      context,
                                                      "مشخصات کاربر",
                                                      item.name +
                                                          " " +
                                                          item.family +
                                                          "\n\n" +
                                                          item.phonenumber +
                                                          "\n\n" +
                                                          item.email,
                                                    );
                                                  },
                                                  child: Text(
                                                    "مشاهده مشخصات کاربر",
                                                    style: CustomTextStyle
                                                        .textbutton,
                                                  ),
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
                                                        onPressed: () {
                                                          deletItemID =
                                                              item.id!;
                                                          _deleteItem(
                                                            item.phonenumber,
                                                          );
                                                        },
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
                  } else if (state is UserErrorState) {
                    return Container(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            "خطا در دریافت اطلاعات",
                            style: CustomTextStyle.textinputdata,
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
    );
  }
}
