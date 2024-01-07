import 'package:flutter/material.dart';
import 'package:shopwise_web/pages/dashboard/chart_built_in.dart';
import 'package:shopwise_web/pages/dashboard/card_grid_view.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
            padding: const EdgeInsets.all(10),
            height: 210,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              
              children: [
                const Text(
                  "Today's Sales",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: CardGridView()),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(10),
              child: const Row(
                children: [
                  Expanded(
                    child: LineChartSample1(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

            // Wrap Row with Expanded
            // child: Container(
            //   //height: 200,
            //   padding: const EdgeInsets.all(10),
            //   color: Colors.white,
            //   child:
              // CardGridView(),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //   children: [
                //     CustomCard(
                //       width: 100,
                //       height: 100,
                //       cardColor: Colors.blue.withOpacity(0.4),
                //       title: "8000",
                //       subtitle: "Total Sales",
                //       icon: Icons.shopping_bag,
                      
                //     ),
                //     CustomCard(
                //       width: 100,
                //       height: 100,
                //       cardColor: Colors.red.withOpacity(0.4),
                //       title: "100",
                //       subtitle: "Total Products",
                //       icon: Icons.production_quantity_limits,
                //     ),
                //     CustomCard(
                //       width: 100,
                //       height: 100,
                //       cardColor: Colors.green.withOpacity(0.4),
                //       title: "100",
                //       subtitle: "Total Categories",
                //       icon: Icons.category,
                //     ),
                //     CustomCard(
                //       width: 100,
                //       height: 100,
                //       cardColor: Colors.yellow.withOpacity(0.4),
                //       title: "100",
                //       subtitle: "Total Users",
                //       icon: Icons.person,
                //     ),
                //   ],
                // ),
              
            //),