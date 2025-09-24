

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:track_expense/ViewModel/transaction_viewmodel.dart';
import 'package:track_expense/views/transaction_detail_screen.dart';
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
    final theme = Theme.of(context);

    // Prepare chart data
    List<_ChartData> chartData;
    List filteredTransactions;

    if (selectedView == "Income") {
      filteredTransactions =
          vm.transactions.where((txn) => txn.type == "Income").toList();
      final Map<String, double> incomeMap = {};
      for (var txn in filteredTransactions) {
        incomeMap[txn.note] = (incomeMap[txn.note] ?? 0) + txn.amount;
      }
      chartData =
          incomeMap.entries.map((e) => _ChartData(e.key, e.value)).toList();
    } else if (selectedView == "Expense") {
      filteredTransactions =
          vm.transactions.where((txn) => txn.type == "Expense").toList();
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
      appBar: AppBar(
        title: const Center(child: Text("Analysis")),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(color: theme.dividerColor, height: 1),
        ),
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Chart + Dropdown section
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: theme.shadowColor.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 6,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Dropdown inside graph section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "View: ",
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      DropdownButton<String>(
                        dropdownColor: theme.cardColor,
                        value: selectedView,
                        items: const [
                          DropdownMenuItem(value: "All", child: Text("All")),
                          DropdownMenuItem(
                              value: "Income", child: Text("Income")),
                          DropdownMenuItem(
                              value: "Expense", child: Text("Expense")),
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
                  SizedBox(
                    height: 250,
                    child: SfCircularChart(
                      legend: const Legend(isVisible: true),
                      series: <CircularSeries<_ChartData, String>>[
                        PieSeries<_ChartData, String>(
                          dataSource: chartData,
                          xValueMapper: (_ChartData data, _) => data.label,
                          yValueMapper: (_ChartData data, _) => data.value,
                          dataLabelSettings:
                              const DataLabelSettings(isVisible: true),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Transactions list
            filteredTransactions.isEmpty
                ? const Center(child: Text("No records available"))
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredTransactions.length,
                    itemBuilder: (context, index) {
                      final txn = filteredTransactions[
                          filteredTransactions.length - 1 - index];
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 6),
                        decoration: BoxDecoration(
                          color: theme.cardColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: theme.dividerColor),
                          boxShadow: [
                            BoxShadow(
                              color: theme.shadowColor.withOpacity(0.15),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    TransactionDetailsScreen(transaction: txn),
                              ),
                            );
                          },
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
                          title: Text(txn.type,
                              style: theme.textTheme.bodyLarge),
                          subtitle: Text(txn.date,
                              style: theme.textTheme.bodySmall),
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
