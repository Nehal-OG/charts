import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:charts/modal/sale.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SaleChart extends StatefulWidget {
  static const String id = 'salechart';

  const SaleChart({Key? key}) : super(key: key);
  @override
  State<SaleChart> createState() => _SalesHomePageState();
}

class _SalesHomePageState extends State<SaleChart> {
  late List<charts.Series<Sales, String>> _seriesBarData;
  late List<Sales> mydata;
  _generateData(mydata) {
    // ignore: deprecated_member_use
    _seriesBarData = <charts.Series<Sales, String>>[];
    _seriesBarData.add(
      charts.Series(
        domainFn: (Sales sales, _) => sales.saleYear.toString(),
        measureFn: (Sales sales, _) => sales.saleVal,
        colorFn: (Sales sales, _) =>
            charts.ColorUtil.fromDartColor(Color(int.parse(sales.colorVal))),
        id: 'Sales',
        data: mydata,
        labelAccessorFn: (Sales row, _) => row.saleYear,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sales')),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Sales').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const LinearProgressIndicator();
        } else {
           //List<Sales> sales = snapshot.data!.docs!.map<Widget>((shapshot) => Sales.fromMap(snapshot.data!).toList());
          List<Sales> sales = [];
          final salesData = snapshot.data!.docs;
          print('Sales Data');
          for (var data in salesData) {
            print(data.get("colorVal"));
            print(data.get("saleVal"));
          }

          return _buildChart(context, sales);
        }
      },
    );
  }

  Widget _buildChart(BuildContext context, List<Sales> saledata) {
    mydata = saledata;
    _generateData(mydata);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Column(
          children: <Widget>[
            const Text(
              'Sales by Year',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Expanded(
              child: charts.BarChart(
                _seriesBarData,
                animate: true,
                animationDuration: const Duration(seconds: 5),
                behaviors: [
                  charts.DatumLegend(
                    entryTextStyle: charts.TextStyleSpec(
                        color: charts.MaterialPalette.purple.shadeDefault,
                        fontFamily: 'Georgia',
                        fontSize: 18),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
