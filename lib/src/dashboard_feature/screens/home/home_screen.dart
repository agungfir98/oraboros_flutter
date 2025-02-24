import 'package:flutter/material.dart';
import 'package:oraboros/src/dashboard_feature/screens/home/widgets/balance_card.dart';
import 'package:oraboros/src/dashboard_feature/screens/home/widgets/new_expense_sheet.dart';
import 'package:oraboros/src/dashboard_feature/screens/home/widgets/new_income_button.dart';
import 'package:oraboros/src/dashboard_feature/screens/home/widgets/transaction_list.dart';
import 'package:oraboros/src/widgets/bottom_sheet.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  _openExpenseBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
      ),
      isScrollControlled: true,
      builder: (context) {
        return const BottomeSheetWrapper(
          sheet: NewExpense(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: Theme.of(context).colorScheme.outline,
          ),
          borderRadius: BorderRadius.circular(100),
        ),
        child: FloatingActionButton(
          shape: const CircleBorder(),
          elevation: 0,
          onPressed: () => _openExpenseBottomSheet(context),
          child: Icon(
            Icons.add,
            color: Theme.of(context).colorScheme.outline,
            size: 28,
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 50,
            ),
            Stack(children: [
              BalanceCard(),
              Positioned(
                right: 0,
                top: 0,
                height: 40,
                width: 110,
                child: NewIncomeButton(),
              )
            ]),
            SizedBox(height: 20),
            TransactionList()
          ],
        ),
      ),
    );
  }
}
