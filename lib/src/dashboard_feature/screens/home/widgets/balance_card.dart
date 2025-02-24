import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:oraboros/src/lib/locator.dart';
import 'package:oraboros/src/service/transaction.service.dart';
import 'package:oraboros/src/utils/currency_formatter.dart';
import 'package:oraboros/src/utils/maffs/maff.dart';

class BalanceCard extends StatefulWidget {
  const BalanceCard({super.key});

  @override
  State<BalanceCard> createState() => _BalanceCardState();
}

class _BalanceCardState extends State<BalanceCard> {
  var transactionService = locator<TransactionService>();
  Map<String, dynamic> balance = {};
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    isLoading = true;
    _fetchBalance();
  }

  _fetchBalance() async {
    var data = await transactionService.getBalance();
    if (kDebugMode) {
      print(data);
    }
    setState(() {
      balance = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CardOutlinePainter(
        strokeWidth: 4,
        color: Theme.of(context).colorScheme.outline,
      ),
      child: ClipPath(
        clipper: CustomCardClipper(), // Apply custom shape
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(40),
            ),
          ),
          child: Builder(builder: (context) {
            if (isLoading) {
              return const Text("loading...");
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Your Balance",
                  style: TextStyle(fontSize: 18, color: Colors.black54),
                ),
                const SizedBox(height: 5),
                Text(
                  formatting.format(balance['balance'] ?? ""),
                  style: const TextStyle(
                      fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

// Custom Clipper for the Unique Shape
class CustomCardClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    double radius = 20;

    ({double x, double y}) v1 = (x: 0, y: 0);
    ({double x, double y}) v2 = (x: 0, y: size.height);
    ({double x, double y}) v3 = (x: size.width, y: size.height);
    ({double x, double y}) v4 = (x: size.width, y: 0 + 50);
    ({double x, double y}) v5 = (x: size.width - 110, y: 0 + 50);
    ({double x, double y}) v6 = (x: size.width - 135, y: 0);

    // top left
    path.moveTo(v1.x + radius, v1.y);
    path.quadraticBezierTo(v1.x, v1.y, v1.x, v1.y + radius);
    path.lineTo(v1.x, v1.y + radius);

    // bottom left
    path.lineTo(v2.x, v2.y - radius);
    path.quadraticBezierTo(v2.x, v2.y, v2.x + radius, v2.y);
    path.lineTo(v2.x + radius, v2.y);

    // bottom right
    path.lineTo(v3.x - radius, v3.y);
    path.quadraticBezierTo(v3.x, v3.y, v3.x, v3.y - radius);
    path.lineTo(v3.x, v3.y - radius);

    // top right
    path.lineTo(v4.x, v4.y + radius);
    path.quadraticBezierTo(v4.x, v4.y, v4.x - radius, v4.y);
    path.lineTo(v4.x - radius, v4.y);

    // deep cutout
    path.lineTo(v5.x + radius, v5.y);
    var v55 = pointAtDistance((x: v5.x, y: v5.y), (x: v6.x, y: v6.y), radius);
    path.quadraticBezierTo(v5.x, v5.y, v55.x, v55.y);
    path.lineTo(v55.x, v55.y);

    var v65 = pointAtDistance(v6, v5, radius);
    path.lineTo(v65.x, v65.y);
    path.quadraticBezierTo(v6.x, v6.y, v6.x - radius, v6.y);
    path.lineTo(v6.x - radius, v6.y);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class CardOutlinePainter extends CustomPainter {
  final double strokeWidth;
  final Color? color;
  const CardOutlinePainter({required this.strokeWidth, this.color});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color ?? Colors.black // Outline color
      ..strokeWidth = strokeWidth // Outline thickness
      ..style = PaintingStyle.stroke; // Stroke only

    Path path = CustomCardClipper().getClip(size);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
