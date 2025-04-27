import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:shahrzad/classes/color.dart';
import 'package:shahrzad/classes/style.dart';

class CustomLineChartWidget extends StatelessWidget {
  final List<FlSpot> spots;
  final List<String> verticalLabel;
  final String title;
  final List<Color> colorTheme;

  const CustomLineChartWidget({
    Key? key,
    required this.spots,
    required this.verticalLabel,
    required this.title,
    required this.colorTheme,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: mzhColorThem1[2],
      child: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Container(
            width: double.infinity,
            height: 40,
            child: Center(
              child: Text(
                "نمودار " + title,
                style: CustomTextStyle.headerchart,
              ),
            ),
          ),
          Divider(
            color: mzhColorThem1[4], // رنگ خط
            thickness: 5, // ضخامت خط
          ),
          SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: double.infinity,
              height: 400,
              decoration: BoxDecoration(
                color: colorTheme[0],
                borderRadius: BorderRadius.circular(5),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: LineChart(
                  LineChartData(
                    minX: 0,
                    maxX: 11,
                    borderData: FlBorderData(
                      show: true,
                      border: Border(
                        left: BorderSide(color: colorTheme[2], width: 3),
                        bottom: BorderSide(color: colorTheme[2], width: 3),
                      ),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: spots,
                        barWidth: 4,
                        color: colorTheme[1],
                      )
                    ],
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          getTitlesWidget: (value, meta) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Text(
                              value.toInt().toString(),
                              style: TextStyle(color: colorTheme[3]),
                            ),
                          ),
                        ),
                      ),
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          reservedSize: 80,
                          getTitlesWidget: (value, meta) {
                            String label = '';
                            if (value.toInt() >= 0 &&
                                value.toInt() < verticalLabel.length) {
                              label = verticalLabel[value.toInt()];
                            }
                            return Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: RotatedBox(
                                quarterTurns: 3,
                                child: Text(
                                  label,
                                  style: TextStyle(color: colorTheme[3]),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
