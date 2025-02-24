import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

NumberFormat formatting =
    NumberFormat.simpleCurrency(locale: 'ID', decimalDigits: 0, name: 'Rp ');

class CurrencyInputFormatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat.decimalPattern('en_US');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // If the new value is empty, return as is
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Remove all non-digit characters
    String digitsOnly = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    // Handle backspace when only a zero is left
    if (digitsOnly.isEmpty) {
      return const TextEditingValue(text: '');
    }

    // Convert to number
    int number = int.parse(digitsOnly);

    // Format the number
    final formatted = _formatter.format(number);

    // Return new value with formatted text
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
