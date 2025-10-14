import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shahrzad/blocs/category/category_bloc.dart';
import 'package:shahrzad/feature/feature_user/presentation/bloc/user/users_bloc.dart';
import 'package:shahrzad/models/category_model.dart';
import 'package:shahrzad/pages/addcategorydialog.dart';

import '../classes/color.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../core/widgets/customalertdialog.dart';

class Managecategory extends StatefulWidget {
  final int coachCode;

  const Managecategory(this.coachCode);

  @override
  State<Managecategory> createState() => _ManagecategoryState();
}

class _ManagecategoryState extends State<Managecategory> {
  List<CategoryModel> lstCategory =[];
  late int deletItemID;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            "مدیریت گروه بندی",
            style: GoogleFonts.vazirmatn(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Container(
          color: mzhColorThem1[5],
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: BlocConsumer<CategoryBloc, CategoryState>(
              listener: (context, state) {
                if (state is CategoryDeletSuccessState) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    // تابع async ناشناس برای استفاده از await
                    () async {
                      await customDialogBuilder(
                        context,
                        "تبریک",
                        "حذف با موفقیت انجام شد",
                      );

                      setState(() {
                        lstCategory.removeWhere(
                          (item) => item.id == deletItemID,
                        );
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
                } else if (state is CategoryLoadSuccessState) {
                  lstCategory = state.categiries;
                  return buildListVIew();
                }
                return buildListVIew();
              },
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          tooltip: "افزودن",
          onPressed: () {
            openAddCategoryDialog();
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  Widget buildListVIew() {
    return ListView.builder(
      itemCount: lstCategory.length,
      itemBuilder: (context, index) {
        final item = lstCategory[index];
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 6,
          margin: EdgeInsets.symmetric(vertical: 10),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(lstCategory[index].categoryName ?? ''),
                Tooltip(
                  message: 'حذف',
                  child: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      deletItemID = lstCategory[index].id;
                      _deleteItem(deletItemID);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void openAddCategoryDialog() async {
    final result = await showDialog(
      context: context,
      builder: (context) => BlocProvider.value(
        value: context.read<CategoryBloc>(),
        child: AddCategortDialog((widget.coachCode)),
      ),
    );
    CategoryModel tempCategory = CategoryModel(
      id: result[0],
      categoryName: result[1],
      coachCode: widget.coachCode,
    );

    setState(() {
      lstCategory.add(tempCategory);
    });
  }

  void _deleteItem(int id) async {
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
      context.read<CategoryBloc>().add(DeletCategoryEvent(id));
    }
  }
}
