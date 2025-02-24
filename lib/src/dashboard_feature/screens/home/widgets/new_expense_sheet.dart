import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:oraboros/src/lib/locator.dart';
import 'package:oraboros/src/model/transactions.model.dart';
import 'package:oraboros/src/model/category.model.dart' as budget;
import 'package:oraboros/src/service/category.service.dart';
import 'package:oraboros/src/service/transaction.service.dart';
import 'package:oraboros/src/utils/currency_formatter.dart';
import 'package:oraboros/src/widgets/custom_gesture_detector.dart';
import 'package:oraboros/src/widgets/custom_snackbar.dart';

class NewExpense extends StatefulWidget {
  const NewExpense({super.key});

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  final _formKey = GlobalKey<FormBuilderState>();
  final TextEditingController _valueController = TextEditingController();
  final _locale = "ID";
  String get _currency =>
      NumberFormat.compactSimpleCurrency(locale: _locale).currencySymbol;
  final transactionService = locator<TransactionService>();
  final categoryService = locator<CategoryService>();
  List<budget.Category> categories = [];

  @override
  void initState() {
    super.initState();
    _fetchCategory();
  }

  _fetchCategory() async {
    List<budget.Category> data = await categoryService.getCategories();

    setState(() {
      categories = data;
    });
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.saveAndValidate() ?? false)) {
      return;
    }

    var formData = _formKey.currentState?.value;
    final description = formData?['description'];
    final rawValue = formData?["value"]?.toString().replaceAll(',', '');
    final parsedValue = double.parse(rawValue!);
    final category = formData?['category'];

    Transactions payload = Transactions(
      amount: parsedValue,
      categoryId: category,
      description: description,
    );

    try {
      await transactionService.newExpense(payload);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(
        context: context,
        type: SnackBarType.success,
        content: const Text("new expense recorded!"),
      ));
      return Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(
        context: context,
        type: SnackBarType.success,
        content: Text('failed to record expense: $e'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          "Record your expense",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 50),
        FormBuilder(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FormBuilderTextField(
                name: 'description',
                decoration:
                    const InputDecoration(hintText: "what did you buy?"),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                ]),
              ),
              const SizedBox(height: 10),
              FormBuilderTextField(
                name: 'value',
                controller: _valueController,
                decoration: InputDecoration(
                    prefix: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        _currency,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    hintText: "how much did you buy?"),
                inputFormatters: [
                  CurrencyInputFormatter(),
                ],
                keyboardType: TextInputType.number,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  (value) {
                    if (value == null || value.isEmpty) return null;
                    final numericValue = value.replaceAll(',', '');
                    if (!RegExp(r'^\d+$').hasMatch(numericValue)) {
                      return 'Please enter a valid number';
                    }
                    final number = int.parse(numericValue);
                    if (number < 1000) {
                      return 'Minimum Rp 1,000';
                    }
                    return null;
                  },
                ]),
              ),
              const SizedBox(height: 10),
              FormBuilderDropdown(
                name: 'category',
                initialValue: null,
                validator: FormBuilderValidators.required(),
                decoration: const InputDecoration(
                  hintText: "category",
                ),
                items: categories
                    .map(
                      (category) => DropdownMenuItem(
                        value: category.id,
                        child: Text(category.name),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 50),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: CustomGestureDetector(
                  onTap: () => _submit(),
                  child: Center(
                    child: Text(
                      'Submit',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.outline,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
