import 'package:flutter/material.dart';
import 'package:oraboros/src/dashboard_feature/screens/home/widgets/new_income_sheet.dart';
import 'package:oraboros/src/widgets/bottom_sheet.dart';

class NewIncomeButton extends StatelessWidget {
  const NewIncomeButton({super.key});

  void _openSheet(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
      ),
      isScrollControlled: true,
      builder: (ctx) {
        return const BottomeSheetWrapper(sheet: NewIncomeSheet());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        backgroundColor: Theme.of(context).colorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      onPressed: () => _openSheet(context),
      child: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(width: 2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.add_outlined,
              color: Theme.of(context).colorScheme.outline,
              size: 24,
              weight: 2,
            ),
            const SizedBox(width: 2),
            Text(
              "Income",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.outline,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
