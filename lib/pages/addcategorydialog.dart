import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/category/category_bloc.dart';

class AddCategortDialog extends StatefulWidget {
  final int coachCode;
  const AddCategortDialog(this.coachCode);

  @override
  State<AddCategortDialog> createState() => _AddCategortDialogState();
}

class _AddCategortDialogState extends State<AddCategortDialog> {
  late TextEditingController _nameController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameController = TextEditingController();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _nameController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
   
    return BlocListener<CategoryBloc, CategoryState>(
  listener: (context, state) {
    if(state is CategoryCreateSuccess)
      {
        Navigator.pop(context,[state.id , _nameController.text ]);
      }
  },
  child: AlertDialog(
      title:Text( 'افزودن گروه بندی جدید'),
      backgroundColor: Colors.limeAccent,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(maxLength: 50,
            controller: _nameController,
            keyboardType: TextInputType.text,
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
        ],
      ),
      actions: [
        ElevatedButton(
          child: const Text("تأیید"),
          onPressed: () {
            context.read<CategoryBloc>().add(AddCategoryEvent(widget.coachCode,_nameController.text));

          },
        ),
        ElevatedButton(
          child: const Text("لغو"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    ),
);
  }
}
