// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:track_expense/ViewModel/transaction_viewmodel.dart';
// import 'package:fl_chart/fl_chart.dart';

// class AnalysisScreen extends StatelessWidget {
//   const AnalysisScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final vm = Provider.of<TransactionViewModel>(context);

//     return Scaffold(
//       appBar: AppBar(title: const Text("Analysis")),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             const Text("Income vs Expense", style: TextStyle(fontSize: 18)),
//             const SizedBox(height: 16),
//             Expanded(
//               child: PieChart(
//                 PieChartData(
//                   sections: [
//                     PieChartSectionData(
//                       value: vm.totalIncome,
//                       color: Colors.green,
//                       title: "Income",
//                       radius: 60,
//                       titleStyle:
//                           const TextStyle(color: Colors.white, fontSize: 14),
//                     ),
//                     PieChartSectionData(
//                       value: vm.totalExpense,
//                       color: Colors.red,
//                       title: "Expense",
//                       radius: 60,
//                       titleStyle:
//                           const TextStyle(color: Colors.white, fontSize: 14),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             const Text("Monthly Overview", style: TextStyle(fontSize: 18)),
//             const SizedBox(height: 16),
//             Expanded(
//               child: BarChart(
//                 BarChartData(
//                   barGroups: [
//                     BarChartGroupData(x: 0, barRods: [
//                       BarChartRodData(
//                           toY: vm.totalIncome, color: Colors.green),
//                     ]),
//                     BarChartGroupData(x: 1, barRods: [
//                       BarChartRodData(
//                           toY: vm.totalExpense, color: Colors.red),
//                     ]),
//                   ],
//                   titlesData: FlTitlesData(
//                     bottomTitles: AxisTitles(
//                       sideTitles: SideTitles(
//                         showTitles: true,
//                         getTitlesWidget: (value, meta) {
//                           switch (value.toInt()) {
//                             case 0:
//                               return const Text("Income");
//                             case 1:
//                               return const Text("Expense");
//                             default:
//                               return const Text("");
//                           }
//                         },
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:track_expense/ViewModel/transaction_viewmodel.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';

// class AnalysisScreen extends StatelessWidget {
//   const AnalysisScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final vm = Provider.of<TransactionViewModel>(context);

//     // Data for charts
//     final List<_ChartData> pieData = [
//       _ChartData("Income", vm.totalIncome),
//       _ChartData("Expense", vm.totalExpense),
//     ];

//     final List<_ChartData> barData = [
//       _ChartData("Income", vm.totalIncome),
//       _ChartData("Expense", vm.totalExpense),
//     ];

//     return Scaffold(
//       appBar: AppBar(title: const Text("Analysis")),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             const Text("Income vs Expense", style: TextStyle(fontSize: 18)),
//             const SizedBox(height: 16),
//             Expanded(
//               child: SfCircularChart(
//                 legend: const Legend(isVisible: true),
//                 series: <CircularSeries<_ChartData, String>>[
//                   PieSeries<_ChartData, String>(
//                     dataSource: pieData,
//                     xValueMapper: (_ChartData data, _) => data.label,
//                     yValueMapper: (_ChartData data, _) => data.value,
//                     dataLabelSettings: const DataLabelSettings(isVisible: true),
//                   ),
//                 ],
//               ),
//             ),
         
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _ChartData {
//   final String label;
//   final double value;
//   _ChartData(this.label, this.value);
// }


import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:track_expense/ViewModel/transaction_viewmodel.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class AnalysisScreen extends StatelessWidget {
  const AnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<TransactionViewModel>(context);

    // Data for charts
    final List<_ChartData> pieData = [
      _ChartData("Income", vm.totalIncome),
      _ChartData("Expense", vm.totalExpense),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Analysis")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text("Income vs Expense", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 16),

            // Chart
            SizedBox(
              height: 250,
              child: SfCircularChart(
                legend: const Legend(isVisible: true),
                series: <CircularSeries<_ChartData, String>>[
                  PieSeries<_ChartData, String>(
                    dataSource: pieData,
                    xValueMapper: (_ChartData data, _) => data.label,
                    yValueMapper: (_ChartData data, _) => data.value,
                    dataLabelSettings: const DataLabelSettings(isVisible: true),
                  ),
                ],
              ),
            ),
           // const Divider(),
            const SizedBox(height: 8),

            // Title for records
            // const Align(
            //   alignment: Alignment.centerLeft,
            //   child: Text(
            //     "All Records",
            //     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            //   ),
            // ),
            // const SizedBox(height: 8),

            // Records List
            Expanded(
              child: vm.transactions.isEmpty
                  ? const Center(child: Text("No records available"))
                  : ListView.builder(
                      itemCount: vm.transactions.length,
                      itemBuilder: (context, index) {
                        final txn = vm.transactions[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: txn.type == "Income"
                                  ? Colors.green
                                  : Colors.red,
                              child: Text(
                                txn.type.substring(0, 1),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            title: Text("${txn.type} - ${txn.note}"),
                            subtitle: Text(txn.date),
                            trailing: Text(
                              "\$${txn.amount.toStringAsFixed(2)}",
                              style: TextStyle(
                                color: txn.type == "Income"
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChartData {
  final String label;
  final double value;
  _ChartData(this.label, this.value);
}
