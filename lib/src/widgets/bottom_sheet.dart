import 'package:flutter/material.dart';

class BottomeSheetWrapper extends StatelessWidget {
  final Widget? sheet;
  const BottomeSheetWrapper({super.key, this.sheet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.only(
          top: 36,
          left: 16,
          right: 16,
          bottom: 0,
        ),
        child: SizedBox(
          width: double.infinity,
          child: sheet,
        ),
      ),
    );
  }
}
