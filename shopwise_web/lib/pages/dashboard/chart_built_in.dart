import 'package:flutter/material.dart';
import 'package:shopwise_web/pages/dashboard/bar%20graph/bar_grapg.dart';
import 'package:shopwise_web/pages/product_placement/database_manager.dart';

class LineChartSample1 extends StatefulWidget {
  const LineChartSample1({super.key});

  @override
  State<StatefulWidget> createState() => LineChartSample1State();
}

class LineChartSample1State extends State<LineChartSample1> {
  //list of customers
  List<double> weeklySummary = [12, 15, 56, 2, 10, 10, 10];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weekly Customer Summary',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true, // to center the title
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20), // Add space at the top
        child: FutureBuilder<List>(
          future: Future.wait([
            FireStoreDataBase().getData(),
            FireStoreDataBase().getOrderData(),
            FireStoreDataBase().getCustomerData(),
          ]),
          builder:
              (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(); // or some other widget
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              List products = snapshot.data![0];
              List orders = snapshot.data![1];
              List customers = snapshot.data![2];
              debugPrint("hola");
              debugPrint(customers.toString());

              List dates = customers
                  .map((item) => item['shopping_date'].toDate())
                  .toList();

              List<String> daysOfWeek = [
                'Monday',
                'Tuesday',
                'Wednesday',
                'Thursday',
                'Friday',
                'Saturday',
                'Sunday'
              ];
              List<String> datesOfWeek =
                  dates.map((date) => daysOfWeek[date.weekday - 1]).toList();
              debugPrint("dates");
              debugPrint(dates.toString());
              debugPrint(datesOfWeek.toString());

              List<int> counts = List<int>.generate(7, (index) => 0);

              for (String day in datesOfWeek) {
                int index = daysOfWeek.indexOf(day);
                counts[index]++;
              }

              debugPrint(counts.toString());

              return SizedBox(
                height: 700,
                child: MyBarGraph(
                  weeklySummary: counts,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
