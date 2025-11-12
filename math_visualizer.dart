import 'dart:math';
import 'package:flutter/material.dart';

void main() => runApp(MathPatternApp());

class MathPatternApp extends StatefulWidget {
  @override
  _MathPatternAppState createState() => _MathPatternAppState();
}

class _MathPatternAppState extends State<MathPatternApp>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double points = 200;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text('Math Pattern Visualizer'),
          backgroundColor: Colors.deepPurple,
        ),
        body: Column(
          children: [
            Expanded(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  return CustomPaint(
                    painter: PatternPainter(
                      animationValue: _controller.value,
                      totalPoints: points.toInt(),
                    ),
                    child: Container(),
                  );
                },
              ),
            ),
            Slider(
              value: points,
              min: 50,
              max: 400,
              divisions: 350,
              label: points.toStringAsFixed(0),
              onChanged: (v) => setState(() => points = v),
            ),
          ],
        ),
      ),
    );
  }
}

class PatternPainter extends CustomPainter {
  final double animationValue;
  final int totalPoints;

  PatternPainter({required this.animationValue, required this.totalPoints});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.pinkAccent
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 - 20;

    for (int i = 0; i < totalPoints; i++) {
      final angle1 = (i / totalPoints) * 2 * pi;
      final angle2 = ((i * 2 + animationValue * totalPoints) / totalPoints) * 2 * pi;
      final p1 = Offset(center.dx + radius * cos(angle1), center.dy + radius * sin(angle1));
      final p2 = Offset(center.dx + radius * cos(angle2), center.dy + radius * sin(angle2));
      canvas.drawLine(p1, p2, paint);
    }
  }

  @override
  bool shouldRepaint(_) => true;
}
