
// // import 'package:flutter/material.dart';
// // import 'package:intl/intl.dart';
// // import 'package:provider/provider.dart';
// // import 'package:math_expressions/math_expressions.dart';
// // import 'package:track_expense/Model/transaction_model.dart';
// // import 'package:track_expense/ViewModel/transaction_viewmodel.dart';

// // class AddTransactionScreen extends StatefulWidget {
// //   const AddTransactionScreen({super.key});

// //   @override
// //   State<AddTransactionScreen> createState() => _AddTransactionScreenState();
// // }

// // class _AddTransactionScreenState extends State<AddTransactionScreen> {
// //   final _amountController = TextEditingController();
// //   final _noteController = TextEditingController();
// //   String _type = "Income";
// //   String? _selectedCategory;
// //   bool _showCalculator = false;
// //   String expression = "";

// //   final Map<String, List<Map<String, dynamic>>> categories = {
// //     "Income": [
// //       {"icon": Icons.work, "label": "Salary", "amount": 500},
// //       {"icon": Icons.card_giftcard, "label": "Lottery", "amount": 200},
// //       {"icon": Icons.attach_money, "label": "Bonus", "amount": 100},
// //     ],
// //     "Expense": [
// //       {"icon": Icons.fastfood, "label": "Food", "amount": 50},
// //       {"icon": Icons.home, "label": "Rent", "amount": 300},
// //       {"icon": Icons.local_taxi, "label": "Transport", "amount": 20},
// //     ],
// //     "Transfer": [
// //       {"icon": Icons.account_balance, "label": "Bank Transfer", "amount": 1000},
// //       {"icon": Icons.send, "label": "To Friend", "amount": 150},
// //       {"icon": Icons.credit_card, "label": "Credit Payment", "amount": 200},
// //     ],
// //   };

// //   void _addCustomCategory() {
// //     final _customController = TextEditingController();
// //     showDialog(
// //       context: context,
// //       builder: (ctx) => AlertDialog(
// //         title: const Text("Add Custom Category"),
// //         content: TextField(
// //           controller: _customController,
// //           decoration: const InputDecoration(hintText: "Enter category name"),
// //         ),
// //         actions: [
// //           TextButton(
// //             onPressed: () => Navigator.pop(ctx),
// //             child: const Text("Cancel"),
// //           ),
// //           ElevatedButton(
// //             onPressed: () {
// //               if (_customController.text.isNotEmpty) {
// //                 setState(() {
// //                   categories[_type]!.add({
// //                     "icon": Icons.star,
// //                     "label": _customController.text,
// //                     "amount": 0,
// //                   });
// //                   _selectedCategory = _customController.text;
// //                   _noteController.text = _customController.text;
// //                 });
// //                 Navigator.pop(ctx);
// //                 Navigator.pop(context);
// //               }
// //             },
// //             child: const Text("Add"),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   void _showCategorySelector() {
// //     final currentCategories = categories[_type]!;
// //     showModalBottomSheet(
// //       context: context,
// //       shape: const RoundedRectangleBorder(
// //         borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
// //       ),
// //       builder: (ctx) => Padding(
// //         padding: const EdgeInsets.all(16),
// //         child: Wrap(
// //           spacing: 12,
// //           runSpacing: 12,
// //           children: [
// //             ...currentCategories.map((cat) {
// //               return ChoiceChip(
// //                 avatar: Icon(cat["icon"], color: const Color(0xFFDEE1E6)),
// //                 label: Text(cat["label"]),
// //                 selected: _selectedCategory == cat["label"],
// //                 selectedColor: const Color(0xFFDEE1E6),
// //                 backgroundColor: Colors.grey.shade300,
// //                 labelStyle: TextStyle(
// //                   color: _selectedCategory == cat["label"]
// //                       ? Colors.white
// //                       : Colors.black,
// //                 ),
// //                 onSelected: (selected) {
// //                   setState(() {
// //                     _selectedCategory = cat["label"];
// //                     _amountController.text = cat["amount"].toString();
// //                     _noteController.text = cat["label"];
// //                   });
// //                   Navigator.pop(context);
// //                 },
// //               );
// //             }).toList(),
// //             ActionChip(
// //               avatar: const Icon(Icons.add, color: Colors.black),
// //               label: const Text("Custom"),
// //               backgroundColor: Colors.white,
// //               labelStyle: const TextStyle(color: Colors.black),
// //               onPressed: _addCustomCategory,
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   // ✅ Calculator logic
// //   void _onPressed(String value) {
// //     setState(() {
// //       if (value == "C") {
// //         expression = "";
// //         _amountController.clear();
// //       } else if (value == "⌫") {
// //         if (expression.isNotEmpty) {
// //           expression = expression.substring(0, expression.length - 1);
// //           _amountController.text = expression;
// //         }
// //       } else if (value == "=") {
// //         try {
// //           Parser p = Parser();
// //           Expression exp = p.parse(expression);
// //           double result = exp.evaluate(EvaluationType.REAL, ContextModel());
// //           expression = result.toStringAsFixed(2);
// //           _amountController.text = expression;
// //         } catch (e) {
// //           expression = "Error";
// //           _amountController.text = "";
// //         }
// //       } else {
// //         expression += value;
// //         _amountController.text = expression;
// //       }
// //     });
// //   }

