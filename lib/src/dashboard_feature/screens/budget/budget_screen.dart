import 'package:flutter/material.dart';
import 'package:oraboros/src/dashboard_feature/screens/budget/widgets/new_budget_sheet.dart';
import 'package:oraboros/src/lib/locator.dart';
import 'package:oraboros/src/model/category.model.dart';
import 'package:oraboros/src/service/category.service.dart';
import 'package:oraboros/src/utils/currency_formatter.dart';
import 'package:oraboros/src/widgets/bottom_sheet.dart';

class BudgetScreen extends StatefulWidget {
  const BudgetScreen({super.key});

  @override
  State<BudgetScreen> createState() => _BudgetScreenState();
}

class _BudgetScreenState extends State<BudgetScreen> {
  final budgetService = locator<CategoryService>();
  bool isLoading = false;
  List<Category> _budgetList = [];

  @override
  void initState() {
    super.initState();
    _fetchBudgetList();
  }

  void _fetchBudgetList() async {
    setState(() {
      isLoading = true;
    });

    _budgetList = await budgetService.getCategories();

    setState(() {
      isLoading = false;
    });
  }

  _openNewBudgetBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
      ),
      builder: (context) {
        return const BottomeSheetWrapper(
          sheet: NewBudgetSheet(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: Border(
          bottom: BorderSide(
              width: 2, color: Theme.of(context).colorScheme.outline),
        ),
        title: const Text("budget"),
        actions: [
          Container(
            height: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(
                strokeAlign: BorderSide.strokeAlignOutside,
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
            child: IconButton(
              onPressed: () => _openNewBudgetBottomSheet(context),
              icon: const Icon(Icons.add),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _budgetList.length,
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
        itemBuilder: (context, index) {
          var budget = _budgetList.elementAt(index);
          if (isLoading) {
            return const Center(child: Text("loading..."));
          }
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  width: 2, color: Theme.of(context).colorScheme.outline),
            ),
            child: ListTile(
              title: Text(budget.name),
              trailing: Text(
                formatting.format(budget.amount),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          );
        },
      ),
    );
  }
}
