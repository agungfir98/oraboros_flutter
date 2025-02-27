import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oraboros/src/lib/locator.dart';
import 'package:oraboros/src/model/transactions.model.dart';
import 'package:oraboros/src/service/transaction.service.dart';

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
    return ListView.builder(
      // padding: const EdgeInsets.symmetric(vertical: 30),
      itemCount: dateList.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        String date = DateFormat("EEE dd MMM").format(dateList[index]);
        return Container(
          decoration: BoxDecoration(border: Border.all()),
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: Builder(
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
                  title: Text(date.toString()),
                ),
                const Divider(
                  thickness: 2,
                ),
                Builder(
                  builder: (context) {
                    if (_transactionHistory.containsKey(date)) {
                      return Text(
                          "ada ${_transactionHistory[date]?[0].description}");
                    }

                    return const Opacity(
                      opacity: 0.8,
                      child: Text("no transactions"),
                    );
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