// //   void _saveTransaction() {
// //     if (_amountController.text.isNotEmpty && _noteController.text.isNotEmpty) {
// //       final txn = TransactionModel(
// //         type: _type,
// //         category: _selectedCategory ?? "Uncategorized",
// //         amount: double.tryParse(_amountController.text) ?? 0,
// //         note: _noteController.text,
// //         date: DateFormat.yMMMd().format(DateTime.now()),
// //       );
// //       Provider.of<TransactionViewModel>(context, listen: false)
// //           .addTransaction(txn);
// //       Navigator.pop(context);
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: SafeArea(
// //         child: Column(
// //           children: [
// //             // ✅ Top Section
// //             Padding(
// //               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
// //               child: Row(
// //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                 children: [
// //                   TextButton(
// //                     onPressed: () => Navigator.pop(context),
// //                     child: const Text("Cancel",
// //                         style: TextStyle(color: Colors.red, fontSize: 16)),
// //                   ),
// //                   TextButton(
// //                     onPressed: _saveTransaction,
// //                     child: const Text("Save Transaction",
// //                         style: TextStyle(color: Colors.blue, fontSize: 16)),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //             const Divider(color: Color(0xFFDEE1E6), thickness: 1),

// //             Expanded(
// //               child: SingleChildScrollView(
// //                 padding: const EdgeInsets.all(16),
// //                 child: Column(
// //                   crossAxisAlignment: CrossAxisAlignment.start,
// //                   children: [
// //                     // ✅ Type Buttons
// //                     Row(
// //                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// //                       children: ["Income", "Expense", "Transfer"].map((t) {
// //                         final isSelected = _type == t;
// //                         return Expanded(
// //                           child: Padding(
// //                             padding:
// //                                 const EdgeInsets.symmetric(horizontal: 4.0),
// //                             child: isSelected
// //                                 ? Container(
// //                                     decoration: BoxDecoration(
// //                                       color: const Color(0xFF0073D1),
// //                                       borderRadius: BorderRadius.circular(24),
                                     
// //                                     ),
// //                                     child: TextButton(
// //                                       onPressed: () {
// //                                         setState(() {
// //                                           _type = t;
// //                                           _selectedCategory = null;
// //                                           _amountController.clear();
// //                                           expression = "";
// //                                           _noteController.clear();
// //                                         });
// //                                       },
// //                                       child: Text(
// //                                         t,
// //                                         style: const TextStyle(
// //                                             color: Colors.white,
// //                                             fontSize: 16,
// //                                             fontWeight: FontWeight.w600),
// //                                       ),
// //                                     ),
// //                                   )
// //                                 : TextButton(
// //                                     onPressed: () {
// //                                       setState(() {
// //                                         _type = t;
// //                                         _selectedCategory = null;
// //                                         _amountController.clear();
// //                                         expression = "";
// //                                         _noteController.clear();
// //                                       });
// //                                     },
// //                                     child: Text(
// //                                       t,
// //                                       style: const TextStyle(
// //                                           color: Colors.black, fontSize: 14),
// //                                     ),
// //                                   ),
// //                           ),
// //                         );
// //                       }).toList(),
// //                     ),

// //                     const SizedBox(height: 16),

// //                     // ✅ Category Field
// //                     TextField(
// //                       readOnly: true,
// //                       onTap: _showCategorySelector,
// //                       decoration: InputDecoration(
// //                         labelText: "Select Category",
// //                         prefixIcon: const Icon(Icons.category),
// //                         hintText: _selectedCategory ?? "Tap to choose",
// //                         filled: true,
// //                         fillColor: Colors.white,
// //                         border: OutlineInputBorder(
// //                           borderRadius: BorderRadius.circular(12),
// //                           borderSide:
// //                               const BorderSide(color: Color(0xFFDEE1E6)),
// //                         ),
// //                         enabledBorder: OutlineInputBorder(
// //                           borderRadius: BorderRadius.circular(12),
// //                           borderSide:
// //                               const BorderSide(color: Color(0xFFDEE1E6)),
// //                         ),
// //                         focusedBorder: OutlineInputBorder(
// //                           borderRadius: BorderRadius.circular(12),
// //                           borderSide:
// //                               const BorderSide(color: Color(0xFFDEE1E6)),
// //                         ),
// //                       ),
// //                     ),

// //                     const SizedBox(height: 16),

// //                     // ✅ Amount Field with label outside
// //                     Column(
// //                       crossAxisAlignment: CrossAxisAlignment.start,
// //                       children: [
// //                         const Text(
// //                           "Amount",
// //                           style: TextStyle(
// //                               fontSize: 14, fontWeight: FontWeight.w500),
// //                         ),
// //                         const SizedBox(height: 6),
// //                         TextField(
// //                           controller: _amountController,
// //                           readOnly: true,
// //                           onTap: () {
// //                             setState(() {
// //                               _showCalculator = true;
// //                             });
// //                           },
// //                           decoration: InputDecoration(
// //                             prefixIcon: const Icon(Icons.attach_money),
// //                             filled: true,
// //                             fillColor: Colors.white,
// //                             border: OutlineInputBorder(
// //                               borderRadius: BorderRadius.circular(12),
// //                             ),
// //                             enabledBorder: OutlineInputBorder(
// //                               borderRadius: BorderRadius.circular(12),
// //                               borderSide: const BorderSide(
// //                                   color: Color(0xFFDEE1E6)),
// //                             ),
// //                             focusedBorder: OutlineInputBorder(
// //                               borderRadius: BorderRadius.circular(12),
// //                               borderSide: const BorderSide(
// //                                   color: Color(0xFFDEE1E6)), // ✅ no blue
// //                             ),
// //                           ),
// //                         ),
// //                       ],
// //                     ),

// //                     const SizedBox(height: 16),

// //                     // ✅ Note Field with label outside, hint text, and right icon
// //                     Column(
// //                       crossAxisAlignment: CrossAxisAlignment.start,
// //                       children: [
// //                         const Text(
// //                           "Note",
// //                           style: TextStyle(
// //                               fontSize: 14, fontWeight: FontWeight.w500),
// //                         ),
// //                         const SizedBox(height: 6),
// //                         TextField(
// //                           controller: _noteController,
// //                           decoration: InputDecoration(
// //                             hintText: "Add a note here (e.g 'Groceries of the week')",
// //                             filled: true,
// //                             fillColor: Colors.white,
// //                             suffixIcon: const Icon(Icons.note), // ✅ right icon
// //                             border: OutlineInputBorder(
// //                               borderRadius: BorderRadius.circular(12),
// //                             ),
// //                             enabledBorder: OutlineInputBorder(
// //                               borderRadius: BorderRadius.circular(12),
// //                               borderSide: const BorderSide(
// //                                   color: Color(0xFFDEE1E6)),
// //                             ),
// //                             focusedBorder: OutlineInputBorder(
// //                               borderRadius: BorderRadius.circular(12),
// //                               borderSide: const BorderSide(
// //                                   color: Color(0xFFDEE1E6)), // ✅ no blue
// //                             ),
// //                           ),
// //                         ),
// //                       ],
// //                     ),

// //                    // const SizedBox(height: 1),

// //                     // ✅ Calculator
// //                     if (_showCalculator) ...[
// //                       Container(
// //                         padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
// //                         alignment: Alignment.centerRight,
// //                         child: Text(
// //                           expression,
// //                           style: const TextStyle(
// //                               fontSize: 20, fontWeight: FontWeight.w500),
// //                         ),
// //                       ),
// //                       Container(
// //                         margin: const EdgeInsets.only(top: 6),
// //                         padding: const EdgeInsets.all(12),
// //                         decoration: BoxDecoration(
// //                           color: const Color(0xFFFAFAFB),
// //                           borderRadius: BorderRadius.circular(16),
// //                           boxShadow: [
// //                             BoxShadow(
// //                               color: Colors.black26,
// //                               blurRadius: 6,
// //                               offset: const Offset(2, 2),
// //                             ),
// //                           ],
// //                         ),
// //                         child: GridView.count(
// //                           crossAxisCount: 4,
// //                           shrinkWrap: true,
// //                           physics: const NeverScrollableScrollPhysics(),
// //                           childAspectRatio: 1.4,
// //                           children: [
// //                             "7", "8", "9", "/",
// //                             "4", "5", "6", "*",
// //                             "1", "2", "3", "-",
// //                             "0", ".", "=", "+",
// //                             "C", "⌫",
// //                           ].map((btnText) {
// //                             return Padding(
// //                               padding: const EdgeInsets.all(6.0),
// //                               child: ElevatedButton(
// //                                 style: ElevatedButton.styleFrom(
// //                                   backgroundColor: btnText == "C"
// //                                       ? const Color(0xFFCA5359)
// //                                       : (btnText == "="
// //                                           ? const Color(0xFF0073D1)
// //                                           : Colors.white),
// //                                   foregroundColor: btnText == "C" || btnText == "="
// //                                       ? Colors.white
// //                                       : Colors.black,
// //                                   shape: RoundedRectangleBorder(
// //                                     borderRadius: BorderRadius.circular(12),
// //                                   ),
// //                                   elevation: 0,
// //                                 ),
// //                                 onPressed: () => _onPressed(btnText),
// //                                 child: Text(
// //                                   btnText,
// //                                   style: const TextStyle(
// //                                       fontSize: 18,
// //                                       fontWeight: FontWeight.bold),
// //                                 ),
// //                               ),
// //                             );
// //                           }).toList(),
// //                         ),
// //                       ),
// //                     ],
// //                   ],
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }



// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:math_expressions/math_expressions.dart';
// import 'package:track_expense/Model/transaction_model.dart';
// import 'package:track_expense/ViewModel/transaction_viewmodel.dart';

// class AddTransactionScreen extends StatefulWidget {
//   const AddTransactionScreen({super.key});

//   @override
//   State<AddTransactionScreen> createState() => _AddTransactionScreenState();
// }

// class _AddTransactionScreenState extends State<AddTransactionScreen> {
//   final _amountController = TextEditingController();
//   final _noteController = TextEditingController();
//   String _type = "Income";
//   String? _selectedCategory;
//   bool _showCalculator = false;
//   String expression = "";

//   final Map<String, List<Map<String, dynamic>>> categories = {
//     "Income": [
//       {"icon": Icons.work, "label": "Salary", "amount": 500},
//       {"icon": Icons.card_giftcard, "label": "Lottery", "amount": 200},
//       {"icon": Icons.attach_money, "label": "Bonus", "amount": 100},
//     ],
//     "Expense": [
//       {"icon": Icons.fastfood, "label": "Food", "amount": 50},
//       {"icon": Icons.home, "label": "Rent", "amount": 300},
//       {"icon": Icons.local_taxi, "label": "Transport", "amount": 20},
//     ],
//     "Transfer": [
//       {"icon": Icons.account_balance, "label": "Bank Transfer", "amount": 1000},
//       {"icon": Icons.send, "label": "To Friend", "amount": 150},
//       {"icon": Icons.credit_card, "label": "Credit Payment", "amount": 200},
//     ],
//   };

