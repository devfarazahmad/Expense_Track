

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';
// import 'package:track_expense/Model/transaction_model.dart';
// import 'package:track_expense/ViewModel/transaction_viewmodel.dart';

// class TransactionDetailsScreen extends StatefulWidget {
//   final TransactionModel transaction;

//   const TransactionDetailsScreen({super.key, required this.transaction});

//   @override
//   State<TransactionDetailsScreen> createState() =>
//       _TransactionDetailsScreenState();
// }

// class _TransactionDetailsScreenState extends State<TransactionDetailsScreen> {
//   late TextEditingController _amountController;
//   late TextEditingController _noteController;
//   late TextEditingController _dateController;
//   late DateTime _selectedDate;
//   late String _selectedType;
//   String? _selectedCategory;

//   final Map<String, List<Map<String, dynamic>>> categories = {
//     "Income": [
//       {"icon": Icons.work, "label": "Salary"},
//       {"icon": Icons.card_giftcard, "label": "Lottery"},
//       {"icon": Icons.attach_money, "label": "Bonus"},
//     ],
//     "Expense": [
//       {"icon": Icons.fastfood, "label": "Food"},
//       {"icon": Icons.home, "label": "Rent"},
//       {"icon": Icons.local_taxi, "label": "Transport"},
//     ],
//   };

//   @override
//   void initState() {
//     super.initState();

//     // ✅ Fix: ensure _selectedType is valid
//     final validTypes = ["Expense", "Income"];
//     _selectedType = validTypes.contains(widget.transaction.type)
//         ? widget.transaction.type
//         : "Expense";

//     _selectedCategory = widget.transaction.category;
//     _amountController =
//         TextEditingController(text: widget.transaction.amount.toString());
//     _noteController = TextEditingController(text: widget.transaction.note);

//     try {
//       _selectedDate = DateFormat("MMM d, yyyy").parse(widget.transaction.date);
//     } catch (_) {
//       _selectedDate = DateTime.now();
//     }

//     _dateController = TextEditingController(
//       text: DateFormat("MMM d, yyyy").format(_selectedDate),
//     );
//   }

//   @override
//   void dispose() {
//     _amountController.dispose();
//     _noteController.dispose();
//     _dateController.dispose();
//     super.dispose();
//   }

//   void _showCategorySelector() {
//     final currentCategories = categories[_selectedType]!;
//     final theme = Theme.of(context);

//     showModalBottomSheet(
//       context: context,
//       backgroundColor: theme.scaffoldBackgroundColor,
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
//                 avatar: Icon(cat["icon"], color: theme.colorScheme.primary),
//                 label: Text(cat["label"]),
//                 selected: _selectedCategory == cat["label"],
//                 selectedColor: theme.colorScheme.primary,
//                 backgroundColor: theme.colorScheme.surfaceVariant,
//                 labelStyle: TextStyle(
//                   color: _selectedCategory == cat["label"]
//                       ? Colors.white
//                       : theme.colorScheme.onSurface,
//                 ),
//                 onSelected: (selected) {
//                   setState(() {
//                     _selectedCategory = cat["label"];
//                     _noteController.text = cat["label"];
//                   });
//                   Navigator.pop(context);
//                 },
//               );
//             }).toList(),
//           ],
//         ),
//       ),
//     );
//   }

//   Future<void> _saveTransaction(BuildContext context) async {
//     final vm = Provider.of<TransactionViewModel>(context, listen: false);

//     try {
//       _selectedDate = DateFormat("MMM d, yyyy").parse(_dateController.text);
//     } catch (_) {}

//     final updatedTxn = widget.transaction.copyWith(
//       type: _selectedType,
//       category: _selectedCategory ?? "Uncategorized",
//       amount: double.tryParse(_amountController.text) ??
//           widget.transaction.amount,
//       note: _noteController.text,
//       date: DateFormat("MMM d, yyyy").format(_selectedDate),
//     );

//     await vm.deleteTransaction(widget.transaction.id!);
//     await vm.addTransaction(updatedTxn);

//     Navigator.pop(context);
//   }

//   Widget _buildBoxField({
//     required String label,
//     required String value,
//     required IconData icon,
//     VoidCallback? onTap,
//     bool isHint = false,
//     bool showArrow = false,
//   }) {
//     final theme = Theme.of(context);

