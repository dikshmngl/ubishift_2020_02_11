import 'dart:math';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class PieOutsideLabelChart extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;
  PieOutsideLabelChart(this.seriesList, {this.animate});
  factory PieOutsideLabelChart.withRandomData(info) {
    return new PieOutsideLabelChart(_createRandomData(info));
  }
  static List<charts.Series<LinearSales, String>> _createRandomData(info) {
   // print('------->>>>');
   // print('------->>>>');
  //  print(info);
    int total=int.parse(info[0]['absent'])+int.parse(info[0]['present']);
    int set=(total/10).round();
    final data = [

      new LinearSales('EL', int.parse(info[0]['early'])),
      new LinearSales('P', int.parse(info[0]['present'])),
      new LinearSales('A', int.parse(info[0]['absent'])),
      new LinearSales('LC', int.parse(info[0]['late'])),
    ];
    return [
      new charts.Series<LinearSales, String>(
        id: 'Attendance',
        colorFn: (LinearSales sales, _) {
          // Bucket the measure column value into 3 distinct colors.
         // final bucket = sales.sales / 0.5;

          if (sales.sales < set) {
            return charts.MaterialPalette.yellow.shadeDefault;
          }else if (sales.sales<(set*2)) {
            return charts.MaterialPalette.cyan.shadeDefault;
          } else if (sales.sales < (set*3)) {
            return charts.MaterialPalette.blue.shadeDefault;
          } else if (sales.sales < (set*4)) {
            return charts.MaterialPalette.gray.shadeDefault;
          }else if (sales.sales < (set*5)) {
            return charts.MaterialPalette.indigo.shadeDefault;
          }else if (sales.sales < (set*6)) {
            return charts.MaterialPalette.lime.shadeDefault;
          }else if (sales.sales < (set*7)) {
            return charts.MaterialPalette.indigo.shadeDefault;
          }else if (sales.sales < (set*8)) {
            return charts.MaterialPalette.deepOrange.shadeDefault;
          }else if (sales.sales < (set*9)) {
            return charts.MaterialPalette.teal.shadeDefault;
          }
          else
            return charts.MaterialPalette.green.shadeDefault;
        },
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,

        fillColorFn: (LinearSales sales, _) => charts.Color.fromHex(code: '#DCDCDC00'),
        data: data,
        // Set a label accessor to control the text of the arc label.
        labelAccessorFn: (LinearSales row, _) => '${row.year}: ${row.sales}',
      )
    ];
  }
  //////-------------------last 7/30 days attn chart-start
  factory PieOutsideLabelChart.withRandomData_range(info) {
    return new PieOutsideLabelChart(_createRandomData_range(info));
  }
  static List<charts.Series<LinearSales, String>> _createRandomData_range(info) {
  //   print('------->>>>');
  //   print('------->>>>');
 //   //  print(info);
    //int total=int.parse(info[0]['absent'])+int.parse(info[0]['present']);
    //int set=(total/10).round();
    final data = [new LinearSales('', 0)];/*
      new LinearSales('LC', int.parse(info[0]['late'])),
      new LinearSales('EL', int.parse(info[0]['early'])),
      new LinearSales('P', int.parse(info[0]['present'])),
      new LinearSales('A', int.parse(info[0]['absent'])),
    ];*/
     data.clear();
  //  print('I am called-- chart');
    for(int i=0;i<info.length;i++){
    //  print(info[i]['date']);
      data.add(new LinearSales(info[i]['date'].toString(), int.parse(info[i]['total'])));
    }
    return [
      new charts.Series<LinearSales, String>(
        id: 'Attendance_range',
        domainFn: (LinearSales sales, _) => sales.year,
        measureFn: (LinearSales sales, _) => sales.sales,

        fillColorFn: (LinearSales sales, _) => charts.Color.fromHex(code: '#DCDCDC00'),
        data: data,
        // Set a label accessor to control the text of the arc label.
        labelAccessorFn: (LinearSales row, _) => '${row.year}: ${row.sales}',
      )
    ];
  }
  //////-------------------last 7/30 days attn chart-close
  @override
  Widget build(BuildContext context) {
    return new charts.PieChart(seriesList,
        animate: animate,animationDuration: Duration(milliseconds: 1200),
        defaultRenderer: new charts.ArcRendererConfig(
            arcRendererDecorators: [
              new charts.ArcLabelDecorator(
                  labelPosition: charts.ArcLabelPosition.auto,
                  outsideLabelStyleSpec: charts.TextStyleSpec(
                    color: charts.Color.fromHex(code: '#28282800'),
                    fontSize: 14,
                  ),
                insideLabelStyleSpec: charts.TextStyleSpec(
                  color: charts.Color.fromHex(code: '#FFFFFF00'),
                  fontSize: 14,
                ),labelPadding: 5,

              ),

        ]));
  }
}
class LinearSales {
  final String year;
  final int sales;
  LinearSales(this.year, this.sales);
}
