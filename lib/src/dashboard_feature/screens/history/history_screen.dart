import 'package:flutter/material.dart';
import 'package:oraboros/src/dashboard_feature/screens/history/tab_screen/daily_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final _tabIndex = 0;
  final List<Map<String, dynamic>> _tabItems = [
    {
      "tab": const Tab(
        text: "daily",
      ),
      "tabView": const DailyScreen(),
    },
    {
      "tab": const Tab(
        child: Text("weekly"),
      ),
      "tabView": const Center(
        child: Text("weekly"),
      ),
    },
    {
      "tab": const Tab(
        child: Text("monthly"),
      ),
      "tabView": const Center(
        child: Text("monthly"),
      ),
    }
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: _tabIndex,
      length: _tabItems.length,
      child: Scaffold(
        appBar: AppBar(
          shape: Border(
            bottom: BorderSide(
              width: 2,
              color: Theme.of(context).colorScheme.outline,
              strokeAlign: BorderSide.strokeAlignInside,
            ),
          ),
          title: const Text("History"),
          bottom: TabBar(
            labelPadding: EdgeInsets.zero,
            splashFactory: NoSplash.splashFactory,
            tabs: _tabItems.map((item) {
              return Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(strokeAlign: BorderSide.strokeAlignCenter),
                ),
                child: item['tab'] as Tab,
              );
            }).toList(),
          ),
        ),
        body: TabBarView(
          children: _tabItems.map((item) => item['tabView'] as Widget).toList(),
        ),
      ),
    );
  }
}
