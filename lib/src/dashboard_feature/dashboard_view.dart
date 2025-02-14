import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:oraboros/src/dashboard_feature/screens/home/home_screen.dart';
import 'package:oraboros/src/dashboard_feature/settings/settings_controller.dart';
import 'package:oraboros/src/dashboard_feature/settings/settings_view.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key, required this.settingsController});

  final SettingsController settingsController;

  static const routeName = '/';

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  int _currentIndex = 0;
  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> sections = [
      {
        "navItem": const BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          label: "Home",
        ),
        "widget": const HomeScreen()
      },
      {
        "navItem": const BottomNavigationBarItem(
          icon: Icon(Icons.show_chart_rounded),
          label: "Statistics",
        ),
        "widget": Scaffold(
          body: Center(
              child: Text(
            "statistics",
            style: Theme.of(context).textTheme.bodyLarge,
          )),
        )
      },
      {
        "navItem": const BottomNavigationBarItem(
          icon: Icon(Icons.settings_outlined),
          label: "Settings",
        ),
        "widget": SettingsView(controller: widget.settingsController)
      },
    ];

    return Scaffold(
        extendBody: true,
        bottomNavigationBar: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                color: Theme.of(context).colorScheme.outline,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  offset: const Offset(5, 5),
                  color: Theme.of(context).colorScheme.shadow,
                ),
              ]),
          clipBehavior: Clip.hardEdge,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: BottomNavigationBar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              currentIndex: _currentIndex,
              showUnselectedLabels: false,
              unselectedItemColor: Colors.black,
              selectedItemColor: Theme.of(context).colorScheme.secondary,
              selectedFontSize: 14,
              onTap: (int index) {
                setState(() {
                  _currentIndex = index;
                });
                if (kDebugMode) {
                  print(index);
                }
              },
              items: sections
                  .map<BottomNavigationBarItem>((section) => section['navItem'])
                  .toList(),
            ),
          ),
        ),
        body: SafeArea(
          child: sections[_currentIndex]['widget'],
        ));
  }
}
