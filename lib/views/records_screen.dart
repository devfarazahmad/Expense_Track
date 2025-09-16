// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:track_expense/ViewModel/transaction_viewmodel.dart';
// import 'package:intl/intl.dart';

// class RecordsScreen extends StatelessWidget {
//   const RecordsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final vm = Provider.of<TransactionViewModel>(context);

//     DateTime today = DateTime.now();
//     DateTime startOfWeek = today.subtract(Duration(days: today.weekday - 1));
//     DateTime startOfMonth = DateTime(today.year, today.month, 1);

//     DateTime? parseDate(String dateStr) {
//       try {
//         return DateFormat.yMMMd().parse(dateStr);
//       } catch (_) {
//         return null;
//       }
//     }

//     List dailyTxns = vm.transactions.where((txn) {
//       final txnDate = parseDate(txn.date);
//       return txnDate != null &&
//           DateFormat.yMd().format(txnDate) == DateFormat.yMd().format(today);
//     }).toList();

//     List weeklyTxns = vm.transactions.where((txn) {
//       final txnDate = parseDate(txn.date);
//       return txnDate != null &&
//           txnDate.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
//           txnDate.isBefore(today.add(const Duration(days: 1)));
//     }).toList();

//     List monthlyTxns = vm.transactions.where((txn) {
//       final txnDate = parseDate(txn.date);
//       return txnDate != null &&
//           txnDate.isAfter(startOfMonth.subtract(const Duration(days: 1))) &&
//           txnDate.isBefore(today.add(const Duration(days: 1)));
//     }).toList();

//     // Totals
//     double totalDaily = _calcNet(dailyTxns);
//     double totalWeekly = _calcNet(weeklyTxns);
//     double totalMonthly = _calcNet(monthlyTxns);
//     double totalOverall = _calcNet(vm.transactions);

//     return DefaultTabController(
//       length: 4,
//       child: Scaffold(
//         body: SafeArea(
//           child: Column(
//             children: [
//               const SizedBox(height: 16),
//               const Text(
//                 "Records Summary",
//                 style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87),
//               ),
//               const SizedBox(height: 12),

//               // ✅ Tabs for Daily, Weekly, Monthly, Total
//               TabBar(
//                 indicatorColor: Colors.blue,
//                 labelColor: Colors.blue,
//                 unselectedLabelColor: Colors.black54,
//                 tabs: [
//                   Tab(text: "Daily\n\$${totalDaily.toStringAsFixed(2)}"),
//                   Tab(text: "Weekly\n\$${totalWeekly.toStringAsFixed(2)}"),
//                   Tab(text: "Monthly\n\$${totalMonthly.toStringAsFixed(2)}"),
//                   Tab(text: "Total\n\$${totalOverall.toStringAsFixed(2)}"),
//                 ],
//               ),

//               const Divider(height: 1),

//               // ✅ Show transaction list based on tab
//               Expanded(
//                 child: TabBarView(
//                   children: [
//                     _transactionList(dailyTxns),
//                     _transactionList(weeklyTxns),
//                     _monthlyGroupedList(monthlyTxns),
//                     _transactionList(vm.transactions),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // ✅ Calculate Net Amount
//   static double _calcNet(List txns) {
//     double total = 0;
//     for (var txn in txns) {
//       total += txn.type == "Expense" ? -txn.amount : txn.amount;
//     }
//     return total;
//   }

//   // ✅ Normal Transaction List (Latest First - LIFO)
//   Widget _transactionList(List transactions) {
//     if (transactions.isEmpty) {
//       return const Center(child: Text("No transactions found"));
//     }
//     // 🔥 Reverse to show latest first (LIFO)
//     final reversed = transactions.reversed.toList();

