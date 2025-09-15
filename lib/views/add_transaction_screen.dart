
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
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

  // Default categories
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

  // Add new custom category
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
            onPressed: () {
              Navigator.pop(ctx);
            },
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
                });
                Navigator.pop(ctx);
              }
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentCategories = categories[_type]!;

    return Scaffold(
      resizeToAvoidBottomInset: true, // ✅ Prevents overflow when keyboard opens
      appBar: AppBar(title: const Text("Add Transaction")),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                value: _type,
                items: ["Income", "Expense", "Transfer"]
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    _type = val!;
                    _selectedCategory = null;
                    _amountController.clear();
                    _noteController.clear();
                  });
                },
              ),
              const SizedBox(height: 16),

              // Categories with icons
              Wrap(
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
                      },
                    );
                  }).toList(),

                  // Add custom category button
                  ActionChip(
                    avatar: const Icon(Icons.add, color: Colors.white),
                    label: const Text("Custom"),
                    backgroundColor: Colors.green,
                    labelStyle: const TextStyle(color: Colors.white),
                    onPressed: _addCustomCategory,
                  ),
                ],
              ),

              const SizedBox(height: 16),

              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Amount",
                  prefixIcon: Icon(Icons.attach_money),
                ),
              ),
              TextField(
                controller: _noteController,
                decoration: const InputDecoration(
                  labelText: "Note",
                  prefixIcon: Icon(Icons.note),
                ),
              ),
              const SizedBox(height: 20),

              // Stylish Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () {
                    final txn = TransactionModel(
                      type: _type,
                      amount: double.tryParse(_amountController.text) ?? 0,
                      note: _noteController.text,
                      date: DateFormat.yMMMd().format(DateTime.now()),
                    );
                    Provider.of<TransactionViewModel>(context, listen: false)
                        .addTransaction(txn);
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.save, color: Colors.white),
                  label: const Text(
                    "Save Transaction",
                    style: TextStyle(fontSize: 16, color: Colors.white),
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
