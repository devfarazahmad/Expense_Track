import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:track_expense/ViewModel/transaction_viewmodel.dart';


class RecordsScreen extends StatelessWidget {
  const RecordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<TransactionViewModel>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("All Records")),
      body: vm.transactions.isEmpty
          ? const Center(child: Text("No transactions yet"))
          : ListView.builder(
              itemCount: vm.transactions.length,
              itemBuilder: (context, index) {
                final txn = vm.transactions[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor:
                          txn.type == "Income" ? Colors.green : Colors.red,
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
                        color:
                            txn.type == "Income" ? Colors.green : Colors.red,
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
