import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../classes/style.dart';
import '../../../feature_category/presenteation/bloc/category/category_bloc.dart';

class CoachCodeDialogPage extends StatefulWidget {

  final String getTitle;
  final String getContent;

  const CoachCodeDialogPage(
      {super.key, required this.getTitle, required this.getContent});

  @override
  State<CoachCodeDialogPage> createState() => _CoachCodeDialogPageState();
}

class _CoachCodeDialogPageState extends State<CoachCodeDialogPage> {
  late TextEditingController _coachcodeController;

  @override
  void initState() {
    super.initState();
    _coachcodeController = TextEditingController();
  }

  @override
  void dispose() {
    _coachcodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.limeAccent,
      title: Text(widget.getTitle, style: CustomTextStyle.alert_title_style),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(widget.getContent, style: CustomTextStyle.alert_content_style),
          const SizedBox(height: 12),
          TextField(maxLength: 4,
            controller: _coachcodeController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                   color: Colors.blue,
                   width: 2,
              ),
            ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 2),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // نمونه BlocBuilder داخل دیالوگ
          BlocBuilder<CategoryBloc, CategoryState>(
            builder: (context, state) {
              if (state is CategoryLoadingState) {
                return const CircularProgressIndicator();
              } else if (state is CategoryLoadSuccessState) {
                if(state.categiries.length > 0){
                  Navigator.pop(context,[state.categiries , _coachcodeController.text]);
                  Future.microtask(() {
                    context.read<CategoryBloc>().add(ResetCategoryEvent());
                  });

                }else{
                  return Text("گروه بندی برای مربی مورد نظر شما یافت نشد " , style: TextStyle(color: Colors.red , fontWeight: FontWeight.bold),);
                }
              } else if (state is CategoryLoadFailState) {
                return Text("Error");
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          child: const Text("تأیید"),
          onPressed: () {
            context.read<CategoryBloc>().add(LoadCategoryEvent(int.parse(_coachcodeController.text)));
           // Navigator.of(context).pop(_coachcodeController.text);
          },
        ),
        ElevatedButton(
          child: const Text("لغو"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}


