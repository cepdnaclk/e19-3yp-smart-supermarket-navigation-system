import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:shopwise_web/pages/dashboard/bar%20graph/bar_data.dart';

class MyBarGraph extends StatelessWidget {
  final List weeklySummary;
  const MyBarGraph({
    super.key,
    required this.weeklySummary,
  });

  @override
  Widget build(BuildContext context) {
    BarData mybarData = BarData(
        sun: weeklySummary[0],
        mon: weeklySummary[1],
        tue: weeklySummary[2],
        wed: weeklySummary[3],
        thu: weeklySummary[4],
        fri: weeklySummary[5],
        sat: weeklySummary[6]);

    mybarData.initializeBarData();

    return BarChart(
      BarChartData(
          maxY: 70,
          minY: 0,
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
                sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: getBottomTitles,
            )),
          ),
          barGroups: mybarData.barData
              .map((data) => BarChartGroupData(x: data.x, barRods: [
                    BarChartRodData(
                      toY: data.y,
                      width: 50,
                      borderRadius: BorderRadius.circular(4),
                    )
                  ]))
              .toList()),
    );
  }
}

Widget getBottomTitles(double value, TitleMeta meta) {
  const style = TextStyle(
    color: Color.fromARGB(255, 38, 50, 56),
    fontSize: 12,
    fontWeight: FontWeight.bold,
  );

  Widget text;
  switch (value.toInt()) {
    case 0:
      text = Text('Mon', style: style);
      break;
    case 1:
      text = Text('Tue', style: style);
      break;
    case 2:
      text = Text('Wed', style: style);
      break;
    case 3:
      text = Text('Thu', style: style);
      break;
    case 4:
      text = Text('Fri', style: style);
      break;
    case 5:
      text = Text('Sat', style: style);
      break;
    case 6:
      text = Text('Sun', style: style);
      break;
    default:
      text = Text('', style: style);
      break;
  }

  return SideTitleWidget(child: text, axisSide: meta.axisSide);
}
