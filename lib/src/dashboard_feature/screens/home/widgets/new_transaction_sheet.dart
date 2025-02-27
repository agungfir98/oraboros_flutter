import 'package:flutter/material.dart';
import 'package:oraboros/src/dashboard_feature/screens/home/widgets/new_expense_sheet.dart';
import 'package:oraboros/src/dashboard_feature/screens/home/widgets/new_income_sheet.dart';

class TransactionSheet extends StatefulWidget {
  const TransactionSheet({super.key});

  @override
  State<TransactionSheet> createState() => _TransactionSheetState();
}

class _TransactionSheetState extends State<TransactionSheet> {
  final List<Map<String, dynamic>> _transactionType = [
    {"type": "expense", "widget": const NewExpense()},
    {"type": "income", "widget": const NewIncomeSheet()},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 50),
        child: DefaultTabController(
            length: _transactionType.length,
            initialIndex: 0,
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 50),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: TabBar(
                      splashFactory: NoSplash.splashFactory,
                      labelPadding: EdgeInsets.zero,
                      tabs: _transactionType.map((item) {
                        return Container(
                          width: double.infinity,
                          height: 40,
                          decoration: BoxDecoration(
                            border: Border.all(
                                strokeAlign: BorderSide.strokeAlignCenter),
                          ),
                          child: Tab(
                            text: item["type"],
                          ),
                        );
                      }).toList()),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: TabBarView(
                    children: _transactionType.map((item) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: item['widget'] as Widget,
                      );
                    }).toList(),
                  ),
                )
              ],
            )),
      ),
    );
  }
}
