// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:math_expressions/math_expressions.dart';
// import 'package:track_expense/Model/transaction_model.dart';
// import 'package:track_expense/ViewModel/transaction_viewmodel.dart';
// import 'package:shared_preferences/shared_preferences.dart';

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
//   String expression = "";

//   // Default Categories
//   Map<String, List<Map<String, dynamic>>> categories = {
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

//   @override
//   void initState() {
//     super.initState();
//     _loadCustomCategories(); 
//   }

//   Future<void> _loadCustomCategories() async {
//     final prefs = await SharedPreferences.getInstance();
//     for (var type in ["Income", "Expense", "Transfer"]) {
//       List<String>? savedCats = prefs.getStringList("custom_$type");
//       if (savedCats != null) {
//         for (var label in savedCats) {
//           categories[type]!.add({
//             "icon": Icons.star,
//             "label": label,
//             "amount": 0,
//           });
//         }
//       }
//     }
//     setState(() {});
//   }

//   Future<void> _saveCustomCategory(String type, String label) async {
//     final prefs = await SharedPreferences.getInstance();
//     List<String> savedCats = prefs.getStringList("custom_$type") ?? [];
//     if (!savedCats.contains(label)) {
//       savedCats.add(label);
//       await prefs.setStringList("custom_$type", savedCats);
//     }
//   }

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
//                   style:
//                       TextStyle(color: isDark ? Colors.red[300] : Colors.red)),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 if (_customController.text.isNotEmpty) {
//                   String newCategory = _customController.text;

//                   setState(() {
//                     categories[_type]!.add({
//                       "icon": Icons.star,
//                       "label": newCategory,
//                       "amount": 0,
//                     });
//                     _selectedCategory = newCategory;
//                     _noteController.text = newCategory;
//                   });

//                   await _saveCustomCategory(_type, newCategory);

//                   Navigator.pop(ctx);
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
//                         style: const TextStyle(
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
//                       ),
//                     ),
//                     const SizedBox(height: 16),
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
//                       decoration: InputDecoration(
//                         prefixIcon: Icon(Icons.attach_money,
//                             color: isDark ? Colors.white70 : Colors.black54),
//                         filled: true,
//                         fillColor: fieldColor,
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
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
//                       ),
//                     ),
//                     Container(
//                       padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
//                       alignment: Alignment.centerRight,
//                       child: Text(expression,
//                           style: TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.w500,
//                               color: textColor)),
//                     ),
//                     Container(
//                       margin: const EdgeInsets.only(top: 6),
//                       padding: const EdgeInsets.all(12),
//                       decoration: BoxDecoration(
//                         color: isDark
//                             ? Colors.grey.shade900
//                             : const Color(0xFFFAFAFB),
//                         borderRadius: BorderRadius.circular(16),
//                         boxShadow: [
//                           BoxShadow(
//                             color: isDark
//                                 ? Colors.black.withOpacity(0.3)
//                                 : Colors.black26,
//                             blurRadius: 6,
//                             offset: const Offset(2, 2),
//                           ),
//                         ],
//                       ),
//                       child: GridView.count(
//                         crossAxisCount: 4,
//                         shrinkWrap: true,
//                         physics: const NeverScrollableScrollPhysics(),
//                         childAspectRatio: 1.4,
//                         children: [
//                           "7", "8", "9", "/",
//                           "4", "5", "6", "*",
//                           "1", "2", "3", "-",
//                           "0", ".", "=", "+",
//                           "C", "⌫"
//                         ].map((btnText) {
//                           final isAction = btnText == "C" || btnText == "=";
//                           return Padding(
//                             padding: const EdgeInsets.all(6.0),
//                             child: ElevatedButton(
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: btnText == "C"
//                                     ? const Color(0xFFCA5359)
//                                     : (btnText == "="
//                                         ? const Color(0xFF0073D1)
//                                         : (isDark
//                                             ? Colors.grey.shade800
//                                             : Colors.white)),
//                                 foregroundColor: isAction
//                                     ? Colors.white
//                                     : (isDark ? Colors.white : Colors.black),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                                 elevation: 0,
//                               ),
//                               onPressed: () => _onPressed(btnText),
//                               child: Text(
//                                 btnText,
//                                 style: TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                   color: isAction
//                                       ? Colors.white
//                                       : (isDark
//                                           ? Colors.white
//                                           : Colors.black),
//                                 ),
//                               ),
//                             ),
//                           );
//                         }).toList(),
//                       ),
//                     ),
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



// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:math_expressions/math_expressions.dart';
// import 'package:track_expense/Model/transaction_model.dart';
// import 'package:track_expense/ViewModel/transaction_viewmodel.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class AddTransactionScreen extends StatefulWidget {
//   const AddTransactionScreen({super.key});

//   @override
//   State<AddTransactionScreen> createState() => _AddTransactionScreenState();
// }

// class _AddTransactionScreenState extends State<AddTransactionScreen> {
//   final _amountController = TextEditingController();
//   final _noteController = TextEditingController();
//   final _formKey = GlobalKey<FormState>(); // ✅ Added form key
//   String _type = "Income";
//   String? _selectedCategory;
//   String expression = "";

//   // Default Categories
//   Map<String, List<Map<String, dynamic>>> categories = {
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

//   @override
//   void initState() {
//     super.initState();
//     _loadCustomCategories();
//   }

//   Future<void> _loadCustomCategories() async {
//     final prefs = await SharedPreferences.getInstance();
//     for (var type in ["Income", "Expense", "Transfer"]) {
//       List<String>? savedCats = prefs.getStringList("custom_$type");
//       if (savedCats != null) {
//         for (var label in savedCats) {
//           categories[type]!.add({
//             "icon": Icons.star,
//             "label": label,
//             "amount": 0,
//           });
//         }
//       }
//     }
//     setState(() {});
//   }

//   Future<void> _saveCustomCategory(String type, String label) async {
//     final prefs = await SharedPreferences.getInstance();
//     List<String> savedCats = prefs.getStringList("custom_$type") ?? [];
//     if (!savedCats.contains(label)) {
//       savedCats.add(label);
//       await prefs.setStringList("custom_$type", savedCats);
//     }
//   }

//   void _addCustomCategory() {
//     final _customController = TextEditingController();
//     showDialog(
//       context: context,
//       builder: (ctx) {
//         final isDark = Theme.of(context).brightness == Brightness.dark;
//         return AlertDialog(
//           backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
//           title: Text(
//             "Add Custom Category",
//             style: TextStyle(color: isDark ? Colors.white : Colors.black),
//           ),
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
//                   style:
//                       TextStyle(color: isDark ? Colors.red[300] : Colors.red)),
//             ),
//             ElevatedButton(
//               onPressed: () async {
//                 if (_customController.text.isNotEmpty) {
//                   String newCategory = _customController.text;

//                   setState(() {
//                     categories[_type]!.add({
//                       "icon": Icons.star,
//                       "label": newCategory,
//                       "amount": 0,
//                     });
//                     _selectedCategory = newCategory;
//                     _noteController.text = newCategory;
//                   });

//                   await _saveCustomCategory(_type, newCategory);

