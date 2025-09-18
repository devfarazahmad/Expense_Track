import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
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
  late DateTime _selectedDate;
  late String _selectedType;
  String? _selectedCategory;

  // ✅ Default Categories (copied from AddTransactionScreen)
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

  @override
  void initState() {
    super.initState();
    _selectedType = widget.transaction.type;
    _selectedCategory = widget.transaction.category;
    _amountController =
        TextEditingController(text: widget.transaction.amount.toString());
    _noteController = TextEditingController(text: widget.transaction.note);

    try {
      _selectedDate = DateFormat("yyyy-MM-dd").parse(widget.transaction.date);
    } catch (_) {
      try {
        _selectedDate =
            DateFormat("MMM d, yyyy").parse(widget.transaction.date);
      } catch (_) {
        _selectedDate = DateTime.now();
      }
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  // ✅ Show Category Selector
  void _showCategorySelector() {
    final currentCategories = categories[_selectedType]!;
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

  // ✅ Add Custom Category
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
                  categories[_selectedType]!.add({
                    "icon": Icons.star,
                    "label": _customController.text,
                    "amount": 0,
                  });
                  _selectedCategory = _customController.text;
                  _noteController.text = _customController.text;
                });
                Navigator.pop(ctx);
                Navigator.pop(context); // close bottom sheet
              }
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  // ✅ Save Transaction
  Future<void> _saveTransaction(BuildContext context) async {
    final vm = Provider.of<TransactionViewModel>(context, listen: false);

    final updatedTxn = widget.transaction.copyWith(
      type: _selectedType,
      category: _selectedCategory ?? "Uncategorized",
      amount: double.tryParse(_amountController.text) ??
          widget.transaction.amount,
      note: _noteController.text,
      date: DateFormat("yyyy-MM-dd").format(_selectedDate),
    );

    await vm.deleteTransaction(widget.transaction.id!);
    await vm.addTransaction(updatedTxn);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Transaction Details")),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(color: Colors.grey, height: 1),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildExpenseDropdownField(),
            _buildCategoryField(),
            _buildDatePicker(),
            _buildTextField("Amount", _amountController, Icons.attach_money,
                isNumber: true),
            _buildTextField("Notes", _noteController, Icons.note),

            const SizedBox(height: 20),

            // ✅ Update button (always saves now)
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () => _saveTransaction(context),
              icon: const Icon(Icons.update),
              label: const Text("Update Transaction"),
            ),

            const SizedBox(height: 12),

            // ✅ Delete button
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.red,
                minimumSize: const Size(double.infinity, 50),
              ),
              onPressed: () async {
                final vm =
                    Provider.of<TransactionViewModel>(context, listen: false);
                await vm.deleteTransaction(widget.transaction.id!);
                Navigator.pop(context);
              },
              icon: const Icon(Icons.delete),
              label: const Text("Delete Transaction"),
            ),
          ],
        ),
      ),
    );
  }

  /// ✅ Expense field with dropdown
  Widget _buildExpenseDropdownField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: "Expense",
          prefixIcon: Icon(Icons.category, color: Colors.black),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: _selectedType,
            isExpanded: true,
            items: ["Expense", "Income", "Transfer"].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: const TextStyle(color: Colors.black)),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedType = newValue!;
                _selectedCategory = null; // reset category
              });
            },
          ),
        ),
      ),
    );
  }

  /// ✅ Category field (always tappable)
  Widget _buildCategoryField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        readOnly: true,
        onTap: _showCategorySelector,
        decoration: InputDecoration(
          labelText: "Category",
          prefixIcon: const Icon(Icons.list, color: Colors.black),
          filled: true,
          fillColor: Colors.white,
          border: const OutlineInputBorder(),
          hintText: _selectedCategory ?? "Tap to choose",
        ),
        controller: TextEditingController(text: _selectedCategory ?? ""),
      ),
    );
  }

  /// ✅ Date picker
  Widget _buildDatePicker() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        onTap: () async {
          DateTime? picked = await showDatePicker(
            context: context,
            initialDate: _selectedDate,
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
          );
          if (picked != null) {
            setState(() => _selectedDate = picked);
          }
        },
        child: InputDecorator(
          decoration: const InputDecoration(
            labelText: "Date",
            prefixIcon: Icon(Icons.date_range, color: Colors.black),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(),
          ),
          child: Text(
            DateFormat("yyyy-MM-dd").format(_selectedDate),
            style: const TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }

  /// ✅ Generic text fields
  Widget _buildTextField(String label, TextEditingController controller,
      IconData icon,
      {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.black),
          filled: true,
          fillColor: Colors.white,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