//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(10),
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
//           decoration: BoxDecoration(
//             color: theme.cardColor,
//             borderRadius: BorderRadius.circular(10),
//             border: Border.all(color: theme.dividerColor),
//           ),
//           child: Row(
//             children: [
//               Icon(icon, color: theme.iconTheme.color),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(label,
//                         style: TextStyle(
//                             fontSize: 12,
//                             color: theme.textTheme.bodySmall?.color)),
//                     const SizedBox(height: 6),
//                     Text(
//                       value,
//                       style: TextStyle(
//                         fontSize: 16,
//                         color: isHint
//                             ? theme.hintColor
//                             : theme.textTheme.bodyLarge?.color,
//                         fontWeight:
//                             isHint ? FontWeight.normal : FontWeight.w600,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               if (showArrow)
//                 Icon(Icons.arrow_drop_down, color: theme.iconTheme.color),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildEditableBoxField({
//     required String label,
//     required TextEditingController controller,
//     required IconData icon,
//     bool isNumber = false,
//   }) {
//     final theme = Theme.of(context);

//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
//         decoration: BoxDecoration(
//           color: theme.cardColor,
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(color: theme.dividerColor),
//         ),
//         child: Row(
//           children: [
//             Icon(icon, color: theme.iconTheme.color),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(label,
//                       style: TextStyle(
//                           fontSize: 12,
//                           color: theme.textTheme.bodySmall?.color)),
//                   const SizedBox(height: 6),
//                   TextField(
//                     controller: controller,
//                     keyboardType:
//                         isNumber ? TextInputType.number : TextInputType.text,
//                     decoration: InputDecoration(
//                       isDense: true,
//                       border: InputBorder.none,
//                       hintText: "Enter value",
//                       hintStyle: TextStyle(color: theme.hintColor),
//                     ),
//                     style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.w600,
//                         color: theme.textTheme.bodyLarge?.color),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDateField() {
//     final theme = Theme.of(context);

