import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oraboros/src/lib/locator.dart';
import 'package:oraboros/src/model/transactions.model.dart';
import 'package:oraboros/src/service/transaction.service.dart';
import 'package:oraboros/src/utils/currency_formatter.dart';

class DailyScreen extends StatefulWidget {
  const DailyScreen({super.key});

  @override
  State<DailyScreen> createState() => _DailyScreenState();
}

class _DailyScreenState extends State<DailyScreen> {
  Map<String, List<Transactions>> _transactionHistory = {};
  int numOfDay = 7;
  late List<DateTime> dateList = List.generate(
    numOfDay,
    (index) => DateTime.now().subtract(Duration(days: index)),
  );
  final transactionService = locator<TransactionService>();

  @override
  void initState() {
    super.initState();
    _fetchDailyHistory();
  }

  _fetchDailyHistory() async {
    var data = await transactionService.getTransactions(
      endDate: DateTime.now(),
      startDate: DateTime.now().subtract(const Duration(days: 7)),
    );
    Map<String, List<Transactions>> temp = {};

    for (var transaction in data) {
      var transactionMap = transaction.toMap();
      String key =
          DateFormat("EEE dd MMM").format(transactionMap['created_at']);

      if (!temp.containsKey(key)) {
        temp[key] = [];
      }

      temp[key]!.add(Transactions.fromMap(transactionMap));
    }

    setState(() {
      _transactionHistory = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: dateList.length,
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        String date = DateFormat("EEE dd MMM").format(dateList[index]);
        double incomeSum = 0;
        double expenseSum = 0;
        if (_transactionHistory.containsKey(date)) {
          incomeSum = _transactionHistory[date]!.fold(
            incomeSum,
            (sum, e) => e.type == TransactionType.income ? sum + e.amount : sum,
          );
          expenseSum = _transactionHistory[date]!.fold(
            expenseSum,
            (sum, e) =>
                e.type == TransactionType.expense ? sum + e.amount : sum,
          );
        }
        return ListTile(
          contentPadding: EdgeInsets.zero,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.only(right: 10),
                  decoration: const BoxDecoration(
                    border: Border(
                      right: BorderSide(
                        width: 1,
                      ),
                    ),
                  ),
                  child: Builder(
                    builder: (context) {
                      List<String> dateString = date.split(" ");
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            dateString[1],
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(dateString[0])
                        ],
                      );
                    },
                  ),
                ),
                title: Row(
                  children: [
                    Expanded(
                      child: Text(
                        formatting.format(incomeSum),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        formatting.format(expenseSum),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const Divider(
                thickness: 1,
              ),
              Builder(
                builder: (context) {
                  if (_transactionHistory.containsKey(date)) {
                    return ListView.separated(
                      itemCount: _transactionHistory[date]!.length,
                      shrinkWrap: true,
                      itemBuilder: (context, i) {
                        var item = _transactionHistory[date]![i];
                        return ListTile(
                          dense: true,
                          leading: Opacity(
                            opacity: 0.5,
                            child: Text(
                              DateFormat("HH:MM")
                                  .format(item.createdAt!.toUtc()),
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          title: Text(
                            item.description ?? "no description",
                          ),
                          subtitle: Opacity(
                            opacity: 0.5,
                            child: Text(
                              item.category ?? item.type.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          trailing: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                size: 14,
                                item.type == TransactionType.expense
                                    ? Icons.remove_outlined
                                    : Icons.add_outlined,
                                // color: item.type == TransactionType.expense
                                //     ? Colors.red[500]
                                //     : Colors.green[500],
                              ),
                              Text(
                                formatting.format(item.amount),
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  // color: item.type == TransactionType.expense
                                  //     ? Colors.red[500]
                                  //     : Colors.green[500],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Divider(
                          thickness: 1,
                          height: 1,
                        ),
                      ),
                    );
                  }

                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Opacity(
                      opacity: 0.4,
                      child: Center(child: Text("no records")),
                    ),
                  );
                },
              )
            ],
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(
        thickness: 10,
        height: 10,
      ),
    );
  }
}
