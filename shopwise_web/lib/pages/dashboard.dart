import 'package:flutter/material.dart';
import 'package:shopwise_web/widgets/custom_card.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: [
          Expanded(
            // Wrap Row with Expanded
            child: Row(
              children: [
                Expanded(
                  // Wrap each CustomCard with Expanded
                  child: CustomCard(
                    title: "8000",
                    subtitle: "Total Sales",
                    icon: Icons.shopping_bag,
                  ),
                ),
                Expanded(
                  child: CustomCard(
                    title: "100",
                    subtitle: "Total Products",
                    icon: Icons.production_quantity_limits,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
