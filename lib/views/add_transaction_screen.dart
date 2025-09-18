

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

//   // ✅ Default Categories
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

//   // ✅ Add Custom Category Dialog
//   void _addCustomCategory() {
//     final _customController = TextEditingController();
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: const Text("Add Custom Category"),
//         content: TextField(
//           controller: _customController,
//           decoration: const InputDecoration(hintText: "Enter category name"),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(ctx),
//             child: const Text("Cancel"),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               if (_customController.text.isNotEmpty) {
//                 setState(() {
//                   categories[_type]!.add({
//                     "icon": Icons.star,
//                     "label": _customController.text,
//                     "amount": 0,
//                   });
//                   _selectedCategory = _customController.text;
//                   _noteController.text = _customController.text;
//                 });
//                 Navigator.pop(ctx);
//                 Navigator.pop(context); // close bottom sheet as well
//               }
//             },
//             child: const Text("Add"),
//           ),
//         ],
//       ),
//     );
//   }

//   // ✅ Show Category Selector in Bottom Sheet
//   void _showCategorySelector() {
//     final currentCategories = categories[_type]!;
//     showModalBottomSheet(
//       context: context,
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
//               return ChoiceChip(
//                 avatar: Icon(cat["icon"], color: Colors.green),
//                 label: Text(cat["label"]),
//                 selected: _selectedCategory == cat["label"],
//                 selectedColor: Colors.blue,
//                 backgroundColor: Colors.grey.shade300,
//                 labelStyle: TextStyle(
//                   color: _selectedCategory == cat["label"]
//                       ? Colors.white
//                       : Colors.black,
//                 ),
//                 onSelected: (selected) {
//                   setState(() {
//                     _selectedCategory = cat["label"];
//                     _amountController.text = cat["amount"].toString();
//                     _noteController.text = cat["label"];
//                   });
//                   Navigator.pop(context); // close bottom sheet
//                 },
//               );
//             }).toList(),
//             ActionChip(
//               avatar: const Icon(Icons.add, color: Colors.black),
//               label: const Text("Custom"),
//               backgroundColor: Colors.white,
//               labelStyle: const TextStyle(color: Colors.black),
//               onPressed: _addCustomCategory,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // ✅ Calculator Logic
//   void _onPressed(String value) {
//     setState(() {
//       if (value == "C") {
//         expression = "";
//       } else if (value == "⌫") {
//         if (expression.isNotEmpty) {
//           expression = expression.substring(0, expression.length - 1);
//         }
//       } else if (value == "=") {
//         try {
//           Parser p = Parser();
//           Expression exp = p.parse(expression);
//           double result = exp.evaluate(EvaluationType.REAL, ContextModel());
//           expression = result.toStringAsFixed(2);
//           _amountController.text = expression;
//         } catch (e) {
//           expression = "Error";
//         }
//       } else {
//         expression += value;
//       }
//     });
//   }

