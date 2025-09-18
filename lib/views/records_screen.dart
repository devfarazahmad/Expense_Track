

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:track_expense/ViewModel/transaction_viewmodel.dart';
// import 'package:track_expense/Model/transaction_model.dart';
// import 'package:intl/intl.dart';
// import 'package:track_expense/views/transaction_detail_screen.dart';

// class RecordsScreen extends StatefulWidget {
//   const RecordsScreen({super.key});

//   @override
//   State<RecordsScreen> createState() => _RecordsScreenState();
// }

// class _RecordsScreenState extends State<RecordsScreen> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final vm = Provider.of<TransactionViewModel>(context, listen: false);
//       if (vm.transactions.isEmpty) vm.fetchTransactions();
//     });
//   }

//   DateTime? _parseDate(String s) {
//     if (s.isEmpty) return null;
//     try {
//       return DateTime.parse(s);
//     } catch (_) {}
//     try {
//       return DateFormat('yyyy-MM-dd').parseStrict(s);
//     } catch (_) {}
//     try {
//       return DateFormat.yMMMd().parseLoose(s);
//     } catch (_) {}
//     try {
//       return DateFormat.yMd().parseLoose(s);
//     } catch (_) {}
//     try {
//       return DateFormat('MMM d, yyyy').parseLoose(s);
//     } catch (_) {}
//     return null;
//   }

//   Map<String, double> _calcTotals(List<TransactionModel> list) {
//     double income = 0, expense = 0;
//     for (final txn in list) {
//       if (txn.type.toLowerCase() == 'income') {
//         income += txn.amount;
//       } else if (txn.type.toLowerCase() == 'expense') {
//         expense += txn.amount;
//       }
//     }
//     return {
//       'income': income,
//       'expense': expense,
//       'net': income - expense,
//     };
//   }

//   List<T> _sortedByDateDesc<T extends TransactionModel>(List<T> list) {
//     final copy = List<T>.from(list);
//     copy.sort((a, b) {
//       final da = _parseDate(a.date) ?? DateTime.fromMillisecondsSinceEpoch(0);
//       final db = _parseDate(b.date) ?? DateTime.fromMillisecondsSinceEpoch(0);
//       return db.compareTo(da); // ✅ newest first (LIFO)
//     });
//     return copy;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<TransactionViewModel>(builder: (context, vm, child) {
//       final today = DateTime.now();
//       final startOfDay = DateTime(today.year, today.month, today.day);
//       final startOfWeek =
//           startOfDay.subtract(Duration(days: startOfDay.weekday - 1));
//       final startOfNextWeek = startOfWeek.add(const Duration(days: 7));
//       final startOfMonth = DateTime(today.year, today.month, 1);
//       final startOfNextMonth = DateTime(today.year, today.month + 1, 1);

//       final allTxns = vm.transactions;

//       // ✅ Daily
//       final dailyTxns = allTxns.where((t) {
//         final d = _parseDate(t.date);
//         if (d == null) return false;
//         return d.year == startOfDay.year &&
//             d.month == startOfDay.month &&
//             d.day == startOfDay.day;
//       }).toList();

//       // ✅ Weekly
//       final weeklyTxns = allTxns.where((t) {
//         final d = _parseDate(t.date);
//         if (d == null) return false;
//         return (d.isAtSameMomentAs(startOfWeek) || d.isAfter(startOfWeek)) &&
//             d.isBefore(startOfNextWeek);
//       }).toList();

//       // ✅ Monthly
//       final monthlyTxns = allTxns.where((t) {
//         final d = _parseDate(t.date);
//         if (d == null) return false;
//         return (d.isAtSameMomentAs(startOfMonth) || d.isAfter(startOfMonth)) &&
//             d.isBefore(startOfNextMonth);
//       }).toList();

//       // ✅ Totals
//       final dailyTotals = _calcTotals(dailyTxns);
//       final weeklyTotals = _calcTotals(weeklyTxns);
//       final monthlyTotals = _calcTotals(monthlyTxns);
//       final overallTotals = _calcTotals(allTxns);