//     return ListView.builder(
//       itemCount: reversed.length,
//       itemBuilder: (context, index) {
//         final txn = reversed[index];
//         return Card(
//           margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//           child: ListTile(
//             leading: CircleAvatar(
//               backgroundColor: txn.type == "Income"
//                   ? Colors.green
//                   : txn.type == "Expense"
//                       ? Colors.red
//                       : Colors.blue,
//               child: Text(
//                 txn.type.substring(0, 1),
//                 style: const TextStyle(color: Colors.white),
//               ),
//             ),
//             title: Text("${txn.type} - ${txn.note}"),
//             subtitle: Text(txn.date),
//             trailing: Text(
//               "\$${txn.amount.toStringAsFixed(2)}",
//               style: TextStyle(
//                 color: txn.type == "Income"
//                     ? Colors.green
//                     : txn.type == "Expense"
//                         ? Colors.red
//                         : Colors.blue,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   // ✅ Monthly Grouped List
//   Widget _monthlyGroupedList(List transactions) {
//     if (transactions.isEmpty) {
//       return const Center(child: Text("No transactions found"));
//     }

//     final Map<String, List> grouped = {};
//     final formatter = DateFormat.MMMM();

//     for (var txn in transactions) {
//       final date = DateFormat.yMMMd().parse(txn.date);
//       final month = formatter.format(date);

//       if (!grouped.containsKey(month)) {
//         grouped[month] = [];
//       }
//       grouped[month]!.add(txn);
//     }

//     return ListView(
//       children: grouped.entries.map((entry) {
//         double income = 0, expense = 0;
//         for (var txn in entry.value) {
//           if (txn.type == "Income") {
//             income += txn.amount;
//           } else if (txn.type == "Expense") {
//             expense += txn.amount;
//           }
//         }
//         return Card(
//           margin: const EdgeInsets.all(8),
//           child: ExpansionTile(
//             title: Text(entry.key),
//             subtitle: Text(
//               "Income: \$${income.toStringAsFixed(2)} | Expense: \$${expense.toStringAsFixed(2)}",
//               style: const TextStyle(fontSize: 12, color: Colors.black54),
//             ),
//             // 🔥 Reverse order inside monthly too
//             children: entry.value.reversed.map<Widget>((txn) {
//               return ListTile(
//                 title: Text("${txn.type} - ${txn.note}"),
//                 subtitle: Text(txn.date),
//                 trailing: Text(
//                   "\$${txn.amount.toStringAsFixed(2)}",
//                   style: TextStyle(
//                     color: txn.type == "Income"
//                         ? Colors.green
//                         : Colors.red,
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
import 'package:intl/intl.dart';

class RecordsScreen extends StatelessWidget {
  const RecordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<TransactionViewModel>(context);

    DateTime today = DateTime.now();
    DateTime startOfWeek = today.subtract(Duration(days: today.weekday - 1));
    DateTime startOfMonth = DateTime(today.year, today.month, 1);

    DateTime? parseDate(String dateStr) {
      try {
        return DateFormat.yMMMd().parse(dateStr);
      } catch (_) {
        return null;
      }
    }

    List dailyTxns = vm.transactions.where((txn) {
      final txnDate = parseDate(txn.date);
      return txnDate != null &&
          DateFormat.yMd().format(txnDate) == DateFormat.yMd().format(today);
    }).toList();

    List weeklyTxns = vm.transactions.where((txn) {
      final txnDate = parseDate(txn.date);
      return txnDate != null &&
          txnDate.isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
          txnDate.isBefore(today.add(const Duration(days: 1)));
    }).toList();

    List monthlyTxns = vm.transactions.where((txn) {
      final txnDate = parseDate(txn.date);
      return txnDate != null &&
          txnDate.isAfter(startOfMonth.subtract(const Duration(days: 1))) &&
          txnDate.isBefore(today.add(const Duration(days: 1)));
    }).toList();