//   void _addCustomCategory() {
//     final _customController = TextEditingController();
//     showDialog(
//       context: context,
//       builder: (ctx) {
//         final isDark = Theme.of(context).brightness == Brightness.dark;
//         return AlertDialog(
//           backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
//           title: Text("Add Custom Category",
//               style: TextStyle(color: isDark ? Colors.white : Colors.black)),
//           content: TextField(
//             controller: _customController,
//             style: TextStyle(color: isDark ? Colors.white : Colors.black),
//             decoration: InputDecoration(
//               hintText: "Enter category name",
//               hintStyle:
//                   TextStyle(color: isDark ? Colors.white70 : Colors.black54),
//               filled: true,
//               fillColor: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(ctx),
//               child: Text("Cancel",
//                   style: TextStyle(color: isDark ? Colors.red[300] : Colors.red)),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 if (_customController.text.isNotEmpty) {
//                   setState(() {
//                     categories[_type]!.add({
//                       "icon": Icons.star,
//                       "label": _customController.text,
//                       "amount": 0,
//                     });
//                     _selectedCategory = _customController.text;
//                     _noteController.text = _customController.text;
//                   });
//                   Navigator.pop(ctx);
//                   Navigator.pop(context);
//                 }
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.blue,
//                 foregroundColor: Colors.white,
//               ),
//               child: const Text("Add"),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _showCategorySelector() {
//     final currentCategories = categories[_type]!;
//     final isDark = Theme.of(context).brightness == Brightness.dark;