//   // ✅ Save Transaction
//   void _saveTransaction() {
//     if (_amountController.text.isNotEmpty && _noteController.text.isNotEmpty) {
//       final txn = TransactionModel(
//         type: _type,
//         category: _selectedCategory ?? "Uncategorized", // ✅ FIXED
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
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           children: [
//             // ✅ Custom Top Bar
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   TextButton(
//                     onPressed: () => Navigator.pop(context),
//                     child: const Text("Cancel",
//                         style: TextStyle(color: Colors.red, fontSize: 16)),
//                   ),
//                   TextButton(
//                     onPressed: _saveTransaction,
//                     child: const Text("Save Transaction",
//                         style: TextStyle(color: Colors.green, fontSize: 16)),
//                   ),
//                 ],
//               ),
//             ),

//             Expanded(
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // ✅ Transaction type buttons
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: ["Income", "Expense", "Transfer"].map((t) {
//                         final isSelected = _type == t;
//                         return Expanded(
//                           child: Padding(
//                             padding:
//                                 const EdgeInsets.symmetric(horizontal: 4.0),
//                             child: ElevatedButton(
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: isSelected
//                                     ? (t == "Income"
//                                         ? Colors.green
//                                         : t == "Expense"
//                                             ? Colors.red
//                                             : Colors.blue)
//                                     : Colors.white,
//                                 foregroundColor:
//                                     isSelected ? Colors.white : Colors.black,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                 ),
//                               ),
//                               onPressed: () {
//                                 setState(() {
//                                   _type = t;
//                                   _selectedCategory = null;
//                                   _amountController.clear();
//                                   _noteController.clear();
//                                 });
//                               },
//                               child: Text(
//                                 t,
//                                 style: const TextStyle(fontSize: 12),
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
//                       decoration: InputDecoration(
//                         labelText: "Select Category",
//                         prefixIcon: const Icon(Icons.category),
//                         hintText: _selectedCategory ?? "Tap to choose",
//                         filled: true,
//                         fillColor: Colors.grey.shade100,
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                     ),

//                     const SizedBox(height: 16),

//                     // ✅ Amount Field
//                     TextField(
//                       controller: _amountController,
//                       readOnly: true,
//                       onTap: () {
//                         setState(() {
//                           _showCalculator = true;
//                         });
//                       },
//                       decoration: InputDecoration(
//                         labelText: "Amount",
//                         prefixIcon: const Icon(Icons.attach_money),
//                         filled: true,
//                         fillColor: Colors.grey.shade100,
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: BorderSide(color: Colors.grey.shade400),
//                         ),
//                       ),
//                     ),

//                     const SizedBox(height: 12),

//                     // ✅ Note Field
//                     TextField(
//                       controller: _noteController,
//                       decoration: InputDecoration(
//                         labelText: "Note",
//                         prefixIcon: const Icon(Icons.note),
//                         filled: true,
//                         fillColor: Colors.grey.shade100,
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: BorderSide(color: Colors.grey.shade400),
//                         ),
//                       ),
//                     ),

//                     const SizedBox(height: 1),

//                     // ✅ Inline Calculator
//                     if (_showCalculator) ...[
//                       Container(
//                         padding: const EdgeInsets.all(8),
//                         alignment: Alignment.centerRight,
//                         child: Text(
//                           expression,
//                           style: const TextStyle(
//                               fontSize: 20, fontWeight: FontWeight.w500),
//                         ),
//                       ),
//                       GridView.count(
//                         crossAxisCount: 4,
//                         shrinkWrap: true,
//                         physics: const NeverScrollableScrollPhysics(),
//                         childAspectRatio: 1.4,
//                         padding: const EdgeInsets.all(8),
//                         children: [
//                           "7", "8", "9", "/",
//                           "4", "5", "6", "*",
//                           "1", "2", "3", "-",
//                           "0", ".", "=", "+",
//                           "C", "⌫",
//                         ].map((btnText) {
//                           return Padding(
//                             padding: const EdgeInsets.all(4.0),
//                             child: ElevatedButton(
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: btnText == "C"
//                                     ? Colors.red
//                                     : (btnText == "="
//                                         ? Colors.green
//                                         : Colors.grey[200]),
//                                 foregroundColor:
//                                     btnText == "C" || btnText == "="
//                                         ? Colors.white
//                                         : Colors.black,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                               ),
//                               onPressed: () => _onPressed(btnText),
//                               child: Text(
//                                 btnText,
//                                 style: const TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold),
//                               ),
//                             ),
//                           );
//                         }).toList(),
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
  bool _showCalculator = false;
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
      builder: (ctx) => AlertDialog(
        title: const Text("Add Custom Category"),
        content: TextField(
          controller: _customController,
          decoration: const InputDecoration(hintText: "Enter category name"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
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
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  void _showCategorySelector() {
    final currentCategories = categories[_type]!;
    showModalBottomSheet(
      context: context,
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
              return ChoiceChip(
                avatar: Icon(cat["icon"], color: Colors.green),
                label: Text(cat["label"]),
                selected: _selectedCategory == cat["label"],
                selectedColor: Colors.blue,
                backgroundColor: Colors.grey.shade300,
                labelStyle: TextStyle(
                  color: _selectedCategory == cat["label"]
                      ? Colors.white
                      : Colors.black,
                ),
                onSelected: (selected) {
                  setState(() {
                    _selectedCategory = cat["label"];
                    _amountController.text = cat["amount"].toString();
                    _noteController.text = cat["label"];
                  });
                  Navigator.pop(context);
                },
              );
            }).toList(),
            ActionChip(
              avatar: const Icon(Icons.add, color: Colors.black),
              label: const Text("Custom"),
              backgroundColor: Colors.white,
              labelStyle: const TextStyle(color: Colors.black),
              onPressed: _addCustomCategory,
            ),
          ],
        ),
      ),
    );
  }

  // ✅ UPDATED CALCULATOR LOGIC
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
        } catch (e) {
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
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel",
                        style: TextStyle(color: Colors.red, fontSize: 16)),
                  ),
                  TextButton(
                    onPressed: _saveTransaction,
                    child: const Text("Save Transaction",
                        style: TextStyle(color: Colors.green, fontSize: 16)),
                  ),
                ],
              ),
            ),
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
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isSelected
                                    ? (t == "Income"
                                        ? Colors.green
                                        : t == "Expense"
                                            ? Colors.red
                                            : Colors.blue)
                                    : Colors.white,
                                foregroundColor:
                                    isSelected ? Colors.white : Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
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
                                style: const TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      readOnly: true,
                      onTap: _showCategorySelector,
                      decoration: InputDecoration(
                        labelText: "Select Category",
                        prefixIcon: const Icon(Icons.category),
                        hintText: _selectedCategory ?? "Tap to choose",
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _amountController,
                      readOnly: true,
                      onTap: () {
                        setState(() {
                          _showCalculator = true;
                        });
                      },
                      decoration: InputDecoration(
                        labelText: "Amount",
                        prefixIcon: const Icon(Icons.attach_money),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade400),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _noteController,
                      decoration: InputDecoration(
                        labelText: "Note",
                        prefixIcon: const Icon(Icons.note),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade400),
                        ),
                      ),
                    ),
                    const SizedBox(height: 1),
                    if (_showCalculator) ...[
                      Container(
                        padding: const EdgeInsets.all(8),
                        alignment: Alignment.centerRight,
                        child: Text(
                          expression,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                      ),
                      GridView.count(
                        crossAxisCount: 4,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        childAspectRatio: 1.4,
                        padding: const EdgeInsets.all(8),
                        children: [
                          "7", "8", "9", "/",
                          "4", "5", "6", "*",
                          "1", "2", "3", "-",
                          "0", ".", "=", "+",
                          "C", "⌫",
                        ].map((btnText) {
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: btnText == "C"
                                    ? Colors.red
                                    : (btnText == "="
                                        ? Colors.green
                                        : Colors.grey[200]),
                                foregroundColor:
                                    btnText == "C" || btnText == "="
                                        ? Colors.white
                                        : Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () => _onPressed(btnText),
                              child: Text(
                                btnText,
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
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
