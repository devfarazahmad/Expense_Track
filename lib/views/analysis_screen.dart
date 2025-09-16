

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:track_expense/ViewModel/transaction_viewmodel.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';

// class AnalysisScreen extends StatefulWidget {
//   const AnalysisScreen({super.key});

//   @override
//   State<AnalysisScreen> createState() => _AnalysisScreenState();
// }

// class _AnalysisScreenState extends State<AnalysisScreen> {
//   String? selectedCategory; // null => show all, "Income" or "Expense" => filter

//   @override
//   Widget build(BuildContext context) {
//     final vm = Provider.of<TransactionViewModel>(context);

//     // Data for charts
//     final List<_ChartData> pieData = [
//       _ChartData("Income", vm.totalIncome),
//       _ChartData("Expense", vm.totalExpense),
//     ];

//     // Choose transactions to show based on selectedCategory
//     final filteredTransactions = selectedCategory == null
//         ? vm.transactions
//         : vm.transactions.where((txn) => txn.type == selectedCategory).toList();

//     return Scaffold(
//       appBar: AppBar(title: const Text("Analysis")),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             const Text("Income vs Expense", style: TextStyle(fontSize: 18)),
//             const SizedBox(height: 16),

//             // Chart area
//             SizedBox(
//               height: 250,
//               child: SfCircularChart(
//                 legend: const Legend(isVisible: true),
//                 series: <CircularSeries<_ChartData, String>>[
//                   PieSeries<_ChartData, String>(
//                     dataSource: pieData,
//                     xValueMapper: (_ChartData data, _) => data.label,
//                     yValueMapper: (_ChartData data, _) => data.value,
//                     dataLabelSettings: const DataLabelSettings(isVisible: true),

//                     // ✅ Separate slices with space
//                     explode: true,
//                     explodeAll: true,
//                     explodeOffset: '10%', // control gap size

//                     // Callback when a slice is tapped:
//                     onPointTap: (ChartPointDetails details) {
//                       final idx = details.pointIndex;
//                       if (idx == null) return;
//                       final tappedLabel = pieData[idx].label;
//                       setState(() {
//                         if (selectedCategory == tappedLabel) {
//                           selectedCategory = null; // toggle off
//                         } else {
//                           selectedCategory = tappedLabel;
//                         }
//                       });
//                     },
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 8),

//             // Optional small subtitle showing current filter:
//             if (selectedCategory != null)
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 6.0),
//                 child: Text(
//                   'Showing: $selectedCategory transactions',
//                   style: const TextStyle(fontWeight: FontWeight.w600),
//                 ),
//               ),

//             // Transactions list (LIFO: latest first)
//             Expanded(
//               child: filteredTransactions.isEmpty
//                   ? const Center(child: Text("No records available"))
//                   : ListView.builder(
//                       itemCount: filteredTransactions.length,
//                       itemBuilder: (context, index) {
//                         // LIFO: latest first
//                         final txn = filteredTransactions[
//                             filteredTransactions.length - 1 - index];
//                         return Card(
//                           margin: const EdgeInsets.symmetric(vertical: 6),
//                           child: ListTile(
//                             leading: CircleAvatar(
//                               backgroundColor: txn.type == "Income"
//                                   ? Colors.green
//                                   : Colors.red,
//                               child: Text(
//                                 txn.type.substring(0, 1),
//                                 style: const TextStyle(color: Colors.white),
//                               ),
//                             ),
//                             title: Text("${txn.type} - ${txn.note}"),
//                             subtitle: Text(txn.date),
//                             trailing: Text(
//                               "\$${txn.amount.toStringAsFixed(2)}",
//                               style: TextStyle(
//                                 color: txn.type == "Income"
//                                     ? Colors.green
//                                     : Colors.red,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         );
//                       },
//                     ),
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

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  String selectedView = "All"; // Dropdown value: All, Income, Expense

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<TransactionViewModel>(context);

    // Prepare chart data
    List<_ChartData> chartData;
    List filteredTransactions;

    if (selectedView == "Income") {
      filteredTransactions =
          vm.transactions.where((txn) => txn.type == "Income").toList();
      // Group by note for income
      final Map<String, double> incomeMap = {};
      for (var txn in filteredTransactions) {
        incomeMap[txn.note] = (incomeMap[txn.note] ?? 0) + txn.amount;
      }
      chartData =
          incomeMap.entries.map((e) => _ChartData(e.key, e.value)).toList();
    } else if (selectedView == "Expense") {
      filteredTransactions =
          vm.transactions.where((txn) => txn.type == "Expense").toList();
      // Group by note for expenses
      final Map<String, double> expenseMap = {};
      for (var txn in filteredTransactions) {
        expenseMap[txn.note] = (expenseMap[txn.note] ?? 0) + txn.amount;
      }
      chartData =
          expenseMap.entries.map((e) => _ChartData(e.key, e.value)).toList();
    } else {
      filteredTransactions = vm.transactions;
      chartData = [
        _ChartData("Income", vm.totalIncome),
        _ChartData("Expense", vm.totalExpense),
      ];
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Analysis")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Dropdown for selecting view
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("View: ",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: selectedView,
                  items: const [
                    DropdownMenuItem(value: "All", child: Text("All")),
                    DropdownMenuItem(value: "Income", child: Text("Income")),
                    DropdownMenuItem(value: "Expense", child: Text("Expense")),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedView = value!;
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Chart area
            SizedBox(
              height: 250,
              child: SfCircularChart(
                legend: const Legend(isVisible: true),
                series: <CircularSeries<_ChartData, String>>[
                  PieSeries<_ChartData, String>(
                    dataSource: chartData,
                    xValueMapper: (_ChartData data, _) => data.label,
                    yValueMapper: (_ChartData data, _) => data.value,
                    dataLabelSettings: const DataLabelSettings(isVisible: true),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Transactions list (LIFO)
            Expanded(
              child: filteredTransactions.isEmpty
                  ? const Center(child: Text("No records available"))
                  : ListView.builder(
                      itemCount: filteredTransactions.length,
                      itemBuilder: (context, index) {
                        final txn = filteredTransactions[
                            filteredTransactions.length - 1 - index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: txn.type == "Income"
                                  ? Colors.blue.shade100
                                  : Colors.red.shade100,
                              child: Text(
                                txn.type.substring(0, 1),
                                style: TextStyle(
                                  color: txn.type == "Income"
                                      ? Colors.blue
                                      : Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Text("${txn.type} - ${txn.note}"),
                            subtitle: Text(txn.date),
                            trailing: Text(
                              "\$${txn.amount.toStringAsFixed(2)}",
                              style: TextStyle(
                                color: txn.type == "Income"
                                    ? Colors.blue
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