//     showModalBottomSheet(
//       context: context,
//       backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//       ),
//       builder: (ctx) => Padding(
//         padding: const EdgeInsets.all(16),
//         child: Wrap(
//           spacing: 12,
//           runSpacing: 12,
//           children: [
//             ...currentCategories.map((cat) {
//               final selected = _selectedCategory == cat["label"];
//               return ChoiceChip(
//                 avatar: Icon(cat["icon"],
//                     color: selected
//                         ? Colors.white
//                         : (isDark ? Colors.white70 : Colors.black54)),
//                 label: Text(cat["label"],
//                     style: TextStyle(
//                         color: selected
//                             ? Colors.white
//                             : (isDark ? Colors.white : Colors.black))),
//                 selected: selected,
//                 selectedColor: Colors.blue,
//                 backgroundColor:
//                     isDark ? Colors.grey.shade800 : Colors.grey.shade200,
//                 onSelected: (s) {
//                   setState(() {
//                     _selectedCategory = cat["label"];
//                     _amountController.text = cat["amount"].toString();
//                     _noteController.text = cat["label"];
//                   });
//                   Navigator.pop(context);
//                 },
//               );
//             }),
//             ActionChip(
//               avatar: const Icon(Icons.add, color: Colors.blue),
//               label: Text("Custom",
//                   style:
//                       TextStyle(color: isDark ? Colors.white : Colors.black)),
//               backgroundColor:
//                   isDark ? Colors.grey.shade800 : Colors.grey.shade100,
//               onPressed: _addCustomCategory,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // ✅ Calculator logic
//   void _onPressed(String value) {
//     setState(() {
//       if (value == "C") {
//         expression = "";
//         _amountController.clear();
//       } else if (value == "⌫") {
//         if (expression.isNotEmpty) {
//           expression = expression.substring(0, expression.length - 1);
//           _amountController.text = expression;
//         }
//       } else if (value == "=") {
//         try {
//           Parser p = Parser();
//           Expression exp = p.parse(expression);
//           double result = exp.evaluate(EvaluationType.REAL, ContextModel());
//           expression = result.toStringAsFixed(2);
//           _amountController.text = expression;
//         } catch (_) {
//           expression = "Error";
//           _amountController.text = "";
//         }
//       } else {
//         expression += value;
//         _amountController.text = expression;
//       }
//     });
//   }

//   void _saveTransaction() {
//     if (_amountController.text.isNotEmpty && _noteController.text.isNotEmpty) {
//       final txn = TransactionModel(
//         type: _type,
//         category: _selectedCategory ?? "Uncategorized",
//         amount: double.tryParse(_amountController.text) ?? 0,
//         note: _noteController.text,
//         date: DateFormat.yMMMd().format(DateTime.now()),
//       );
//       Provider.of<TransactionViewModel>(context, listen: false)
//           .addTransaction(txn);
//       Navigator.pop(context);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final bgColor = isDark ? Colors.black : Colors.white;
//     final textColor = isDark ? Colors.white : Colors.black;
//     final fieldColor = isDark ? Colors.grey.shade900 : Colors.white;

//     return Scaffold(
//       backgroundColor: bgColor,
//       body: SafeArea(
//         child: Column(
//           children: [
//             // ✅ Top Section
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   TextButton(
//                     onPressed: () => Navigator.pop(context),
//                     child: Text("Cancel",
//                         style: TextStyle(
//                             color: isDark ? Colors.red[300] : Colors.red,
//                             fontSize: 16)),
//                   ),
//                   TextButton(
//                     onPressed: _saveTransaction,
//                     child: Text("Save Transaction",
//                         style: TextStyle(
//                             color: Colors.blue,
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600)),
//                   ),
//                 ],
//               ),
//             ),
//             Divider(
//                 color: isDark ? Colors.grey.shade700 : const Color(0xFFDEE1E6),
//                 thickness: 1),

