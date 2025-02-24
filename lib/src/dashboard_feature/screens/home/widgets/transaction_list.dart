import 'package:flutter/material.dart';
import 'package:oraboros/src/lib/locator.dart';
import 'package:oraboros/src/model/transactions.model.dart';
import 'package:oraboros/src/service/transaction.service.dart';
import 'package:oraboros/src/utils/currency_formatter.dart';

class TransactionList extends StatefulWidget {
  const TransactionList({super.key});

  @override
  State<TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  final TransactionService transactionService = locator<TransactionService>();
  List<Transactions> data = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchTransaction();
  }

  _fetchTransaction() async {
    setState(() {
      isLoading = true;
    });

    List<Transactions> fetchedData = await transactionService.getTransactions();

    setState(() {
      data = fetchedData;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const Center(child: Text("No transactions found."));
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Transactions",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: data.length,
          padding: const EdgeInsets.symmetric(vertical: 10),
          itemBuilder: (context, index) {
            final transaction = data.elementAt(index);
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              margin: const EdgeInsets.symmetric(vertical: 2.5),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  width: 2,
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                dense: true,
                leading: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: transaction.type == TransactionType.expense
                        ? Colors.red[500]
                        : const Color.fromARGB(255, 94, 228, 98),
                    border: Border.all(
                      width: 2,
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                  child: Icon(
                    transaction.type == TransactionType.expense
                        ? Icons.trending_down_outlined
                        : Icons.trending_up_outlined,
                    weight: 1000,
                  ),
                ),
                title: Container(
                  child: transaction.type == TransactionType.income
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              transaction.description ?? "no description",
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 5),
                            const Text("income"),
                          ],
                        )
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              transaction.description ?? "no description",
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            Text(transaction.category ?? "chill"),
                          ],
                        ),
                ),
                trailing: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      size: 14,
                      transaction.type == TransactionType.expense
                          ? Icons.remove_outlined
                          : Icons.add_outlined,
                      color: transaction.type == TransactionType.expense
                          ? Colors.red[500]
                          : Colors.green[500],
                    ),
                    Text(
                      formatting.format(transaction.amount),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: transaction.type == TransactionType.expense
                            ? Colors.red[500]
                            : Colors.green[500],
                      ),
                    )
                  ],
                ),
              ),
            );
            // return Container(
            //   padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            //   margin: const EdgeInsets.symmetric(vertical: 2.5),
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     borderRadius: BorderRadius.circular(20),
            //     border: Border.all(
            //       width: 2,
            //       color: Theme.of(context).colorScheme.outline,
            //     ),
            //   ),
            //   child: Row(
            //     children: [
            //       Container(
            //         padding: const EdgeInsets.all(5),
            //         decoration: BoxDecoration(
            //           borderRadius: BorderRadius.circular(100),
            //           color: transaction.type == TransactionType.expense
            //               ? Colors.red[500]
            //               : const Color.fromARGB(255, 94, 228, 98),
            //           border: Border.all(
            //             width: 2,
            //             color: Theme.of(context).colorScheme.outline,
            //           ),
            //         ),
            //         child: Icon(
            //           transaction.type == TransactionType.expense
            //               ? Icons.trending_down_outlined
            //               : Icons.trending_up_outlined,
            //           weight: 1000,
            //         ),
            //       ),
            //       Expanded(
            //         child: Container(
            //           padding: const EdgeInsets.symmetric(horizontal: 10),
            //           child: transaction.type == TransactionType.income
            //               ? Column(
            //                   crossAxisAlignment: CrossAxisAlignment.start,
            //                   children: [
            //                     Text(
            //                       transaction.description ?? "no description",
            //                       style: const TextStyle(
            //                         fontWeight: FontWeight.w600,
            //                         fontSize: 16,
            //                       ),
            //                     ),
            //                     const SizedBox(height: 5),
            //                     const Text("income"),
            //                   ],
            //                 )
            //               : Column(
            //                   mainAxisSize: MainAxisSize.min,
            //                   crossAxisAlignment: CrossAxisAlignment.start,
            //                   children: [
            //                     Text(transaction.type.name),
            //                   ],
            //                 ),
            //         ),
            //       ),
            //       DefaultTextStyle(
            //         style: TextStyle(
            //           color: transaction.type == TransactionType.expense
            //               ? Colors.red[500]
            //               : Colors.green[500],
            //           fontWeight: FontWeight.w600,
            //         ),
            //         child: Row(
            //           children: [
            //             Icon(
            //               size: 16,
            //               transaction.type == TransactionType.expense
            //                   ? Icons.remove_outlined
            //                   : Icons.add_outlined,
            //               color: transaction.type == TransactionType.expense
            //                   ? Colors.red[500]
            //                   : Colors.green[500],
            //             ),
            //             Text(_formatting.format(transaction.amount))
            //           ],
            //         ),
            //       ),
            //     ],
            //   ),
            // );
          },
        ),
      ],
    );
  }
}
