// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:track_expense/ViewModel/transaction_viewmodel.dart';
// import 'package:track_expense/Model/transaction_model.dart';
// import 'package:intl/intl.dart';
// import 'package:track_expense/views/transaction_detail_screen.dart';

// class RecordsScreen extends StatelessWidget {
//   const RecordsScreen({super.key});

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

//       final dateCompare = db.compareTo(da);
//       if (dateCompare != 0) return dateCompare;

//       if (a.id != null && b.id != null) {
//         return b.id!.compareTo(a.id!);
//       }
//       return 0;
//     });
//     return copy;
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Consumer<TransactionViewModel>(builder: (context, vm, child) {
//       final today = DateTime.now();
//       final startOfDay = DateTime(today.year, today.month, today.day);
//       final startOfWeek =
//           startOfDay.subtract(Duration(days: startOfDay.weekday - 1));
//       final startOfNextWeek = startOfWeek.add(const Duration(days: 7));

//       final allTxns = vm.transactions;

//       final dailyTxns = allTxns.where((t) {
//         final d = _parseDate(t.date);
//         if (d == null) return false;
//         return d.year == startOfDay.year &&
//             d.month == startOfDay.month &&
//             d.day == startOfDay.day;
//       }).toList();

//       final weeklyTxns = allTxns.where((t) {
//         final d = _parseDate(t.date);
//         if (d == null) return false;
//         return (d.isAtSameMomentAs(startOfWeek) || d.isAfter(startOfWeek)) &&
//             d.isBefore(startOfNextWeek);
//       }).toList();

//       final monthlyTxns = allTxns;

//       final dailyTotals = _calcTotals(dailyTxns);
//       final weeklyTotals = _calcTotals(weeklyTxns);
//       final monthlyTotals = _calcTotals(monthlyTxns);
//       final overallTotals = _calcTotals(allTxns);

//       final dailySorted = _sortedByDateDesc(dailyTxns);
//       final weeklySorted = _sortedByDateDesc(weeklyTxns);
//       final monthlySorted = _sortedByDateDesc(monthlyTxns);
//       final overallSorted = _sortedByDateDesc(allTxns);

//       List<Map<String, dynamic>> tabs = [
//         {"label": "Daily", "amount": dailyTotals['net'], "list": dailySorted},
//         {"label": "Weekly", "amount": weeklyTotals['net'], "list": weeklySorted},
//         {"label": "Monthly", "amount": monthlyTotals['net'], "list": monthlySorted},
//         {"label": "Total", "amount": overallTotals['net'], "list": overallSorted},
//       ];

//       return DefaultTabController(
//         length: tabs.length,
//         child: Scaffold(
//           backgroundColor: theme.scaffoldBackgroundColor,
//           appBar: AppBar(
//             title: Text(
//               'Records Summary',
//               style: theme.textTheme.titleMedium?.copyWith(
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             centerTitle: true,
//             bottom: PreferredSize(
//               preferredSize: const Size.fromHeight(1),
//               child: Divider(
//                 color: theme.dividerColor,
//                 height: 1,
//               ),
//             ),
//           ),
//           body: Column(
//             children: [
//               Container(
//                 margin: const EdgeInsets.all(5),
//                 padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0.5),
//                 decoration: BoxDecoration(
//                   color: theme.cardColor,
//                   borderRadius: BorderRadius.circular(12),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.withOpacity(0.15),
//                       blurRadius: 6,
//                       spreadRadius: 1,
//                       offset: const Offset(2, 3),
//                     ),
//                   ],
//                 ),
//                 child: TabBar(
//                   dividerColor: Colors.transparent,
//                   indicatorColor: Colors.transparent,
//                   labelColor: Colors.blue,
//                   unselectedLabelColor: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
//                   tabs: tabs
//                       .map((tab) => Column(
//                             children: [
//                               Text(
//                                 tab["label"],
//                                 style: const TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               const SizedBox(height: 4),
//                               Text(
//                                 "\$${tab["amount"]!.toStringAsFixed(2)}",
//                                 style: const TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ],
//                           ))
//                       .toList(),
//                 ),
//               ),
//               Expanded(
//                 child: TabBarView(
//                   children: [
//                     _transactionList(context, dailySorted, theme),
//                     _transactionList(context, weeklySorted, theme),
//                     _monthlyGroupedList(context, monthlySorted, theme),
//                     _transactionList(context, overallSorted, theme),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     });
//   }

//   Widget _transactionList(
//       BuildContext context, List<TransactionModel> txns, ThemeData theme) {
//     if (txns.isEmpty) {
//       return Center(
//         child: Text(
//           "No transactions found",
//           style: theme.textTheme.bodyMedium,
//         ),
//       );
//     }

//     final sorted = _sortedByDateDesc(txns);

//     return ListView.separated(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       itemCount: sorted.length,
//       separatorBuilder: (_, __) => Divider(
//         height: 1,
//         color: theme.dividerColor,
//         indent: 12,
//         endIndent: 12,
//       ),
//       itemBuilder: (context, index) {
//         final txn = sorted[index];
//         final dt = _parseDate(txn.date);
//         final dateText = dt != null ? DateFormat.yMMMd().format(dt) : txn.date;
//         final isIncome = txn.type.toLowerCase() == 'income';

//         return ListTile(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (_) => TransactionDetailsScreen(transaction: txn),
//               ),
//             );
//           },
//           leading: CircleAvatar(
//             backgroundColor: isIncome
//                 ? const Color(0xFF0073D1).withValues(alpha: 0.1)
//                 : const Color(0xFFCA5359).withValues(alpha: 0.1),
//             child: Text(
//               txn.type.substring(0, 1),
//               style: TextStyle(
//                 color: isIncome ? Colors.blue : Colors.red,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//           title: Text(
//             "${txn.type} - ${txn.category}",
//             style: theme.textTheme.bodyLarge?.copyWith(
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           subtitle: Text(
//             "$dateText | ${txn.note}",
//             style: theme.textTheme.bodySmall,
//           ),
//           trailing: Text(
//             (isIncome ? '+' : '-') + "\$${txn.amount.toStringAsFixed(2)}",
//             style: TextStyle(
//               color: isIncome ? Colors.blue : Colors.red,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _monthlyGroupedList(
//       BuildContext context, List<TransactionModel> txns, ThemeData theme) {
//     if (txns.isEmpty) {
//       return Center(
//         child: Text(
//           "No transactions found",
//           style: theme.textTheme.bodyMedium,
//         ),
//       );
//     }

//     final Map<String, List<TransactionModel>> groups = {};
//     for (final txn in txns) {
//       final dt = _parseDate(txn.date);
//       final key = dt != null ? DateFormat('yyyy-MM').format(dt) : txn.date;
//       groups.putIfAbsent(key, () => []);
//       groups[key]!.add(txn);
//     }

//     final sortedKeys = groups.keys.toList()..sort((a, b) => b.compareTo(a));

//     return ListView(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       children: sortedKeys.map((key) {
//         final list = _sortedByDateDesc(groups[key]!);
//         final monthDt = _parseDate(list.first.date);
//         final monthLabel =
//             monthDt != null ? DateFormat.yMMMM().format(monthDt) : key;

//         double income = 0, expense = 0;
//         for (var t in list) {
//           if (t.type.toLowerCase() == 'income') {
//             income += t.amount;
//           } else if (t.type.toLowerCase() == 'expense') {
//             expense += t.amount;
//           }
//         }

//         return Container(
//           margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//           decoration: BoxDecoration(
//             color: theme.cardColor,
//             borderRadius: BorderRadius.circular(12),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.grey.withOpacity(0.15),
//                 blurRadius: 6,
//                 spreadRadius: 1,
//                 offset: const Offset(2, 3),
//               ),
//             ],
//           ),
//           child: ExpansionTile(
//             backgroundColor: theme.cardColor,
//             collapsedTextColor: theme.textTheme.bodyLarge?.color,
//             iconColor: theme.iconTheme.color,
//             title: Text(
//               monthLabel,
//               style: theme.textTheme.bodyLarge?.copyWith(
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             subtitle: Text(
//               "Inc: \$${income.toStringAsFixed(2)}  •  Exp: \$${expense.toStringAsFixed(2)}",
//               style: theme.textTheme.bodySmall,
//             ),
//             children: list.map((txn) {
//               final dt = _parseDate(txn.date);
//               final dateText =
//                   dt != null ? DateFormat.yMMMd().format(dt) : txn.date;
//               final isIncome = txn.type.toLowerCase() == 'income';

//               return ListTile(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (_) =>
//                           TransactionDetailsScreen(transaction: txn),
//                     ),
//                   );
//                 },
//                 leading: CircleAvatar(
//                   backgroundColor: isIncome
//                       ? const Color(0xFFD9EEFF)
//                       : const Color(0xFFFFE1E4),
//                   child: Text(
//                     txn.type.substring(0, 1),
//                     style: TextStyle(
//                       color: isIncome ? Colors.blue : Colors.red,
//                     ),
//                   ),
//                 ),
//                 title: Text(
//                   "${txn.type} - ${txn.category}",
//                   style: theme.textTheme.bodyLarge?.copyWith(
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 subtitle: Text(
//                   dateText,
//                   style: theme.textTheme.bodySmall,
//                 ),
//                 trailing: Text(
//                   (isIncome ? '+' : '-') +
//                       "\$${txn.amount.toStringAsFixed(2)}",
//                   style: TextStyle(
//                     color: isIncome ? Colors.blue : Colors.red,
//                     fontWeight: FontWeight.bold,
//                   ),
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

class RecordsScreen extends StatelessWidget {
  const RecordsScreen({super.key});

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

      final dateCompare = db.compareTo(da);
      if (dateCompare != 0) return dateCompare;

      if (a.id != null && b.id != null) {
        return b.id!.compareTo(a.id!);
      }
      return 0;
    });
    return copy;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<TransactionViewModel>(builder: (context, vm, child) {
      final today = DateTime.now();
      final startOfDay = DateTime(today.year, today.month, today.day);
      final startOfWeek =
          startOfDay.subtract(Duration(days: startOfDay.weekday - 1));
      final startOfNextWeek = startOfWeek.add(const Duration(days: 7));

      final allTxns = vm.transactions;

      final dailyTxns = allTxns.where((t) {
        final d = _parseDate(t.date);
        if (d == null) return false;
        return d.year == startOfDay.year &&
            d.month == startOfDay.month &&
            d.day == startOfDay.day;
      }).toList();

      final weeklyTxns = allTxns.where((t) {
        final d = _parseDate(t.date);
        if (d == null) return false;
        return (d.isAtSameMomentAs(startOfWeek) || d.isAfter(startOfWeek)) &&
            d.isBefore(startOfNextWeek);
      }).toList();

      final monthlyTxns = allTxns;

      final dailyTotals = _calcTotals(dailyTxns);
      final weeklyTotals = _calcTotals(weeklyTxns);
      final monthlyTotals = _calcTotals(monthlyTxns);
      final overallTotals = _calcTotals(allTxns);

      final dailySorted = _sortedByDateDesc(dailyTxns);
      final weeklySorted = _sortedByDateDesc(weeklyTxns);
      final monthlySorted = _sortedByDateDesc(monthlyTxns);
      final overallSorted = _sortedByDateDesc(allTxns);

      List<Map<String, dynamic>> tabs = [
        {"label": "Daily", "amount": dailyTotals['net'], "list": dailySorted},
        {"label": "Weekly", "amount": weeklyTotals['net'], "list": weeklySorted},
        {"label": "Monthly", "amount": monthlyTotals['net'], "list": monthlySorted},
        {"label": "Total", "amount": overallTotals['net'], "list": overallSorted},
      ];

      return DefaultTabController(
        length: tabs.length,
        child: Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            title: Text(
              'Records Summary',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
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
              Container(
                margin: const EdgeInsets.all(5),
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0.5),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.15),
                      blurRadius: 6,
                      spreadRadius: 1,
                      offset: const Offset(2, 3),
                    ),
                  ],
                ),
                child: TabBar(
                  dividerColor: Colors.transparent,
                  indicatorColor: Colors.transparent,
                  labelColor: Colors.blue,
                  unselectedLabelColor:
                      theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                  tabs: tabs
                      .map((tab) => Column(
                            children: [
                              Text(
                                tab["label"],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "\$${tab["amount"]!.toStringAsFixed(2)}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ))
                      .toList(),
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _transactionList(context, dailySorted, theme),
                    _transactionList(context, weeklySorted, theme),
                    _monthlyGroupedList(context, monthlySorted, theme),
                    _transactionList(context, overallSorted, theme),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _transactionList(
      BuildContext context, List<TransactionModel> txns, ThemeData theme) {
    if (txns.isEmpty) {
      return Center(
        child: Text(
          "No transactions found",
          style: theme.textTheme.bodyMedium,
        ),
      );
    }

    final sorted = _sortedByDateDesc(txns);
    final isDark = theme.brightness == Brightness.dark;

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      itemCount: sorted.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final txn = sorted[index];
        final dt = _parseDate(txn.date);
        final dateText = dt != null ? DateFormat.yMMMd().format(dt) : txn.date;
        final isIncome = txn.type.toLowerCase() == 'income';

        // ✅ Theme-based colors
        final incomeColor = isDark ? Colors.purple : Colors.blue;
        final incomeBg = isDark
            ? Colors.purple.withOpacity(0.15)
            : Colors.blue.withOpacity(0.15);
        final expenseColor = Colors.red;
        final expenseBg = Colors.red.withOpacity(0.15);

        return Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E2128) : theme.cardColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isDark
                ? [] // no shadow & no border in dark mode
                : [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.15),
                      blurRadius: 6,
                      spreadRadius: 1,
                      offset: const Offset(2, 3),
                    ),
                  ],
            border: isDark
                ? null
                : Border.all(
                    color: Colors.grey.shade300,
                    width: 1,
                  ),
          ),
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
              backgroundColor: isIncome ? incomeBg : expenseBg,
              child: Text(
                txn.type.substring(0, 1),
                style: TextStyle(
                  color: isIncome ? incomeColor : expenseColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              "${txn.type} - ${txn.category}",
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              "$dateText | ${txn.note}",
              style: theme.textTheme.bodySmall,
            ),
            trailing: Text(
              (isIncome ? '+' : '-') + "\$${txn.amount.toStringAsFixed(2)}",
              style: TextStyle(
                color: isIncome ? incomeColor : expenseColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _monthlyGroupedList(
      BuildContext context, List<TransactionModel> txns, ThemeData theme) {
    if (txns.isEmpty) {
      return Center(
        child: Text(
          "No transactions found",
          style: theme.textTheme.bodyMedium,
        ),
      );
    }

    final Map<String, List<TransactionModel>> groups = {};
    for (final txn in txns) {
      final dt = _parseDate(txn.date);
      final key = dt != null ? DateFormat('yyyy-MM').format(dt) : txn.date;
      groups.putIfAbsent(key, () => []);
      groups[key]!.add(txn);
    }

    final sortedKeys = groups.keys.toList()..sort((a, b) => b.compareTo(a));
    final isDark = theme.brightness == Brightness.dark;

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
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

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E2128) : theme.cardColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isDark
                ? []
                : [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.15),
                      blurRadius: 6,
                      spreadRadius: 1,
                      offset: const Offset(2, 3),
                    ),
                  ],
            border: isDark
                ? null
                : Border.all(
                    color: Colors.black,
                    width: 1,
                  ),
          ),
          child: ExpansionTile(
            backgroundColor: Colors.transparent,
            collapsedTextColor: theme.textTheme.bodyLarge?.color,
            iconColor: theme.iconTheme.color,
            title: Text(
              monthLabel,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              "Inc: \$${income.toStringAsFixed(2)}  •  Exp: \$${expense.toStringAsFixed(2)}",
              style: theme.textTheme.bodySmall,
            ),
            children: list.map((txn) {
              final dt = _parseDate(txn.date);
              final dateText =
                  dt != null ? DateFormat.yMMMd().format(dt) : txn.date;
              final isIncome = txn.type.toLowerCase() == 'income';

              // ✅ Theme-based colors
              final incomeColor = isDark ? const Color(0xFFA46BF5) : Colors.blue;
              final incomeBg = isDark
                  ? const Color(0xFFA46BF5).withOpacity(0.1)
                  : Colors.blue.withOpacity(0.1);
              final expenseColor = const Color(0xFFFF5F5B);
              final expenseBg = isDark
                  ? const Color(0xFFFF5F5B).withOpacity(0.1)
                  : Colors.red.withOpacity(0.1);

              return ListTile(
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
                  backgroundColor: isIncome ? incomeBg : expenseBg,
                  child: Text(
                    txn.type.substring(0, 1),
                    style: TextStyle(
                      color: isIncome ? incomeColor : expenseColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(
                  "${txn.type} - ${txn.category}",
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  dateText,
                  style: theme.textTheme.bodySmall,
                ),
                trailing: Text(
                  (isIncome ? '+' : '-') +
                      "\$${txn.amount.toStringAsFixed(2)}",
                  style: TextStyle(
                    color: isIncome ? incomeColor : expenseColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }
}