//             Expanded(
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // ✅ Type Buttons
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: ["Income", "Expense", "Transfer"].map((t) {
//                         final isSelected = _type == t;
//                         return Expanded(
//                           child: Padding(
//                             padding:
//                                 const EdgeInsets.symmetric(horizontal: 4.0),
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 color: isSelected
//                                     ? Colors.blue
//                                     : Colors.transparent,
//                                 borderRadius: BorderRadius.circular(24),
//                               ),
//                               child: TextButton(
//                                 onPressed: () {
//                                   setState(() {
//                                     _type = t;
//                                     _selectedCategory = null;
//                                     _amountController.clear();
//                                     expression = "";
//                                     _noteController.clear();
//                                   });
//                                 },
//                                 child: Text(
//                                   t,
//                                   style: TextStyle(
//                                     color: isSelected
//                                         ? Colors.white
//                                         : (isDark
//                                             ? Colors.white70
//                                             : Colors.black87),
//                                     fontSize: isSelected ? 16 : 14,
//                                     fontWeight: isSelected
//                                         ? FontWeight.w600
//                                         : FontWeight.normal,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         );
//                       }).toList(),
//                     ),

//                     const SizedBox(height: 16),

//                     // ✅ Category Field
//                     TextField(
//                       readOnly: true,
//                       onTap: _showCategorySelector,
//                       style: TextStyle(color: textColor),
//                       decoration: InputDecoration(
//                         labelText: "Select Category",
//                         labelStyle: TextStyle(color: textColor),
//                         prefixIcon: Icon(Icons.category,
//                             color: isDark ? Colors.white70 : Colors.black54),
//                         hintText: _selectedCategory ?? "Tap to choose",
//                         hintStyle: TextStyle(
//                             color: isDark ? Colors.white60 : Colors.black54),
//                         filled: true,
//                         fillColor: fieldColor,
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: BorderSide(
//                               color: isDark
//                                   ? Colors.grey.shade700
//                                   : const Color(0xFFDEE1E6)),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: BorderSide(
//                               color: isDark
//                                   ? Colors.grey.shade500
//                                   : const Color(0xFFDEE1E6)),
//                         ),
//                       ),
//                     ),

//                     const SizedBox(height: 16),

//                     // ✅ Amount Field
//                     Text("Amount",
//                         style: TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w500,
//                             color: textColor)),
//                     const SizedBox(height: 6),
//                     TextField(
//                       controller: _amountController,
//                       readOnly: true,
//                       style: TextStyle(color: textColor),
//                       onTap: () {
//                         setState(() {
//                           _showCalculator = true;
//                         });
//                       },
//                       decoration: InputDecoration(
//                         prefixIcon: Icon(Icons.attach_money,
//                             color: isDark ? Colors.white70 : Colors.black54),
//                         filled: true,
//                         fillColor: fieldColor,
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: BorderSide(
//                               color: isDark
//                                   ? Colors.grey.shade700
//                                   : const Color(0xFFDEE1E6)),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: BorderSide(
//                               color: isDark
//                                   ? Colors.grey.shade500
//                                   : const Color(0xFFDEE1E6)),
//                         ),
//                       ),
//                     ),

//                     const SizedBox(height: 16),

//                     // ✅ Note Field
//                     Text("Note",
//                         style: TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w500,
//                             color: textColor)),
//                     const SizedBox(height: 6),
//                     TextField(
//                       controller: _noteController,
//                       style: TextStyle(color: textColor),
//                       decoration: InputDecoration(
//                         hintText: "Add a note here (e.g 'Groceries of the week')",
//                         hintStyle: TextStyle(
//                             color: isDark ? Colors.white60 : Colors.black54),
//                         filled: true,
//                         fillColor: fieldColor,
//                         suffixIcon: Icon(Icons.note,
//                             color: isDark ? Colors.white70 : Colors.black54),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: BorderSide(
//                               color: isDark
//                                   ? Colors.grey.shade700
//                                   : const Color(0xFFDEE1E6)),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: BorderSide(
//                               color: isDark
//                                   ? Colors.grey.shade500
//                                   : const Color(0xFFDEE1E6)),
//                         ),
//                       ),
//                     ),

//                     // ✅ Calculator
//                     if (_showCalculator) ...[
//                       Container(
//                         padding:
//                             const EdgeInsets.only(left: 8, right: 8, top: 8),
//                         alignment: Alignment.centerRight,
//                         child: Text(expression,
//                             style: TextStyle(
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.w500,
//                                 color: textColor)),
//                       ),
//                       Container(
//                         margin: const EdgeInsets.only(top: 6),
//                         padding: const EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           color: isDark
//                               ? Colors.grey.shade900
//                               : const Color(0xFFFAFAFB),
//                           borderRadius: BorderRadius.circular(16),
//                           boxShadow: [
//                             BoxShadow(
//                               color: isDark
//                                   ? Colors.black.withOpacity(0.3)
//                                   : Colors.black26,
//                               blurRadius: 6,
//                               offset: const Offset(2, 2),
//                             ),
//                           ],
//                         ),
//                         child: GridView.count(
//                           crossAxisCount: 4,
//                           shrinkWrap: true,
//                           physics: const NeverScrollableScrollPhysics(),
//                           childAspectRatio: 1.4,
//                           children: [
//                             "7", "8", "9", "/",
//                             "4", "5", "6", "*",
//                             "1", "2", "3", "-",
//                             "0", ".", "=", "+",
//                             "C", "⌫",
//                           ].map((btnText) {
//                             final isAction = btnText == "C" || btnText == "=";
//                             return Padding(
//                               padding: const EdgeInsets.all(6.0),
//                               child: ElevatedButton(
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: btnText == "C"
//                                       ? const Color(0xFFCA5359)
//                                       : (btnText == "="
//                                           ? const Color(0xFF0073D1)
//                                           : (isDark
//                                               ? Colors.grey.shade800
//                                               : Colors.white)),
//                                   foregroundColor: isAction
//                                       ? Colors.white
//                                       : (isDark ? Colors.white : Colors.black),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                   elevation: 0,
//                                 ),
//                                 onPressed: () => _onPressed(btnText),
//                                 child: Text(btnText,
//                                     style: TextStyle(
//                                         fontSize: 18,
//                                         fontWeight: FontWeight.bold,
//                                         color: isAction
//                                             ? Colors.white
//                                             : (isDark
//                                                 ? Colors.white
//                                                 : Colors.black))),
//                               ),
//                             );
//                           }).toList(),
//                         ),
//                       ),
//                     ],
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:track_expense/Model/transaction_model.dart';
import 'package:track_expense/ViewModel/transaction_viewmodel.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  String _type = "Income";
  String? _selectedCategory;
  bool _showCalculator = true; // ✅ Always visible
  String expression = "";

  final Map<String, List<Map<String, dynamic>>> categories = {
    "Income": [
      {"icon": Icons.work, "label": "Salary", "amount": 500},
      {"icon": Icons.card_giftcard, "label": "Lottery", "amount": 200},
      {"icon": Icons.attach_money, "label": "Bonus", "amount": 100},
    ],
    "Expense": [
      {"icon": Icons.fastfood, "label": "Food", "amount": 50},
      {"icon": Icons.home, "label": "Rent", "amount": 300},
      {"icon": Icons.local_taxi, "label": "Transport", "amount": 20},
    ],
    "Transfer": [
      {"icon": Icons.account_balance, "label": "Bank Transfer", "amount": 1000},
      {"icon": Icons.send, "label": "To Friend", "amount": 150},
      {"icon": Icons.credit_card, "label": "Credit Payment", "amount": 200},
    ],
  };

  void _addCustomCategory() {
    final _customController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
          title: Text("Add Custom Category",
              style: TextStyle(color: isDark ? Colors.white : Colors.black)),
          content: TextField(
            controller: _customController,
            style: TextStyle(color: isDark ? Colors.white : Colors.black),
            decoration: InputDecoration(
              hintText: "Enter category name",
              hintStyle:
                  TextStyle(color: isDark ? Colors.white70 : Colors.black54),
              filled: true,
              fillColor: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text("Cancel",
                  style: TextStyle(color: isDark ? Colors.red[300] : Colors.red)),
            ),
            ElevatedButton(
              onPressed: () {
                if (_customController.text.isNotEmpty) {
                  setState(() {
                    categories[_type]!.add({
                      "icon": Icons.star,
                      "label": _customController.text,
                      "amount": 0,
                    });
                    _selectedCategory = _customController.text;
                    _noteController.text = _customController.text;
                  });
                  Navigator.pop(ctx);
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  void _showCategorySelector() {
    final currentCategories = categories[_type]!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            ...currentCategories.map((cat) {
              final selected = _selectedCategory == cat["label"];
              return ChoiceChip(
                avatar: Icon(cat["icon"],
                    color: selected
                        ? Colors.white
                        : (isDark ? Colors.white70 : Colors.black54)),
                label: Text(cat["label"],
                    style: TextStyle(
                        color: selected
                            ? Colors.white
                            : (isDark ? Colors.white : Colors.black))),
                selected: selected,
                selectedColor: Colors.blue,
                backgroundColor:
                    isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                onSelected: (s) {
                  setState(() {
                    _selectedCategory = cat["label"];
                    _noteController.text = cat["label"];
                    // ✅ Removed setting default amount
                  });
                  Navigator.pop(context);
                },
              );
            }),
            ActionChip(
              avatar: const Icon(Icons.add, color: Colors.blue),
              label: Text("Custom",
                  style:
                      TextStyle(color: isDark ? Colors.white : Colors.black)),
              backgroundColor:
                  isDark ? Colors.grey.shade800 : Colors.grey.shade100,
              onPressed: _addCustomCategory,
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Calculator logic
  void _onPressed(String value) {
    setState(() {
      if (value == "C") {
        expression = "";
        _amountController.clear();
      } else if (value == "⌫") {
        if (expression.isNotEmpty) {
          expression = expression.substring(0, expression.length - 1);
          _amountController.text = expression;
        }
      } else if (value == "=") {
        try {
          Parser p = Parser();
          Expression exp = p.parse(expression);
          double result = exp.evaluate(EvaluationType.REAL, ContextModel());
          expression = result.toStringAsFixed(2);
          _amountController.text = expression;
        } catch (_) {
          expression = "Error";
          _amountController.text = "";
        }
      } else {
        expression += value;
        _amountController.text = expression;
      }
    });
  }

  void _saveTransaction() {
    if (_amountController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      final txn = TransactionModel(
        type: _type,
        category: _selectedCategory ?? "Uncategorized",
        amount: double.tryParse(_amountController.text) ?? 0,
        note: _noteController.text,
        date: DateFormat.yMMMd().format(DateTime.now()),
      );
      Provider.of<TransactionViewModel>(context, listen: false)
          .addTransaction(txn);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? Colors.black : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black;
    final fieldColor = isDark ? Colors.grey.shade900 : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
            // ✅ Top Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Cancel",
                        style: TextStyle(
                            color: isDark ? Colors.red[300] : Colors.red,
                            fontSize: 16)),
                  ),
                  TextButton(
                    onPressed: _saveTransaction,
                    child: Text("Save Transaction",
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 16,
                            fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ),
            Divider(
                color: isDark ? Colors.grey.shade700 : const Color(0xFFDEE1E6),
                thickness: 1),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ✅ Type Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: ["Income", "Expense", "Transfer"].map((t) {
                        final isSelected = _type == t;
                        return Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.blue
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  setState(() {
                                    _type = t;
                                    _selectedCategory = null;
                                    _amountController.clear();
                                    expression = "";
                                    _noteController.clear();
                                  });
                                },
                                child: Text(
                                  t,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : (isDark
                                            ? Colors.white70
                                            : Colors.black87),
                                    fontSize: isSelected ? 16 : 14,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 16),

                    // ✅ Category Field
                    TextField(
                      readOnly: true,
                      onTap: _showCategorySelector,
                      style: TextStyle(color: textColor),
                      decoration: InputDecoration(
                        labelText: "Select Category",
                        labelStyle: TextStyle(color: textColor),
                        prefixIcon: Icon(Icons.category,
                            color: isDark ? Colors.white70 : Colors.black54),
                        hintText: _selectedCategory ?? "Tap to choose",
                        hintStyle: TextStyle(
                            color: isDark ? Colors.white60 : Colors.black54),
                        filled: true,
                        fillColor: fieldColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: isDark
                                  ? Colors.grey.shade700
                                  : const Color(0xFFDEE1E6)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: isDark
                                  ? Colors.grey.shade500
                                  : const Color(0xFFDEE1E6)),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ✅ Amount Field
                    Text("Amount",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: textColor)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _amountController,
                      readOnly: true,
                      style: TextStyle(color: textColor),
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.attach_money,
                            color: isDark ? Colors.white70 : Colors.black54),
                        filled: true,
                        fillColor: fieldColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: isDark
                                  ? Colors.grey.shade700
                                  : const Color(0xFFDEE1E6)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: isDark
                                  ? Colors.grey.shade500
                                  : const Color(0xFFDEE1E6)),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ✅ Note Field
                    Text("Note",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: textColor)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _noteController,
                      style: TextStyle(color: textColor),
                      decoration: InputDecoration(
                        hintText: "Add a note here (e.g 'Groceries of the week')",
                        hintStyle: TextStyle(
                            color: isDark ? Colors.white60 : Colors.black54),
                        filled: true,
                        fillColor: fieldColor,
                        suffixIcon: Icon(Icons.note,
                            color: isDark ? Colors.white70 : Colors.black54),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: isDark
                                  ? Colors.grey.shade700
                                  : const Color(0xFFDEE1E6)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: isDark
                                  ? Colors.grey.shade500
                                  : const Color(0xFFDEE1E6)),
                        ),
                      ),
                    ),

                    // ✅ Calculator (always visible now)
                    Container(
                      padding:
                          const EdgeInsets.only(left: 8, right: 8, top: 8),
                      alignment: Alignment.centerRight,
                      child: Text(expression,
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: textColor)),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 6),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.grey.shade900
                            : const Color(0xFFFAFAFB),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: isDark
                                ? Colors.black.withOpacity(0.3)
                                : Colors.black26,
                            blurRadius: 6,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                      child: GridView.count(
                        crossAxisCount: 4,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        childAspectRatio: 1.4,
                        children: [
                          "7", "8", "9", "/",
                          "4", "5", "6", "*",
                          "1", "2", "3", "-",
                          "0", ".", "=", "+",
                          "C", "⌫",
                        ].map((btnText) {
                          final isAction = btnText == "C" || btnText == "=";
                          return Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: btnText == "C"
                                    ? const Color(0xFFCA5359)
                                    : (btnText == "="
                                        ? const Color(0xFF0073D1)
                                        : (isDark
                                            ? Colors.grey.shade800
                                            : Colors.white)),
                                foregroundColor: isAction
                                    ? Colors.white
                                    : (isDark ? Colors.white : Colors.black),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              onPressed: () => _onPressed(btnText),
                              child: Text(btnText,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: isAction
                                          ? Colors.white
                                          : (isDark
                                              ? Colors.white
                                              : Colors.black))),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
