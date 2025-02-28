import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:intl/intl.dart';
import 'package:oraboros/src/lib/db/db_helper.dart';
import 'package:oraboros/src/lib/locator.dart';
import 'package:oraboros/src/model/transactions.model.dart';
import 'package:oraboros/src/service/transaction.service.dart';
import 'package:oraboros/src/utils/currency_formatter.dart';
import 'package:oraboros/src/widgets/custom_gesture_detector.dart';
import 'package:oraboros/src/widgets/custom_snackbar.dart';

class NewIncomeSheet extends StatefulWidget {
  const NewIncomeSheet({super.key});

  @override
  State<NewIncomeSheet> createState() => _NewIncomeSheetState();
}

class _NewIncomeSheetState extends State<NewIncomeSheet> {
  final _formKey = GlobalKey<FormBuilderState>();
  final TextEditingController _valueController = TextEditingController();
  static const _locale = "ID";
  final TransactionService transactionService = locator<TransactionService>();

  String get _currency =>
      NumberFormat.compactSimpleCurrency(locale: _locale).currencySymbol;

  void _submitForm() async {
    if (!(_formKey.currentState?.saveAndValidate() ?? false)) {
      return;
    }
    final formData = _formKey.currentState?.value;
    final rawValue = formData?["value"]?.toString().replaceAll(',', '');
    final description = formData?["description"];
    final parsedValue = double.parse(rawValue!);
    final createdAt = formData?['created_at'];

    Transactions payload = Transactions(
      amount: parsedValue,
      createdAt: createdAt,
      description: description,
    );

    try {
      await transactionService.newIncome(payload);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar(
            context: context,
            type: SnackBarType.success,
            content: Text(
              "income recorded",
              style: TextStyle(
                color: Theme.of(context).colorScheme.outline,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
        return Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar(
            context: context,
            type: SnackBarType.error,
            content: Text("Failed to record new income $e"),
            duration: const Duration(days: 1),
          ),
        );
      }
    }

    return;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          "Record new income",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        FormBuilder(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _currency,
                    style: TextStyle(
                      fontSize: 44,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  Expanded(
                    child: FormBuilderTextField(
                      name: 'value',
                      controller: _valueController,
                      style: const TextStyle(
                        fontSize: 44,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.right,
                      decoration: const InputDecoration(
                        hintText: "0",
                        border: InputBorder.none,
                      ),
                      showCursor: false,
                      keyboardType: TextInputType.number,
                      inputFormatters: [CurrencyInputFormatter()],
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
                  ),
                ],
              ),
              const SizedBox(height: 20),
              FormBuilderTextField(
                name: "description",
                decoration: const InputDecoration(hintText: "description..."),
                keyboardType: TextInputType.multiline,
                maxLines: null,
              ),
              const SizedBox(height: 10),
              FormBuilderDateTimePicker(
                name: 'created_at',
                fieldHintText: 'Pick a date',
                format: DateFormat(sqliteDefaultDateFormat),
                inputType: InputType.both,
                decoration: InputDecoration(
                    hintText: "when did you buy? (default now)",
                    suffixIcon: IconButton(
                        onPressed: () {
                          _formKey.currentState!.fields['created_at']
                              ?.didChange(null);
                        },
                        icon: const Icon(Icons.clear_outlined))),
                lastDate: DateTime.now(),
              ),
              const SizedBox(height: 50),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: CustomGestureDetector(
                  onTap: () => _submitForm(),
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
              const SizedBox(height: 50),
            ],
          ),
        )
      ],
    );
  }
}