//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
//         decoration: BoxDecoration(
//           color: theme.cardColor,
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(color: theme.dividerColor),
//         ),
//         child: Row(
//           children: [
//             Icon(Icons.date_range, color: theme.iconTheme.color),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text("Date", style: TextStyle(fontSize: 12)),
//                   const SizedBox(height: 6),
//                   TextField(
//                     controller: _dateController,
//                     decoration: InputDecoration(
//                       isDense: true,
//                       border: InputBorder.none,
//                       hintText: "MM DD, YYYY",
//                       hintStyle: TextStyle(color: theme.hintColor),
//                     ),
//                     onSubmitted: (val) {
//                       try {
//                         setState(() {
//                           _selectedDate =
//                               DateFormat("MMM d, yyyy").parse(val);
//                         });
//                       } catch (_) {}
//                     },
//                     style: TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                       color: theme.textTheme.bodyLarge?.color,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             IconButton(
//               icon: const Icon(Icons.calendar_today),
//               color: theme.iconTheme.color,
//               onPressed: () async {
//                 DateTime? picked = await showDatePicker(
//                   context: context,
//                   initialDate: _selectedDate,
//                   firstDate: DateTime(2000),
//                   lastDate: DateTime(2100),
//                 );
//                 if (picked != null) {
//                   setState(() {
//                     _selectedDate = picked;
//                     _dateController.text =
//                         DateFormat("MMM d, yyyy").format(picked);
//                   });
//                 }
//               },
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildExpenseDropdownField() {
//     final theme = Theme.of(context);

//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10),
//       child: InputDecorator(
//         decoration: InputDecoration(
//           labelText: "Type",
//           filled: true,
//           fillColor: theme.cardColor,
//           enabledBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10),
//             borderSide: BorderSide(color: theme.dividerColor),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(10),
//             borderSide: BorderSide(color: theme.dividerColor),
//           ),
//           prefixIcon: Icon(Icons.category, color: theme.iconTheme.color),
//         ),
//         child: DropdownButtonHideUnderline(
//           child: DropdownButton<String>(
//             value: _selectedType,
//             isExpanded: true,
//             items: ["Expense", "Income"].map((String value) {
//               return DropdownMenuItem<String>(
//                 value: value,
//                 child: Text(
//                   value,
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: value == "Expense"
//                         ? Colors.red
//                         : theme.colorScheme.primary,
//                   ),
//                 ),
//               );
//             }).toList(),
//             onChanged: (String? newValue) {
//               setState(() {
//                 _selectedType = newValue!;
//                 _selectedCategory = null;
//               });
//             },
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "Transaction Details",
//           style: TextStyle(fontSize: 18),
//         ),
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(1),
//           child: Divider(color: theme.dividerColor, height: 1),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             _buildExpenseDropdownField(),
//             _buildBoxField(
//               label: "Category",
//               value: _selectedCategory ?? "Select category",
//               icon: Icons.list,
//               isHint: _selectedCategory == null,
//               onTap: _showCategorySelector,
//               showArrow: true,
//             ),
//             _buildDateField(),
//             _buildEditableBoxField(
//               label: "Amount",
//               controller: _amountController,
//               icon: Icons.attach_money,
//               isNumber: true,
//             ),
//             _buildEditableBoxField(
//               label: "Notes",
//               controller: _noteController,
//               icon: Icons.note,
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton.icon(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFFA46BF5),
//                 foregroundColor: Colors.white,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 minimumSize: const Size(double.infinity, 50),
//               ),
//               onPressed: () => _saveTransaction(context),
//               icon: const Icon(Icons.edit),
//               label: const Text(
//                 "Update Transaction",
//                 style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
//               ),
//             ),
//             const SizedBox(height: 12),
//             OutlinedButton.icon(
//               style: OutlinedButton.styleFrom(
//                 side: const BorderSide(color: Color(0xFFFF5F5B), width: 2),
//                 foregroundColor: const Color(0xFFFF5F5B),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 minimumSize: const Size(double.infinity, 50),
//               ),
//               onPressed: () async {
//                 final vm =
//                     Provider.of<TransactionViewModel>(context, listen: false);
//                 await vm.deleteTransaction(widget.transaction.id!);
//                 Navigator.pop(context);
//               },
//               icon: const Icon(Icons.delete),
//               label: const Text(
//                 "Delete Transaction",
//                 style: TextStyle(
//                     fontWeight: FontWeight.w700,
//                     color: Color(0xFFFF5F5B),
//                     fontSize: 16),
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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:track_expense/Model/transaction_model.dart';
import 'package:track_expense/ViewModel/transaction_viewmodel.dart';

class TransactionDetailsScreen extends StatefulWidget {
  final TransactionModel transaction;

  const TransactionDetailsScreen({super.key, required this.transaction});

  @override
  State<TransactionDetailsScreen> createState() =>
      _TransactionDetailsScreenState();
}

class _TransactionDetailsScreenState extends State<TransactionDetailsScreen> {
  late TextEditingController _amountController;
  late TextEditingController _noteController;
  late TextEditingController _dateController;
  late DateTime _selectedDate;
  late String _selectedType;
  String? _selectedCategory;

  // ✅ Categories (with default)
  Map<String, List<Map<String, dynamic>>> categories = {
    "Income": [
      {"icon": Icons.work, "label": "Salary"},
      {"icon": Icons.card_giftcard, "label": "Lottery"},
      {"icon": Icons.attach_money, "label": "Bonus"},
    ],
    "Expense": [
      {"icon": Icons.fastfood, "label": "Food"},
      {"icon": Icons.home, "label": "Rent"},
      {"icon": Icons.local_taxi, "label": "Transport"},
    ],
    "Transfer": [
      {"icon": Icons.account_balance, "label": "Bank Transfer"},
      {"icon": Icons.send, "label": "To Friend"},
      {"icon": Icons.credit_card, "label": "Credit Payment"},
    ],
  };

  @override
  void initState() {
    super.initState();

    final validTypes = ["Expense", "Income", "Transfer"];
    _selectedType = validTypes.contains(widget.transaction.type)
        ? widget.transaction.type
        : "Expense";

    _selectedCategory = widget.transaction.category;
    _amountController =
        TextEditingController(text: widget.transaction.amount.toString());
    _noteController = TextEditingController(text: widget.transaction.note);

    try {
      _selectedDate = DateFormat("MMM d, yyyy").parse(widget.transaction.date);
    } catch (_) {
      _selectedDate = DateTime.now();
    }

    _dateController = TextEditingController(
      text: DateFormat("MMM d, yyyy").format(_selectedDate),
    );

    _loadCustomCategories();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  // ✅ Load custom categories
  Future<void> _loadCustomCategories() async {
    final prefs = await SharedPreferences.getInstance();
    for (var type in ["Income", "Expense", "Transfer"]) {
      List<String>? savedCats = prefs.getStringList("custom_$type");
      if (savedCats != null) {
        for (var label in savedCats) {
          if (!categories[type]!.any((c) => c["label"] == label)) {
            categories[type]!.add({"icon": Icons.star, "label": label});
          }
        }
      }
    }
    setState(() {});
  }

  // ✅ Save custom category
  Future<void> _saveCustomCategory(String type, String label) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> savedCats = prefs.getStringList("custom_$type") ?? [];
    if (!savedCats.contains(label)) {
      savedCats.add(label);
      await prefs.setStringList("custom_$type", savedCats);
    }
  }

  // ✅ Add custom category dialog
  void _addCustomCategory() {
    final _customController = TextEditingController();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
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
            onPressed: () async {
              if (_customController.text.isNotEmpty) {
                String newCategory = _customController.text;

                setState(() {
                  categories[_selectedType]!.add({
                    "icon": Icons.star,
                    "label": newCategory,
                  });
                  _selectedCategory = newCategory;
                  _noteController.text = newCategory;
                });

                await _saveCustomCategory(_selectedType, newCategory);

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
      ),
    );
  }

  // ✅ Category selector (same as AddTransactionScreen)
  void _showCategorySelector() {
    final currentCategories = categories[_selectedType]!;
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

  // ✅ Save Transaction (unchanged)
  Future<void> _saveTransaction(BuildContext context) async {
    final vm = Provider.of<TransactionViewModel>(context, listen: false);

    try {
      _selectedDate = DateFormat("MMM d, yyyy").parse(_dateController.text);
    } catch (_) {}

    final updatedTxn = widget.transaction.copyWith(
      type: _selectedType,
      category: _selectedCategory ?? "Uncategorized",
      amount: double.tryParse(_amountController.text) ??
          widget.transaction.amount,
      note: _noteController.text,
      date: DateFormat("MMM d, yyyy").format(_selectedDate),
    );

    await vm.deleteTransaction(widget.transaction.id!);
    await vm.addTransaction(updatedTxn);

    Navigator.pop(context);
  }

  // ✅ Type dropdown (unchanged)
  Widget _buildExpenseDropdownField() {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: "Type",
          filled: true,
          fillColor: theme.cardColor,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: theme.dividerColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: theme.dividerColor),
          ),
          prefixIcon: Icon(Icons.category, color: theme.iconTheme.color),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: _selectedType,
            isExpanded: true,
            items: ["Expense", "Income", "Transfer"].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: value == "Expense"
                        ? Colors.red
                        : theme.colorScheme.primary,
                  ),
                ),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedType = newValue!;
                _selectedCategory = null;
              });
            },
          ),
        ),
      ),
    );
  }

  // ✅ Build Method (only category section replaced)
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Transaction Details",
          style: TextStyle(fontSize: 18),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(color: theme.dividerColor, height: 1),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildExpenseDropdownField(),

            // ✅ Category Field (new)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: InkWell(
                onTap: _showCategorySelector,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: theme.dividerColor),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.list, color: theme.iconTheme.color),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _selectedCategory ?? "Select Category",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: _selectedCategory == null
                                ? theme.hintColor
                                : theme.textTheme.bodyLarge?.color,
                          ),
                        ),
                      ),
                      Icon(Icons.arrow_drop_down, color: theme.iconTheme.color),
                    ],
                  ),
                ),
              ),
            ),

            // ✅ Other fields unchanged
            _buildDateField(),
            _buildEditableBoxField(
              label: "Amount",
              controller: _amountController,
              icon: Icons.attach_money,
              isNumber: true,
            ),
            _buildEditableBoxField(
              label: "Notes",
              controller: _noteController,
              icon: Icons.note,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFA46BF5),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () => _saveTransaction(context),
              icon: const Icon(Icons.edit),
              label: const Text(
                "Update Transaction",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFFFF5F5B), width: 2),
                foregroundColor: const Color(0xFFFF5F5B),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () async {
                final vm =
                    Provider.of<TransactionViewModel>(context, listen: false);
                await vm.deleteTransaction(widget.transaction.id!);
                Navigator.pop(context);
              },
              icon: const Icon(Icons.delete),
              label: const Text(
                "Delete Transaction",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFFF5F5B),
                    fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Date + Editable fields (reused from your old code)
  Widget _buildDateField() {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: theme.dividerColor),
        ),
        child: Row(
          children: [
            Icon(Icons.date_range, color: theme.iconTheme.color),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: _dateController,
                decoration: InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  hintText: "MM DD, YYYY",
                  hintStyle: TextStyle(color: theme.hintColor),
                ),
                onSubmitted: (val) {
                  try {
                    setState(() {
                      _selectedDate = DateFormat("MMM d, yyyy").parse(val);
                    });
                  } catch (_) {}
                },
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: theme.textTheme.bodyLarge?.color,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.calendar_today),
              color: theme.iconTheme.color,
              onPressed: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  setState(() {
                    _selectedDate = picked;
                    _dateController.text =
                        DateFormat("MMM d, yyyy").format(picked);
                  });
                }
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildEditableBoxField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool isNumber = false,
  }) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: theme.dividerColor),
        ),
        child: Row(
          children: [
            Icon(icon, color: theme.iconTheme.color),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: controller,
                keyboardType:
                    isNumber ? TextInputType.number : TextInputType.text,
                decoration: InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  hintText: "Enter value",
                  hintStyle: TextStyle(color: theme.hintColor),
                ),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: theme.textTheme.bodyLarge?.color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
