import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:oraboros/src/lib/locator.dart';
import 'package:oraboros/src/model/category.model.dart';
import 'package:oraboros/src/service/category.service.dart';
import 'package:oraboros/src/utils/currency_formatter.dart';
import 'package:oraboros/src/widgets/custom_gesture_detector.dart';
import 'package:oraboros/src/widgets/custom_snackbar.dart';

class NewBudgetSheet extends StatefulWidget {
  const NewBudgetSheet({super.key});

  @override
  State<NewBudgetSheet> createState() => _NewBudgetSheetState();
}

class _NewBudgetSheetState extends State<NewBudgetSheet> {
  final _formKey = GlobalKey<FormBuilderState>();
  final _valueController = TextEditingController();
  final _currency =
      NumberFormat.compactSimpleCurrency(locale: 'ID').currencySymbol;
  final categoryService = locator<CategoryService>();

  Future<void> _submitNewBudget() async {
    if (!(_formKey.currentState?.saveAndValidate() ?? false)) {
      return;
    }

    var formData = _formKey.currentState?.value;
    final name = formData?['name'];
    final value = formData?['value'].toString().replaceAll(",", "");
    final parsedValue = double.parse(value!);

    Category payload = Category(amount: parsedValue, name: name);
    try {
      await categoryService.createCategory(payload);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(
        context: context,
        type: SnackBarType.success,
        content: const Text("new budget have been recorded"),
      ));
      return Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(
        context: context,
        type: SnackBarType.error,
        content: Text("unable to write new budget: $e"),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Center(
          child: Text("add budget"),
        ),
        const SizedBox(height: 50),
        FormBuilder(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FormBuilderTextField(
                name: "name",
                decoration: const InputDecoration(hintText: "name"),
                validator: FormBuilderValidators.required(),
              ),
              const SizedBox(height: 20),
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
                    hintText: "amount"),
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
              const SizedBox(height: 50),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: CustomGestureDetector(
                  child: const Center(
                    child: Text(
                      "submit",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  onTap: () => _submitNewBudget(),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