//                   Navigator.pop(ctx);
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
//     if (_formKey.currentState!.validate() && _selectedCategory != null) {
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
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Please fill all fields!")),
//       );
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
//         child: Form(
//           key: _formKey, // ✅ Wrap with Form
//           child: Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     TextButton(
//                       onPressed: () => Navigator.pop(context),
//                       child: Text("Cancel",
//                           style: TextStyle(
//                               color: isDark ? Colors.red[300] : Colors.red,
//                               fontSize: 16)),
//                     ),
//                     TextButton(
//                       onPressed: _saveTransaction,
//                       child: const Text(
//                         "Save Transaction",
//                         style: TextStyle(
//                             color: Colors.blue,
//                             fontSize: 16,
//                             fontWeight: FontWeight.w600),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Divider(
//                   color: isDark ? Colors.grey.shade700 : const Color(0xFFDEE1E6),
//                   thickness: 1),
//               Expanded(
//                 child: SingleChildScrollView(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: ["Income", "Expense", "Transfer"].map((t) {
//                           final isSelected = _type == t;
//                           return Expanded(
//                             child: Padding(
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 4.0),
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                   color: isSelected
//                                       ? Colors.blue
//                                       : Colors.transparent,
//                                   borderRadius: BorderRadius.circular(24),
//                                 ),
//                                 child: TextButton(
//                                   onPressed: () {
//                                     setState(() {
//                                       _type = t;
//                                       _selectedCategory = null;
//                                       _amountController.clear();
//                                       expression = "";
//                                       _noteController.clear();
//                                     });
//                                   },
//                                   child: Text(
//                                     t,
//                                     style: TextStyle(
//                                       color: isSelected
//                                           ? Colors.white
//                                           : (isDark
//                                               ? Colors.white70
//                                               : Colors.black87),
//                                       fontSize: isSelected ? 16 : 14,
//                                       fontWeight: isSelected
//                                           ? FontWeight.w600
//                                           : FontWeight.normal,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           );
//                         }).toList(),
//                       ),
//                       const SizedBox(height: 16),
//                       // ✅ Category Validation
//                       TextFormField(
//                         readOnly: true,
//                         onTap: _showCategorySelector,
//                         validator: (val) =>
//                             _selectedCategory == null ? "Select a category" : null,
//                         style: TextStyle(color: textColor),
//                         decoration: InputDecoration(
//                           labelText: "Select Category",
//                           labelStyle: TextStyle(color: textColor),
//                           prefixIcon: Icon(Icons.category,
//                               color: isDark ? Colors.white70 : Colors.black54),
//                           hintText: _selectedCategory ?? "Tap to choose",
//                           hintStyle: TextStyle(
//                               color: isDark ? Colors.white60 : Colors.black54),
//                           filled: true,
//                           fillColor: fieldColor,
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       Text("Amount",
//                           style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w500,
//                               color: textColor)),
//                       const SizedBox(height: 6),
//                       // ✅ Amount Validation
//                       TextFormField(
//                         controller: _amountController,
//                         readOnly: true,
//                         validator: (val) =>
//                             val == null || val.isEmpty ? "Enter amount" : null,
//                         style: TextStyle(color: textColor),
//                         decoration: InputDecoration(
//                           prefixIcon: Icon(Icons.attach_money,
//                               color: isDark ? Colors.white70 : Colors.black54),
//                           filled: true,
//                           fillColor: fieldColor,
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       Text("Note",
//                           style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w500,
//                               color: textColor)),
//                       const SizedBox(height: 6),
//                       // ✅ Note Validation
//                       TextFormField(
//                         controller: _noteController,
//                         validator: (val) =>
//                             val == null || val.isEmpty ? "Enter note" : null,
//                         style: TextStyle(color: textColor),
//                         decoration: InputDecoration(
//                           hintText: "Add a note here (e.g 'Groceries of the week')",
//                           hintStyle: TextStyle(
//                               color: isDark ? Colors.white60 : Colors.black54),
//                           filled: true,
//                           fillColor: fieldColor,
//                           suffixIcon: Icon(Icons.note,
//                               color: isDark ? Colors.white70 : Colors.black54),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                       ),
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
//                       // ✅ Calculator
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
//                             "7",
//                             "8",
//                             "9",
//                             "/",
//                             "4",
//                             "5",
//                             "6",
//                             "*",
//                             "1",
//                             "2",
//                             "3",
//                             "-",
//                             "0",
//                             ".",
//                             "=",
//                             "+",
//                             "C",
//                             "⌫",
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
//                                 child: Text(
//                                   btnText,
//                                   style: TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                     color: isAction
//                                         ? Colors.white
//                                         : (isDark
//                                             ? Colors.white
//                                             : Colors.black),
//                                   ),
//                                 ),
//                               ),
//                             );
//                           }).toList(),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
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
import 'package:shared_preferences/shared_preferences.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _type = "Income";
  String? _selectedCategory;
  String expression = "";

  // Default Categories
  Map<String, List<Map<String, dynamic>>> categories = {
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

  @override
  void initState() {
    super.initState();
    _loadCustomCategories();
  }

  Future<void> _loadCustomCategories() async {
    final prefs = await SharedPreferences.getInstance();
    for (var type in ["Income", "Expense", "Transfer"]) {
      List<String>? savedCats = prefs.getStringList("custom_$type");
      if (savedCats != null) {
        for (var label in savedCats) {
          categories[type]!.add({
            "icon": Icons.star,
            "label": label,
            "amount": 0,
          });
        }
      }
    }
    setState(() {});
  }

  Future<void> _saveCustomCategory(String type, String label) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> savedCats = prefs.getStringList("custom_$type") ?? [];
    if (!savedCats.contains(label)) {
      savedCats.add(label);
      await prefs.setStringList("custom_$type", savedCats);
    }
  }

  void _addCustomCategory() {
    final _customController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,
          title: Text(
            "Add Custom Category",
            style: TextStyle(color: isDark ? Colors.white : Colors.black),
          ),
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
                  style:
                      TextStyle(color: isDark ? Colors.red[300] : Colors.red)),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_customController.text.isNotEmpty) {
                  String newCategory = _customController.text;

                  setState(() {
                    categories[_type]!.add({
                      "icon": Icons.star,
                      "label": newCategory,
                      "amount": 0,
                    });
                    _selectedCategory = newCategory;
                    _noteController.text = newCategory;
                  });

                  await _saveCustomCategory(_type, newCategory);

                  Navigator.pop(ctx);
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
    if (_formKey.currentState!.validate() && _selectedCategory != null) {
      final txn = TransactionModel(
        type: _type,
        category: _selectedCategory ?? "Uncategorized",
        amount: double.tryParse(_amountController.text) ?? 0,
        note: _noteController.text, // ✅ Will save empty string if left blank
        date: DateFormat.yMMMd().format(DateTime.now()),
      );
      Provider.of<TransactionViewModel>(context, listen: false)
          .addTransaction(txn);
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields!")),
      );
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
        child: Form(
          key: _formKey,
          child: Column(
            children: [
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
                      child: const Text(
                        "Save Transaction",
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
                      ),
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
                      TextFormField(
                        readOnly: true,
                        onTap: _showCategorySelector,
                        validator: (val) =>
                            _selectedCategory == null ? "Select a category" : null,
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
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text("Amount",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: textColor)),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _amountController,
                        readOnly: true,
                        validator: (val) =>
                            val == null || val.isEmpty ? "Enter amount" : null,
                        style: TextStyle(color: textColor),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.attach_money,
                              color: isDark ? Colors.white70 : Colors.black54),
                          filled: true,
                          fillColor: fieldColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text("Note",
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: textColor)),
                      const SizedBox(height: 6),
                      // ✅ Optional Note (no validator)
                      TextFormField(
                        controller: _noteController,
                        style: TextStyle(color: textColor),
                        decoration: InputDecoration(
                          hintText: "Add a note here (optional)",
                          hintStyle: TextStyle(
                              color: isDark ? Colors.white60 : Colors.black54),
                          filled: true,
                          fillColor: fieldColor,
                          suffixIcon: Icon(Icons.note,
                              color: isDark ? Colors.white70 : Colors.black54),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
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
                            "7",
                            "8",
                            "9",
                            "/",
                            "4",
                            "5",
                            "6",
                            "*",
                            "1",
                            "2",
                            "3",
                            "-",
                            "0",
                            ".",
                            "=",
                            "+",
                            "C",
                            "⌫",
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
                                child: Text(
                                  btnText,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: isAction
                                        ? Colors.white
                                        : (isDark
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                ),
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
      ),
    );
  }
}
