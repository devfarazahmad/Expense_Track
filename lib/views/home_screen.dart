
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:track_expense/ViewModel/transaction_viewmodel.dart';
import 'package:track_expense/views/transaction_detail_screen.dart';
import 'add_transaction_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<TransactionViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Track Expenses")),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(color: Colors.grey, height: 1),
        ),
      ),
      body: Column(
        children: [
          // ✅ Summary Section
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _summaryCard("Income", vm.totalIncome, Colors.blue, Icons.arrow_upward),
                _summaryCard("Expense", vm.totalExpense, Colors.red, Icons.arrow_downward_rounded),
                _summaryCard("Balance", vm.totalBalance, Colors.green, Icons.account_balance_wallet),
              ],
            ),
          ),

          // ✅ Transactions List (LIFO → latest first)
          Expanded(
            child: vm.transactions.isEmpty
                ? const Center(child: Text("No transactions found"))
                : ListView.builder(
                    itemCount: vm.transactions.length,
                    itemBuilder: (context, index) {
                      // take reversed list → latest first
                      final txn = vm.transactions.reversed.toList()[index];

                      return ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => TransactionDetailsScreen(transaction: txn),
                            ),
                          );
                        },
                        leading: CircleAvatar(
                          backgroundColor: txn.type == "Income"
                              ? const Color.fromARGB(255, 232, 245, 255)
                              : const Color.fromARGB(255, 255, 237, 239),
                          child: Text(
                            txn.type.substring(0, 1),
                            style: TextStyle(
                              color: txn.type == "Income" ? Colors.blue : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text("${txn.type} - ${txn.category}"),
                        subtitle: Text("${txn.date} | ${txn.note}"),
                        trailing: Text(
                          "\$${txn.amount.toStringAsFixed(2)}",
                          style: TextStyle(
                            color: txn.type == "Income" ? Colors.blue : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),

      // ✅ Add Transaction Button
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddTransactionScreen()),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // ✅ Summary Card Widget
  Widget _summaryCard(String title, double value, Color color, IconData icon) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(0.5),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: color, width: 2),
                  ),
                  child: Icon(icon, color: color, size: 16),
                ),
                const SizedBox(width: 8),
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              "\$${value.toStringAsFixed(2)}",
              style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