//       // ✅ Sorted lists
//       final dailySorted = _sortedByDateDesc(dailyTxns);
//       final weeklySorted = _sortedByDateDesc(weeklyTxns);
//       final monthlySorted = _sortedByDateDesc(monthlyTxns);
//       final overallSorted = _sortedByDateDesc(allTxns);

//       Widget sectionHeader(Map<String, double> totals) {
//         return Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
//           child: Row(
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text("Income: \$${totals['income']!.toStringAsFixed(2)}",
//                       style: const TextStyle(fontWeight: FontWeight.w600)),
//                   Text("Expense: \$${totals['expense']!.toStringAsFixed(2)}",
//                       style: const TextStyle(fontWeight: FontWeight.w600)),
//                 ],
//               ),
//               const Spacer(),
//               Text(
//                 "Net: \$${totals['net']!.toStringAsFixed(2)}",
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   color: (totals['net']! >= 0) ? Colors.green : Colors.red,
//                 ),
//               ),
//             ],
//           ),
//         );
//       }

//       return DefaultTabController(
//         length: 4,
//         child: Scaffold(
//           appBar: AppBar(
//             title: const Text('Records Summary'),
//             centerTitle: true,
//             bottom: const PreferredSize(
//               preferredSize: Size.fromHeight(1),
//               child: Divider(color: Colors.grey, height: 1),
//             ),
//           ),
//           body: Column(
//             children: [
//               const SizedBox(height: 12),
//               TabBar(
//                 indicatorColor: Colors.blue,
//                 labelColor: Colors.blue,
//                 unselectedLabelColor: Colors.black54,
//                 tabs: const [
//                   Tab(text: "Daily"),
//                   Tab(text: "Weekly"),
//                   Tab(text: "Monthly"),
//                   Tab(text: "Total"),
//                 ],
//               ),
//               const Divider(height: 1),
//               Expanded(
//                 child: TabBarView(
//                   children: [
//                     Column(
//                       children: [
//                         sectionHeader(dailyTotals),
//                         const Divider(height: 1),
//                         Expanded(child: _transactionList(context, dailySorted)),
//                       ],
//                     ),
//                     Column(
//                       children: [
//                         sectionHeader(weeklyTotals),
//                         const Divider(height: 1),
//                         Expanded(child: _transactionList(context, weeklySorted)),
//                       ],
//                     ),
//                     Column(
//                       children: [
//                         sectionHeader(monthlyTotals),
//                         const Divider(height: 1),
//                         Expanded(child: _monthlyGroupedList(context, monthlySorted)),
//                       ],
//                     ),
//                     Column(
//                       children: [
//                         sectionHeader(overallTotals),
//                         const Divider(height: 1),
//                         Expanded(child: _transactionList(context, overallSorted)),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     });
//   }

//   /// ✅ Transaction list (with tap → TransactionDetailsScreen)
//   Widget _transactionList(BuildContext context, List<TransactionModel> txns) {
//     if (txns.isEmpty) return const Center(child: Text("No transactions found"));

//     final sorted = _sortedByDateDesc(txns);

//     return ListView.separated(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       itemCount: sorted.length,
//       separatorBuilder: (_, __) => const SizedBox(height: 4),
//       itemBuilder: (context, index) {
//         final txn = sorted[index];
//         final dt = _parseDate(txn.date);
//         final dateText = dt != null ? DateFormat.yMMMd().format(dt) : txn.date;
//         final isIncome = txn.type.toLowerCase() == 'income';
//         return Card(
//           margin: const EdgeInsets.symmetric(horizontal: 12),
//           child: ListTile(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (_) => TransactionDetailsScreen(transaction: txn),
//                 ),
//               );
//             },
//             leading: CircleAvatar(
//               backgroundColor:
//                   isIncome ? const Color(0xFFD9EEFF) : const Color(0xFFFFE1E4),
//               child: Text(
//                 txn.type.substring(0, 1),
//                 style: TextStyle(
//                   color: isIncome ? Colors.blue : Colors.red,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             title: Text("${txn.type} · ${txn.category ?? ''}".trim()),
//             subtitle: Text("$dateText • ${txn.note}"),
//             trailing: Text(
//               (isIncome ? '+' : '-') + "\$${txn.amount.toStringAsFixed(2)}",
//               style: TextStyle(
//                 color: isIncome ? Colors.blue : Colors.red,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   /// ✅ Monthly grouped list (tap → TransactionDetailsScreen)
//   Widget _monthlyGroupedList(BuildContext context, List<TransactionModel> txns) {
//     if (txns.isEmpty) return const Center(child: Text("No transactions found"));

//     final Map<String, List<TransactionModel>> groups = {};
//     for (final txn in txns) {
//       final dt = _parseDate(txn.date);
//       final key = dt != null ? DateFormat('yyyy-MM-dd').format(dt) : txn.date;
//       groups.putIfAbsent(key, () => []);
//       groups[key]!.add(txn);
//     }

//     final sortedKeys = groups.keys.toList()..sort((a, b) => b.compareTo(a));

//     return ListView(
//       children: sortedKeys.map((key) {
//         final list = _sortedByDateDesc(groups[key]!);

//         final dayDt = _parseDate(list.first.date);
//         final dayLabel =
//             dayDt != null ? DateFormat.yMMMMd().format(dayDt) : key;
//         double income = 0, expense = 0;
//         for (var t in list) {
//           if (t.type.toLowerCase() == 'income') {
//             income += t.amount;
//           } else if (t.type.toLowerCase() == 'expense') {
//             expense += t.amount;
//           }
//         }
//         return Card(
//           margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//           child: ExpansionTile(
//             title: Text(dayLabel),
//             subtitle: Text(
//                 "Inc: \$${income.toStringAsFixed(2)}  •  Exp: \$${expense.toStringAsFixed(2)}"),
//             children: list.map((txn) {
//               final dt = _parseDate(txn.date);
//               final dateText =
//                   dt != null ? DateFormat.jm().format(dt) : txn.date;
//               final isIncome = txn.type.toLowerCase() == 'income';
//               return ListTile(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (_) => TransactionDetailsScreen(transaction: txn),
//                     ),
//                   );
//                 },
//                 leading: CircleAvatar(
//                   backgroundColor:
//                       isIncome ? Colors.blue.shade50 : Colors.red.shade50,
//                   child: Text(txn.type.substring(0, 1),
//                       style: TextStyle(
//                           color: isIncome ? Colors.blue : Colors.red)),
//                 ),
//                 title: Text("${txn.type} · ${txn.category ?? ''}".trim()),
//                 subtitle: Text("$dateText • ${txn.note}"),
//                 trailing: Text(
//                   (isIncome ? '+' : '-') +
//                       "\$${txn.amount.toStringAsFixed(2)}",
//                   style: TextStyle(
//                       color: isIncome ? Colors.blue : Colors.red,
//                       fontWeight: FontWeight.bold),
//                 ),
//               );
//             }).toList(),
//           ),
//         );
//       }).toList(),
//     );
//   }
// }




import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:track_expense/ViewModel/transaction_viewmodel.dart';
import 'package:track_expense/Model/transaction_model.dart';
import 'package:intl/intl.dart';
import 'package:track_expense/views/transaction_detail_screen.dart';

class RecordsScreen extends StatefulWidget {
  const RecordsScreen({super.key});

  @override
  State<RecordsScreen> createState() => _RecordsScreenState();
}

class _RecordsScreenState extends State<RecordsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vm = Provider.of<TransactionViewModel>(context, listen: false);
      if (vm.transactions.isEmpty) vm.fetchTransactions();
    });
  }

  DateTime? _parseDate(String s) {
    if (s.isEmpty) return null;
    try {
      return DateTime.parse(s);
    } catch (_) {}
    try {
      return DateFormat('yyyy-MM-dd').parseStrict(s);
    } catch (_) {}
    try {
      return DateFormat.yMMMd().parseLoose(s);
    } catch (_) {}
    try {
      return DateFormat.yMd().parseLoose(s);
    } catch (_) {}
    try {
      return DateFormat('MMM d, yyyy').parseLoose(s);
    } catch (_) {}
    return null;
  }

  Map<String, double> _calcTotals(List<TransactionModel> list) {
    double income = 0, expense = 0;
    for (final txn in list) {
      if (txn.type.toLowerCase() == 'income') {
        income += txn.amount;
      } else if (txn.type.toLowerCase() == 'expense') {
        expense += txn.amount;
      }
    }
    return {
      'income': income,
      'expense': expense,
      'net': income - expense,
    };
  }

  List<T> _sortedByDateDesc<T extends TransactionModel>(List<T> list) {
    final copy = List<T>.from(list);
    copy.sort((a, b) {
      final da = _parseDate(a.date) ?? DateTime.fromMillisecondsSinceEpoch(0);
      final db = _parseDate(b.date) ?? DateTime.fromMillisecondsSinceEpoch(0);
      return db.compareTo(da); // ✅ newest first (LIFO)
    });
    return copy;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionViewModel>(builder: (context, vm, child) {
      final today = DateTime.now();
      final startOfDay = DateTime(today.year, today.month, today.day);
      final startOfWeek =
          startOfDay.subtract(Duration(days: startOfDay.weekday - 1));
      final startOfNextWeek = startOfWeek.add(const Duration(days: 7));

      final allTxns = vm.transactions;

      // ✅ Daily
      final dailyTxns = allTxns.where((t) {
        final d = _parseDate(t.date);
        if (d == null) return false;
        return d.year == startOfDay.year &&
            d.month == startOfDay.month &&
            d.day == startOfDay.day;
      }).toList();

      // ✅ Weekly
      final weeklyTxns = allTxns.where((t) {
        final d = _parseDate(t.date);
        if (d == null) return false;
        return (d.isAtSameMomentAs(startOfWeek) || d.isAfter(startOfWeek)) &&
            d.isBefore(startOfNextWeek);
      }).toList();

      // ✅ Monthly (⚡ now includes all months, not just current)
      final monthlyTxns = allTxns; // <-- take all transactions

      // ✅ Totals
      final dailyTotals = _calcTotals(dailyTxns);
      final weeklyTotals = _calcTotals(weeklyTxns);
      final monthlyTotals = _calcTotals(monthlyTxns);
      final overallTotals = _calcTotals(allTxns);

      // ✅ Sorted lists
      final dailySorted = _sortedByDateDesc(dailyTxns);
      final weeklySorted = _sortedByDateDesc(weeklyTxns);
      final monthlySorted = _sortedByDateDesc(monthlyTxns);
      final overallSorted = _sortedByDateDesc(allTxns);

      Widget sectionHeader(Map<String, double> totals) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Income: \$${totals['income']!.toStringAsFixed(2)}",
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  Text("Expense: \$${totals['expense']!.toStringAsFixed(2)}",
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                ],
              ),
              const Spacer(),
              Text(
                "Net: \$${totals['net']!.toStringAsFixed(2)}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: (totals['net']! >= 0) ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
        );
      }

      return DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Records Summary'),
            centerTitle: true,
            bottom: const PreferredSize(
              preferredSize: Size.fromHeight(1),
              child: Divider(color: Colors.grey, height: 1),
            ),
          ),
          body: Column(
            children: [
              const SizedBox(height: 12),
              TabBar(
                indicatorColor: Colors.blue,
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.black54,
                tabs: const [
                  Tab(text: "Daily"),
                  Tab(text: "Weekly"),
                  Tab(text: "Monthly"),
                  Tab(text: "Total"),
                ],
              ),
              const Divider(height: 1),
              Expanded(
                child: TabBarView(
                  children: [
                    Column(
                      children: [
                        sectionHeader(dailyTotals),
                        const Divider(height: 1),
                        Expanded(child: _transactionList(context, dailySorted)),
                      ],
                    ),
                    Column(
                      children: [
                        sectionHeader(weeklyTotals),
                        const Divider(height: 1),
                        Expanded(child: _transactionList(context, weeklySorted)),
                      ],
                    ),
                    Column(
                      children: [
                        sectionHeader(monthlyTotals),
                        const Divider(height: 1),
                        Expanded(child: _monthlyGroupedList(context, monthlySorted)),
                      ],
                    ),
                    Column(
                      children: [
                        sectionHeader(overallTotals),
                        const Divider(height: 1),
                        Expanded(child: _transactionList(context, overallSorted)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  /// ✅ Transaction list (with tap → TransactionDetailsScreen)
  Widget _transactionList(BuildContext context, List<TransactionModel> txns) {
    if (txns.isEmpty) return const Center(child: Text("No transactions found"));

    final sorted = _sortedByDateDesc(txns);

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: sorted.length,
      separatorBuilder: (_, __) => const SizedBox(height: 4),
      itemBuilder: (context, index) {
        final txn = sorted[index];
        final dt = _parseDate(txn.date);
        final dateText = dt != null ? DateFormat.yMMMd().format(dt) : txn.date;
        final isIncome = txn.type.toLowerCase() == 'income';
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          child: ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TransactionDetailsScreen(transaction: txn),
                ),
              );
            },
            leading: CircleAvatar(
              backgroundColor:
                  isIncome ? const Color(0xFFD9EEFF) : const Color(0xFFFFE1E4),
              child: Text(
                txn.type.substring(0, 1),
                style: TextStyle(
                  color: isIncome ? Colors.blue : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text("${txn.type} · ${txn.category ?? ''}".trim()),
            subtitle: Text("$dateText • ${txn.note}"),
            trailing: Text(
              (isIncome ? '+' : '-') + "\$${txn.amount.toStringAsFixed(2)}",
              style: TextStyle(
                color: isIncome ? Colors.blue : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }

  /// ✅ Monthly grouped list (tap → TransactionDetailsScreen)
  Widget _monthlyGroupedList(BuildContext context, List<TransactionModel> txns) {
    if (txns.isEmpty) return const Center(child: Text("No transactions found"));

    // ✅ Group transactions by month-year
    final Map<String, List<TransactionModel>> groups = {};
    for (final txn in txns) {
      final dt = _parseDate(txn.date);
      final key = dt != null ? DateFormat('yyyy-MM').format(dt) : txn.date;
      groups.putIfAbsent(key, () => []);
      groups[key]!.add(txn);
    }

    final sortedKeys = groups.keys.toList()..sort((a, b) => b.compareTo(a));

    return ListView(
      children: sortedKeys.map((key) {
        final list = _sortedByDateDesc(groups[key]!);

        final monthDt = _parseDate(list.first.date);
        final monthLabel =
            monthDt != null ? DateFormat.yMMMM().format(monthDt) : key;
        double income = 0, expense = 0;
        for (var t in list) {
          if (t.type.toLowerCase() == 'income') {
            income += t.amount;
          } else if (t.type.toLowerCase() == 'expense') {
            expense += t.amount;
          }
        }
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: ExpansionTile(
            title: Text(monthLabel),
            subtitle: Text(
                "Inc: \$${income.toStringAsFixed(2)}  •  Exp: \$${expense.toStringAsFixed(2)}"),
            children: list.map((txn) {
              final dt = _parseDate(txn.date);
              final dateText =
                  dt != null ? DateFormat.yMMMd().format(dt) : txn.date;
              final isIncome = txn.type.toLowerCase() == 'income';
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
                  backgroundColor:
                      isIncome ? Colors.blue.shade50 : Colors.red.shade50,
                  child: Text(txn.type.substring(0, 1),
                      style: TextStyle(
                          color: isIncome ? Colors.blue : Colors.red)),
                ),
                title: Text("${txn.type} · ${txn.category ?? ''}".trim()),
                subtitle: Text("$dateText • ${txn.note}"),
                trailing: Text(
                  (isIncome ? '+' : '-') +
                      "\$${txn.amount.toStringAsFixed(2)}",
                  style: TextStyle(
                      color: isIncome ? Colors.blue : Colors.red,
                      fontWeight: FontWeight.bold),
                ),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }
}
