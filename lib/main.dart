import 'package:flutter/material.dart';
import 'screen/sale_chart.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ChartDemo());
}

class ChartDemo extends StatelessWidget {
  const ChartDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        initialRoute: SaleChart.id,
        routes: {
          SaleChart.id: (context) => const SaleChart(),
        },
        debugShowCheckedModeBanner: false);
  }
}
