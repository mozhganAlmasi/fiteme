import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/size/sizes_bloc.dart';
import '../classes/color.dart';
import '../classes/style.dart';
import '../models/size_model.dart';
import '../widgets/customchartwidget.dart';
import 'home.dart';

class ShowChartPage extends StatelessWidget {
  final String userID;
  final List<SizeModel> lstSize;
  final String title;


  const ShowChartPage(
      {super.key,
      required this.userID,
      required this.lstSize,
      required this.title});

  @override
  Widget build(BuildContext context) {
    late List<FlSpot> dataset = [];
    List<String> verticalLabel = [];
    List<FlSpot> getChartData(List<SizeModel> lstSize) {
      return List.generate(lstSize.length, (index) {
        final reversedIndex = lstSize.length - 1 - index; // index معکوس
        final size = lstSize[reversedIndex];
        double value;

        switch (title) {
          case 'دور کمر':
            value = size.waist ?? 0;
            break;
          case 'دور باسن':
            value = size.hips ?? 0;
            break;
          case 'دور بازو':
            value = size.arm ?? 0;
            break;
          case  'دور سینه':
            value = size.chest ?? 0;
            break;
          case 'سرشانه':
            value = size.shoulder ?? 0;
            break;
          case 'دور شکم':
            value = size.belly ?? 0;
            break;
          case 'دور ران':
            value = size.thigh ?? 0;
            break;
          default:
            value = 0;
        }
        return FlSpot(index.toDouble(),
            value ?? 0); // یا size.dorBasan و ... بسته به نیاز
      });
    }

    List<String> getChartLable(List<SizeModel> lstSize) {
      return List.generate(lstSize.length, (index) {
        final reversedIndex = lstSize.length - 1 - index; // index معکوس
        final size = lstSize[reversedIndex];
        return (size.dateInsert ?? ''); // یا size.dorBasan و ... بسته به نیاز
      });
    }

    dataset = getChartData(lstSize);
    verticalLabel = getChartLable(lstSize);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              child: CustomLineChartWidget(
                spots: dataset,
                verticalLabel: verticalLabel,
                colorTheme: [
                  mzhColorThem1[6],
                  Colors.greenAccent,
                  Colors.red,
                  mzhColorThem1[9]
                ],
                title: title,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                backgroundColor: mzhColorThem1[5],
                foregroundColor: mzhColorThem1[2],
                side: BorderSide(color: mzhColorThem1[2]),
              ),
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) => BlocProvider(
                              create: (context) =>
                                  SizesBloc()..add(SizesLoadEvent(userID)),
                              child: HomePage(),
                            )));
              },
              child: Text("بازگشت", style: CustomTextStyle.textbutton),
            )
          ],
        ),
      ),
    );
  }
}
