import 'package:flutter/material.dart';
import 'package:oraboros/src/utils/maffs/maff.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: const CardOutlinePainter(strokeWidth: 4),
      child: ClipPath(
        clipper: CustomCardClipper(), // Apply custom shape
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(40),
            ),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Your Balance is",
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
              SizedBox(height: 5),
              Text(
                "\$45,934.00",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5),
              Row(
                children: [
                  Icon(Icons.trending_up, color: Colors.green),
                  SizedBox(width: 5),
                  Text(
                    "8.82% (+\$876)",
                    style: TextStyle(color: Colors.green),
                  ),
                ],
              ),
            ],
          ),
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
    ({double x, double y}) v4 = (x: size.width, y: size.height * 0.3);
    ({double x, double y}) v5 = (x: size.width * 0.8, y: size.height * 0.3);
    ({double x, double y}) v6 = (x: size.width * 0.6, y: 0);

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
    // var v55 = pointAtDistance(v5, v6, radius);
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
  const CardOutlinePainter({required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black // Outline color
      ..strokeWidth = strokeWidth // Outline thickness
      ..style = PaintingStyle.stroke; // Stroke only

    Path path = CustomCardClipper().getClip(size);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
