import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:oraboros/src/dashboard_feature/screens/home/widgets/balance_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 50,
            ),
            const BalanceCard(),
            SizedBox(
              height: 80,
              width: double.infinity,
              child: Center(
                  child: Text(
                'ORABOROS',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                    fontFamily: GoogleFonts.inter().fontFamily),
              )),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              height: 100,
              decoration: BoxDecoration(
                  border: Border.all(width: 2),
                  borderRadius: BorderRadius.circular(10)),
              child: const Text("ini di dalem container"),
            ),
            const Text(
                style: TextStyle(fontSize: 14),
                "Home Screen dengan teks yang sangat panjang sekali sampai kena ke pulau kamera lingkaran itu"),
          ],
        ),
      ),
    );
  }
}
