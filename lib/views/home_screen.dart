

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:track_expense/ViewModel/transaction_viewmodel.dart';
// import 'package:track_expense/views/transaction_detail_screen.dart';
// import 'add_transaction_screen.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   @override
//   Widget build(BuildContext context) {
//     final vm = Provider.of<TransactionViewModel>(context);

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: Colors.white, // ✅ White background
//         elevation: 0, // ✅ Flat look
//         title: const Center(
//           child: Text(
//             "Track Expenses",
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//               color: Colors.black, // ✅ Text black for contrast
//             ),
//           ),
//         ),
//         bottom: const PreferredSize(
//           preferredSize: Size.fromHeight(1),
//           child: Divider(color: Color(0xFFDEE1E6), height: 1),
//         ),
//         iconTheme: const IconThemeData(color: Colors.black), // ✅ Icons black
//       ),
//       body: Column(
//         children: [
//           // ✅ Summary Section
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 _summaryCard("Income", vm.totalIncome, Colors.blue, Icons.arrow_upward),
//                 _summaryCard("Expense", vm.totalExpense, Colors.red, Icons.arrow_downward_rounded),
//                 _summaryCard("Balance", vm.totalBalance, Colors.green, Icons.account_balance_wallet),
//               ],
//             ),
//           ),

//           // ✅ Transactions List (inside one container with divider)
//           Expanded(
//             child: vm.transactions.isEmpty
//                 ? const Center(child: Text("No transactions found"))
//                 : Container(
//                     margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       border: Border.all(color: Colors.grey.shade300),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Padding(
//                           padding: EdgeInsets.all(12.0),
//                           child: Text(
//                             "Recent Transactions",
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                         const Divider(height: 1, color: Color(0xFFF3F4F6)),

//                         // ✅ Transaction List
//                         Expanded(
//                           child: ListView.separated(
//                             itemCount: vm.transactions.length,
//                             separatorBuilder: (context, index) =>
//                                 const Divider(height: 1, color: Color(0xFFF3F4F6)),
//                             itemBuilder: (context, index) {
//                               // take reversed list → latest first
//                               final txn = vm.transactions.reversed.toList()[index];

//                               return ListTile(
//                                 onTap: () {
//                                   Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (_) =>
//                                           TransactionDetailsScreen(transaction: txn),
//                                     ),
//                                   );
//                                 },
//                                 leading: CircleAvatar(
//                                   backgroundColor: txn.type == "Income"
//                                       ? const Color.fromARGB(255, 232, 245, 255)
//                                       : const Color.fromARGB(255, 255, 237, 239),
//                                   child: Text(
//                                     txn.type.substring(0, 1),
//                                     style: TextStyle(
//                                       color: txn.type == "Income" ? Colors.blue : Colors.red,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ),
//                                 title: Text("${txn.type} - ${txn.category}"),
//                                 subtitle: Text("${txn.date} | ${txn.note}"),
//                                 trailing: Text(
//                                   "\$${txn.amount.toStringAsFixed(2)}",
//                                   style: TextStyle(
//                                     color: txn.type == "Income" ? Colors.blue : Colors.red,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//           ),
//         ],
//       ),

//       // ✅ Add Transaction Button
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Colors.blue,
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) => const AddTransactionScreen()),
//           );
//         },
//         child: const Icon(Icons.add, color: Colors.white),
//       ),
//     );
//   }

//   // ✅ Summary Card Widget
//   Widget _summaryCard(String title, double value, Color color, IconData icon) {
//     return Container(
//       width: 114,
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         border: Border.all(color: Colors.grey.shade400),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(0.5),
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   border: Border.all(color: color, width: 2),
//                 ),
//                 child: Icon(icon, color: color, size: 16),
//               ),
//               const SizedBox(width: 8),
//               Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
//             ],
//           ),
//           const SizedBox(height: 6),
//           Text(
//             "\$${value.toStringAsFixed(2)}",
//             style: TextStyle(
//                 color: color, fontSize: 12, fontWeight: FontWeight.bold),
//           ),
//         ],
//       ),
//     );
//   }
// }



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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Center(
          child: Text(
            "Track Expenses",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(color: Color(0xFFDEE1E6), height: 1),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          // ✅ Summary Section
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: _summaryCard(
                      "Income", vm.totalIncome, Colors.blue, Icons.arrow_upward),
                ),
                Expanded(
                  child: _summaryCard("Expense", vm.totalExpense, Colors.red,
                      Icons.arrow_downward_rounded),
                ),
                Expanded(
                  child: _summaryCard("Balance", vm.totalBalance, Colors.green,
                      Icons.account_balance_wallet),
                ),
              ],
            ),
          ),

          // ✅ Transactions List (inside one container with shadow + radius)
          Expanded(
            child: vm.transactions.isEmpty
                ? const Center(child: Text("No transactions found"))
                : Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12), // ✅ rounded
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.15),
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
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Divider(
                          height: 1,
                          // color: Color(0xFFF3F4F6),
                           color: Colors.white,

                          indent: 12, // ✅ divider not touching start
                          endIndent: 12, // ✅ divider not touching end
                        ),

                        // ✅ Transaction List
                        Expanded(
                          child: ListView.separated(
                            itemCount: vm.transactions.length,
                            separatorBuilder: (context, index) =>
                                const Divider(
                                  height: 1,
                                  color: Color(0xFFF3F4F6),
                                  indent: 12, // ✅ same indent for items
                                  endIndent: 12,
                                ),
                            itemBuilder: (context, index) {
                              // take reversed list → latest first
                              final txn =
                                  vm.transactions.reversed.toList()[index];

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
                                title: Text("${txn.type} - ${txn.category}"),
                                subtitle: Text("${txn.date} | ${txn.note}"),
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6), // space between cards
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
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
            mainAxisSize: MainAxisSize.max,
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
