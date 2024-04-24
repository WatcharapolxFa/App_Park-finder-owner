import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:parking_finder_app_provider/assets/colors/constant.dart';

class IncomeChart extends StatelessWidget {
  final List<dynamic> incomeData;
  final String dropdownValueFilter;
  final int filterMonths;

  const IncomeChart({
    super.key,
    required this.incomeData,
    required this.dropdownValueFilter,
    required this.filterMonths,
  });

  String mapValueToRange(int daysInMonth, double value) {
    if (dropdownValueFilter == "รายวัน") {
      return "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}";
    } else if (dropdownValueFilter == "รายสัปดาห์") {
      if (value == 0.0) {
        return "Thu";
      } else if (value == 1.0) {
        return "Fri";
      } else if (value == 2.0) {
        return "Sat";
      } else if (value == 3.0) {
        return "Sun";
      } else if (value == 4.0) {
        return "Mon";
      } else if (value == 5.0) {
        return "Tue";
      } else if (value == 6.0) {
        return "Wed";
      }
    } else if (dropdownValueFilter == "รายเดือน") {
      if (value == 0.0) {
        return "1-7";
      } else if (value == 1.0) {
        return "8-14";
      } else if (value == 2.0) {
        return "15-21";
      } else if (value == 3.0) {
        return "22-28";
      } else {
        return "28-$daysInMonth";
      }
    }

    if (value == 0.0) {
      int monthNow = DateTime.now().month;
      monthNow += value.toInt();
      if (monthNow > 12) {
        monthNow -= 12;
      }
      return monthNow.toString();
    } else if (value == 1.0) {
      int monthNow = DateTime.now().month;
      monthNow += value.toInt();
      if (monthNow > 12) {
        monthNow -= 12;
      }
      return monthNow.toString();
    } else if (value == 2.0) {
      int monthNow = DateTime.now().month;
      monthNow += value.toInt();
      if (monthNow > 12) {
        monthNow -= 12;
      }
      return monthNow.toString();
    } else if (value == 3.0) {
      int monthNow = DateTime.now().month;
      monthNow += value.toInt();
      if (monthNow > 12) {
        monthNow -= 12;
      }
      return monthNow.toString();
    } else if (value == 4.0) {
      int monthNow = DateTime.now().month;
      monthNow += value.toInt();
      if (monthNow > 12) {
        monthNow -= 12;
      }
      return monthNow.toString();
    } else if (value == 5.0) {
      int monthNow = DateTime.now().month;
      monthNow += value.toInt();
      if (monthNow > 12) {
        monthNow -= 12;
      }
      return monthNow.toString();
    } else if (value == 6.0) {
      int monthNow = DateTime.now().month;
      monthNow += value.toInt();
      if (monthNow > 12) {
        monthNow -= 12;
      }
      return monthNow.toString();
    } else if (value == 7.0) {
      int monthNow = DateTime.now().month;
      monthNow += value.toInt();
      if (monthNow > 12) {
        monthNow -= 12;
      }
      return monthNow.toString();
    } else if (value == 8.0) {
      int monthNow = DateTime.now().month;
      monthNow += value.toInt();
      if (monthNow > 12) {
        monthNow -= 12;
      }
      return monthNow.toString();
    } else if (value == 9.0) {
      int monthNow = DateTime.now().month;
      monthNow += value.toInt();
      if (monthNow > 12) {
        monthNow -= 12;
      }
      return monthNow.toString();
    } else if (value == 10.0) {
      int monthNow = DateTime.now().month;
      monthNow += value.toInt();
      if (monthNow > 12) {
        monthNow -= 12;
      }
      return monthNow.toString();
    } else {
      int monthNow = DateTime.now().month;
      monthNow += value.toInt();
      if (monthNow > 12) {
        monthNow -= 12;
      }
      return monthNow.toString();
    }
  }

  String monthNumberToShortString(int monthNumber) {
    DateTime date = DateTime(2024, monthNumber);
    String shortMonth = DateFormat.MMM().format(date);
    return shortMonth;
  }

  @override
  Widget build(BuildContext context) {
    return BarChart(mainData());
  }

  BarChartData mainData() {
    List<BarChartGroupData> barGroups = [];
    for (var i = 0; i < incomeData.length; i++) {
      var income = incomeData[i]["sum"].toDouble();
      barGroups.add(BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            y: income,
            colors: [AppColor.appPrimaryColor, AppColor.grapPuple],
            width: 15, // ตั้งค่าความกว้างของแท่ง
          ),
        ],
      ));
    }

    return BarChartData(
      titlesData: FlTitlesData(
          bottomTitles: SideTitles(
            showTitles: true,
            getTitles: (double value) {
              return mapValueToRange(31, value); // แสดงเฉพาะวันที่
            },
            reservedSize: 22, // ปรับความสูงสำหรับข้อความแกน X
          ),
          leftTitles: SideTitles(
            showTitles: true,
            margin: 0,
            getTextStyles: (context, _) => const TextStyle(fontSize: 12),
            getTitles: (value) {
              return value.toInt().toString();
            },
          ),
          rightTitles: SideTitles(showTitles: false),
          topTitles: SideTitles(showTitles: false)),
      gridData: FlGridData(show: false),
      borderData: FlBorderData(show: false),
      barGroups: barGroups,
      groupsSpace: 10, // ตั้งค่าระยะห่างระหว่างกลุ่มแท่ง
    );
  }
}
