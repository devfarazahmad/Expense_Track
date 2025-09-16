// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:table_calendar/table_calendar.dart';
// import 'package:track_expense/ViewModel/transaction_viewmodel.dart';
// import 'add_transaction_screen.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   DateTime? _selectedDate;

//   DateTime? _tryParseDate(String dateStr) {
//     if (dateStr.isEmpty) return null;

//     final formats = [
//       DateFormat('yyyy-MM-dd'),
//       DateFormat.yMMMd(),
//       DateFormat.yMd(),
//     ];

//     for (final fmt in formats) {
//       try {
//         return fmt.parseLoose(dateStr);
//       } catch (_) {}
//     }

//     try {
//       return DateTime.parse(dateStr);
//     } catch (_) {
//       return null;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final vm = Provider.of<TransactionViewModel>(context);

//     // Filter transactions if a date is selected
//     List transactions = _selectedDate == null
//         ? List.from(vm.transactions)
//         : vm.transactions
//             .where((txn) =>
//                 txn.date ==
//                 DateFormat('yyyy-MM-dd').format(_selectedDate!))
//             .toList();

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Track Expenses"),
//         actions: [
//           IconButton(
//             onPressed: () {
//               showSearch(
//                 context: context,
//                 delegate: TransactionSearch(vm.transactions),
//               );
//             },
//             icon: const Icon(Icons.search),
//           ),
//         ],
//         leading: IconButton(
//           icon: const Icon(Icons.calendar_today),
//           onPressed: () async {
//             await showDialog(
//               context: context,
//               builder: (context) {
//                 return AlertDialog(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                   content: SizedBox(
//                     height: 450,
//                     width: 350,
//                     child: TableCalendar(
//                       focusedDay: DateTime.now(),
//                       firstDay: DateTime(2000),
//                       lastDay: DateTime(2100),
//                       selectedDayPredicate: (day) =>
//                           isSameDay(_selectedDate, day),
//                       onDaySelected: (selectedDay, focusedDay) {
//                         setState(() {
//                           _selectedDate = selectedDay;
//                         });
//                         Navigator.pop(context);
//                       },
//                       headerStyle: HeaderStyle(
//                         formatButtonVisible: false,
//                         titleCentered: true,
//                         titleTextFormatter: (date, locale) =>
//                             DateFormat('MMM yyyy').format(date),
//                         titleTextStyle: const TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.blueAccent,
//                         ),
//                         leftChevronIcon:
//                             const Icon(Icons.chevron_left, color: Colors.blue),
//                         rightChevronIcon:
//                             const Icon(Icons.chevron_right, color: Colors.blue),
//                       ),
//                       daysOfWeekStyle: const DaysOfWeekStyle(
//                         weekdayStyle: TextStyle(
//                             color: Colors.black87, fontWeight: FontWeight.w600),
//                         weekendStyle: TextStyle(
//                             color: Colors.redAccent, fontWeight: FontWeight.w600),
//                       ),
//                       calendarStyle: CalendarStyle(
//                         todayDecoration: BoxDecoration(
//                           color: Colors.orangeAccent,
//                           shape: BoxShape.circle,
//                         ),
//                         selectedDecoration: BoxDecoration(
//                           color: Colors.blue,
//                           shape: BoxShape.circle,
//                         ),
//                         weekendTextStyle:
//                             const TextStyle(color: Colors.redAccent),
//                         defaultTextStyle:
//                             const TextStyle(color: Colors.black87),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             );
//           },
//         ),
//       ),
//       body: Column(
//         children: [
//           // Section: Summary
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 _summaryCard("Income", vm.totalIncome, Colors.green),
//                 _summaryCard("Expense", vm.totalExpense, Colors.red),
//                 _summaryCard("Balance", vm.totalBalance, Colors.blue),
//               ],
//             ),
//           ),
//           const Divider(),
//           // Section: Transactions list (LIFO: latest on top)
//           Expanded(
//             child: transactions.isEmpty
//                 ? const Center(child: Text("No transactions found"))
//                 : ListView.builder(
//                     itemCount: transactions.length,
//                     itemBuilder: (context, index) {
//                       final txn = transactions.reversed.toList()[index];
//                       return ListTile(
//                         leading: CircleAvatar(
//                           backgroundColor:
//                               txn.type == "Income" ? Colors.green : Colors.red,
//                           child: Text(
//                             txn.type.substring(0, 1),
//                             style: const TextStyle(color: Colors.white),
//                           ),
//                         ),
//                         title: Text("${txn.type} - ${txn.note}"),
//                         subtitle: Text(txn.date),
//                         trailing: Text(
//                           "\$${txn.amount.toStringAsFixed(2)}",
//                           style: TextStyle(
//                             color: txn.type == "Income"
//                                 ? Colors.green
//                                 : Colors.red,
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//           ),
//         ],
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(context,
//               MaterialPageRoute(builder: (_) => const AddTransactionScreen()));
//         },
//         child: const Icon(Icons.add),
//       ),
//     );
//   }

//   Widget _summaryCard(String title, double value, Color color) {
//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       elevation: 3,
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           children: [
//             Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
//             Text(
//               "\$${value.toStringAsFixed(2)}",
//               style: TextStyle(color: color, fontSize: 16),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// /// Search Delegate for transactions
// class TransactionSearch extends SearchDelegate {
//   final List<dynamic> transactions;

//   TransactionSearch(this.transactions);

//   @override
//   List<Widget>? buildActions(BuildContext context) {
//     return [
//       IconButton(onPressed: () => query = "", icon: const Icon(Icons.clear))
//     ];
//   }

//   @override
//   Widget? buildLeading(BuildContext context) {
//     return IconButton(
//         onPressed: () => close(context, null),
//         icon: const Icon(Icons.arrow_back));
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     final results = transactions
//         .where((txn) =>
//             (txn.note ?? '').toString().toLowerCase().contains(query.toLowerCase()) ||
//             (txn.type ?? '').toString().toLowerCase().contains(query.toLowerCase()))
//         .toList();

//     return results.isEmpty
//         ? const Center(child: Text("No results found"))
//         : ListView.builder(
//             itemCount: results.length,
//             itemBuilder: (context, index) {
//               final txn = results[index];
//               return ListTile(
//                 leading: CircleAvatar(
//                   backgroundColor:
//                       txn.type == "Income" ? Colors.green : Colors.red,
//                   child: Text(txn.type.substring(0, 1),
//                       style: const TextStyle(color: Colors.white)),
//                 ),
//                 title: Text("${txn.type} - ${txn.note}"),
//                 subtitle: Text(txn.date),
//                 trailing: Text(
//                   "\$${txn.amount.toStringAsFixed(2)}",
//                   style: TextStyle(
//                     color: txn.type == "Income" ? Colors.green : Colors.red,
//                   ),
//                 ),
//               );
//             },
//           );
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     final suggestions = transactions
//         .where((txn) =>
//             (txn.note ?? '').toString().toLowerCase().contains(query.toLowerCase()) ||
//             (txn.type ?? '').toString().toLowerCase().contains(query.toLowerCase()))
//         .toList();

//     return ListView.builder(
//       itemCount: suggestions.length,
//       itemBuilder: (context, index) {
//         final txn = suggestions[index];
//         return ListTile(
//           title: Text("${txn.type} - ${txn.note}"),
//           onTap: () {
//             query = txn.note ?? '';
//             showResults(context);
//           },
//         );
//       },
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:track_expense/ViewModel/transaction_viewmodel.dart';
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
          child: Divider(
            color: Colors.grey,
            height: 1,
          ),
        ),
      ),
      body: Column(
        children: [
          // Section: Summary with Icons in Row
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
        
          // Section: Transactions list (LIFO: latest on top)
          Expanded(
            child: vm.transactions.isEmpty
                ? const Center(child: Text("No transactions found"))
                : ListView.builder(
                    itemCount: vm.transactions.length,
                    itemBuilder: (context, index) {
                      final txn = vm.transactions.reversed.toList()[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: txn.type == "Income"
                              ? const Color.fromARGB(255, 232, 245, 255)
                              : const Color.fromARGB(255, 255, 237, 239),
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
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        
        backgroundColor: Colors.blue,
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const AddTransactionScreen()));
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  /// Summary card with Border Circle Icon + Text in Row
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
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              "\$${value.toStringAsFixed(2)}",
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
