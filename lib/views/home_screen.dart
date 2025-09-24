

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
  void initState() {
    super.initState();
    // fetch once after first frame so DB is read on app open
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TransactionViewModel>(context, listen: false).fetchTransactions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<TransactionViewModel>(context);
    final theme = Theme.of(context);

    // vm.transactions is now kept sorted newest-first by the ViewModel
    final transactions = vm.transactions;

    final bool isDark = theme.brightness == Brightness.dark;

    final incomeColor = isDark ? const Color(0xFFA46BF5) : const Color(0xFF0073D1);
    final expenseColor = isDark ? const Color(0xFFCA5359) : const Color(0xFFCA5359);
    final balanceColor = isDark ? const Color(0xFF00D0C7) : const Color(0xFF39A75A);

    final incomeBg = isDark
        ? const Color(0xFFA46BF5).withValues(alpha: 0.1)
        : const Color(0xFF0073D1).withValues(alpha: 0.1);
    final expenseBg = const Color(0xFFCA5359).withValues(alpha: 0.1);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Center(
          child: Text(
            "Track Expenses",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(
            color: theme.dividerColor,
            height: 1,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: _summaryCard(
                      "Income", vm.totalIncome, incomeColor, Icons.arrow_upward, theme),
                ),
                Expanded(
                  child: _summaryCard("Expense", vm.totalExpense, expenseColor,
                      Icons.arrow_downward_rounded, theme),
                ),
                Expanded(
                  child: _summaryCard("Balance", vm.totalBalance, balanceColor,
                      Icons.account_balance_wallet, theme),
                ),
              ],
            ),
          ),
          Expanded(
            child: transactions.isEmpty
                ? const Center(child: Text("No transactions found"))
                : Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: theme.cardColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withValues(alpha: 0.1),
                          blurRadius: 6,
                          spreadRadius: 1,
                          offset: const Offset(2, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            "Recent Transactions",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Divider(
                          height: 1,
                          color: theme.dividerColor,
                          indent: 12,
                          endIndent: 12,
                        ),
                        Expanded(
                          child: ListView.separated(
                            itemCount: transactions.length,
                            separatorBuilder: (context, index) => Divider(
                              height: 1,
                              color: theme.dividerColor,
                              indent: 12,
                              endIndent: 12,
                            ),
                            itemBuilder: (context, index) {
                              final txn = transactions[index];
                              final isIncome = txn.type == "Income";

                              return ListTile(
                                onTap: () async {
                                  // await details route — when returned, refresh list
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          TransactionDetailsScreen(transaction: txn),
                                    ),
                                  );
                                  // refresh after coming back (covers update/delete)
                                  await Provider.of<TransactionViewModel>(context,
                                          listen: false)
                                      .fetchTransactions();
                                },
                                leading: CircleAvatar(
                                  backgroundColor: isIncome ? incomeBg : expenseBg,
                                  child: Text(
                                    txn.type.substring(0, 1),
                                    style: TextStyle(
                                      color: isIncome ? incomeColor : expenseColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                title: Text("${txn.type} - ${txn.category}"),
                                subtitle: Text("${txn.date} | ${txn.note}"),
                                trailing: Text(
                                  "\$${txn.amount.toStringAsFixed(2)}",
                                  style: TextStyle(
                                    color: isIncome ? incomeColor : expenseColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: isDark ? const Color(0xFFA46BF5) : const Color(0xFF0073D1),
        onPressed: () async {
          // await add screen, then refresh list so the new txn appears at top
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddTransactionScreen()),
          );
          await Provider.of<TransactionViewModel>(context, listen: false).fetchTransactions();
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _summaryCard(
      String title, double value, Color color, IconData icon, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(2, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(0.5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: color, width: 2),
                ),
                child: Icon(icon, color: color, size: 16),
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "\$${value.toStringAsFixed(2)}",
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
