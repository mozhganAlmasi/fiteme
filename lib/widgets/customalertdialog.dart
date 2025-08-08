import 'package:flutter/material.dart';

import '../classes/style.dart';

Future<void> customDialogBuilder(BuildContext context , String getTitle ,String getContent ) {
   String title = getTitle;
   String contentText = getContent;
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.limeAccent,
        title: Text(title , style: CustomTextStyle.alert_title_style,),
        content: Wrap(
          children: [
             Text(
             contentText
              , style: CustomTextStyle.alert_content_style,),
          ],
        ),
        actions: <Widget>[
          ElevatedButton(
            style: OutlinedButton.styleFrom(
              backgroundColor: Colors.amber,
              shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('بستن صفحه' , style: CustomTextStyle.alert_action_style,),
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),

        ],
      );
    },
  );
}


