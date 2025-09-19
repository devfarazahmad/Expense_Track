

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
                avatar: Icon(cat["icon"], color: Colors.blue),
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
          ],
        ),
      ),
    );
  }

  Future<void> _saveTransaction(BuildContext context) async {
    final vm = Provider.of<TransactionViewModel>(context, listen: false);

    final updatedTxn = widget.transaction.copyWith(
      type: _selectedType,
      category: _selectedCategory ?? "Uncategorized",
      amount: double.tryParse(_amountController.text) ?? widget.transaction.amount,
      note: _noteController.text,
      date: DateFormat("yyyy-MM-dd").format(_selectedDate),
    );

    await vm.deleteTransaction(widget.transaction.id!);
    await vm.addTransaction(updatedTxn);

    Navigator.pop(context);
  }

  /// Common reusable container (for static fields like category/date)
  Widget _buildBoxField({
    required String label,
    required String value,
    required IconData icon,
    VoidCallback? onTap,
    bool isHint = false,
    bool showArrow = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFDEE1E6)),
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.black),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label,
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade700)),
                    const SizedBox(height: 6),
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 16,
                        color: isHint ? Colors.grey.shade600 : Colors.black,
                        fontWeight: isHint ? FontWeight.normal : FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              if (showArrow)
                const Icon(Icons.arrow_drop_down, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }

  /// Editable container with TextField (for Amount & Notes)
  Widget _buildEditableBoxField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool isNumber = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFDEE1E6)),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.black),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: TextStyle(
                          fontSize: 12, color: Colors.grey.shade700)),
                  const SizedBox(height: 6),
                  TextField(
                    controller: controller,
                    keyboardType:
                        isNumber ? TextInputType.number : TextInputType.text,
                    decoration: const InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      hintText: "Enter value",
                    ),
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Transaction Details")),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(color: Color(0xFFDEE1E6), height: 1),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildExpenseDropdownField(),

            // Category (with arrow & selector)
            _buildBoxField(
              label: "Category",
              value: _selectedCategory ?? "Select category",
              icon: Icons.list,
              isHint: _selectedCategory == null,
              onTap: _showCategorySelector,
              showArrow: true,
            ),

            // Date (picker, no arrow)
            _buildBoxField(
              label: "Date",
              value: DateFormat("yyyy-MM-dd").format(_selectedDate),
              icon: Icons.date_range,
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
            ),

            // Amount (direct editable)
            _buildEditableBoxField(
              label: "Amount",
              controller: _amountController,
              icon: Icons.attach_money,
              isNumber: true,
            ),

            // Notes (direct editable)
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
                foregroundColor: Color(0xFFFF5F5B),
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

  /// Type dropdown with color change
  Widget _buildExpenseDropdownField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: "Type",
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFDEE1E6)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFDEE1E6)),
          ),
          prefixIcon: const Icon(Icons.category, color: Colors.black),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: _selectedType,
            isExpanded: true,
            items: ["Expense", "Income"].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: value == "Expense" ? Colors.red : Colors.blue,
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
}