    // Totals
    double totalDaily = _calcNet(dailyTxns);
    double totalWeekly = _calcNet(weeklyTxns);
    double totalMonthly = _calcNet(monthlyTxns);
    double totalOverall = _calcNet(vm.transactions);

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Records Summary"),
          centerTitle: true,
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(1),
            child: Divider(color: Colors.grey, height: 1),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 12),

              // ✅ Tabs for Daily, Weekly, Monthly, Total
              TabBar(
                indicatorColor: Colors.blue,
                labelColor: Colors.blue,
                unselectedLabelColor: Colors.black54,
                tabs: [
                  Tab(text: "Daily\n\$${totalDaily.toStringAsFixed(2)}"),
                  Tab(text: "Weekly\n\$${totalWeekly.toStringAsFixed(2)}"),
                  Tab(text: "Monthly\n\$${totalMonthly.toStringAsFixed(2)}"),
                  Tab(text: "Total\n\$${totalOverall.toStringAsFixed(2)}"),
                ],
              ),

              const Divider(height: 1),

              // ✅ Show transaction list based on tab
              Expanded(
                child: TabBarView(
                  children: [
                    _transactionList(dailyTxns),
                    _transactionList(weeklyTxns),
                    _monthlyGroupedList(monthlyTxns),
                    _transactionList(vm.transactions),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ Calculate Net Amount
  static double _calcNet(List txns) {
    double total = 0;
    for (var txn in txns) {
      total += txn.type == "Expense" ? -txn.amount : txn.amount;
    }
    return total;
  }

  // ✅ Normal Transaction List (Latest First - LIFO)
  Widget _transactionList(List transactions) {
    if (transactions.isEmpty) {
      return const Center(child: Text("No transactions found"));
    }
    final reversed = transactions.reversed.toList();

    return ListView.builder(
      itemCount: reversed.length,
      itemBuilder: (context, index) {
        final txn = reversed[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: txn.type == "Income"
                  ? const Color.fromARGB(255, 217, 238, 255)
                  : const Color.fromARGB(255, 255, 225, 228),
              child: Text(
                txn.type.substring(0, 1),
                style: TextStyle(
                  color: txn.type == "Income" ? Colors.blue : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text("${txn.type} - ${txn.note}"),
            subtitle: Text(txn.date),
            trailing: Text(
              "\$${txn.amount.toStringAsFixed(2)}",
              style: TextStyle(
                color: txn.type == "Income" ? Colors.blue : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );
  }

  // ✅ Monthly Grouped List
  Widget _monthlyGroupedList(List transactions) {
    if (transactions.isEmpty) {
      return const Center(child: Text("No transactions found"));
    }

    final Map<String, List> grouped = {};
    final formatter = DateFormat.MMMM();

    for (var txn in transactions) {
      final date = DateFormat.yMMMd().parse(txn.date);
      final month = formatter.format(date);

      if (!grouped.containsKey(month)) {
        grouped[month] = [];
      }
      grouped[month]!.add(txn);
    }

    return ListView(
      children: grouped.entries.map((entry) {
        double income = 0, expense = 0;
        for (var txn in entry.value) {
          if (txn.type == "Income") {
            income += txn.amount;
          } else if (txn.type == "Expense") {
            expense += txn.amount;
          }
        }
        return Card(
          margin: const EdgeInsets.all(8),
          child: ExpansionTile(
            title: Text(entry.key),
            subtitle: Text(
              "Income: \$${income.toStringAsFixed(2)} | Expense: \$${expense.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
            children: entry.value.reversed.map<Widget>((txn) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: txn.type == "Income"
                      ? Colors.blue.shade100
                      : Colors.red.shade100,
                  child: Text(
                    txn.type.substring(0, 1),
                    style: TextStyle(
                      color: txn.type == "Income" ? Colors.blue : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text("${txn.type} - ${txn.note}"),
                subtitle: Text(txn.date),
                trailing: Text(
                  "\$${txn.amount.toStringAsFixed(2)}",
                  style: TextStyle(
                    color: txn.type == "Income" ? Colors.blue : Colors.red,
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

